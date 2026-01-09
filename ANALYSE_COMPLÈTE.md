# 📊 ANALYSE COMPLÈTE DU PROJET TAXIBROUSSE

## 🎯 OBJECTIF DU PROJET
**TaxiBrousse** est une application de **gestion intégrée de transport collectif** (taxi-brousse) destinée à gérer:
- Les trajets et les voyages
- Les réservations de passagers
- Les véhicules et leur maintenance
- Les finances (revenus, dépenses, paiements)
- Le transport de colis
- La gestion du personnel (chauffeurs, aides)

---

## 🏗️ ARCHITECTURE DU PROJET

### Stack Technologique
- **Framework**: Spring Boot 3.5.9
- **Java Version**: Java 17 LTS
- **Build**: Maven
- **Base de données**: PostgreSQL
- **Template Engine**: Thymeleaf
- **ORM**: JPA/Hibernate
- **Frontend**: Bootstrap 5, CSS3, JavaScript
- **Packaging**: WAR (Web Archive)

### Structure du Projet
```
src/main/
├── java/com/taxiBrousse/app/
│   ├── controller/       (5 contrôleurs)
│   ├── model/           (12 entités)
│   ├── service/         (5 services)
│   └── repositories/    (12 repositories)
└── resources/
    ├── templates/       (HTML Thymeleaf)
    ├── static/
    │   ├── css/
    │   ├── js/
    │   └── images/
    └── application.properties
```

---

## 📋 MODÈLE DE DONNÉES (12 ENTITÉS)

### 1. **PERSONNE** (Générique pour tous types)
```
Champs: id, typePersonne, nom, prenom, cin, dateNaissance, adresse, 
        telephone, email, permisNumero, permisCategorie, permisDateExpiration,
        dateEmbauche, salaireBase, statut, photoUrl, remarques
Types: CHAUFFEUR, AIDE_CHAUFFEUR, EMPLOYE, CLIENT
```

### 2. **VEHICULE**
```
Champs: id, immatriculation (unique), typeVehicule, marque, modele, annee,
        couleur, nombrePlaces, statut, kilometrageActuel, dateAcquisition,
        dateDerniereVisiteTechnique, dateProchaineVisiteTechnique
Statut: DISPONIBLE, EN_SERVICE, EN_MAINTENANCE, HORS_SERVICE
```

### 3. **TYPE_VEHICULE**
```
Champs: id, nom (unique), capacitePassagers, capaciteBagages, description
```

### 4. **TRAJET**
```
Champs: id, code (unique), villeDepart, villeArrivee, distanceKm, 
        dureeEstimeeMinutes, description
```

### 5. **TARIF** (Très flexible)
```
Champs: id, trajet_id, typeVehicule_id, prixBase, typeTarif,
        dateDebut, dateFin, multiplicateur
Types: NORMAL, FETE, WEEKEND, NUIT
```

### 6. **VOYAGE** (Courses réelles)
```
Champs: id, codeVoyage (unique), vehicule_id, chauffeur_id, 
        aideChauffeur_id, trajet_id, dateDepart, dateArriveePrevue,
        dateArriveeReelle, statut, nombrePlacesDisponibles, prixParPlace
Statut: PLANIFIE, EN_COURS, TERMINE, ANNULE
```

### 7. **RESERVATION**
```
Champs: id, codeReservation (unique), voyage_id, client_id, nombrePlaces,
        montantTotal, montantPaye, montantRestant, modeReservation,
        statut, dateReservation, remarques
Statut: EN_ATTENTE, CONFIRME, PAYE, ANNULE, TERMINE
ModeReservation: SUR_PLACE, TELEPHONE, EN_LIGNE
```

### 8. **PAIEMENT**
```
Champs: id, codePaiement (unique), typePaiement, referenceId, montant,
        modePaiement, momentPaiement, datePaiement, referenceTransaction,
        recuPar_id, remarques
TypePaiement: RESERVATION, COLIS, AUTRE
ModePaiement: ESPECE, MOBILE_MONEY, CARTE, VIREMENT
```

### 9. **COLIS**
```
Champs: id, codeColis (unique), voyage_id, expediteur_id, destinataireNom,
        destinataireTelephone, description, poidsKg, tarif, statut, dateEnvoi
Statut: ENREGISTRE, EN_TRANSIT, LIVRE, ANNULE
```

### 10. **DEPENSE**
```
Champs: id, codeDepense (unique), typeDepense, vehicule_id, garage_id,
        beneficiaire_id, montant, dateDepense, description, factureNumero,
        factureUrl, approuvePar_id, statut
TypeDepense: CARBURANT, REPARATION, VISITE_TECHNIQUE, SALAIRE, ENTRETIEN, AUTRE
Statut: EN_ATTENTE, APPROUVE, PAYE, REJETE
```

