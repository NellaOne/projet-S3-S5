package com.taxiBrousse.app.service;

import com.taxiBrousse.app.dto.DateDisponibleDTO;
import com.taxiBrousse.app.dto.VoyageDisponibleDTO;
import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * VoyageService - Logique métier pour les voyages
 * Correspond à la notion de "session" (film/session_film)
 * 
 * Responsabilités :
 * - Fournir les données pour listes déroulantes dynamiques
 * - Calculer les places disponibles EN TEMPS RÉEL
 * - Gérer le cycle de vie du voyage
 */
@Service
@Transactional
public class VoyageService {
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private ListeAttenteRepository listeAttenteRepo;
    @Autowired private TrajetRepository trajetRepo;
    
    // ============================================
    // 1. LISTES DÉROULANTES DYNAMIQUES (UI/UX)
    // ============================================
    
    /**
     * Récupère les dates disponibles pour un trajet
     * (Pour la 2ème liste déroulante)
     * 
     * @param trajetId ID du trajet sélectionné
     * @return Liste des dates avec nombre de voyages
     */
    public List<DateDisponibleDTO> getDatesDisponibles(Long trajetId) {
        // Utiliser directement la requête du Repository
        List<String> dateStrings = voyageRepo.findDatesDisponiblesParTrajet(trajetId);
        
        // Convertir les strings en LocalDate
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        List<LocalDate> dates = dateStrings.stream()
            .map(dateStr -> LocalDate.parse(dateStr, formatter))
            .sorted()  // Trier les dates en ordre croissant
            .collect(Collectors.toList());
        
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
        
        return dates.stream().map(date -> {
            // Compter les voyages pour cette date
            List<Voyage> voyages = voyageRepo.findVoyagesParTrajetEtDate(trajetId, date);
            int nbVoyages = voyages.size();
            
            return new DateDisponibleDTO(
                date,
                nbVoyages,
                String.format("%s (%d voyage%s)", 
                    date.format(displayFormatter),
                    nbVoyages,
                    nbVoyages > 1 ? "s" : "")
            );
        }).collect(Collectors.toList());
    }
    
    /**
     * Récupère les heures disponibles pour un trajet à une date donnée
     * (Pour la 3ème liste déroulante + détail du voyage avant réservation)
     * 
     * @param trajetId ID du trajet
     * @param date Date sélectionnée
     * @return Liste des voyages (sessions) avec détails
     */
    public List<VoyageDisponibleDTO> getHeuresDisponibles(Long trajetId, LocalDate date) {
        // Récupérer tous les voyages pour ce trajet/date
        List<Voyage> voyages = voyageRepo.findVoyagesParTrajetEtDate(trajetId, date);
        
        return voyages.stream().map(voyage -> {
            // Calculer les places disponibles EN TEMPS RÉEL (via réservations)
            int placesReservees = reservationRepo
                .findByVoyageIdAndStatutNot(voyage.getId(), "ANNULE")
                .stream()
                .mapToInt(Reservation::getNombrePlaces)
                .sum();
            
            int capaciteTotale = voyage.getVehicule().getNombrePlaces();
            int placesDisponibles = capaciteTotale - placesReservees;
            
            return new VoyageDisponibleDTO(
                voyage.getId(),
                voyage.getDateDepart().toLocalTime(),
                placesDisponibles,
                voyage.getPrixParPlace(),
                voyage.getCodeVoyage(),
                voyage.getVehicule().getImmatriculation(),
                capaciteTotale,
                voyage.getChauffeur().getNom() + " " + 
                    (voyage.getChauffeur().getPrenom() != null ? 
                     voyage.getChauffeur().getPrenom() : "")
            );
        }).collect(Collectors.toList());
    }
    
    // ============================================
    // 2. LOGIQUE MÉTIER - GESTION VOYAGE
    // ============================================
    
    /**
     * Crée un nouveau voyage (session)
     */
    public Voyage creerVoyage(Voyage voyage) {
        // Générer code unique
        voyage.setCodeVoyage("VOY-" + System.currentTimeMillis());
        voyage.setStatut("PLANIFIE");
        
        // Mettre à jour statut véhicule
        Vehicule vehicule = voyage.getVehicule();
        vehicule.setStatut("EN_SERVICE");
        vehiculeRepo.save(vehicule);
        
        return voyageRepo.save(voyage);
    }
    
    /**
     * Récupère les voyages disponibles (PLANIFIÉS)
     */
    public List<Voyage> getVoyagesDisponibles() {
        return voyageRepo.findVoyagesDisponibles();
    }
    
