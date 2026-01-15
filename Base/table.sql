\c taxi_brousse;

CREATE TABLE type_vehicule (
    id_type_vehicule BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(100) NOT NULL,
    capacite_standard BIGINT NOT NULL CHECK (capacite_standard > 0),
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trajet (
    id_trajet BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    ville_depart VARCHAR(100) NOT NULL,
    ville_arrivee VARCHAR(100) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL CHECK (distance_km > 0),
    duree_estimee_minutes BIGINT CHECK (duree_estimee_minutes > 0),
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE garage (
    id_garage BIGSERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(50),
    email VARCHAR(100),
    specialite TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE personne (
    id_personne BIGSERIAL PRIMARY KEY,
    
    type_personne VARCHAR(50) NOT NULL 
        CHECK (type_personne IN ('CHAUFFEUR', 'AIDE_CHAUFFEUR', 'CLIENT', 'EMPLOYE')),
    
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),
    cin VARCHAR(50) UNIQUE,
    date_naissance DATE CHECK (date_naissance < CURRENT_DATE),
    
    -- Contact
    telephone VARCHAR(50),
    email VARCHAR(100),
    adresse TEXT,
    
    -- Specifique chauffeurs
    permis_numero VARCHAR(50),
    permis_categorie VARCHAR(20),
    permis_date_expiration DATE,
    
    -- Specifique employes
    date_embauche DATE,
    salaire_base DECIMAL(10,2) CHECK (salaire_base IS NULL OR salaire_base >= 0),
    
    statut VARCHAR(50) DEFAULT 'ACTIF' 
        CHECK (statut IN ('ACTIF', 'INACTIF', 'CONGE', 'SUSPENDU')),
    
    remarques TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Contrainte : chauffeur doit avoir permis
    CONSTRAINT check_chauffeur_permis CHECK (
        type_personne != 'CHAUFFEUR' OR permis_numero IS NOT NULL
    )
);


CREATE TABLE configuration (
    id_configuration BIGSERIAL PRIMARY KEY,
    cle VARCHAR(100) UNIQUE NOT NULL,
    valeur TEXT NOT NULL,
    type_valeur VARCHAR(50) CHECK (type_valeur IN ('STRING', 'NUMBER', 'BOOLEAN')),
    categorie VARCHAR(100),
    description TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE vehicule (
    id_vehicule BIGSERIAL PRIMARY KEY,
    immatriculation VARCHAR(50) UNIQUE NOT NULL,
    type_vehicule_id BIGINT NOT NULL REFERENCES type_vehicule(id_type_vehicule),
    garage_id BIGINT REFERENCES garage(id_garage),
    marque VARCHAR(100),
    modele VARCHAR(100),
    annee BIGINT CHECK (annee >= 1900),
    couleur VARCHAR(50),
    numero_chassis VARCHAR(50) UNIQUE,
    
    -- ✅ CAPACITe FIXE (comme capacite d'une salle)
    nombre_places BIGINT NOT NULL CHECK (nombre_places > 0),
    
    -- etat du vehicule
    statut VARCHAR(50) DEFAULT 'DISPONIBLE' 
        CHECK (statut IN ('DISPONIBLE', 'EN_SERVICE', 'EN_MAINTENANCE', 'HORS_SERVICE')),
    
    kilometrage_actuel DECIMAL(10,2) DEFAULT 0 CHECK (kilometrage_actuel >= 0),
    date_acquisition DATE,
    date_derniere_visite_technique DATE,
    date_prochaine_visite_technique DATE,
    
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE tarif (
    id_tarif BIGSERIAL PRIMARY KEY,
    
    trajet_id BIGINT NOT NULL REFERENCES trajet(id_trajet),
    type_vehicule_id BIGINT REFERENCES type_vehicule(id_type_vehicule),
    
    prix_base DECIMAL(10,2) NOT NULL CHECK (prix_base > 0),
    
    type_tarif VARCHAR(50) DEFAULT 'NORMAL' 
        CHECK (type_tarif IN ('NORMAL', 'FETE', 'WEEKEND', 'NUIT', 'PROMOTIONNEL')),
    
    date_debut DATE NOT NULL,
    date_fin DATE,
    
    multiplicateur DECIMAL(5,2) DEFAULT 1.0 CHECK (multiplicateur > 0),
    
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_dates_tarif CHECK (date_fin IS NULL OR date_fin >= date_debut)
);



CREATE TABLE voyage (
    id_voyage BIGSERIAL PRIMARY KEY,
    
    code_voyage VARCHAR(50) UNIQUE NOT NULL,
    
    -- ✅ References aux "catalogues"
    trajet_id BIGINT NOT NULL REFERENCES trajet(id_trajet),    -- Quel trajet ?
    vehicule_id BIGINT NOT NULL REFERENCES vehicule(id_vehicule), -- Quel vehicule ?
    chauffeur_id BIGINT NOT NULL REFERENCES personne(id_personne), -- Qui conduit ?
    aide_chauffeur_id BIGINT REFERENCES personne(id_personne),
    
    -- ✅ Temporalite (QUAND ?)
    date_depart TIMESTAMP NOT NULL,
    date_arrivee_prevue TIMESTAMP,
    date_arrivee_reelle TIMESTAMP,
    
    -- ✅ etat du voyage
    statut VARCHAR(50) DEFAULT 'PLANIFIE' 
        CHECK (statut IN ('PLANIFIE', 'EN_COURS', 'TERMINE', 'ANNULE')),
    
    -- ✅ Prix pour CE voyage specifique
    prix_par_place DECIMAL(10,2) NOT NULL CHECK (prix_par_place > 0),
    
    -- ⚠️ IMPORTANT : PAS DE nombre_places_disponibles ici !
    -- On le calcule depuis vehicule.nombre_places et les reservations
    
    remarques TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_dates_voyage CHECK (
        date_arrivee_prevue IS NULL OR date_arrivee_prevue > date_depart
    )
);



CREATE TABLE reservation (
    id_reservation BIGSERIAL PRIMARY KEY,
    
    code_reservation VARCHAR(50) UNIQUE NOT NULL,
    
    -- ✅ References
    voyage_id BIGINT NOT NULL REFERENCES voyage(id_voyage),
    client_id BIGINT NOT NULL REFERENCES personne(id_personne),
    
    -- ✅ Details reservation
    nombre_places BIGINT NOT NULL CHECK (nombre_places > 0),
    
    -- ✅ Tarification
    montant_total DECIMAL(10,2) NOT NULL CHECK (montant_total >= 0),
    montant_paye DECIMAL(10,2) DEFAULT 0 CHECK (montant_paye >= 0),
    montant_restant DECIMAL(10,2) GENERATED ALWAYS AS (montant_total - montant_paye) STORED,
    
    mode_reservation VARCHAR(50) DEFAULT 'SUR_PLACE' 
        CHECK (mode_reservation IN ('SUR_PLACE', 'TELEPHONE', 'EN_LIGNE')),
    
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE' 
        CHECK (statut IN ('EN_ATTENTE', 'CONFIRME', 'PAYE', 'TERMINE', 'ANNULE')),
    
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarques TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_montant_paye CHECK (montant_paye <= montant_total)
);


CREATE TABLE colis (
    id_colis BIGSERIAL PRIMARY KEY,
    code_colis VARCHAR(50) UNIQUE NOT NULL,
    
    voyage_id BIGINT NOT NULL REFERENCES voyage(id_voyage),
    expediteur_id BIGINT REFERENCES personne(id_personne),
    
    destinataire_nom VARCHAR(200) NOT NULL,
    destinataire_telephone VARCHAR(50) NOT NULL,
    
    description TEXT NOT NULL,
    poids_kg DECIMAL(10,2) CHECK (poids_kg IS NULL OR poids_kg > 0),
    tarif DECIMAL(10,2) NOT NULL CHECK (tarif > 0),
    
    statut VARCHAR(50) DEFAULT 'ENREGISTRE' 
        CHECK (statut IN ('ENREGISTRE', 'EN_TRANSIT', 'LIVRE', 'ANNULE')),
    
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison TIMESTAMP,
    remarques TEXT
);

CREATE TABLE paiement (
    id_paiement BIGSERIAL PRIMARY KEY,
    code_paiement VARCHAR(50) UNIQUE NOT NULL,
    
    type_paiement VARCHAR(50) NOT NULL 
        CHECK (type_paiement IN ('RESERVATION', 'COLIS', 'REMBOURSEMENT')),
    reference_id BIGINT NOT NULL,
    
    montant DECIMAL(10,2) NOT NULL CHECK (montant > 0),
    mode_paiement VARCHAR(50) NOT NULL 
        CHECK (mode_paiement IN ('ESPECE', 'MOBILE_MONEY', 'CARTE', 'VIREMENT')),
    
    moment_paiement VARCHAR(50) 
        CHECK (moment_paiement IN ('RESERVATION', 'DEPART', 'ARRIVEE')),
    
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_transaction VARCHAR(200),
    recu_par_id BIGINT REFERENCES personne(id_personne),
    remarques TEXT
);


CREATE TABLE depense (
    id_depense BIGSERIAL PRIMARY KEY,
    code_depense VARCHAR(50) UNIQUE NOT NULL,
    
    type_depense VARCHAR(100) NOT NULL 
        CHECK (type_depense IN ('CARBURANT', 'REPARATION', 'VISITE_TECHNIQUE', 
                               'SALAIRE', 'ENTRETIEN', 'AUTRE')),
    
    vehicule_id BIGINT REFERENCES vehicule(id_vehicule),
    voyage_id BIGINT REFERENCES voyage(id_voyage),
    garage_id BIGINT REFERENCES garage(id_garage),
    beneficiaire_id BIGINT REFERENCES personne(id_personne),
    
    montant DECIMAL(10,2) NOT NULL CHECK (montant > 0),
    date_depense DATE NOT NULL,
    description TEXT NOT NULL,
    
    facture_numero VARCHAR(100),
    facture_url VARCHAR(500),
    
    approuve_par_id BIGINT REFERENCES personne(id_personne),
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE' 
        CHECK (statut IN ('EN_ATTENTE', 'APPROUVE', 'PAYE', 'REJETE')),
    
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE maintenance (
    id_maintenance BIGSERIAL PRIMARY KEY,
    vehicule_id BIGINT NOT NULL REFERENCES vehicule(id_vehicule),
    garage_id BIGINT REFERENCES garage(id_garage),
    
    type_maintenance VARCHAR(100) NOT NULL 
        CHECK (type_maintenance IN ('VISITE_TECHNIQUE', 'REPARATION', 'ENTRETIEN')),
    
    date_debut DATE NOT NULL,
    date_fin_prevue DATE,
    date_fin_reelle DATE,
    
    cout_prevu DECIMAL(10,2) CHECK (cout_prevu >= 0),
    cout_reel DECIMAL(10,2) CHECK (cout_reel >= 0),
    
    description TEXT,
    pieces_changees TEXT,
    
    statut VARCHAR(50) DEFAULT 'EN_COURS' 
        CHECK (statut IN ('EN_COURS', 'TERMINE', 'ANNULE')),
    
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE liste_attente (
    id_liste_attente BIGSERIAL PRIMARY KEY,
    
    trajet_id BIGINT NOT NULL REFERENCES trajet(id_trajet),
    client_id BIGINT NOT NULL REFERENCES personne(id_personne),
    
    nombre_places_demandees BIGINT NOT NULL CHECK (nombre_places_demandees > 0),
    date_depart_souhaitee DATE,
    
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE' 
        CHECK (statut IN ('EN_ATTENTE', 'NOTIFIE', 'CONVERTI', 'EXPIRE', 'ANNULE')),
    
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_notification TIMESTAMP,
    remarques TEXT
);




CREATE TABLE audit_log (
    id_audit_log BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action VARCHAR(50) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    utilisateur_id BIGINT REFERENCES personne(id_personne),
    anciennes_valeurs TEXT,
    nouvelles_valeurs TEXT,
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE INDEX idx_vehicule_statut ON vehicule(statut) WHERE actif = TRUE;
CREATE INDEX idx_voyage_date_statut ON voyage(date_depart, statut);
CREATE INDEX idx_voyage_trajet ON voyage(trajet_id, date_depart) WHERE statut = 'PLANIFIE';
CREATE INDEX idx_reservation_voyage ON reservation(voyage_id, statut);
CREATE INDEX idx_reservation_client ON reservation(client_id, date_reservation DESC);
CREATE INDEX idx_paiement_reference ON paiement(type_paiement, reference_id);
CREATE INDEX idx_depense_date ON depense(date_depense DESC, type_depense);

-- ============================================
-- VUE : RECETTES (Calculees, pas stockees)
-- ============================================

CREATE VIEW v_voyage_disponibilite AS
SELECT 
    v.id_voyage,
    v.code_voyage,
    v.date_depart,
    v.statut,
    v.prix_par_place,
    
    -- Informations trajet
    t.code AS trajet_code,
    t.ville_depart,
    t.ville_arrivee,
    t.distance_km,
    
    -- Informations vehicule
    ve.immatriculation,
    ve.nombre_places AS capacite_totale,
    
    -- ✅ Calcul en temps reel (pas stocke !)
    COALESCE(SUM(
        CASE 
            WHEN r.statut NOT IN ('ANNULE') 
            THEN r.nombre_places 
            ELSE 0 
        END
    ), 0) AS places_reservees,
    
    ve.nombre_places - COALESCE(SUM(
        CASE 
            WHEN r.statut NOT IN ('ANNULE') 
            THEN r.nombre_places 
            ELSE 0 
        END
    ), 0) AS places_disponibles,
    
    ROUND(
        (COALESCE(SUM(
            CASE 
                WHEN r.statut NOT IN ('ANNULE') 
                THEN r.nombre_places 
                ELSE 0 
            END
        ), 0)::NUMERIC / ve.nombre_places) * 100, 
        2
    ) AS taux_occupation_pct,
    
    -- Informations chauffeur
    p.nom AS chauffeur_nom,
    p.prenom AS chauffeur_prenom
    
FROM voyage v
INNER JOIN trajet t ON v.trajet_id = t.id_trajet
INNER JOIN vehicule ve ON v.vehicule_id = ve.id_vehicule
INNER JOIN personne p ON v.chauffeur_id = p.id_personne
LEFT JOIN reservation r ON r.voyage_id = v.id_voyage
GROUP BY 
    v.id_voyage, v.code_voyage, v.date_depart, v.statut, v.prix_par_place,
    t.code, t.ville_depart, t.ville_arrivee, t.distance_km,
    ve.immatriculation, ve.nombre_places,
    p.nom, p.prenom;

-- ✅ VUE pour l'affichage de reservation (UI/UX)
-- Repond a : "Quels voyages puis-je reserver ?"
CREATE VIEW v_voyages_reservables AS
SELECT 
    vd.*
FROM v_voyage_disponibilite vd
WHERE vd.statut = 'PLANIFIE'
  AND vd.places_disponibles > 0
  AND vd.date_depart > CURRENT_TIMESTAMP
ORDER BY vd.date_depart;



CREATE VIEW v_recettes AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY date_recette, type_recette) AS id_recette,
    date_recette,
    voyage_id,
    type_recette,
    montant,
    description
FROM (
    -- Recettes des reservations
    SELECT 
        r.date_reservation::DATE AS date_recette,
        r.voyage_id,
        'RESERVATION' AS type_recette,
        r.montant_paye AS montant,
        'Reservation ' || r.code_reservation || ' - ' || 
        p.nom || ' ' || COALESCE(p.prenom, '') AS description
    FROM reservation r
    JOIN personne p ON r.client_id = p.id_personne
    WHERE r.statut NOT IN ('ANNULE')
    
    UNION ALL
    
    -- Recettes des colis
    SELECT 
        c.date_envoi::DATE AS date_recette,
        c.voyage_id,
        'COLIS' AS type_recette,
        c.tarif AS montant,
        'Colis ' || c.code_colis || ' - ' || c.destinataire_nom AS description
    FROM colis c
    WHERE c.statut NOT IN ('ANNULE')
) AS recettes_consolidees
ORDER BY date_recette DESC, type_recette;

-- Vue agregee pour dashboard
CREATE VIEW v_recettes_par_voyage AS
SELECT 
    v.id_voyage,
    v.code_voyage,
    v.date_depart,
    t.ville_depart,
    t.ville_arrivee,
    COALESCE(SUM(CASE WHEN r.type_recette = 'RESERVATION' THEN r.montant ELSE 0 END), 0) AS recettes_passagers,
    COALESCE(SUM(CASE WHEN r.type_recette = 'COLIS' THEN r.montant ELSE 0 END), 0) AS recettes_colis,
    COALESCE(SUM(r.montant), 0) AS recettes_totales
FROM voyage v
JOIN trajet t ON v.trajet_id = t.id_trajet
LEFT JOIN v_recettes r ON r.voyage_id = v.id_voyage
GROUP BY v.id_voyage, v.code_voyage, v.date_depart, t.ville_depart, t.ville_arrivee;


-- ✅ TRIGGER : Verifier places disponibles AVANT insertion
CREATE OR REPLACE FUNCTION fn_check_places_avant_reservation()
RETURNS TRIGGER AS $$
DECLARE
    v_places_dispo BIGINT;
BEGIN
    -- Recuperer places disponibles depuis la VUE
    SELECT places_disponibles INTO v_places_dispo
    FROM v_voyage_disponibilite
    WHERE id_voyage = NEW.voyage_id;
    
    IF v_places_dispo IS NULL THEN
        RAISE EXCEPTION 'Voyage introuvable';
    END IF;
    
    IF NEW.nombre_places > v_places_dispo THEN
        RAISE EXCEPTION 'Pas assez de places. Disponibles: %, Demandees: %', 
            v_places_dispo, NEW.nombre_places;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_places_reservation
BEFORE INSERT ON reservation
FOR EACH ROW
WHEN (NEW.statut != 'ANNULE')
EXECUTE FUNCTION fn_check_places_avant_reservation();

-- ✅ TRIGGER : Empecher double reservation simultanee
CREATE OR REPLACE FUNCTION fn_lock_voyage_pour_reservation()
RETURNS TRIGGER AS $$
BEGIN
    -- Lock le voyage pendant la transaction
    PERFORM * FROM voyage WHERE id_voyage = NEW.voyage_id FOR UPDATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lock_voyage
BEFORE INSERT ON reservation
FOR EACH ROW
EXECUTE FUNCTION fn_lock_voyage_pour_reservation();



-- Fonction : Obtenir les dates disponibles pour un trajet
CREATE OR REPLACE FUNCTION fn_get_dates_disponibles(p_trajet_id BIGINT)
RETURNS TABLE(date_voyage DATE, nb_voyages_dispo BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        DATE(v.date_depart) AS date_voyage,
        COUNT(*)::BIGINT AS nb_voyages_dispo
    FROM v_voyages_reservables v
    WHERE v.id_voyage IN (
        SELECT voy.id_voyage 
        FROM voyage voy 
        WHERE voy.trajet_id = p_trajet_id
    )
    GROUP BY DATE(v.date_depart)
    ORDER BY date_voyage;
END;
$$ LANGUAGE plpgsql;

-- Fonction : Obtenir les heures disponibles pour un trajet a une date
CREATE OR REPLACE FUNCTION fn_get_heures_disponibles(
    p_trajet_id BIGINT, 
    p_date DATE
)
RETURNS TABLE(
    id_voyage BIGINT,
    heure_depart TIME,
    places_disponibles BIGINT,
    prix_par_place NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id_voyage,
        v.date_depart::TIME AS heure_depart,
        v.places_disponibles,
        v.prix_par_place
    FROM v_voyages_reservables v
    WHERE v.id_voyage IN (
        SELECT voy.id_voyage 
        FROM voyage voy 
        WHERE voy.trajet_id = p_trajet_id
          AND DATE(voy.date_depart) = p_date
    )
    ORDER BY heure_depart;
END;
$$ LANGUAGE plpgsql;

-- Fonction : Calculer montant reservation
CREATE OR REPLACE FUNCTION fn_calculer_montant_reservation(
    p_voyage_id BIGINT,
    p_nombre_places BIGINT
)
RETURNS NUMERIC AS $$
DECLARE
    v_prix_unitaire NUMERIC;
    v_montant_total NUMERIC;
BEGIN
    SELECT prix_par_place INTO v_prix_unitaire
    FROM voyage
    WHERE id_voyage = p_voyage_id;
    
    IF v_prix_unitaire IS NULL THEN
        RAISE EXCEPTION 'Voyage introuvable';
    END IF;
    
    v_montant_total := v_prix_unitaire * p_nombre_places;
    
    RETURN v_montant_total;
END;
$$ LANGUAGE plpgsql;