### 11. **GARAGE**
```
Champs: id, nom, adresse, telephone, email, specialite
```

### 12. **LISTE_ATTENTE**
```
Champs: id, trajet_id, personne_id, dateDepartSouhaitee,
        statut, dateNotification
Statut: EN_ATTENTE, NOTIFIE, INSCRIT
```

---

## 🎮 CONTRÔLEURS (5 principaux)

### 1. **VoyageController** (@/voyages)
```
GET  /voyages                    → list()          Lister tous les voyages
GET  /voyages/nouveau            → nouveauForm()   Formulaire création
POST /voyages/creer              → creer()         Créer voyage
GET  /voyages/{id}               → details()       Détails voyage
POST /voyages/{id}/demarrer      → demarrer()      Démarrer voyage
POST /voyages/{id}/terminer      → terminer()      Terminer voyage
GET  /voyages/disponibles        → disponibles()   Voyages dispo
```

### 2. **ReservationController** (@/reservations)
```
GET  /reservations               → list()
GET  /reservations/nouvelle      → nouvelleForm()  (+ paramètre voyageId)
POST /reservations/creer         → creer()
(À compléter dans les sources)
```

### 3. **FinanceController** (@/finances)
```
GET  /finances                   → dashboard()     Bilan du mois
GET  /finances/bilan             → bilan()        Bilan période
GET  /finances/depenses          → depenses()     Lister dépenses
POST /finances/depenses/creer    → creerDepense()
```

### 4. **VehiculeController** (@/vehicules)
```
(À explorer complètement)
```

### 5. **HomeController** (@/)
```
GET  /                           → Accueil
(À explorer)
```

---

## 🔧 SERVICES (5 principaux)

### 1. **VoyageService**
- `creerVoyage()` - Génère code unique, met à jour statut véhicule
- `getVoyagesDisponibles()` - Requête personnalisée
- `demarrerVoyage()` - Change statut à EN_COURS
- `terminerVoyage()` - Change statut à TERMINE, libère véhicule
- `notifierListeAttente()` - Gère notifications liste d'attente

### 2. **ReservationService**
- `creerReservation()` - Créer et gérer places disponibles
- (À explorer complètement)

### 3. **VehiculeService**
- (À explorer)

### 4. **FinanceService**
- `getBilanFinancier()` - Calcul revenus/dépenses période
- `creerDepense()` - Créer une dépense

### 5. **ColisService**
- (À explorer)

---

## 🗄️ REPOSITORIES (12)

Tous héritent de `JpaRepository`:
- VoyageRepository
- ReservationRepository
- VehiculeRepository
- PersonneRepository
- TrajetRepository
- TarifRepository
- PaiementRepository
- DepenseRepository
- ColisRepository
- GarageRepository
- TypeVehiculeRepository
- ListeAttenteRepository

**Requêtes personnalisées observées:**
- `VoyageRepository.findVoyagesDisponibles()` - Méthode custom
- `PersonneRepository.findByTypePersonneAndStatut()`
- `PersonneRepository.findByTypePersonneAndActifTrue()`
- `TrajetRepository.findByActifTrue()`
- `TarifRepository.findByTrajetIdAndActifTrue()`

---

## 🎨 INTERFACE UTILISATEUR

### Templates Thymeleaf
```
templates/
├── index.html                    Accueil/Dashboard
├── layout/
│   ├── header.html               Navigation
│   └── footer.html               Pied de page
├── fragments/
│   └── common.html               Fragments réutilisables
├── voyages/
│   ├── list.html                 Liste voyages
│   ├── form.html                 Formulaire création
│   └── details.html              Détails voyage
├── reservations/
│   ├── list.html
│   ├── form.html
│   └── details.html
├── vehicules/
│   ├── list.html
│   └── details.html
└── finances/
    └── dashboard.html            Tableau de bord finances
```

### Dashboard Principal (index.html)
Affiche 4 cartes statistiques:
- Total Voyages
- Voyages En Cours
- Total Réservations
- Véhicules Disponibles

---

## 🔌 CONFIGURATION

