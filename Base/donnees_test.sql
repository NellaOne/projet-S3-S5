
INSERT INTO type_vehicule (nom, capacite_passagers, capacite_bagages, description, actif) VALUES
('Sprinter', 15, 20.0, 'Mini-bus Mercedes Sprinter - Confortable avec AC', TRUE),
('Mazda', 18, 25.0, 'Bus Mazda - Ideal trajets moyens', TRUE),
('Toyota Hiace', 12, 15.0, 'Toyota Hiace - Trajets courts/locaux', TRUE),
('Boeing', 25, 30.0, 'Grand bus type Boeing - Longues distances', TRUE),
('VW Transporter', 10, 12.0, 'Minibus - VIP/tourisme', TRUE);


INSERT INTO garage (nom, adresse, telephone, email, specialite, actif) VALUES
('Garage Central Tana', '123 Rue de l''Independance, Antananarivo', '+261 20 22 12 34', 'garage@taxibrousse.mg', 'Entretien general, Revisions completes', TRUE),
('Garage Express Tamatave', '456 Avenue Lapaix, Toamasina', '+261 20 53 45 67', 'tamatave@garages.mg', 'Reparations moteur, Changement pneus', TRUE),
('Garage Premium VIP', '789 Boulevard de la Paix, Antananarivo', '+261 20 22 98 76', 'premium@garages.mg', 'Revisions VIP, Climatisation, electricite', TRUE),
('Garage Nord Majunga', '321 Rue du Commerce, Mahajunga', '+261 20 62 34 56', 'majunga@garages.mg', 'Entretien general', TRUE);


INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, permis_numero, permis_categorie, permis_date_expiration, statut, actif) VALUES
('CHAUFFEUR', 'Rakoto', 'Jean', '101201001', '1985-03-15', '123 Rue du Roi, Tana', '+261 32 12 34 567', 'jean.rakoto@email.mg', 'PERM001', 'D1', '2026-12-31', 'ACTIF', TRUE),
('CHAUFFEUR', 'Randriamampoinimerina', 'Pierre', '102205002', '1988-07-22', '456 Rue Solitude, Tana', '+261 33 45 67 890', 'pierre.rand@email.mg', 'PERM002', 'D1', '2025-06-15', 'ACTIF', TRUE),
('CHAUFFEUR', 'Bemanatoa', 'Michel', '103210003', '1990-11-08', '789 Rue de la Paix, Toliara', '+261 34 78 90 123', 'michel.bem@email.mg', 'PERM003', 'D1', '2027-03-20', 'ACTIF', TRUE),
('CHAUFFEUR', 'Ranarivo', 'Samuel', '104215004', '1992-05-30', '321 Avenue Soleil, Majunga', '+261 32 98 76 543', 'samuel.rana@email.mg', 'PERM004', 'D1', '2026-09-10', 'CONGE', TRUE),
('CHAUFFEUR', 'Zazaravao', 'Martin', '105220005', '1987-09-12', '654 Rue Fleurs, Tamatave', '+261 33 54 32 10', 'martin.zaza@email.mg', 'PERM005', 'D1', '2025-12-25', 'ACTIF', TRUE);

INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, date_embauche, statut, actif) VALUES
('AIDE_CHAUFFEUR', 'Ramirez', 'Andre', '201301001', '1995-01-18', '111 Rue Jeunesse, Tana', '+261 32 11 22 33', 'andre.ram@email.mg', '2023-06-01', 'ACTIF', TRUE),
('AIDE_CHAUFFEUR', 'Andriamampoinimerina', 'Louis', '202305002', '1998-04-25', '222 Rue Courage, Tana', '+261 33 22 33 44', 'louis.andria@email.mg', '2023-08-15', 'ACTIF', TRUE),
('AIDE_CHAUFFEUR', 'Tolijaona', 'edouard', '203310003', '1996-08-10', '333 Rue Succes, Toliara', '+261 34 33 44 55', 'edouard.toli@email.mg', '2023-09-20', 'ACTIF', TRUE);

INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, date_embauche, salaire_base, statut, actif) VALUES
('EMPLOYE', 'Ratsimba', 'Jacques', '301401001', '1980-06-05', '444 Rue Travail, Tana', '+261 32 44 55 66', 'jacques.rats@email.mg', '2022-01-10', 1500000, 'ACTIF', TRUE),
('EMPLOYE', 'Andrianampoinimerina', 'Yves', '302405002', '1983-10-12', '555 Rue Commerce, Tana', '+261 33 55 66 77', 'yves.andrian@email.mg', '2022-03-15', 1200000, 'ACTIF', TRUE),
('EMPLOYE', 'Tolifotsoa', 'Mathieu', '303410003', '1989-12-20', '666 Rue Service, Toliara', '+261 34 66 77 88', 'mathieu.toli@email.mg', '2023-02-01', 900000, 'ACTIF', TRUE);

INSERT INTO personne (type_personne, nom, prenom, cin, date_naissance, adresse, telephone, email, statut, actif) VALUES
('CLIENT', 'Rasolofo', 'Anne', '401501001', '1975-02-14', '777 Rue Clients, Tana', '+261 32 77 88 99', 'anne.ras@email.mg', 'ACTIF', TRUE),
('CLIENT', 'Randrianatoandro', 'Bruno', '402505002', '1982-07-08', '888 Rue Affaires, Tana', '+261 33 88 99 00', 'bruno.rand@email.mg', 'ACTIF', TRUE),
('CLIENT', 'Tolifotsaravao', 'Catherine', '403510003', '1992-03-19', '999 Rue Voyages, Toliara', '+261 34 99 00 11', 'catherine.toli@email.mg', 'ACTIF', TRUE),
('CLIENT', 'Rabemanampy', 'Didier', '404515004', '1988-11-25', '1010 Rue Tourisme, Majunga', '+261 32 00 11 22', 'didier.rab@email.mg', 'ACTIF', TRUE),
('CLIENT', 'Randriamahitsy', 'elise', '405520005', '1994-05-03', '1111 Rue Vacances, Tamatave', '+261 33 11 22 33', 'elise.rand@email.mg', 'ACTIF', TRUE),
('CLIENT', 'Tolijaona', 'François', '406525006', '1986-09-17', '1212 Rue Transport, Antsirabe', '+261 34 22 33 44', 'francois.toli@email.mg', 'ACTIF', TRUE);

INSERT INTO vehicule (immatriculation, type_vehicule_id, marque, modele, annee, couleur, nombre_places, statut, kilometrage_actuel, date_acquisition, date_derniere_visite_technique, date_prochaine_visite_technique, actif) VALUES
('TNR-001-AA', 1, 'Mercedes', 'Sprinter 311', 2022, 'Blanc', 15, 'DISPONIBLE', 45000.0, '2022-01-15', '2024-12-01', '2025-12-01', TRUE),
('TNR-002-AA', 1, 'Mercedes', 'Sprinter 311', 2021, 'Bleu', 15, 'DISPONIBLE', 67500.0, '2021-06-20', '2024-11-15', '2025-11-15', TRUE),
('TNR-003-AA', 2, 'Mazda', 'E5000', 2020, 'Blanc', 18, 'EN_MAINTENANCE', 89000.0, '2020-03-10', '2024-10-01', '2025-10-01', TRUE),
('TNR-004-AA', 2, 'Mazda', 'E5000', 2019, 'Gris', 18, 'DISPONIBLE', 125000.0, '2019-08-05', '2024-09-20', '2025-09-20', TRUE),
('TNR-005-AA', 3, 'Toyota', 'Hiace 2.4', 2023, 'Noir', 12, 'DISPONIBLE', 23000.0, '2023-02-28', '2025-01-05', '2026-01-05', TRUE),
('TNR-006-AA', 4, 'Volvo', 'B10M', 2018, 'Blanc', 25, 'EN_SERVICE', 156000.0, '2018-11-12', '2024-08-15', '2025-08-15', TRUE),
('TNR-007-AA', 3, 'Toyota', 'Hiace 2.4', 2022, 'Bordeaux', 12, 'DISPONIBLE', 34500.0, '2022-09-01', '2024-12-20', '2025-12-20', TRUE),
('TAM-001-AA', 1, 'Mercedes', 'Sprinter 315', 2021, 'Bleu', 15, 'DISPONIBLE', 56000.0, '2021-05-10', '2024-11-01', '2025-11-01', TRUE),
('MAJ-001-AA', 2, 'Mazda', 'E5000', 2020, 'Blanc', 18, 'DISPONIBLE', 78500.0, '2020-07-15', '2024-10-15', '2025-10-15', TRUE);


