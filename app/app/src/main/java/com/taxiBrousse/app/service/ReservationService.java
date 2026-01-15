package com.taxiBrousse.app.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;

/**
 * ReservationService - Gestion des réservations
 * 
 * Responsabilités :
 * - Créer/modifier/annuler réservations
 * - Vérifier disponibilité EN TEMPS RÉEL (via VoyageService)
 * - Gérer paiements et notifications
 * - Respecter les contraintes métier
 */
@Service
@Transactional
public class ReservationService {
    @Autowired private ReservationRepository reservationRepository;
    @Autowired private VoyageRepository voyageRepository;
    @Autowired private VoyageService voyageService;
    @Autowired private PaiementRepository paiementRepo;
    @Autowired private ListeAttenteRepository listeAttenteRepo;
    @Autowired private TrajetRepository trajetRepository;
    @Autowired private PersonneRepository personneRepository;
    
    // ============================================
    // CRÉER RÉSERVATION (Logique métier complète)
    // ============================================
    
    /**
     * Crée une réservation avec places PREMIUM et STANDARD séparées
     * 
     * @param voyageId ID du voyage
     * @param clientId ID du client
     * @param nombrePlacesPremium Nombre de places premium
     * @param nombrePlacesStandard Nombre de places standard
     * @return Réservation créée
     */
    public Reservation creerReservation(Long voyageId, Long clientId, Integer nombrePlacesPremium, Integer nombrePlacesStandard) {
        // 1. Récupérer le voyage
        Voyage voyage = voyageRepository.findById(voyageId)
            .orElseThrow(() -> new RuntimeException("Voyage non trouvé"));
        
        // 2. Récupérer le client
        Personne client = personneRepository.findById(clientId)
            .orElseThrow(() -> new RuntimeException("Client non trouvé"));
        
        // 3. Vérifier disponibilité Premium EN TEMPS RÉEL
        List<Reservation> reservationsActuelles = reservationRepository
            .findByVoyageIdAndStatutNot(voyageId, "ANNULE");
        
        int placesPremiumsReservees = reservationsActuelles.stream()
            .mapToInt(Reservation::getNombrePlacesPremium)
            .sum();
        
        int placesStandardReservees = reservationsActuelles.stream()
            .mapToInt(Reservation::getNombrePlacesStandard)
            .sum();
        
        int capacitePremiume = voyage.getVehicule().getNombrePlacesPremium();
        int capaciteStandard = voyage.getVehicule().getNombrePlacesStandard();
        
        int placesPremiumsDisponibles = capacitePremiume - placesPremiumsReservees;
        int placesStandardDisponibles = capaciteStandard - placesStandardReservees;
        
        if (nombrePlacesPremium > placesPremiumsDisponibles) {
            throw new RuntimeException(
                String.format("Pas assez de places premium. Disponibles: %d, Demandées: %d", 
                    placesPremiumsDisponibles, nombrePlacesPremium)
            );
        }
        
        if (nombrePlacesStandard > placesStandardDisponibles) {
            throw new RuntimeException(
                String.format("Pas assez de places standard. Disponibles: %d, Demandées: %d", 
                    placesStandardDisponibles, nombrePlacesStandard)
            );
        }
        
        // 4. Créer la réservation
        Reservation reservation = new Reservation();
        reservation.setCodeReservation("RES-" + System.currentTimeMillis());
        reservation.setVoyage(voyage);
        reservation.setClient(client);
        reservation.setNombrePlacesPremium(nombrePlacesPremium);
        reservation.setNombrePlacesStandard(nombrePlacesStandard);
        reservation.setStatut("EN_ATTENTE");
        reservation.setDateReservation(LocalDateTime.now());
        
        // 5. Calculer montants (PREMIUM + STANDARD séparément)
        Tarif tarif = trajetRepository.findTarifByTrajetId(voyage.getTrajet().getId());
        if (tarif == null) {
            throw new RuntimeException("Tarif non trouvé pour ce trajet");
        }
        
        BigDecimal montantPremium = tarif.getPrixPlacePremium().multiply(BigDecimal.valueOf(nombrePlacesPremium));
        BigDecimal montantStandard = tarif.getPrixPlaceStandard().multiply(BigDecimal.valueOf(nombrePlacesStandard));
        
        reservation.setMontantTotalPremium(montantPremium);
        reservation.setMontantTotalStandard(montantStandard);
        reservation.setMontantPaye(BigDecimal.ZERO);
        
        // 6. Sauvegarder
        return reservationRepository.save(reservation);
    }
    
