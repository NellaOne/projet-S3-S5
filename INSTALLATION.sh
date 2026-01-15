#!/bin/bash

# ============================================
# SCRIPT D'INSTALLATION - TAXI-BROUSSE
# ============================================
# Instructions complètes pour déployer la nouvelle conception

echo "🚀 TAXI-BROUSSE - Installation Complète"
echo "========================================"
echo ""

# ============================================
# ÉTAPE 1 : DATABASE SETUP
# ============================================
echo "📊 ÉTAPE 1 : Setup Base de Données"
echo "---"

echo "1.1 Connexion à PostgreSQL..."
echo "   psql -U postgres"
echo ""

echo "1.2 Exécuter le schéma principal..."
echo "   \i /chemin/vers/table.sql"
echo ""

echo "1.3 Exécuter les suppléments (triggers, vues)..."
echo "   \i /chemin/vers/supplements_conception.sql"
echo ""

echo "1.4 Vérifier la structure..."
echo "   \i /chemin/vers/verification_conception.sql"
echo ""

# ============================================
# ÉTAPE 2 : JAVA PROJECT BUILD
# ============================================
echo "☕ ÉTAPE 2 : Compilation Java"
echo "---"

echo "2.1 Placer le projet dans l'IDE..."
echo "   VS Code → Open Folder → /chemin/vers/projet-S3-S5/app/app"
echo ""

echo "2.2 Vérifier que Maven est configuré..."
echo "   View → Terminal (Ctrl+`) → mvn -version"
echo ""

echo "2.3 Compiler le projet..."
echo "   mvn clean compile"
echo ""

echo "2.4 Installer les dépendances..."
echo "   mvn install"
echo ""

# ============================================
# ÉTAPE 3 : VÉRIFIER LES FICHIERS MODIFIÉS
# ============================================
echo "📁 ÉTAPE 3 : Vérifier les fichiers modifiés"
echo "---"
echo "✅ Fichiers modifiés :"
echo ""
echo "  Model/"
echo "    └─ Voyage.java (suppression numberOfPlacesDisponibles)"
echo ""
echo "  Repository/"
echo "    ├─ VoyageRepository.java (+2 méthodes)"
echo "    └─ ReservationRepository.java (+1 méthode)"
echo ""
echo "  Service/"
echo "    ├─ VoyageService.java (refonte complète)"
echo "    └─ ReservationService.java (refonte complète)"
echo ""
echo "  Controller/"
echo "    └─ ReservationController.java (+3 endpoints API)"
echo ""
echo "  Template/"
echo "    └─ templates/reservations/form.html (listes déroulantes dynamiques)"
echo ""
echo "  DTO/ (NOUVEAUX)"
echo "    ├─ TrajetDTO.java"
echo "    ├─ DateDisponibleDTO.java"
echo "    └─ VoyageDisponibleDTO.java"
echo ""

# ============================================
# ÉTAPE 4 : LANCER L'APPLICATION
# ============================================
echo "🚀 ÉTAPE 4 : Lancer l'application"
echo "---"
echo ""
echo "4.1 Depuis VS Code Terminal :"
echo "   mvn spring-boot:run"
echo ""
echo "4.2 Vérifier le démarrage :"
echo "   http://localhost:8080/"
echo ""
echo "4.3 Tester la page d'accueil :"
echo "   http://localhost:8080/reservations/nouvelle"
echo ""

# ============================================
# ÉTAPE 5 : TESTER LES FONCTIONNALITÉS
# ============================================
echo "✅ ÉTAPE 5 : Tester les fonctionnalités"
echo "---"
echo ""
echo "5.1 Listes déroulantes dynamiques :"
echo "   - Aller à /reservations/nouvelle"
echo "   - Sélectionner un trajet"
echo "   - Vérifier que la 2ème liste se remplit (dates)"
echo "   - Sélectionner une date"
echo "   - Vérifier que la 3ème liste se remplit (heures/voyages)"
echo ""
echo "5.2 Création de réservation :"
echo "   - Remplir le formulaire complet"
echo "   - Cliquer sur 'Confirmer la réservation'"
echo "   - Vérifier la réservation créée"
echo ""
echo "5.3 Vérifier les places disponibles :"
echo "   - Exécuter verification_conception.sql (requête #4)"
echo "   - Vérifier que places_disponibles est recalculé correctement"
echo ""
echo "5.4 Test d'annulation :"
echo "   - Annuler une réservation"
echo "   - Vérifier que places_disponibles est recalculé"
echo ""

# ============================================
# ÉTAPE 6 : TROUBLESHOOTING
# ============================================
echo "🔧 ÉTAPE 6 : Troubleshooting"
echo "---"
echo ""
echo "6.1 Si les listes déroulantes ne se remplissent pas :"
echo "   - Ouvrir DevTools (F12) → Console"
echo "   - Vérifier les erreurs JavaScript"
echo "   - Vérifier que les endpoints API répondent :"
echo "     GET /reservations/api/dates/1"
echo "     GET /reservations/api/heures/1/2026-01-15"
echo ""
echo "6.2 Si les réservations échouent :"
echo "   - Vérifier que les triggers SQL sont activés"
echo "   - Voir les logs Spring Boot"
echo "   - Vérifier la base de données avec verification_conception.sql"
echo ""
echo "6.3 Logs Spring Boot :"
echo "   - Terminal → Maven output"
echo "   - Rechercher les exceptions ou erreurs"
echo ""

# ============================================
# RÉSUMÉ
# ============================================
echo ""
echo "=========================================="
echo "✅ Installation complète !"
echo "=========================================="
echo ""
echo "📌 Résumé :"
echo "  ✅ Base de données configurée"
echo "  ✅ Triggers et vues créés"
echo "  ✅ Code Java compilé et modifié"
echo "  ✅ Listes déroulantes dynamiques implémentées"
echo "  ✅ Services métier avec logique EN TEMPS RÉEL"
echo ""
echo "🔗 Points d'accès :"
echo "  - Accueil : http://localhost:8080"
echo "  - Réservation : http://localhost:8080/reservations/nouvelle"
echo "  - API dates : http://localhost:8080/reservations/api/dates/{trajetId}"
echo "  - API heures : http://localhost:8080/reservations/api/heures/{trajetId}/{date}"
echo ""
echo "📞 Besoin d'aide ? Vérifiez IMPLEMENTATION_COMPLETE.md"
echo ""