INSERT INTO trajet (code, ville_depart, ville_arrivee, distance_km, duree_estimee_minutes, description) VALUES
('TNR-TAM', 'Antananarivo', 'Tamatave', 370, 480, 'Route nationale vers l''Est'),
('TNR-ANT', 'Antananarivo', 'Antsirabe', 169, 180, 'Route vers le centre'),
('TNR-MAJ', 'Antananarivo', 'Majunga', 550, 660, 'Route vers le Nord-Ouest'),
('TNR-TUL', 'Antananarivo', 'Tulear', 936, 1200, 'Route vers le Sud'),
('TAM-FEN', 'Tamatave', 'Fenerive', 125, 150, 'Route cotiere Nord'),
('ANT-FI', 'Antsirabe', 'Fianarantsoa', 280, 360, 'Route sud'),
('MAJ-AMP', 'Majunga', 'Ampijoroa', 140, 180, 'Route locale');


INSERT INTO tarif (trajet_id, type_vehicule_id, prix_base, type_tarif, multiplicateur, actif) VALUES
(1, 1, 45000, 'NORMAL', 1.0, TRUE),
(1, 2, 40000, 'NORMAL', 1.0, TRUE),
(1, 4, 50000, 'NORMAL', 1.0, TRUE),
(1, 1, 54000, 'WEEKEND', 1.2, TRUE),
(1, 2, 48000, 'WEEKEND', 1.2, TRUE),
(1, 1, 50000, 'NUIT', 1.1, TRUE),

(2, 1, 12000, 'NORMAL', 1.0, TRUE),
(2, 2, 10000, 'NORMAL', 1.0, TRUE),
(2, 3, 8000, 'NORMAL', 1.0, TRUE),
(2, 1, 14400, 'WEEKEND', 1.2, TRUE),

(3, 1, 60000, 'NORMAL', 1.0, TRUE),
(3, 2, 55000, 'NORMAL', 1.0, TRUE),
(3, 4, 70000, 'NORMAL', 1.0, TRUE),

(4, 4, 95000, 'NORMAL', 1.0, TRUE),
(4, 2, 85000, 'NORMAL', 1.0, TRUE),

(5, 1, 15000, 'NORMAL', 1.0, TRUE),
(5, 3, 12000, 'NORMAL', 1.0, TRUE);

INSERT INTO voyage (code_voyage, vehicule_id, chauffeur_id, aide_chauffeur_id, trajet_id, date_depart, date_arrivee_prevue, date_arrivee_reelle, statut, nombre_places_disponibles, prix_par_place, remarques, date_creation, date_modification) VALUES
('VOY-2025-01-01', 1, 1, 1, 1, '2025-01-01 07:00:00', '2025-01-01 15:30:00', '2025-01-01 15:45:00', 'TERMINE', 0, 45000, 'Voyage complet', '2024-12-20 10:00:00', '2025-01-01 16:00:00'),
('VOY-2025-01-02', 2, 2, 2, 2, '2025-01-02 08:00:00', '2025-01-02 11:00:00', '2025-01-02 11:15:00', 'TERMINE', 2, 12000, 'Quelques places restantes', '2024-12-25 14:00:00', '2025-01-02 12:00:00'),
('VOY-2025-01-03', 4, 3, 3, 1, '2025-01-03 06:30:00', '2025-01-03 15:00:00', '2025-01-03 15:30:00', 'TERMINE', 1, 40000, 'Trajet normal', '2024-12-28 09:00:00', '2025-01-03 16:00:00'),

