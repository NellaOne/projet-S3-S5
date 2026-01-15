-- ============================================
-- SCRIPT DE RÉINITIALISATION
-- ============================================
-- À exécuter EN DEHORS de la base taxi_brousse
-- Depuis psql : psql -U postgres -f reinit.sql

-- Terminer toutes les connexions à taxi_brousse
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'taxi_brousse'
  AND pid <> pg_backend_pid();

-- Attendre un peu que les connexions se ferment
-- (psql ne supporte pas les SLEEP, faire une pause manuelle)

-- Supprimer et recréer la base de données
DROP DATABASE IF EXISTS taxi_brousse;
CREATE DATABASE taxi_brousse 
  WITH 
    ENCODING 'UTF8' 
    TEMPLATE template0
    LC_COLLATE 'C'
    LC_CTYPE 'C';

\echo
\echo '✅ Base de données taxi_brousse réinitialisée avec succès !'
\echo 'Maintenant exécutez : psql -U postgres -d taxi_brousse -f table.sql'
\echo
