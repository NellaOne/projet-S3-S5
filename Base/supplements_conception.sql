
CREATE OR REPLACE FUNCTION fn_on_reservation_cancelled()
RETURNS TRIGGER AS $$
BEGIN
    -- Quand une reservation est annulee,
    -- rien a mettre a jour dans voyage (pas de colonne stockee)
    -- car les places disponibles sont calculees via la VUE
    
    -- Optionnel : on peut logger l'annulation
    IF NEW.statut = 'ANNULE' AND OLD.statut != 'ANNULE' THEN
        -- Insertion dans audit si necessaire
        INSERT INTO audit_log (table_name, record_id, action, utilisateur_id, nouvelles_valeurs, date_action)
        VALUES ('reservation', NEW.id_reservation, 'UPDATE', NULL, 
                jsonb_build_object('ancien_statut', OLD.statut, 'nouveau_statut', NEW.statut),
                CURRENT_TIMESTAMP);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_on_reservation_cancelled
AFTER UPDATE ON reservation
FOR EACH ROW
WHEN (OLD.statut IS DISTINCT FROM NEW.statut)
EXECUTE FUNCTION fn_on_reservation_cancelled();


-- ============================================
-- VUE : Trajets avec nombre de voyages
-- ============================================

CREATE OR REPLACE VIEW v_trajets_avec_voyages AS
SELECT 
    t.id_trajet,
    t.code,
    t.ville_depart,
    t.ville_arrivee,
    t.distance_km,
    t.duree_estimee_minutes,
    COUNT(DISTINCT v.id_voyage) AS nb_voyages_total,
    COUNT(DISTINCT CASE WHEN v.statut = 'PLANIFIE' THEN v.id_voyage END) AS nb_voyages_planifies
FROM trajet t
LEFT JOIN voyage v ON v.trajet_id = t.id_trajet
WHERE t.actif = TRUE
GROUP BY t.id_trajet, t.code, t.ville_depart, t.ville_arrivee, t.distance_km, t.duree_estimee_minutes;


-- ============================================
-- FONCTION : Verifier disponibilite avant insertion (utilisee par trigger)
-- ============================================

CREATE OR REPLACE FUNCTION fn_check_places_avant_reservation()
RETURNS TRIGGER AS $$
DECLARE
    v_places_dispo INTEGER;
    v_capacite INTEGER;
    v_places_reservees INTEGER;
BEGIN
    -- Recuperer la capacite du vehicule via le voyage
    SELECT ve.nombre_places INTO v_capacite
    FROM voyage vo
    JOIN vehicule ve ON vo.vehicule_id = ve.id_vehicule
    WHERE vo.id_voyage = NEW.voyage_id;
    
    -- Compter les reservations existantes (non annulees)
    SELECT COALESCE(SUM(nombre_places), 0) INTO v_places_reservees
    FROM reservation
    WHERE voyage_id = NEW.voyage_id
      AND statut != 'ANNULE'
      AND id_reservation != COALESCE(NEW.id_reservation, -1); -- Exclure la reservation en cours de modification
    
    v_places_dispo := v_capacite - v_places_reservees;
    
    IF NEW.nombre_places > v_places_dispo THEN
        RAISE EXCEPTION 'Pas assez de places. Disponibles: %, Demandees: %', 
            v_places_dispo, NEW.nombre_places;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_places_reservation
BEFORE INSERT OR UPDATE ON reservation
FOR EACH ROW
WHEN (NEW.statut != 'ANNULE')
EXECUTE FUNCTION fn_check_places_avant_reservation();


-- ============================================
-- INDEX SUPPLeMENTAIRES pour performances
-- ============================================

CREATE INDEX IF NOT EXISTS idx_voyage_trajet_date_statut ON voyage(trajet_id, date_depart, statut)
WHERE statut = 'PLANIFIE';

CREATE INDEX IF NOT EXISTS idx_reservation_voyage_statut ON reservation(voyage_id, statut);

CREATE INDEX IF NOT EXISTS idx_reservation_date ON reservation(date_reservation DESC);