('VOY-2025-01-08', 1, 1, 1, 1, '2025-01-08 07:00:00', '2025-01-08 15:30:00', NULL, 'EN_COURS', 3, 45000, 'En route vers Tamatave', '2025-01-07 15:00:00', '2025-01-08 08:30:00'),

('VOY-2025-01-09', 2, 2, 2, 2, '2025-01-09 08:00:00', '2025-01-09 11:00:00', NULL, 'PLANIFIE', 15, 12000, 'Depart demain', '2025-01-08 10:00:00', '2025-01-08 10:00:00'),
('VOY-2025-01-10', 7, 5, 3, 1, '2025-01-10 07:00:00', '2025-01-10 15:30:00', NULL, 'PLANIFIE', 12, 45000, 'Prevu dimanche', '2025-01-08 11:00:00', '2025-01-08 11:00:00'),
('VOY-2025-01-11', 4, 3, 2, 3, '2025-01-11 06:00:00', '2025-01-11 18:00:00', NULL, 'PLANIFIE', 18, 60000, 'Voyage Majunga', '2025-01-08 12:00:00', '2025-01-08 12:00:00'),
('VOY-2025-01-12', 8, 1, 1, 1, '2025-01-12 07:00:00', '2025-01-12 15:30:00', NULL, 'PLANIFIE', 10, 45000, 'Dimanche soir', '2025-01-08 13:00:00', '2025-01-08 13:00:00');


INSERT INTO reservation (code_reservation, voyage_id, client_id, nombre_places, montant_total, montant_paye, montant_restant, mode_reservation, statut, date_reservation, remarques, date_modification) VALUES
('RES-2025-01-001', 1, 1, 2, 90000, 90000, 0, 'EN_LIGNE', 'TERMINE', '2024-12-15 14:00:00', 'Reservation en ligne', '2025-01-01 16:00:00'),
('RES-2025-01-002', 1, 2, 3, 135000, 135000, 0, 'TELEPHONE', 'TERMINE', '2024-12-20 10:30:00', 'Appel telephonique', '2025-01-01 16:00:00'),
('RES-2025-01-003', 2, 3, 1, 12000, 12000, 0, 'SUR_PLACE', 'TERMINE', '2025-01-02 07:45:00', 'Sur place à la gare', '2025-01-02 12:00:00'),
('RES-2025-01-004', 3, 4, 2, 80000, 80000, 0, 'EN_LIGNE', 'TERMINE', '2024-12-28 16:20:00', 'VIP client', '2025-01-03 16:00:00'),

('RES-2025-01-005', 4, 1, 1, 45000, 45000, 0, 'SUR_PLACE', 'CONFIRME', '2025-01-08 06:00:00', 'Confirme sur place', '2025-01-08 06:30:00'),
('RES-2025-01-006', 4, 5, 2, 90000, 90000, 0, 'EN_LIGNE', 'CONFIRME', '2025-01-07 18:00:00', 'Reservation en ligne confirmee', '2025-01-08 07:00:00'),

('RES-2025-01-007', 5, 2, 1, 12000, 0, 12000, 'TELEPHONE', 'EN_ATTENTE', '2025-01-08 14:00:00', 'À confirmer', '2025-01-08 14:00:00'),
('RES-2025-01-008', 5, 3, 2, 24000, 12000, 12000, 'SUR_PLACE', 'PAYE', '2025-01-08 15:00:00', 'Paiement partiel reçu', '2025-01-08 15:30:00'),
('RES-2025-01-009', 6, 4, 1, 45000, 0, 45000, 'EN_LIGNE', 'EN_ATTENTE', '2025-01-08 16:00:00', 'Dimanche matin', '2025-01-08 16:00:00'),
('RES-2025-01-010', 7, 1, 3, 180000, 90000, 90000, 'SUR_PLACE', 'PAYE', '2025-01-08 17:00:00', 'Groupe de 3 personnes', '2025-01-08 17:30:00');

