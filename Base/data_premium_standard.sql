-- ============================================
-- DONNEES ADAPTEES POUR SCHEMA PREMIUM/STANDARD
-- ============================================
-- Distribution: Places Premium = 25%, Places Standard = 75%
-- Tarification: Premium ≈ 1.75x Standard
-- a EXeCUTER APReS table.sql pour initialiser les donnees
-- ============================================

\c taxi_brousse;

-- ✅ RESET SEQUENCES (Pour recommencer avec des IDs propres)
ALTER SEQUENCE type_vehicule_id_type_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE trajet_id_trajet_seq RESTART WITH 1;
ALTER SEQUENCE garage_id_garage_seq RESTART WITH 1;
ALTER SEQUENCE personne_id_personne_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE tarif_id_tarif_seq RESTART WITH 1;
ALTER SEQUENCE voyage_id_voyage_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE colis_id_colis_seq RESTART WITH 1;
ALTER SEQUENCE paiement_id_paiement_seq RESTART WITH 1;
ALTER SEQUENCE depense_id_depense_seq RESTART WITH 1;
ALTER SEQUENCE maintenance_id_maintenance_seq RESTART WITH 1;
ALTER SEQUENCE liste_attente_id_liste_attente_seq RESTART WITH 1;

-- ============================================
-- TYPES DE VEHICULES
-- ============================================
INSERT INTO type_vehicule (code, nom, capacite_standard, description, actif)
VALUES 
    ('BUS_30', 'Bus Standard', 30, 'Bus climatise 30 places', TRUE),
    ('VAN_15', 'Van Confortable', 15, 'Van avec sieges remboures', TRUE),
    ('MINI_7', 'Minibus', 7, 'Minibus pour petits trajets', TRUE),
    ('TAXI_4', 'Taxi Collectif', 4, 'Taxi standard avec 4 places', TRUE),
    ('4X4_5', '4x4 Safari', 5, '4x4 pour trajets difficiles', TRUE);

-- ============================================
-- TRAJETS
-- ============================================
INSERT INTO trajet (code, ville_depart, ville_arrivee, distance_km, duree_estimee_minutes, description, actif)
VALUES 
    ('T001', 'Antananarivo', 'Antsirabe', 169.5, 210, 'Route nationale RN1', TRUE),
    ('T002', 'Antsirabe', 'Miandrivazo', 185.0, 300, 'Route via Ambositra', TRUE),
    ('T003', 'Antananarivo', 'Ambatolampy', 69.0, 90, 'Route express', TRUE),
    ('T004', 'Antananarivo', 'Fianarantsoa', 407.0, 600, 'Route longue - Sud', TRUE),
    ('T005', 'Antsirabe', 'Toliara', 470.0, 720, 'Route sud - extrême', TRUE),
    ('T006', 'Fianarantsoa', 'Toliara', 330.0, 480, 'Route est-ouest', TRUE),
    ('T007', 'Ambatolampy', 'Antsirabe', 115.0, 150, 'Route secondaire', TRUE);

-- ============================================
-- GARAGES
-- ============================================
INSERT INTO garage (nom, adresse, telephone, email, specialite, actif)
VALUES 
    ('Garage Antananarivo Centre', 'Avenue de l''Independance, Antananarivo', '+261 20 22 123 456', 'garage.anta@taxi.mg', 'Entretien general', TRUE),
    ('Garage Antsirabe Express', 'Route RN1, Antsirabe', '+261 20 44 567 890', 'garage.antsi@taxi.mg', 'Reparation mecanique', TRUE),
    ('Garage Fianarantsoa Auto', 'Centre-ville, Fianarantsoa', '+261 20 75 234 567', 'garage.fiana@taxi.mg', 'Visite technique', TRUE),
    ('Garage Toliara Entretien', 'Route du port, Toliara', '+261 20 94 345 678', 'garage.tolia@taxi.mg', 'Carrosserie', TRUE);

-- ============================================
-- VEHICULES (Avec distribution Premium/Standard)
-- ============================================
-- Bus 30 places : 8 premium (25%) + 22 standard (75%)
-- Van 15 places : 4 premium (27%) + 11 standard (73%)
-- Minibus 7 places : 2 premium (29%) + 5 standard (71%)
-- Taxi 4 places : 1 premium (25%) + 3 standard (75%)
-- 4x4 5 places : 1 premium (20%) + 4 standard (80%)