    /**
     * Démarre un voyage (passage de PLANIFIE à EN_COURS)
     */
    public Voyage demarrerVoyage(Long voyageId) {
        Voyage voyage = voyageRepo.findById(voyageId).orElseThrow();
        voyage.setStatut("EN_COURS");
        return voyageRepo.save(voyage);
    }
    
    /**
     * Termine un voyage (passage de EN_COURS à TERMINE)
     */
    public Voyage terminerVoyage(Long voyageId) {
        Voyage voyage = voyageRepo.findById(voyageId).orElseThrow();
        voyage.setStatut("TERMINE");
        voyage.setDateArriveeReelle(LocalDateTime.now());
        
        // Libérer le véhicule
        Vehicule vehicule = voyage.getVehicule();
        vehicule.setStatut("DISPONIBLE");
        vehiculeRepo.save(vehicule);
        
        return voyageRepo.save(voyage);
    }
    
    /**
     * Annule un voyage (passage à ANNULE)
     * Déclenche les remboursements et notifications
     */
    public Voyage annulerVoyage(Long voyageId, String raison) {
        Voyage voyage = voyageRepo.findById(voyageId).orElseThrow();
        voyage.setStatut("ANNULE");
        
        // Libérer le véhicule
        Vehicule vehicule = voyage.getVehicule();
        vehicule.setStatut("DISPONIBLE");
        vehiculeRepo.save(vehicule);
        
        // Annuler toutes les réservations
        List<Reservation> reservations = reservationRepo
            .findByVoyageIdAndStatutNot(voyageId, "ANNULE");
        reservations.forEach(r -> {
            r.setStatut("ANNULE");
            reservationRepo.save(r);
        });
        
        // Notifier la liste d'attente
        notifierListeAttente(voyage.getTrajet().getId(), voyage.getDateDepart().toLocalDate());
        
        return voyageRepo.save(voyage);
    }
    
    /**
     * Notifie les clients en liste d'attente
     * quand un nouveau voyage devient disponible
     */
    public void notifierListeAttente(Long trajetId, LocalDate dateDepart) {
        List<ListeAttente> attentes = listeAttenteRepo
            .findByTrajetIdAndStatut(trajetId, "EN_ATTENTE");
        
        for (ListeAttente attente : attentes) {
            if (attente.getDateDepartSouhaitee() == null || 
                attente.getDateDepartSouhaitee().equals(dateDepart)) {
                attente.setStatut("NOTIFIE");
                attente.setDateNotification(LocalDateTime.now());
                listeAttenteRepo.save(attente);
            }
        }
    }
    
    // ============================================
    // 3. CALCULS (Utilise les données de la vue SQL)
    // ============================================
    
    /**
     * Calcule les montants d'une réservation (PREMIUM + STANDARD)
     * @param voyageId ID du voyage
     * @param nombrePlacesPremium Nombre de places premium
     * @param nombrePlacesStandard Nombre de places standard
     * @return Montant total
     */
    public Map<String, BigDecimal> calculerMontantsReservation(Long voyageId, Integer nombrePlacesPremium, Integer nombrePlacesStandard) {
        Voyage voyage = voyageRepo.findById(voyageId)
            .orElseThrow(() -> new RuntimeException("Voyage non trouvé"));
        
        Trajet trajet = voyage.getTrajet();
        Tarif tarif = trajetRepo.findTarifByTrajetId(trajet.getId());
        
        if (tarif == null) {
            throw new RuntimeException("Tarif non trouvé pour ce trajet");
        }
        
        BigDecimal montantPremium = tarif.getPrixPlacePremium().multiply(BigDecimal.valueOf(nombrePlacesPremium));
        BigDecimal montantStandard = tarif.getPrixPlaceStandard().multiply(BigDecimal.valueOf(nombrePlacesStandard));
        BigDecimal montantTotal = montantPremium.add(montantStandard);
        
        Map<String, BigDecimal> result = new HashMap<>();
        result.put("montantPremium", montantPremium);
        result.put("montantStandard", montantStandard);
        result.put("montantTotal", montantTotal);
        
        return result;
    }
    
    /**
     * Calcule le montant total d'une réservation (ancien flux - compatibilité)
     * @param voyageId ID du voyage
     * @param nombrePlaces Nombre de places à réserver
     * @return Montant total
     */
    public BigDecimal calculerMontantReservation(Long voyageId, Integer nombrePlaces) {
        Voyage voyage = voyageRepo.findById(voyageId)
            .orElseThrow(() -> new RuntimeException("Voyage non trouvé"));
        
        return voyage.getPrixParPlace()
            .multiply(BigDecimal.valueOf(nombrePlaces));
    }
}