INSERT INTO colis (code_colis, voyage_id, expediteur_id, destinataire_nom, destinataire_telephone, description, poids_kg, tarif, statut, date_envoi, date_livraison, remarques) VALUES
('COL-2025-01-001', 1, 1, 'Rakoto Jean Paul', '+261 32 11 22 33', 'Vêtements et livres', 5.5, 15000, 'LIVRE', '2025-01-01 07:00:00', '2025-01-01 15:45:00', 'Livre en bon etat'),
('COL-2025-01-002', 1, 2, 'Andriamampoinimerina Luc', '+261 33 44 55 66', 'Medicaments et produits pharmaceutiques', 2.3, 8000, 'LIVRE', '2025-01-01 07:15:00', '2025-01-01 15:45:00', 'Livre - Urgent'),
('COL-2025-01-003', 2, 3, 'Tolifotsoa Remy', '+261 34 66 77 88', 'Fournitures scolaires', 3.8, 5000, 'LIVRE', '2025-01-02 08:00:00', '2025-01-02 11:15:00', 'Rentree scolaire'),
('COL-2025-01-004', 3, 4, 'Rasolofo Yvette', '+261 32 77 88 99', 'Pieces detachees automobiles', 12.5, 25000, 'LIVRE', '2025-01-03 06:30:00', '2025-01-03 15:30:00', 'Garage'),
('COL-2025-01-005', 4, 5, 'Randrianatoandro Claude', '+261 33 88 99 00', 'electronique et accessoires', 4.2, 12000, 'EN_TRANSIT', '2025-01-08 07:00:00', NULL, 'En route'),
('COL-2025-01-006', 5, 1, 'Tolijaona Marie', '+261 34 99 00 11', 'Fruits et legumes frais', 18.0, 30000, 'ENREGISTRE', '2025-01-09 08:00:00', NULL, 'Depart demain');


INSERT INTO paiement (code_paiement, type_paiement, reference_id, montant, mode_paiement, moment_paiement, date_paiement, reference_transaction, recu_par_id, remarques) VALUES
('PAI-2025-01-001', 'RESERVATION', 1, 90000, 'CARTE', 'RESERVATION', '2024-12-15 14:15:00', 'CARD-2025-001', 7, 'Paiement par carte'),
('PAI-2025-01-002', 'RESERVATION', 2, 135000, 'MOBILE_MONEY', 'RESERVATION', '2024-12-20 10:45:00', 'MOOV-2025-001', 7, 'Orange Money'),
('PAI-2025-01-003', 'RESERVATION', 3, 12000, 'ESPECE', 'DEPART', '2025-01-02 07:50:00', 'ESP-2025-001', 8, 'Especes à la gare'),
('PAI-2025-01-004', 'RESERVATION', 4, 80000, 'VIREMENT', 'RESERVATION', '2024-12-28 16:30:00', 'VIREMENT-2025-001', 7, 'Virement bancaire'),

('PAI-2025-01-005', 'COLIS', 1, 15000, 'ESPECE', 'DEPART', '2025-01-01 07:10:00', 'ESP-2025-002', 8, 'Colis livre Tamatave'),
('PAI-2025-01-006', 'COLIS', 2, 8000, 'ESPECE', 'DEPART', '2025-01-01 07:20:00', 'ESP-2025-003', 8, 'Urgent'),
('PAI-2025-01-007', 'COLIS', 3, 5000, 'MOBILE_MONEY', 'DEPART', '2025-01-02 08:05:00', 'MOOV-2025-002', 8, 'Airtel Money'),

