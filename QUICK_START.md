# 🚀 QUICK START - TAXI-BROUSSE
## Démarrer en 5 minutes

---

## ✅ Prérequis
- ✅ PostgreSQL 12+
- ✅ JDK 17+
- ✅ Maven 3.8+
- ✅ VS Code ou IDE Java

---

## 1️⃣ BASE DE DONNÉES (2 min)

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Exécuter le schéma
\i /chemin/vers/table.sql

# Ajouter les triggers et vues
\i /chemin/vers/supplements_conception.sql

# Vérifier
\dt  -- Doit afficher toutes les tables
\dv  -- Doit afficher les vues
```

**Vérification** : 
```sql
SELECT COUNT(*) FROM trajet;  -- Doit retourner les trajets
SELECT COUNT(*) FROM voyage;  -- Doit retourner les voyages
```

---

## 2️⃣ JAVA PROJECT (2 min)

```bash
# 1. Ouvrir le projet
cd /chemin/vers/projet-S3-S5/app/app

# 2. Compiler
mvn clean compile

# 3. Installer dépendances
mvn install

# 4. Lancer
mvn spring-boot:run
```

**Vérification** :
- http://localhost:8080 → Doit afficher la page d'accueil

---

## 3️⃣ TESTER RÉSERVATION (1 min)

```
1. Aller à http://localhost:8080/reservations/nouvelle
2. Sélectionner un TRAJET
   → Les DATES doivent s'afficher
3. Sélectionner une DATE
   → Les HEURES/VOYAGES doivent s'afficher
4. Sélectionner HEURE + CLIENT + PLACES
5. Cliquer "CONFIRMER"
   → Réservation créée ✅
```

---

## 📊 VÉRIFICATIONS RAPIDES

### BD : Vérifier les places disponibles
```sql
-- Affiche disponibilités EN TEMPS RÉEL
SELECT 
    v.code_voyage,
    ve.nombre_places AS capacite,
    (SELECT COUNT(DISTINCT id_reservation) FROM reservation WHERE voyage_id = v.id_voyage AND statut != 'ANNULE') AS reservees,
    ve.nombre_places - (SELECT COUNT(DISTINCT id_reservation) FROM reservation WHERE voyage_id = v.id_voyage AND statut != 'ANNULE') AS disponibles
FROM voyage v
JOIN vehicule ve ON v.vehicule_id = ve.id_vehicule
WHERE v.statut = 'PLANIFIE'
LIMIT 5;
```

### Code : Vérifier les endpoints API
```bash
# Terminal : Curl pour tester les APIs
curl http://localhost:8080/reservations/api/dates/1
curl http://localhost:8080/reservations/api/heures/1/2026-01-15
curl http://localhost:8080/reservations/api/voyage/1
```

---

## 🎯 FONCTIONNALITÉS CLÉS

| Fonctionnalité | URL | Status |
|---|---|---|
| Affichage form réservation | `/reservations/nouvelle` | ✅ |
| Listes déroulantes dynamiques | (JavaScript) | ✅ |
| Créer réservation | `POST /reservations/creer` | ✅ |
| Enregistrer paiement | `POST /reservations/{id}/paiement` | ✅ |
| Annuler réservation | `POST /reservations/{id}/annuler` | ✅ |

---

## 📁 FICHIERS IMPORTANTS

```
Lire EN PREMIER :
├─ CHANGELOG.md                  ← Vue d'ensemble complète
├─ IMPLEMENTATION_COMPLETE.md    ← Documentation détaillée
└─ INSTALLATION.sh              ← Guide étape par étape

Consulter pour tester :
├─ verification_conception.sql   ← Requêtes de vérification BD
└─ supplements_conception.sql    ← Triggers et vues SQL
```

---

## ⚙️ CONFIGURATION (si changements)

Fichier : `app/src/main/resources/application.properties`

```properties
# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/taxi_brousse
spring.datasource.username=postgres
spring.datasource.password=your_password

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQL10Dialect
```

---

## 🆘 TROUBLESHOOTING

### ❌ Erreur : "Pas de date s'affiche"
```
→ Vérifier qu'il y a des voyages en BD
→ Vérifier que VoyageRepository.findDatesDisponiblesParTrajet() retourne des données
→ Vérifier la date_depart > CURRENT_TIMESTAMP
```

### ❌ Erreur : "Trigger non trouvé"
```
→ Exécuter : \i supplements_conception.sql
→ Vérifier avec : \df fn_check_places*
```

### ❌ Erreur : "Spring ne démarre pas"
```
→ Vérifier la BD est accessible
→ Vérifier les logs : mvn spring-boot:run | grep ERROR
→ Vérifier la classe Voyage n'a pas nombrePlacesDisponibles
```

---

## 📈 PROCHAINES ÉTAPES

```
✅ Phase 1 : Setup + test basique (VOUS ÊTES ICI)
→ Phase 2 : Tests complets + validation
→ Phase 3 : Optimisations + notifications
→ Phase 4 : Déploiement production
```

---

## 🎓 APPRENTISSAGE

**Concepts appliqués** :
- ✅ Listes déroulantes dépendantes (frontend)
- ✅ Calculs EN TEMPS RÉEL (pas de stockage redondant)
- ✅ VUEs SQL pour données calculées
- ✅ Triggers pour validation à la BD
- ✅ API REST pour communication
- ✅ DTOs pour séparation métier/affichage
- ✅ Services pour logique métier
- ✅ Transactions et ACID

---

## 📞 BESOIN D'AIDE ?

1. **Lire IMPLEMENTATION_COMPLETE.md** → Explication détaillée
2. **Exécuter verification_conception.sql** → Diagnostiquer BD
3. **Vérifier les logs** → mvn spring-boot:run
4. **Vérifier DevTools** → F12 dans navigateur

---

**✅ Vous êtes prêt ! Lancez et testez ! 🚀**
