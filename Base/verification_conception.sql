-- ============================================
-- VeRIFICATION DE LA NOUVELLE CONCEPTION
-- ============================================
-- Script a executer pour verifier les changements

-- 1. Verifier que la colonne nombrePlacesDisponibles a ete supprimee
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'voyage' 
AND column_name = 'nombre_places_disponibles';
-- Resultat attendu : VIDE (colonne n'existe pas)

-- 2. Verifier la structure de voyage
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'voyage'
ORDER BY ordinal_position;

-- 3. Verifier les reservations actuelles
SELECT 
    r.id_reservation,
    r.code_reservation,
    r.statut,
    v.code_voyage,
    r.nombre_places,
    t.ville_depart,
    t.ville_arrivee
FROM reservation r
JOIN voyage v ON r.voyage_id = v.id_voyage
JOIN trajet t ON v.trajet_id = t.id_trajet
ORDER BY r.date_reservation DESC
LIMIT 20;

-- 4. Verifier les places disponibles EN TEMPS ReEL pour chaque voyage
SELECT 
    v.id_voyage,
    v.code_voyage,
    v.date_depart,
    t.ville_depart,
    t.ville_arrivee,
    ve.nombre_places AS capacite_totale,
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
    ), 0) AS places_disponibles
FROM voyage v
JOIN trajet t ON v.trajet_id = t.id_trajet
JOIN vehicule ve ON v.vehicule_id = ve.id_vehicule
LEFT JOIN reservation r ON r.voyage_id = v.id_voyage
WHERE v.statut = 'PLANIFIE'
GROUP BY v.id_voyage, v.code_voyage, v.date_depart, t.ville_depart, t.ville_arrivee, ve.nombre_places
ORDER BY v.date_depart;

-- 5. Verifier la VUE v_voyage_disponibilite (si elle existe)
SELECT * FROM v_voyage_disponibilite LIMIT 5;

-- 6. Verifier les trajets avec voyages
SELECT * FROM v_trajets_avec_voyages;

-- 7. Tester le calcul des dates disponibles pour un trajet
-- (Remplacer trajet_id par un ID reel)
SELECT DISTINCT CAST(date_depart AS date) as date
FROM voyage
WHERE trajet_id = 1 
  AND statut = 'PLANIFIE'
  AND date_depart > CURRENT_TIMESTAMP
ORDER BY CAST(date_depart AS date);

-- 8. Tester le calcul des heures disponibles pour un trajet a une date donnee
-- (Remplacer trajet_id et date par des valeurs reelles)
SELECT 
    id_voyage,
    code_voyage,
    date_depart::TIME as heure_depart,
    prix_par_place,
    vehicule_id
FROM voyage
WHERE trajet_id = 1
  AND CAST(date_depart AS date) = '2026-01-15'
  AND statut = 'PLANIFIE'
ORDER BY date_depart;

-- 9. Verifier les triggers
SELECT trigger_name
FROM information_schema.triggers
WHERE event_object_table = 'reservation'
ORDER BY trigger_name;

-- 10. Verifier les indexes critiques
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('voyage', 'reservation', 'trajet')
AND indexname LIKE '%voyage%' OR indexname LIKE '%reservation%'
ORDER BY tablename, indexname;