('PAI-2025-01-008', 'RESERVATION', 8, 12000, 'ESPECE', 'RESERVATION', '2025-01-08 15:15:00', 'ESP-2025-004', 8, 'Acompte'),
('PAI-2025-01-009', 'RESERVATION', 10, 90000, 'MOBILE_MONEY', 'RESERVATION', '2025-01-08 17:15:00', 'MOOV-2025-003', 8, 'Acompte groupe');


INSERT INTO depense (code_depense, type_depense, vehicule_id, garage_id, beneficiaire_id, montant, date_depense, description, facture_numero, approuve_par_id, statut, date_creation) VALUES
('DEP-2025-01-001', 'CARBURANT', 1, NULL, NULL, 250000, '2025-01-01', 'Carburant diesel Tana', 'FUEL-001', 9, 'PAYE', '2025-01-01 08:00:00'),
('DEP-2025-01-002', 'CARBURANT', 2, NULL, NULL, 280000, '2025-01-02', 'Carburant diesel Tana', 'FUEL-002', 9, 'PAYE', '2025-01-02 09:00:00'),
('DEP-2025-01-003', 'CARBURANT', 4, NULL, NULL, 320000, '2025-01-03', 'Carburant diesel Tamatave', 'FUEL-003', 9, 'APPROUVE', '2025-01-03 10:00:00'),

('DEP-2025-01-004', 'REPARATION', 3, 1, NULL, 450000, '2024-12-28', 'Reparation moteur - Spark plugs, filtre', 'REP-2025-001', 9, 'PAYE', '2024-12-28 14:00:00'),
('DEP-2025-01-005', 'VISITE_TECHNIQUE', 6, 2, NULL, 180000, '2025-01-05', 'Visite technique annuelle', 'VISITE-2025-001', 9, 'APPROUVE', '2025-01-05 11:00:00'),
('DEP-2025-01-006', 'ENTRETIEN', 1, 3, NULL, 120000, '2025-01-06', 'Entretien preventif - Revision 45000 km', 'ENT-2025-001', 9, 'EN_ATTENTE', '2025-01-06 15:00:00'),

('DEP-2025-01-007', 'SALAIRE', NULL, NULL, 1, 200000, '2025-01-01', 'Salaire janvier Rakoto Jean (chauffeur)', 'SAL-2025-001', 9, 'PAYE', '2025-01-01 10:00:00'),
('DEP-2025-01-008', 'SALAIRE', NULL, NULL, 6, 150000, '2025-01-01', 'Salaire janvier Ramirez Andre (aide)', 'SAL-2025-002', 9, 'PAYE', '2025-01-01 10:00:00'),

('DEP-2025-01-009', 'AUTRE', 1, NULL, NULL, 85000, '2025-01-07', 'Pneus avant (2x) - Vulcanisation', 'PNEU-2025-001', 9, 'EN_ATTENTE', '2025-01-07 16:00:00');

INSERT INTO maintenance (vehicule_id, garage_id, type_maintenance, date_debut, date_fin_prevue, date_fin_reelle, cout_prevu, cout_reel, description, pieces_changees, statut, kilometrage_au_moment) VALUES
(3, 1, 'REPARATION', '2024-12-27', '2024-12-30', '2024-12-28', 500000, 450000, 'Reparation moteur', 'Spark plugs, Filtre air, Filtre huile', 'TERMINE', 89000),
(6, 2, 'VISITE_TECHNIQUE', '2025-01-05', '2025-01-06', NULL, 200000, NULL, 'Visite technique annuelle', NULL, 'EN_COURS', 156000),
(1, 3, 'ENTRETIEN', '2025-01-06', '2025-01-08', NULL, 150000, NULL, 'Revision 45000 km', 'Revision complete moteur', 'EN_COURS', 45000),
(8, 1, 'VISITE_TECHNIQUE', '2025-01-10', '2025-01-12', NULL, 180000, NULL, 'Visite technique annuelle', NULL, 'EN_COURS', 56000);


