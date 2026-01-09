-- SCRIPT DE ReINITIALISATION TAXI BROUSSE

-- Terminer les connexions actives
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'taxi_brousse'
  AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS taxi_brousse;

CREATE DATABASE taxi_brousse;

-- CReATION DES TABLES
-- Table des types de vehicules (dynamique)
CREATE TABLE type_vehicule (
    id_type_vehicule SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    capacite_passagers INTEGER NOT NULL,
    capacite_bagages DECIMAL(10,2),
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des garages
CREATE TABLE garage (
    id_garage SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(50),
    email VARCHAR(100),
    specialite TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des vehicules
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    immatriculation VARCHAR(50) NOT NULL UNIQUE,
    type_vehicule_id INTEGER REFERENCES type_vehicule(id_type_vehicule),
    garage_id INTEGER REFERENCES garage(id_garage),
    marque VARCHAR(100),
    modele VARCHAR(100),
    annee INTEGER,
    couleur VARCHAR(50),
    nombre_places INTEGER NOT NULL,
    statut VARCHAR(50) DEFAULT 'DISPONIBLE',
    kilometrage_actuel DECIMAL(10,2) DEFAULT 0,
    date_acquisition DATE,
    date_derniere_visite_technique DATE,
    date_prochaine_visite_technique DATE,
    numero_chassis VARCHAR(50),
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des personnes (generique pour tous les types)
CREATE TABLE personne (
    id_personne SERIAL PRIMARY KEY,
    type_personne VARCHAR(50) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),
    cin VARCHAR(50) UNIQUE,
    date_naissance DATE,
    adresse TEXT,
    telephone VARCHAR(50),
    email VARCHAR(100),
    permis_numero VARCHAR(50),
    permis_categorie VARCHAR(20),
    permis_date_expiration DATE,
    date_embauche DATE,
    salaire_base DECIMAL(10,2),
    statut VARCHAR(50) DEFAULT 'ACTIF',
    photo_url VARCHAR(500),
    remarques TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des trajets/lignes
CREATE TABLE trajet (
    id_trajet SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    ville_depart VARCHAR(100) NOT NULL,
    ville_arrivee VARCHAR(100) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL,
    duree_estimee_minutes INTEGER,
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des tarifs (tres flexible)
CREATE TABLE tarif (
    id_tarif SERIAL PRIMARY KEY,
    trajet_id INTEGER REFERENCES trajet(id_trajet),
    type_vehicule_id INTEGER REFERENCES type_vehicule(id_type_vehicule),
    prix_base DECIMAL(10,2) NOT NULL,
    type_tarif VARCHAR(50) DEFAULT 'NORMAL',
    date_debut DATE,
    date_fin DATE,
    multiplicateur DECIMAL(5,2) DEFAULT 1.0,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des voyages (courses reelles)
CREATE TABLE voyage (
    id_voyage SERIAL PRIMARY KEY,
    code_voyage VARCHAR(50) UNIQUE NOT NULL,
    vehicule_id INTEGER REFERENCES vehicule(id_vehicule),
    chauffeur_id INTEGER REFERENCES personne(id_personne),
    aide_chauffeur_id INTEGER REFERENCES personne(id_personne),
    trajet_id INTEGER REFERENCES trajet(id_trajet),
    date_depart TIMESTAMP NOT NULL,
    date_arrivee_prevue TIMESTAMP,
    date_arrivee_reelle TIMESTAMP,
    statut VARCHAR(50) DEFAULT 'PLANIFIE',
    nombre_places_disponibles INTEGER,
    prix_par_place DECIMAL(10,2),
    remarques TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des reservations
CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    code_reservation VARCHAR(50) UNIQUE NOT NULL,
    voyage_id INTEGER REFERENCES voyage(id_voyage),
    client_id INTEGER REFERENCES personne(id_personne),
    nombre_places INTEGER NOT NULL DEFAULT 1,
    montant_total DECIMAL(10,2) NOT NULL,
    montant_paye DECIMAL(10,2) DEFAULT 0,
    montant_restant DECIMAL(10,2),
    mode_reservation VARCHAR(50) DEFAULT 'SUR_PLACE',
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE',
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarques TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des colis
CREATE TABLE colis (
    id_colis SERIAL PRIMARY KEY,
    code_colis VARCHAR(50) UNIQUE NOT NULL,
    voyage_id INTEGER REFERENCES voyage(id_voyage),
    expediteur_id INTEGER REFERENCES personne(id_personne),
    destinataire_nom VARCHAR(200),
    destinataire_telephone VARCHAR(50),
    description TEXT,
    poids_kg DECIMAL(10,2),
    tarif DECIMAL(10,2) NOT NULL,
    statut VARCHAR(50) DEFAULT 'ENREGISTRE',
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison TIMESTAMP,
    remarques TEXT
);

-- Table des paiements
CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,
    code_paiement VARCHAR(50) UNIQUE NOT NULL,
    type_paiement VARCHAR(50) NOT NULL,
    reference_id INTEGER NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    mode_paiement VARCHAR(50) NOT NULL,
    moment_paiement VARCHAR(50),
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_transaction VARCHAR(200),
    recu_par_id INTEGER REFERENCES personne(id_personne),
    remarques TEXT
);

-- Table des depenses
CREATE TABLE depense (
    id_depense SERIAL PRIMARY KEY,
    code_depense VARCHAR(50) UNIQUE NOT NULL,
    type_depense VARCHAR(100) NOT NULL,
    vehicule_id INTEGER REFERENCES vehicule(id_vehicule),
    garage_id INTEGER REFERENCES garage(id_garage),
    beneficiaire_id INTEGER REFERENCES personne(id_personne),
    montant DECIMAL(10,2) NOT NULL,
    date_depense DATE NOT NULL,
    description TEXT,
    facture_numero VARCHAR(100),
    facture_url VARCHAR(500),
    approuve_par_id INTEGER REFERENCES personne(id_personne),
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de maintenance
CREATE TABLE maintenance (
    id_maintenance SERIAL PRIMARY KEY,
    vehicule_id INTEGER REFERENCES vehicule(id_vehicule),
    garage_id INTEGER REFERENCES garage(id_garage),
    type_maintenance VARCHAR(100) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin_prevue DATE,
    date_fin_reelle DATE,
    cout_prevu DECIMAL(10,2),
    cout_reel DECIMAL(10,2),
    description TEXT,
    pieces_changees TEXT,
    statut VARCHAR(50) DEFAULT 'EN_COURS',
    kilometrage_au_moment INTEGER,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de liste d'attente
CREATE TABLE liste_attente (
    id_liste_attente SERIAL PRIMARY KEY,
    trajet_id INTEGER REFERENCES trajet(id_trajet),
    client_id INTEGER REFERENCES personne(id_personne),
    nombre_places_demandees INTEGER NOT NULL,
    date_depart_souhaitee DATE,
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE',
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_notification TIMESTAMP,
    remarques TEXT
);

-- Table des recettes (vue consolidee)
CREATE TABLE recette (
    id_recette SERIAL PRIMARY KEY,
    date_recette DATE NOT NULL,
    voyage_id INTEGER REFERENCES voyage(id_voyage),
    type_recette VARCHAR(50) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de configuration (pour parametres dynamiques)
CREATE TABLE configuration (
    id_configuration SERIAL PRIMARY KEY,
    cle VARCHAR(100) UNIQUE NOT NULL,
    valeur TEXT,
    type_valeur VARCHAR(50),
    categorie VARCHAR(100),
    description TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table d'audit/historique
CREATE TABLE audit_log (
    id_audit_log SERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(50) NOT NULL,
    utilisateur_id INTEGER REFERENCES personne(id_personne),
    anciennes_valeurs TEXT,
    nouvelles_valeurs TEXT,
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INDEXES POUR PERFORMANCE
-- ============================================
CREATE INDEX idx_vehicule_statut ON vehicule(statut);
CREATE INDEX idx_vehicule_type ON vehicule(type_vehicule_id);
CREATE INDEX idx_vehicule_garage ON vehicule(garage_id);
CREATE INDEX idx_personne_type ON personne(type_personne);
CREATE INDEX idx_personne_statut ON personne(statut);
CREATE INDEX idx_voyage_date ON voyage(date_depart);
CREATE INDEX idx_voyage_statut ON voyage(statut);
CREATE INDEX idx_voyage_vehicule ON voyage(vehicule_id);
CREATE INDEX idx_voyage_chauffeur ON voyage(chauffeur_id);
CREATE INDEX idx_voyage_trajet ON voyage(trajet_id);
CREATE INDEX idx_reservation_voyage ON reservation(voyage_id);
CREATE INDEX idx_reservation_client ON reservation(client_id);
CREATE INDEX idx_reservation_statut ON reservation(statut);
CREATE INDEX idx_depense_date ON depense(date_depense);
CREATE INDEX idx_depense_type ON depense(type_depense);
CREATE INDEX idx_depense_vehicule ON depense(vehicule_id);
CREATE INDEX idx_paiement_date ON paiement(date_paiement);
CREATE INDEX idx_colis_voyage ON colis(voyage_id);
CREATE INDEX idx_maintenance_vehicule ON maintenance(vehicule_id);
CREATE INDEX idx_trajet_code ON trajet(code);

-- ============================================
-- DONNeES INITIALES
-- ============================================

-- Types de vehicules
INSERT INTO type_vehicule (nom, capacite_passagers, capacite_bagages, description) VALUES
('Sprinter', 15, 20.0, 'Mini-bus Mercedes Sprinter'),
('Mazda', 18, 25.0, 'Bus Mazda'),
('Boeing', 25, 30.0, 'Grand bus type Boeing'),
('Hiace', 12, 15.0, 'Toyota Hiace');

-- Garages
INSERT INTO garage (nom, adresse, telephone, email, specialite) VALUES
('Garage Principal', 'Antananarivo, Route de Vatomandry', '+261 20 XX XX XX', 'garage@taxibrousse.mg', 'Entretien general'),
('Garage Tamatave', 'Tamatave, Zone Portuaire', '+261 20 YY YY YY', 'garage.tam@taxibrousse.mg', 'Reparations'),
('Garage Majunga', 'Majunga, Centre-ville', '+261 20 ZZ ZZ ZZ', 'garage.maj@taxibrousse.mg', 'Visite technique');

-- Configuration initiale
INSERT INTO configuration (cle, valeur, type_valeur, categorie, description) VALUES
('COMMISSION_RESERVATION', '0.05', 'DECIMAL', 'TARIFICATION', 'Commission sur reservations (5%)'),
('DELAI_ANNULATION_HEURES', '24', 'INTEGER', 'RESERVATION', 'Delai d''annulation gratuite'),
('TARIF_COLIS_PAR_KG', '500', 'DECIMAL', 'COLIS', 'Tarif par kg pour colis'),
('ALERTE_VISITE_TECHNIQUE_JOURS', '30', 'INTEGER', 'MAINTENANCE', 'Alerte avant visite technique'),
('NOM_ENTREPRISE', 'Taxi Brousse Madagascar', 'STRING', 'GENERAL', 'Nom de l''entreprise'),
('EMAIL_SUPPORT', 'support@taxibrousse.mg', 'STRING', 'CONTACT', 'Email de support'),
('TELEPHONE_PRINCIPAL', '+261 20 XX XX XX', 'STRING', 'CONTACT', 'Telephone principal');

-- Trajets populaires à Madagascar
INSERT INTO trajet (code, ville_depart, ville_arrivee, distance_km, duree_estimee_minutes, description) VALUES
('TNR-TAM', 'Antananarivo', 'Tamatave', 370, 480, 'Route nationale vers l''Est'),
('TNR-ANT', 'Antananarivo', 'Antsirabe', 169, 180, 'Route vers le centre'),
('TNR-MAJ', 'Antananarivo', 'Majunga', 550, 660, 'Route vers le Nord-Ouest'),
('TNR-TUL', 'Antananarivo', 'Tulear', 936, 1200, 'Route vers le Sud'),
('TAM-FEN', 'Tamatave', 'Fenerive', 125, 150, 'Route cotiere Nord'),
('ANT-FI', 'Antsirabe', 'Fianarantsoa', 280, 360, 'Route sud'),
('MAJ-AMP', 'Majunga', 'Ampijoroa', 140, 180, 'Route locale');

-- Personnes (Chauffeurs et Aides)
INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, permis_numero, permis_categorie, permis_date_expiration, date_embauche, salaire_base, statut) VALUES
('CHAUFFEUR', 'RAKOTO', 'Jean', '101123456789', '1985-05-15', 'Antananarivo, Lot 123', '+261 32 12 34 56', 'rakoto.j@email.mg', 'P123456', 'D', '2027-05-15', '2015-03-01', 500000, 'ACTIF'),
('CHAUFFEUR', 'RAZAFY', 'Marie', '101987654321', '1990-08-22', 'Antananarivo, Lot 456', '+261 33 45 67 89', 'razafy.m@email.mg', 'P654321', 'D', '2026-08-22', '2018-06-15', 480000, 'ACTIF'),
('CHAUFFEUR', 'ANDRIANAMPOINIMERINA', 'Paul', '101234567890', '1988-03-10', 'Antananarivo, Lot 789', '+261 34 56 78 90', 'andri.p@email.mg', 'P456789', 'D', '2028-03-10', '2017-01-10', 510000, 'ACTIF'),
('AIDE_CHAUFFEUR', 'RASOA', 'Pierre', '101555666777', '1995-12-05', 'Antananarivo, Lot 111', '+261 32 99 88 77', 'rasoa.p@email.mg', NULL, NULL, NULL, '2020-09-15', 250000, 'ACTIF'),
('AIDE_CHAUFFEUR', 'RANDRIANASOLO', 'Sophie', '101888999000', '1998-07-18', 'Antananarivo, Lot 222', '+261 33 11 22 33', 'randri.s@email.mg', NULL, NULL, NULL, '2021-04-20', 260000, 'ACTIF');

-- Clients (quelques clients de test)
INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, statut) VALUES
('CLIENT', 'RANDRIAMAMPOINIMERINA', 'Sylvain', '102111222333', '1992-09-14', 'Tamatave', '+261 32 11 11 11', 'sylvain@email.mg', 'ACTIF'),
('CLIENT', 'RATSIMAMANGA', 'Nathalie', '102444555666', '1987-02-28', 'Antsirabe', '+261 33 22 22 22', 'nathalie@email.mg', 'ACTIF'),
('CLIENT', 'RATSIMBAZAFY', 'Olivier', '102777888999', '1993-11-07', 'Majunga', '+261 34 33 33 33', 'olivier@email.mg', 'ACTIF'),
('CLIENT', 'RANDRIANAMPOINIMERINA', 'Henriette', '102000111222', '1980-06-03', 'Tulear', '+261 32 44 44 44', 'henriette@email.mg', 'ACTIF');

-- Vehicules de test
INSERT INTO vehicule (immatriculation, type_vehicule_id, garage_id, marque, modele, annee, couleur, nombre_places, statut, kilometrage_actuel, date_acquisition, date_prochaine_visite_technique, numero_chassis) VALUES
('1234 TAA', 1, 1, 'Mercedes', 'Sprinter', 2020, 'Blanc', 15, 'DISPONIBLE', 125000.50, '2020-02-15', '2026-02-15', 'WDB906K4JVCS12345'),
('5678 TAB', 2, 1, 'Mazda', 'E2700', 2019, 'Bleu', 18, 'DISPONIBLE', 98765.75, '2019-08-10', '2026-01-15', 'JM8BU34M050110045'),
('9012 TAC', 3, 2, 'Kinglong', 'XMQ6129', 2021, 'Noir', 25, 'EN_SERVICE', 52000.00, '2021-05-20', '2026-06-20', 'LGCEF55EXM1234567'),
('3456 TAD', 4, 1, 'Toyota', 'Hiace', 2018, 'Gris', 12, 'DISPONIBLE', 156789.25, '2018-11-05', '2025-11-05', '4T1BF1AK5CU123456');

