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