    /**
     * Crée une réservation (ancien flux - compatibilité arrière)
     */
    public Reservation creerReservation(Long voyageId, Long clientId, Integer nombrePlaces) {
        // 1. Récupérer le voyage (session)
        Voyage voyage = voyageRepository.findById(voyageId)
            .orElseThrow(() -> new RuntimeException("Voyage non trouvé"));
        
        // 2. Récupérer le client
        Personne client = personneRepository.findById(clientId)
            .orElseThrow(() -> new RuntimeException("Client non trouvé"));
        
        // 3. Vérifier disponibilité EN TEMPS RÉEL
        // (utiliser ReservationRepository pour compter les réservations non-annulées)
        List<Reservation> reservationsActuelles = reservationRepository
            .findByVoyageIdAndStatutNot(voyageId, "ANNULE");
        
        int placesReservees = reservationsActuelles.stream()
            .mapToInt(Reservation::getNombrePlaces)
            .sum();
        
        int capaciteTotale = voyage.getVehicule().getNombrePlaces();
        int placesDisponibles = capaciteTotale - placesReservees;
        
        if (nombrePlaces > placesDisponibles) {
            throw new RuntimeException(
                String.format("Pas assez de places. Disponibles: %d, Demandées: %d", 
                    placesDisponibles, nombrePlaces)
            );
        }
        
        // 4. Créer la réservation
        Reservation reservation = new Reservation();
        reservation.setCodeReservation("RES-" + System.currentTimeMillis());
        reservation.setVoyage(voyage);
        reservation.setClient(client);
        reservation.setNombrePlaces(nombrePlaces);
        reservation.setStatut("EN_ATTENTE");
        reservation.setDateReservation(LocalDateTime.now());
        
        // 5. Calculer montant (via VoyageService)
        BigDecimal montant = voyageService.calculerMontantReservation(voyageId, nombrePlaces);
        reservation.setMontantTotal(montant);
        reservation.setMontantPaye(BigDecimal.ZERO);
        reservation.setMontantRestant(montant);
        
        // 6. Sauvegarder
        return reservationRepository.save(reservation);
        
        // NOTE : Les places ne sont PAS mises à jour dans Voyage
        // car elles sont calculées EN TEMPS RÉEL via la vue SQL v_voyage_disponibilite
    }
    
    /**
     * Ancien flux (à conserver pour compatibilité)
     * Réservation rapide par villes/date/heure
     */
    public Reservation reserverPlaces(Long clientId, String villeDepart, String villeArrivee, 
                                      LocalDate date, int heure, int nombrePlaces) {
        Trajet trajet = trajetRepository.findByVilleDepartAndVilleArrivee(villeDepart, villeArrivee);
        if (trajet == null) throw new RuntimeException("Trajet non trouvé");

        List<Voyage> voyages = voyageRepository.findVoyagesByVillesAndDateHeure(
            villeDepart, villeArrivee, date, heure);
        
        Voyage voyage = voyages.stream()
            .filter(v -> {
                int placesReservees = reservationRepository
                    .findByVoyageIdAndStatutNot(v.getId(), "ANNULE")
                    .stream()
                    .mapToInt(Reservation::getNombrePlaces)
                    .sum();
                int placesDisponibles = v.getVehicule().getNombrePlaces() - placesReservees;
                return placesDisponibles >= nombrePlaces;
            })
            .findFirst()
            .orElse(null);
        
        if (voyage == null) throw new RuntimeException("Aucun voyage disponible");

        Personne client = personneRepository.findById(clientId).orElseThrow();
        Reservation reservation = new Reservation();
        reservation.setVoyage(voyage);
        reservation.setClient(client);
        reservation.setNombrePlaces(nombrePlaces);
        reservation.setMontantTotal(voyage.getPrixParPlace().multiply(BigDecimal.valueOf(nombrePlaces)));
        reservation.setStatut("EN_ATTENTE");
        reservation.setDateReservation(LocalDateTime.now());
        reservation.setCodeReservation("RES-" + System.currentTimeMillis());
        reservation.setMontantPaye(BigDecimal.ZERO);
        reservation.setMontantRestant(reservation.getMontantTotal());
        
        return reservationRepository.save(reservation);
    }
    