### application.properties
```properties
spring.application.name=app
server.port=8080

# PostgreSQL
spring.datasource.url=jdbc:postgresql://localhost:5432/taxi_brousse
spring.datasource.username=postgres
spring.datasource.password=nella
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Upload files
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

---

## ✅ FONCTIONNALITÉS ACTUELLES

### ✅ Gestion des Voyages
- Créer voyage
- Lister voyages
- Voir détails
- Démarrer/Terminer voyage
- Lister voyages disponibles

### ✅ Gestion des Réservations
- Créer réservation
- Lister réservations
- (À compléter)

### ✅ Gestion des Véhicules
- (À explorer)

### ✅ Gestion des Finances
- Dashboard financier mensuel
- Bilan sur période
- Gestion des dépenses

### ✅ Gestion des Colis
- Modèle créé
- Service créé
- (À développer l'interface)

### ✅ Authentification/Autorisation
- (À explorer/ajouter)

---

## 🔴 POINTS À AMÉLIORER / À AJOUTER

### 1. **Authentification & Sécurité**
- [ ] Système de login/logout
- [ ] Rôles et permissions (Admin, Gestionnaire, Chauffeur, Client)
- [ ] Spring Security
- [ ] Chiffrement des mots de passe

### 2. **Gestion des Véhicules**
- [ ] Interface CRUD complète
- [ ] Historique maintenance
- [ ] Alertes entretien/visite technique
- [ ] Suivi kilométrage

### 3. **Gestion des Personnes**
- [ ] Interface CRUD complète
- [ ] Gestion des chauffeurs détaillée
- [ ] Suivi permis (expiration)
- [ ] Photo profil

### 4. **Finances Avancées**
- [ ] Rapports PDF détaillés
- [ ] Graphs statistiques (Charts.js)
- [ ] Prévisions de revenus
- [ ] Gestion multi-devises (si besoin)

### 5. **Gestion des Colis**
- [ ] Interface CRUD complète
- [ ] Suivi en temps réel
- [ ] Code-barres/QR codes
- [ ] Assurance colis

### 6. **Amélioration UX/UI**
- [ ] Responsive design amélioré
- [ ] Validation côté client
- [ ] Notifications en temps réel
- [ ] Recherche et filtrage avancés

### 7. **API REST**
- [ ] Endpoints API pour mobile/externe
- [ ] Swagger/OpenAPI documentation

### 8. **Performance & Scalabilité**
- [ ] Pagination des listes
- [ ] Caching (Redis)
- [ ] Index base de données
- [ ] Lazy loading

### 9. **Notifications**
- [ ] Email notifications
- [ ] SMS notifications (Mobile Money)
- [ ] Notifications système

### 10. **Rapports & Export**
- [ ] Rapports PDF
- [ ] Export Excel
- [ ] Historiques auditables

---

## 📊 FLUX MÉTIER PRINCIPAUX

### Flux 1: Création et Gestion d'un Voyage
```
1. Admin crée Trajet (Ville A → Ville B)
2. Admin définit Tarifs par type véhicule
3. Admin crée Voyage (Véhicule + Chauffeur + Trajet + Horaire)
4. Clients peuvent faire Réservations
5. À l'heure, Voyage démarre (EN_COURS)
6. À l'arrivée, Voyage se termine (TERMINE)
7. Paiements traités
8. Véhicule retourne DISPONIBLE
```

### Flux 2: Réservation & Paiement
```
1. Client réserve places sur Voyage
2. Statut: EN_ATTENTE
3. Paiement effectué → Statut: PAYE
4. À départ → Statut: CONFIRME
5. À l'arrivée → Statut: TERMINE
```

### Flux 3: Gestion des Dépenses
```
1. Dépense enregistrée (Carburant, Réparation, etc.)
2. Statut: EN_ATTENTE
3. Admin approuve → Statut: APPROUVE
4. Paiement effectué → Statut: PAYE
5. Comptable inclus dans rapports financiers
```

---

## 🚀 RECOMMANDATIONS POUR ÉVOLUTION

1. **Phase 1 - Prioritaire:**
   - Compléter les CRUD manquants
   - Ajouter authentification
   - Améliorer UX/UI

2. **Phase 2 - Important:**
   - API REST
   - Rapports avancés
   - Notifications

3. **Phase 3 - Souhaitable:**
   - App mobile
   - Tracking GPS
   - Prédictions/IA

---

## 📝 NOTES IMPORTANTES

- **Code Unique**: Tous les entités clés ont des codes uniques générés (VOY+timestamp, RES+timestamp, etc.)
- **Statuts**: Gestion centralisée des statuts (énumérés en BD et code)
- **Audit Trail**: Chaque entité a dateCreation et dateModification
- **Relations**: Modèle très bien structuré avec relations ManyToOne appropriées
- **PostgreSQL**: BD robuste et scalable pour ce type d'application

---

**🎓 Prêt à recevoir vos demandes de développement!**