INSERT INTO vehicule (
    immatriculation, type_vehicule_id, garage_id, marque, modele, annee, couleur, numero_chassis, 
    nombre_places_premium, nombre_places_standard, 
    statut, kilometrage_actuel, date_acquisition, date_derniere_visite_technique, date_prochaine_visite_technique, actif
)
VALUES 
    -- Bus 30 places (8 premium + 22 standard)
    ('501-MG-ANT', 1, 1, 'Mercedes', 'Sprinter 513CDI', 2015, 'Blanc', 'WDB90X194F7123456', 8, 22, 'DISPONIBLE', 125000.50, '2015-06-01', '2025-10-15', '2026-10-15', TRUE),
    ('502-MG-ANT', 1, 1, 'Hyundai', 'County 34', 2018, 'Bleu', 'KMHEC4A46JU123457', 8, 22, 'DISPONIBLE', 89000.00, '2018-03-15', '2025-11-20', '2026-11-20', TRUE),
    
    -- Van 15 places (4 premium + 11 standard)
    ('701-MG-ANTSI', 2, 2, 'Toyota', 'Hiace', 2017, 'Gris', '4T1RF1FA5H1123458', 4, 11, 'EN_SERVICE', 95500.75, '2017-05-20', '2025-09-10', '2026-09-10', TRUE),
    ('702-MG-ANTSI', 2, 2, 'Ford', 'Transit', 2016, 'Blanc', 'WF0XXXWPFG1123459', 4, 11, 'DISPONIBLE', 102000.00, '2016-08-10', '2025-08-05', '2026-08-05', TRUE),
    
    -- Minibus 7 places (2 premium + 5 standard)
    ('801-MG-FIANA', 3, 3, 'Peugeot', 'Boxer', 2019, 'Orange', 'VF3BJFNXS00123460', 2, 5, 'DISPONIBLE', 45000.25, '2019-09-01', '2025-12-01', '2026-12-01', TRUE),
    ('802-MG-FIANA', 3, 3, 'Renault', 'Master', 2018, 'Jaune', 'VF1FG000161123461', 2, 5, 'EN_MAINTENANCE', 52100.00, '2018-11-20', '2025-07-15', '2026-07-15', TRUE),
    
    -- Taxi 4 places (1 premium + 3 standard)
    ('901-MG-TOLIA', 4, 4, 'Peugeot', '301', 2020, 'Blanc', 'VF3CCFFD251123462', 1, 3, 'DISPONIBLE', 28000.50, '2020-07-12', '2025-11-01', '2026-11-01', TRUE),
    ('902-MG-TOLIA', 4, 4, 'Hyundai', 'i10', 2021, 'Gris', 'KMHEC5A46JU123463', 1, 3, 'DISPONIBLE', 18500.00, '2021-02-28', '2025-12-10', '2026-12-10', TRUE),
    
    -- 4x4 Safari (1 premium + 4 standard)
    ('1001-MG-ANT', 5, 1, 'Toyota', 'Land Cruiser', 2014, 'Noir', 'JTMHY4F34E5123464', 1, 4, 'DISPONIBLE', 180000.00, '2014-04-10', '2025-06-20', '2026-06-20', TRUE);