    // ============================================
    // GÉRER PAIEMENTS
    // ============================================
    
    /**
     * Effectue un paiement sur une réservation
     */
    public Reservation effectuerPaiement(Long reservationId, BigDecimal montant, 
                                        String mode, String moment) {
        Reservation res = reservationRepository.findById(reservationId)
            .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        
        // Vérifier le montant
        if (montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Montant invalide");
        }
        
        if (montant.compareTo(res.getMontantRestant()) > 0) {
            throw new RuntimeException(
                String.format("Montant trop élevé. Restant: %s", res.getMontantRestant())
            );
        }
        
        // Créer le paiement
        Paiement paiement = new Paiement();
        paiement.setCodePaiement("PAY-" + System.currentTimeMillis());
        paiement.setTypePaiement("RESERVATION");
        paiement.setReferenceId(reservationId);
        paiement.setMontant(montant);
        paiement.setModePaiement(mode);
        paiement.setMomentPaiement(moment);
        paiement.setDatePaiement(LocalDateTime.now());
        paiementRepo.save(paiement);
        
        // Mettre à jour réservation
        res.setMontantPaye(res.getMontantPaye().add(montant));
        res.setMontantRestant(res.getMontantTotal().subtract(res.getMontantPaye()));
        
        // Mettre à jour statut
        if (res.getMontantRestant().compareTo(BigDecimal.ZERO) <= 0) {
            res.setStatut("PAYE");
        } else {
            res.setStatut("CONFIRME");
        }
        
        res.setDateModification(LocalDateTime.now());
        return reservationRepository.save(res);
    }
    
    // ============================================
    // ANNULER RÉSERVATION
    // ============================================
    
    /**
     * Annule une réservation
     * Redonne les places au voyage
     * Notifie la liste d'attente
     */
    public void annulerReservation(Long reservationId) {
        Reservation res = reservationRepository.findById(reservationId)
            .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        
        if ("ANNULE".equals(res.getStatut())) {
            throw new RuntimeException("Réservation déjà annulée");
        }
        
        // Marquer comme annulée
        res.setStatut("ANNULE");
        res.setDateModification(LocalDateTime.now());
        reservationRepository.save(res);
        
        // Les places sont automatiquement recalculées via la VUE SQL
        
        // Notifier la liste d'attente
        Voyage voyage = res.getVoyage();
        List<ListeAttente> attentes = listeAttenteRepo
            .findByTrajetIdAndStatut(voyage.getTrajet().getId(), "EN_ATTENTE");
        
        for (ListeAttente attente : attentes) {
            // Vérifier si le nombre de places demandées est maintenant disponible
            int placesReservees = reservationRepository
                .findByVoyageIdAndStatutNot(voyage.getId(), "ANNULE")
                .stream()
                .mapToInt(Reservation::getNombrePlaces)
                .sum();
            
            int placesDisponibles = voyage.getVehicule().getNombrePlaces() - placesReservees;
            
            if (attente.getNombrePlacesDemandees() <= placesDisponibles) {
                attente.setStatut("NOTIFIE");
                attente.setDateNotification(LocalDateTime.now());
                listeAttenteRepo.save(attente);
                break; // Notifier un seul pour cette date
            }
        }
    }
    
    // ============================================
    // CONFIRMATIONS (après paiement)
    // ============================================
    
    /**
     * Confirme une réservation (après paiement minimum)
     */
    public Reservation confirmerReservation(Long reservationId) {
        Reservation res = reservationRepository.findById(reservationId)
            .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        
        if (!"EN_ATTENTE".equals(res.getStatut())) {
            throw new RuntimeException("Réservation déjà confirmée");
        }
        
        res.setStatut("CONFIRME");
        res.setDateModification(LocalDateTime.now());
        return reservationRepository.save(res);
    }
}