INSERT INTO liste_attente (trajet_id, client_id, nombre_places_demandees, date_depart_souhaitee, statut, date_inscription, date_notification, remarques) VALUES
(1, 6, 2, '2025-01-15', 'EN_ATTENTE', '2025-01-08 10:00:00', NULL, 'Prefere le matin'),
(2, 4, 1, '2025-01-20', 'EN_ATTENTE', '2025-01-08 11:00:00', NULL, 'Flexible sur les dates'),
(3, 5, 4, '2025-01-22', 'EN_ATTENTE', '2025-01-08 12:00:00', NULL, 'Groupe de 4 personnes'),
(1, 2, 2, '2025-01-12', 'NOTIFIE', '2025-01-07 09:00:00', '2025-01-09 08:00:00', 'Notifie le 09/01');


INSERT INTO recette (date_recette, voyage_id, type_recette, montant, description) VALUES
('2025-01-01', 1, 'PASSAGER', 225000, 'Reservations voyages 1'),
('2025-01-01', 1, 'COLIS', 23000, 'Colis voyage 1'),
('2025-01-02', 2, 'PASSAGER', 12000, 'Reservation voyage 2'),
('2025-01-02', 2, 'COLIS', 5000, 'Colis voyage 2'),
('2025-01-03', 3, 'PASSAGER', 80000, 'Reservation voyage 3'),
('2025-01-03', 3, 'COLIS', 25000, 'Colis voyage 3'),
('2025-01-08', 4, 'PASSAGER', 135000, 'Reservations voyage 4 (en cours)');


INSERT INTO configuration (cle, valeur, type_valeur, categorie, description) VALUES
('COMMISSION_RESERVATION', '0.05', 'DECIMAL', 'TARIFICATION', 'Commission sur reservations (5%)'),
('DELAI_ANNULATION_HEURES', '24', 'INTEGER', 'RESERVATION', 'Delai d''annulation gratuite (heures)'),
('TARIF_COLIS_PAR_KG', '500', 'DECIMAL', 'COLIS', 'Tarif de base par kg pour colis'),
('ALERTE_VISITE_TECHNIQUE_JOURS', '30', 'INTEGER', 'MAINTENANCE', 'Alerte avant visite technique (jours)'),
('TAUX_CHANGE_USD', '4000', 'DECIMAL', 'FINANCE', 'Taux de change USD/MGA'),
('POURCENTAGE_RESERVE_CARBURANT', '10', 'DECIMAL', 'CARBURANT', 'Pourcentage reserve carburant'),
('EMAIL_NOTIFICATION', 'admin@taxibrousse.mg', 'STRING', 'NOTIFICATON', 'Email pour notifications'),
('ACTIVER_SMS', 'false', 'BOOLEAN', 'NOTIFICATION', 'Activation SMS'),
('LOGO_URL', '/static/images/logo.png', 'STRING', 'UI', 'URL du logo'),
('VERSION_APP', '1.0.0', 'STRING', 'SYSTEME', 'Version de l''application');

-- ========================================
-- FIN DES DONNeES DE TEST
-- ========================================
-- Total: 
-- - 5 types de vehicules
-- - 4 garages
-- - 18 personnes (5 chauffeurs, 3 aides, 3 employes, 6 clients, 1 admin)
-- - 5 trajets
-- - 17 tarifs
-- - 8 voyages
-- - 10 reservations
-- - 6 colis
-- - 9 paiements
-- - 9 depenses
-- - 4 maintenances
-- - 4 listes d'attente
-- - 7 recettes
-- - 10 configurations

-- Commandes utiles pour verifier:
-- SELECT COUNT(*) FROM type_vehicule;  -- 5
-- SELECT COUNT(*) FROM vehicule;       -- 9
-- SELECT COUNT(*) FROM personne;       -- 18
-- SELECT COUNT(*) FROM voyage;         -- 8
-- SELECT COUNT(*) FROM reservation;    -- 10
-- SELECT SUM(montant_paye) FROM reservation; -- Total paye
