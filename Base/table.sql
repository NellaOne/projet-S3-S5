create database  taxi_brousse;
\c taxi_brousse;

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

-- Table des vehicules
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    immatriculation VARCHAR(50) NOT NULL UNIQUE,
    type_vehicule_id INTEGER REFERENCES type_vehicule(id_type_vehicule),
    marque VARCHAR(100),
    modele VARCHAR(100),
    annee INTEGER,
    couleur VARCHAR(50),
    nombre_places INTEGER NOT NULL,
    statut VARCHAR(50) DEFAULT 'DISPONIBLE', -- DISPONIBLE, EN_SERVICE, EN_MAINTENANCE, HORS_SERVICE
    kilometrage_actuel DECIMAL(10,2) DEFAULT 0,
    date_acquisition DATE,
    date_derniere_visite_technique DATE,
    date_prochaine_visite_technique DATE,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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

-- Table des personnes (generique pour tous les types)
CREATE TABLE personne (
    id_personne SERIAL PRIMARY KEY,
    type_personne VARCHAR(50) NOT NULL, -- CHAUFFEUR, AIDE_CHAUFFEUR, EMPLOYE, CLIENT
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
    statut VARCHAR(50) DEFAULT 'ACTIF', -- ACTIF, INACTIF, CONGE, SUSPENDU
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
    type_tarif VARCHAR(50) DEFAULT 'NORMAL', -- NORMAL, FETE, WEEKEND, NUIT
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
    statut VARCHAR(50) DEFAULT 'PLANIFIE', -- PLANIFIE, EN_COURS, TERMINE, ANNULE
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
    mode_reservation VARCHAR(50) DEFAULT 'SUR_PLACE', -- SUR_PLACE, TELEPHONE, EN_LIGNE
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE', -- EN_ATTENTE, CONFIRME, PAYE, ANNULE, TERMINE
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
    statut VARCHAR(50) DEFAULT 'ENREGISTRE', -- ENREGISTRE, EN_TRANSIT, LIVRE, ANNULE
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison TIMESTAMP,
    remarques TEXT
);

-- Table des paiements
CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,
    code_paiement VARCHAR(50) UNIQUE NOT NULL,
    type_paiement VARCHAR(50) NOT NULL, -- RESERVATION, COLIS, AUTRE
    reference_id INTEGER NOT NULL, -- ID de la reservation ou colis
    montant DECIMAL(10,2) NOT NULL,
    mode_paiement VARCHAR(50) NOT NULL, -- ESPECE, MOBILE_MONEY, CARTE, VIREMENT
    moment_paiement VARCHAR(50), -- RESERVATION, DEPART, ARRIVEE
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_transaction VARCHAR(200),
    recu_par_id INTEGER REFERENCES personne(id_personne),
    remarques TEXT
);