-- ============================================
-- PERSONNES (Chauffeurs, Aides, Clients, Employes)
-- ============================================
INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, telephone, email, adresse, permis_numero, permis_categorie, permis_date_expiration, statut, actif)
VALUES 
    -- Chauffeurs
    ('CHAUFFEUR', 'Randriamampoinimerina', 'Jean', '101234567', '1978-05-15', '+261 32 12 34 567', 'jean.randi@email.mg', 'Antananarivo', 'P123456', 'D', '2026-12-31', 'ACTIF', TRUE),
    ('CHAUFFEUR', 'Ratsimamanga', 'Marc', '102234567', '1982-08-22', '+261 32 23 45 678', 'marc.ratsi@email.mg', 'Antsirabe', 'P234567', 'D', '2027-06-30', 'ACTIF', TRUE),
    ('CHAUFFEUR', 'Razafindrakoto', 'Pierre', '103234567', '1975-03-10', '+261 32 34 56 789', 'pierre.raza@email.mg', 'Fianarantsoa', 'P345678', 'D', '2026-03-31', 'ACTIF', TRUE),
    ('CHAUFFEUR', 'Andrianampoinimerina', 'Paul', '104234567', '1985-11-28', '+261 32 45 67 890', 'paul.andri@email.mg', 'Toliara', 'P456789', 'D', '2027-09-30', 'ACTIF', TRUE),
    
    -- Aide Chauffeur
    ('AIDE_CHAUFFEUR', 'Ravaloson', 'Luc', '105234567', '1990-02-14', '+261 32 56 78 901', 'luc.rava@email.mg', 'Ambatolampy', NULL, NULL, NULL, 'ACTIF', TRUE),
    
    -- Clients
    ('CLIENT', 'Ranivoson', 'Marie', '201234567', '1988-06-20', '+261 33 11 22 333', 'marie.rani@email.mg', 'Antananarivo', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('CLIENT', 'Rajaonarison', 'Sophie', '202234567', '1992-09-15', '+261 33 22 33 444', 'sophie.raja@email.mg', 'Antsirabe', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('CLIENT', 'Rajaonah', 'Laurent', '203234567', '1980-01-25', '+261 33 33 44 555', 'laurent.raja@email.mg', 'Fianarantsoa', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('CLIENT', 'Rasolofo', 'Nathalie', '204234567', '1986-12-08', '+261 33 44 55 666', 'nathalie.raso@email.mg', 'Toliara', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('CLIENT', 'Bemananzovonjatovo', 'Alain', '205234567', '1975-07-30', '+261 33 55 66 777', 'alain.bema@email.mg', 'Ambatolampy', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('CLIENT', 'Rakotomavo', 'Christelle', '206234567', '1994-04-12', '+261 33 66 77 888', 'christelle.rako@email.mg', 'Antananarivo', NULL, NULL, NULL, 'ACTIF', TRUE),
    
    -- Employes
    ('EMPLOYE', 'Randrianasolo', 'Olivier', '301234567', '1980-03-18', '+261 34 77 88 999', 'olivier.randi@email.mg', 'Antananarivo', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('EMPLOYE', 'Ranaivoson', 'Catherine', '302234567', '1985-09-22', '+261 34 88 99 000', 'catherine.rana@email.mg', 'Antananarivo', NULL, NULL, NULL, 'ACTIF', TRUE),
    ('EMPLOYE', 'Rakotonirina', 'David', '303234567', '1992-05-05', '+261 34 99 00 111', 'david.rako@email.mg', 'Antsirabe', NULL, NULL, NULL, 'ACTIF', TRUE);

-- ============================================
-- TARIFS (Avec prix_place_standard ET prix_place_premium)
-- ============================================
-- Premium = 75% + 40% du standard (arrondi)
-- T001 Anta->Antsi: Standard 25K, Premium 40K
-- T002 Antsi->Miandri: Standard 35K, Premium 55K
-- T003 Anta->Ambatol: Standard 15K, Premium 25K
-- T004 Anta->Fiana: Standard 60K, Premium 95K
-- T005 Antsi->Toliara: Standard 80K, Premium 130K
-- T006 Fiana->Toliara: Standard 65K, Premium 105K
-- T007 Ambatol->Antsi: Standard 20K, Premium 32K

INSERT INTO tarif (trajet_id, type_vehicule_id, prix_place_standard, prix_place_premium, type_tarif, date_debut, date_fin, multiplicateur, actif)
VALUES 
    -- Trajet T001 : Antananarivo -> Antsirabe
    (1, 1, 25000.00, 40000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),  -- Bus
    (1, 2, 25000.00, 40000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),  -- Van
    (1, 3, 25000.00, 40000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),  -- Minibus
    
    -- Trajet T002 : Antsirabe -> Miandrivazo
    (2, 1, 35000.00, 55000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    (2, 2, 35000.00, 55000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    
    -- Trajet T003 : Antananarivo -> Ambatolampy
    (3, 3, 15000.00, 25000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    (3, 4, 15000.00, 25000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    
    -- Trajet T004 : Antananarivo -> Fianarantsoa (long)
    (4, 1, 60000.00, 95000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    (4, 2, 60000.00, 95000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    
    -- Trajet T005 : Antsirabe -> Toliara
    (5, 1, 80000.00, 130000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    (5, 5, 80000.00, 130000.00, 'NORMAL', '2025-01-01', NULL, 1.0, TRUE),
    
    -- Tarifs weekend (multiplicateur 1.5x)
    (1, 1, 25000.00, 40000.00, 'WEEKEND', '2025-01-01', NULL, 1.5, TRUE),
    (2, 1, 35000.00, 55000.00, 'WEEKEND', '2025-01-01', NULL, 1.5, TRUE);

-- ============================================
-- VOYAGES
-- ============================================
INSERT INTO voyage (code_voyage, trajet_id, vehicule_id, chauffeur_id, aide_chauffeur_id, date_depart, date_arrivee_prevue, statut, prix_par_place)
VALUES 
    -- Voyage 1 : Anta -> Antsi, demain a 08h
    ('VOY20250116001', 1, 1, 1, 5, CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '8 hours', CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '11 hours', 'PLANIFIE', 25000.00),
    
    -- Voyage 2 : Anta -> Antsi, demain a 14h
    ('VOY20250116002', 1, 2, 2, 5, CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '14 hours', CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '17 hours', 'PLANIFIE', 25000.00),
    
    -- Voyage 3 : Anta -> Antsi, demain (Van)
    ('VOY20250116003', 1, 3, 1, NULL, CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '16 hours', CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '19 hours', 'PLANIFIE', 25000.00),
    
    -- Voyage 4 : Antsi -> Miandriv, apres-demain
    ('VOY20250117001', 2, 2, 3, 5, CURRENT_TIMESTAMP + INTERVAL '2 days' + INTERVAL '9 hours', CURRENT_TIMESTAMP + INTERVAL '2 days' + INTERVAL '14 hours', 'PLANIFIE', 35000.00),
    
    -- Voyage 5 : Anta -> Ambatol (court)
    ('VOY20250116004', 3, 4, 4, NULL, CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '10 hours', CURRENT_TIMESTAMP + INTERVAL '1 day' + INTERVAL '11.5 hours', 'PLANIFIE', 15000.00),
    
    -- Voyage 6 : Anta -> Fiana (long, dans 3 jours)
    ('VOY20250118001', 4, 1, 2, 5, CURRENT_TIMESTAMP + INTERVAL '3 days' + INTERVAL '7 hours', CURRENT_TIMESTAMP + INTERVAL '3 days' + INTERVAL '17 hours', 'PLANIFIE', 60000.00),
    
    -- Voyage passe (EN_COURS)
    ('VOY20250115001', 1, 3, 1, NULL, CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP + INTERVAL '1 hour', 'EN_COURS', 25000.00),
    
    -- Voyage termine
    ('VOY20250114001', 3, 4, 4, NULL, CURRENT_TIMESTAMP - INTERVAL '24 hours' - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '24 hours' - INTERVAL '1.5 hours', 'TERMINE', 15000.00);

-- ============================================
-- RESERVATIONS (Avec distribution Premium/Standard)
-- ============================================
INSERT INTO reservation (
    code_reservation, voyage_id, client_id, 
    nombre_places_premium, nombre_places_standard, 
    montant_total_premium, montant_total_standard, 
    montant_paye, mode_reservation, statut, date_reservation, remarques
)
VALUES 
    -- Reservation 1 : Voyage 1, 1 premium + 1 standard (25K + 40K = 65K)
    ('RES001-20250116', 1, 6, 1, 1, 40000.00, 25000.00, 65000.00, 'EN_LIGNE', 'PAYE', CURRENT_TIMESTAMP, 'Reservation en ligne'),
    
    -- Reservation 2 : Voyage 1, 2 standard (50K)
    ('RES002-20250116', 1, 7, 0, 2, 0.00, 50000.00, 25000.00, 'TELEPHONE', 'CONFIRME', CURRENT_TIMESTAMP, 'Paiement partiel'),
    
    -- Reservation 3 : Voyage 1, 1 premium (40K)
    ('RES003-20250116', 1, 8, 1, 0, 40000.00, 0.00, 0.00, 'SUR_PLACE', 'EN_ATTENTE', CURRENT_TIMESTAMP, 'En attente de paiement'),
    
    -- Reservation 4 : Voyage 2, 2 premium (80K)
    ('RES004-20250116', 2, 9, 2, 0, 80000.00, 0.00, 80000.00, 'EN_LIGNE', 'PAYE', CURRENT_TIMESTAMP - INTERVAL '1 day', 'Deja payee'),
    
    -- Reservation 5 : Voyage 2, 1 standard (25K)
    ('RES005-20250116', 2, 10, 0, 1, 0.00, 25000.00, 25000.00, 'SUR_PLACE', 'PAYE', CURRENT_TIMESTAMP, NULL),
    
    -- Reservation 6 : Voyage 3 (Van), 2 premium + 2 standard (80K + 50K = 130K)
    ('RES006-20250116', 3, 11, 2, 2, 80000.00, 50000.00, 130000.00, 'EN_LIGNE', 'PAYE', CURRENT_TIMESTAMP, 'Groupe famille'),
    
    -- Reservation 7 : Voyage 4, 1 premium + 1 standard (55K + 35K = 90K)
    ('RES007-20250117', 4, 6, 1, 1, 55000.00, 35000.00, 0.00, 'TELEPHONE', 'EN_ATTENTE', CURRENT_TIMESTAMP, 'Confirmation en attente'),
    
    -- Reservation 8 : Voyage 5 (Taxi court), 1 premium (25K)
    ('RES008-20250116', 5, 12, 1, 0, 25000.00, 0.00, 25000.00, 'SUR_PLACE', 'PAYE', CURRENT_TIMESTAMP - INTERVAL '30 minutes', NULL),
    
    -- Reservation 9 : Voyage 6 (long), 2 premium + 3 standard (190K + 180K = 370K)
    ('RES009-20250118', 6, 7, 2, 3, 190000.00, 180000.00, 185000.00, 'EN_LIGNE', 'CONFIRME', CURRENT_TIMESTAMP - INTERVAL '2 days', 'Acompte verse'),
    
    -- Reservation 10 : Voyage passe (TERMINDEE), 1 premium + 1 standard
    ('RES010-20250115', 7, 8, 1, 1, 40000.00, 25000.00, 65000.00, 'SUR_PLACE', 'TERMINE', CURRENT_TIMESTAMP - INTERVAL '24 hours' - INTERVAL '3 hours', 'Voyage complete'),
    
    -- Reservation 11 : Annulee
    ('RES011-20250116', 1, 9, 1, 0, 40000.00, 0.00, 0.00, 'TELEPHONE', 'ANNULE', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'Annulation client');

-- ============================================
-- COLIS
-- ============================================
INSERT INTO colis (code_colis, voyage_id, expediteur_id, destinataire_nom, destinataire_telephone, description, poids_kg, tarif, statut, date_envoi, remarques)
VALUES 
    -- Colis Voyage 1
    ('COL001', 1, 6, 'Rakoto Jean', '+261 33 77 88 999', 'Boîte vêtements', 15.5, 5000.00, 'EN_TRANSIT', CURRENT_TIMESTAMP, NULL),
    ('COL002', 1, 7, 'Rabe Marie', '+261 33 88 99 000', 'Documents importants', 2.0, 3000.00, 'ENREGISTRE', CURRENT_TIMESTAMP, 'Fragile - a manipuler avec soin'),
    
    -- Colis Voyage 4
    ('COL003', 4, 8, 'Ramirez Pierre', '+261 33 99 00 111', 'Carton fournitures scolaires', 25.0, 8000.00, 'ENREGISTRE', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL);

-- ============================================
-- PAIEMENTS
-- ============================================
INSERT INTO paiement (code_paiement, type_paiement, reference_id, montant, mode_paiement, moment_paiement, date_paiement, reference_transaction, recu_par_id, remarques)
VALUES 
    -- Paiements reservations
    ('PAY001', 'RESERVATION', 1, 65000.00, 'ESPECE', 'RESERVATION', CURRENT_TIMESTAMP, 'TRX20250116001', 13, 'Paiement complet en especes'),
    ('PAY002', 'RESERVATION', 2, 25000.00, 'MOBILE_MONEY', 'RESERVATION', CURRENT_TIMESTAMP - INTERVAL '12 hours', 'TRX20250115001', 13, 'Paiement partiel via Orange Money'),
    ('PAY003', 'RESERVATION', 4, 80000.00, 'CARTE', 'DEPART', CURRENT_TIMESTAMP - INTERVAL '1 day', 'TRX20250115002', 14, 'Carte bancaire'),
    ('PAY004', 'RESERVATION', 5, 25000.00, 'ESPECE', 'ARRIVEE', CURRENT_TIMESTAMP, 'TRX20250116002', 14, 'Paiement a la livraison'),
    ('PAY005', 'RESERVATION', 6, 130000.00, 'MOBILE_MONEY', 'RESERVATION', CURRENT_TIMESTAMP - INTERVAL '6 hours', 'TRX20250116003', 13, 'Airmoney - Groupe'),
    ('PAY006', 'RESERVATION', 9, 185000.00, 'CARTE', 'RESERVATION', CURRENT_TIMESTAMP - INTERVAL '2 days', 'TRX20250114001', 14, 'Acompte - Voyage long'),
    
    -- Paiements colis
    ('PAY007', 'COLIS', 1, 5000.00, 'ESPECE', 'DEPART', CURRENT_TIMESTAMP, 'TRX20250116004', 13, 'Frais colis'),
    ('PAY008', 'COLIS', 2, 3000.00, 'ESPECE', 'DEPART', CURRENT_TIMESTAMP, 'TRX20250116005', 13, 'Documents'),
    
    -- Remboursement (annulation)
    ('PAY009', 'REMBOURSEMENT', 11, 40000.00, 'MOBILE_MONEY', 'RESERVATION', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'TRX20250116006', 13, 'Remboursement annulation');

-- ============================================
-- DEPENSES
-- ============================================
INSERT INTO depense (code_depense, type_depense, vehicule_id, voyage_id, garage_id, beneficiaire_id, montant, date_depense, description, facture_numero, approuve_par_id, statut, date_creation)
VALUES 
    ('DEP001', 'CARBURANT', 1, NULL, NULL, NULL, 45000.00, CURRENT_DATE - INTERVAL '3 days', 'Carburant Diesel 250L', 'FAC20250113001', 13, 'APPROUVE', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('DEP002', 'ENTRETIEN', 1, NULL, 1, NULL, 28500.00, CURRENT_DATE - INTERVAL '2 days', 'Vidange moteur', 'FAC20250114001', 13, 'PAYE', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    ('DEP003', 'CARBURANT', 2, NULL, NULL, NULL, 42000.00, CURRENT_DATE - INTERVAL '1 day', 'Carburant Diesel 210L', 'FAC20250115001', 13, 'APPROUVE', CURRENT_TIMESTAMP - INTERVAL '1 day'),
    ('DEP004', 'SALAIRE', NULL, NULL, NULL, 1, 500000.00, CURRENT_DATE, 'Salaire mensuel Janvier', 'SAL20250116001', 13, 'EN_ATTENTE', CURRENT_TIMESTAMP),
    ('DEP005', 'REPARATION', 3, NULL, 2, NULL, 125000.00, CURRENT_DATE, 'Reparation climatisation', 'FAC20250116001', 14, 'EN_ATTENTE', CURRENT_TIMESTAMP),
    ('DEP006', 'VISITE_TECHNIQUE', 4, NULL, 3, NULL, 95000.00, CURRENT_DATE + INTERVAL '5 days', 'Visite technique annuelle', 'TECH20250121001', 14, 'EN_ATTENTE', CURRENT_TIMESTAMP);

-- ============================================
-- MAINTENANCES
-- ============================================
INSERT INTO maintenance (vehicule_id, garage_id, type_maintenance, date_debut, date_fin_prevue, date_fin_reelle, cout_prevu, cout_reel, description, pieces_changees, statut, date_creation)
VALUES 
    (2, 2, 'VISITE_TECHNIQUE', CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE - INTERVAL '29 days', CURRENT_DATE - INTERVAL '29 days', 95000.00, 95000.00, 'Visite technique annuelle', 'Filters, bougies', 'TERMINE', CURRENT_TIMESTAMP - INTERVAL '30 days'),
    (3, 2, 'REPARATION', CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE - INTERVAL '5 days', 150000.00, 165000.00, 'Reparation climatisation + electrique', 'Compresseur, condenseur, batterie', 'TERMINE', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (6, 3, 'ENTRETIEN', CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE - INTERVAL '14 days', CURRENT_DATE - INTERVAL '14 days', 75000.00, 78000.00, 'Entretien preventif', 'Pneus remplaces partiellement', 'TERMINE', CURRENT_TIMESTAMP - INTERVAL '15 days'),
    (6, 3, 'REPARATION', CURRENT_DATE, CURRENT_DATE + INTERVAL '5 days', NULL, 250000.00, NULL, 'Reparation transmission en cours', 'Boîte de vitesses', 'EN_COURS', CURRENT_TIMESTAMP);

-- ============================================
-- LISTE D'ATTENTE
-- ============================================
INSERT INTO liste_attente (trajet_id, client_id, nombre_places_demandees, date_depart_souhaitee, statut, date_inscription, date_notification, remarques)
VALUES 
    (1, 6, 2, CURRENT_DATE + INTERVAL '3 days', 'EN_ATTENTE', CURRENT_TIMESTAMP - INTERVAL '2 days', NULL, 'Flexible sur les dates'),
    (4, 9, 1, CURRENT_DATE + INTERVAL '7 days', 'EN_ATTENTE', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL, 'Prefere voyage en fin d''apres-midi'),
    (2, 12, 3, CURRENT_DATE + INTERVAL '5 days', 'NOTIFIE', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '1 day', 'Place liberee - en attente confirmation'),
    (5, 10, 2, CURRENT_DATE + INTERVAL '10 days', 'EN_ATTENTE', CURRENT_TIMESTAMP - INTERVAL '1 week', NULL, NULL);

-- ============================================
-- CONFIGURATION
-- ============================================
INSERT INTO configuration (cle, valeur, type_valeur, categorie, description, date_modification)
VALUES 
    ('MONTANT_ACOMPTE_MIN_POURCENT', '30', 'NUMBER', 'PAIEMENTS', 'Acompte minimum requis en pourcentage', CURRENT_TIMESTAMP),
    ('DELAI_ANNULATION_HEURES', '4', 'NUMBER', 'RESERVATIONS', 'Delai avant depart pour annulation gratuite', CURRENT_TIMESTAMP),
    ('TAUX_PENALITE_ANNULATION', '10', 'NUMBER', 'RESERVATIONS', 'Penalite annulation en pourcentage', CURRENT_TIMESTAMP),
    ('DELAI_EXPIRATION_LISTE_ATTENTE_JOURS', '30', 'NUMBER', 'LISTE_ATTENTE', 'Jours avant expiration automatique', CURRENT_TIMESTAMP),
    ('DEVISE_PRINCIPALE', 'MGA', 'STRING', 'GENERAL', 'Devise utilisee pour tous les montants', CURRENT_TIMESTAMP),
    ('NOM_ENTREPRISE', 'Taxi Brousse Express', 'STRING', 'GENERAL', 'Nom officiel de l''entreprise', CURRENT_TIMESTAMP),
    ('TELEPHONE_PRINCIPAL', '+261 20 22 123 456', 'STRING', 'CONTACT', 'Telephone principal d''accueil', CURRENT_TIMESTAMP),
    ('EMAIL_SUPPORT', 'support@taxibrousse.mg', 'STRING', 'CONTACT', 'Email support client', CURRENT_TIMESTAMP),
    ('CAPACITE_MOYENNE_VOYAGE', '20', 'NUMBER', 'OPERATIONNEL', 'Capacite moyenne estimee pour calculs', CURRENT_TIMESTAMP),
    ('PRIX_MOYEN_KM', '150', 'NUMBER', 'TARIFICATION', 'Prix moyen par km (en MGA)', CURRENT_TIMESTAMP);

-- ============================================
-- AUDIT LOGS
-- ============================================
INSERT INTO audit_log (table_name, record_id, action, utilisateur_id, anciennes_valeurs, nouvelles_valeurs, date_action)
VALUES 
    ('vehicule', 3, 'UPDATE', 13, '{"statut":"DISPONIBLE"}', '{"statut":"EN_SERVICE"}', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    ('voyage', 7, 'UPDATE', 13, '{"statut":"PLANIFIE"}', '{"statut":"EN_COURS"}', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
    ('reservation', 11, 'UPDATE', 14, '{"statut":"EN_ATTENTE"}', '{"statut":"ANNULE"}', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
    ('paiement', 9, 'INSERT', 13, NULL, '{"type_paiement":"REMBOURSEMENT","montant":40000}', CURRENT_TIMESTAMP - INTERVAL '1 hour');

-- ============================================
-- RESUME DES DONNEES INSEREES
-- ============================================
-- ✅ Types vehicules : 5
-- ✅ Trajets : 7
-- ✅ Garages : 4
-- ✅ Vehicules : 9 (avec distribution premium/standard)
-- ✅ Personnes : 14 (4 chauffeurs, 1 aide, 6 clients, 3 employes)
-- ✅ Tarifs : 13 (avec prix_place_standard et prix_place_premium)
-- ✅ Voyages : 8 (6 PLANIFIES, 1 EN_COURS, 1 TERMINE)
-- ✅ Reservations : 11 (avec distribution premium/standard)
-- ✅ Colis : 3
-- ✅ Paiements : 9
-- ✅ Depenses : 6
-- ✅ Maintenances : 4 (3 terminees, 1 en cours)
-- ✅ Liste d'attente : 4
-- ✅ Configuration : 10 cles
-- ✅ Audit logs : 4

-- ============================================
-- VERIFICATION (A executer apres insertion)
-- ============================================
-- SELECT COUNT(*) AS nombre_vehicules FROM vehicule;
-- SELECT COUNT(*) AS nombre_reservations FROM reservation;
-- SELECT SUM(nombre_places_premium + nombre_places_standard) AS places_totales FROM vehicule;
-- SELECT * FROM v_voyages_reservables LIMIT 5;
-- SELECT * FROM v_voyage_analytics WHERE id_voyage IN (1, 2, 3) LIMIT 5;
SET prix_place_standard = 37500.00,
    prix_place_premium = 60000.00
WHERE trajet_id = 1 AND type_tarif = 'WEEKEND';

-- Mettre a jour les vehicules avec places premium/standard
-- Bus 30 places : 8 premium + 22 standard
UPDATE vehicule SET nombre_places_premium = 8, nombre_places_standard = 22 WHERE id_vehicule = 1;
UPDATE vehicule SET nombre_places_premium = 8, nombre_places_standard = 22 WHERE id_vehicule = 2;

-- Van 15 places : 5 premium + 10 standard
UPDATE vehicule SET nombre_places_premium = 5, nombre_places_standard = 10 WHERE id_vehicule = 3;
UPDATE vehicule SET nombre_places_premium = 5, nombre_places_standard = 10 WHERE id_vehicule = 4;

-- Minibus 7 places : 2 premium + 5 standard
UPDATE vehicule SET nombre_places_premium = 2, nombre_places_standard = 5 WHERE id_vehicule = 5;
UPDATE vehicule SET nombre_places_premium = 2, nombre_places_standard = 5 WHERE id_vehicule = 6;

-- Taxi 4 places : 1 premium + 3 standard
UPDATE vehicule SET nombre_places_premium = 1, nombre_places_standard = 3 WHERE id_vehicule = 7;
UPDATE vehicule SET nombre_places_premium = 1, nombre_places_standard = 3 WHERE id_vehicule = 8;

-- 4x4 Safari 5 places : 2 premium + 3 standard
UPDATE vehicule SET nombre_places_premium = 2, nombre_places_standard = 3 WHERE id_vehicule = 9;