-- Table des depenses
CREATE TABLE depense (
    id_depense SERIAL PRIMARY KEY,
    code_depense VARCHAR(50) UNIQUE NOT NULL,
    type_depense VARCHAR(100) NOT NULL, -- CARBURANT, REPARATION, VISITE_TECHNIQUE, SALAIRE, ENTRETIEN, AUTRE
    vehicule_id INTEGER REFERENCES vehicule(id_vehicule),
    garage_id INTEGER REFERENCES garage(id_garage),
    beneficiaire_id INTEGER REFERENCES personne(id_personne),
    montant DECIMAL(10,2) NOT NULL,
    date_depense DATE NOT NULL,
    description TEXT,
    facture_numero VARCHAR(100),
    facture_url VARCHAR(500),
    approuve_par_id INTEGER REFERENCES personne(id_personne),
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE', -- EN_ATTENTE, APPROUVE, PAYE, REJETE
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de maintenance
CREATE TABLE maintenance (
    id_maintenance SERIAL PRIMARY KEY,
    vehicule_id INTEGER REFERENCES vehicule(id_vehicule),
    garage_id INTEGER REFERENCES garage(id_garage),
    type_maintenance VARCHAR(100) NOT NULL, -- VISITE_TECHNIQUE, REPARATION, ENTRETIEN
    date_debut DATE NOT NULL,
    date_fin_prevue DATE,
    date_fin_reelle DATE,
    cout_prevu DECIMAL(10,2),
    cout_reel DECIMAL(10,2),
    description TEXT,
    pieces_changees TEXT,
    statut VARCHAR(50) DEFAULT 'EN_COURS', -- EN_COURS, TERMINE, SUSPENDU
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
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE', -- EN_ATTENTE, NOTIFIE, CONVERTI, ANNULE
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_notification TIMESTAMP,
    remarques TEXT
);

-- Table des recettes (vue consolidee)
CREATE TABLE recette (
    id_recette SERIAL PRIMARY KEY,
    date_recette DATE NOT NULL,
    voyage_id INTEGER REFERENCES voyage(id_voyage),
    type_recette VARCHAR(50) NOT NULL, -- PASSAGER, COLIS, AUTRE
    montant DECIMAL(10,2) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de configuration (pour parametres dynamiques)
CREATE TABLE configuration (
    id_configuration SERIAL PRIMARY KEY,
    cle VARCHAR(100) UNIQUE NOT NULL,
    valeur TEXT,
    type_valeur VARCHAR(50), -- STRING, INTEGER, DECIMAL, BOOLEAN, JSON
    categorie VARCHAR(100),
    description TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table d'audit/historique
CREATE TABLE audit_log (
    id_audit_log SERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(50) NOT NULL, -- INSERT, UPDATE, DELETE
    utilisateur_id INTEGER REFERENCES personne(id_personne),
    anciennes_valeurs TEXT,
    nouvelles_valeurs TEXT,
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INDEXES POUR PERFORMANCE
CREATE INDEX idx_vehicule_statut ON vehicule(statut);
CREATE INDEX idx_vehicule_type ON vehicule(type_vehicule_id);
CREATE INDEX idx_personne_type ON personne(type_personne);
CREATE INDEX idx_personne_statut ON personne(statut);
CREATE INDEX idx_voyage_date ON voyage(date_depart);
CREATE INDEX idx_voyage_statut ON voyage(statut);
CREATE INDEX idx_reservation_voyage ON reservation(voyage_id);
CREATE INDEX idx_reservation_client ON reservation(client_id);
CREATE INDEX idx_reservation_statut ON reservation(statut);
CREATE INDEX idx_depense_date ON depense(date_depense);
CREATE INDEX idx_depense_type ON depense(type_depense);
CREATE INDEX idx_paiement_date ON paiement(date_paiement);


-- DONNeES INITIALES
-- Types de vehicules
INSERT INTO type_vehicule (nom, capacite_passagers, capacite_bagages, description) VALUES
('Sprinter', 15, 20.0, 'Mini-bus Mercedes Sprinter'),
('Mazda', 18, 25.0, 'Bus Mazda'),
('Boeing', 25, 30.0, 'Grand bus type Boeing'),
('Hiace', 12, 15.0, 'Toyota Hiace');

-- Configuration initiale
INSERT INTO configuration (cle, valeur, type_valeur, categorie, description) VALUES
('COMMISSION_RESERVATION', '0.05', 'DECIMAL', 'TARIFICATION', 'Commission sur reservations (5%)'),
('DELAI_ANNULATION_HEURES', '24', 'INTEGER', 'RESERVATION', 'Delai d''annulation gratuite'),
('TARIF_COLIS_PAR_KG', '500', 'DECIMAL', 'COLIS', 'Tarif par kg pour colis'),
('ALERTE_VISITE_TECHNIQUE_JOURS', '30', 'INTEGER', 'MAINTENANCE', 'Alerte avant visite technique');

-- Trajets populaires à Madagascar
INSERT INTO trajet (code, ville_depart, ville_arrivee, distance_km, duree_estimee_minutes) VALUES
('TNR-TAM', 'Antananarivo', 'Tamatave', 370, 480),
('TNR-ANT', 'Antananarivo', 'Antsirabe', 169, 180),
('TNR-MAJ', 'Antananarivo', 'Majunga', 550, 660),
('TNR-TUL', 'Antananarivo', 'Tulear', 936, 1200),
('TAM-FEN', 'Tamatave', 'Fenerive', 125, 150);