package com.taxiBrousse.app.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister.NotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.taxiBrousse.app.model.ListeAttente;
import com.taxiBrousse.app.model.Paiement;
import com.taxiBrousse.app.model.Personne;
import com.taxiBrousse.app.model.Reservation;
import com.taxiBrousse.app.model.Trajet;
import com.taxiBrousse.app.model.Voyage;
import com.taxiBrousse.app.repositories.ListeAttenteRepository;
import com.taxiBrousse.app.repositories.PaiementRepository;
import com.taxiBrousse.app.repositories.ReservationRepository;
import com.taxiBrousse.app.repositories.VoyageRepository;
import com.taxiBrousse.app.repositories.TrajetRepository;
import com.taxiBrousse.app.repositories.PersonneRepository;



@Service
@Transactional
public class ReservationService {
    @Autowired private ReservationRepository reservationRepository;
    @Autowired private VoyageRepository voyageRepository;
    @Autowired private PaiementRepository paiementRepo;
    @Autowired private ListeAttenteRepository listeAttenteRepo;
    @Autowired private TrajetRepository trajetRepository;
    @Autowired private PersonneRepository personneRepository;
    
    public Reservation creerReservation(Reservation reservation) {
        Voyage voyage = reservation.getVoyage();
        
        // Vérifier disponibilité
        if (voyage.getNombrePlacesDisponibles() < reservation.getNombrePlaces()) {
            throw new RuntimeException("Pas assez de places disponibles");
        }
        
        // Générer code
        reservation.setCodeReservation("RES" + System.currentTimeMillis());
        
        // Calculer montant
        BigDecimal total = voyage.getPrixParPlace()
            .multiply(BigDecimal.valueOf(reservation.getNombrePlaces()));
        reservation.setMontantTotal(total);
        reservation.setMontantRestant(total.subtract(reservation.getMontantPaye()));
        
        // Mettre à jour places disponibles
        voyage.setNombrePlacesDisponibles(
            voyage.getNombrePlacesDisponibles() - reservation.getNombrePlaces()
        );
        voyageRepository.save(voyage);
        
        return reservationRepository.save(reservation);
    }

    // Réservation rapide par villes/date/heure
    public Reservation reserverPlaces(Long clientId, String villeDepart, String villeArrivee, LocalDate date, int heure, int nombrePlaces) {
        Trajet trajet = trajetRepository.findByVilleDepartAndVilleArrivee(villeDepart, villeArrivee);
        if (trajet == null) throw new RuntimeException("Trajet non trouvé");

        List<Voyage> voyages = voyageRepository.findVoyagesByVillesAndDateHeure(villeDepart, villeArrivee, date, heure);
        Voyage voyage = voyages.stream().filter(v -> v.getNombrePlacesDisponibles() >= nombrePlaces).findFirst().orElse(null);
        if (voyage == null) throw new RuntimeException("Aucun voyage disponible");

        if (voyage.getNombrePlacesDisponibles() < nombrePlaces) throw new RuntimeException("Pas assez de places disponibles");

        Personne client = personneRepository.findById(clientId).orElseThrow();
        Reservation reservation = new Reservation();
        reservation.setVoyage(voyage);
        reservation.setClient(client);
        reservation.setNombrePlaces(nombrePlaces);
        reservation.setMontantTotal(voyage.getPrixParPlace().multiply(BigDecimal.valueOf(nombrePlaces)));
        reservation.setStatut("EN_ATTENTE");
        reservation.setDateReservation(LocalDateTime.now());
        reservation.setCodeReservation("RES" + System.currentTimeMillis());
        reservation.setMontantPaye(BigDecimal.ZERO);
        reservation.setMontantRestant(reservation.getMontantTotal());
        reservationRepository.save(reservation);

        voyage.setNombrePlacesDisponibles(voyage.getNombrePlacesDisponibles() - nombrePlaces);
        voyageRepository.save(voyage);

        return reservation;
    }
    
    public Reservation effectuerPaiement(Long reservationId, BigDecimal montant, String mode, String moment) {
        Reservation res = reservationRepository.findById(reservationId).orElseThrow();
        
        // Créer paiement
        Paiement paiement = new Paiement();
        paiement.setCodePaiement("PAY" + System.currentTimeMillis());
        paiement.setTypePaiement("RESERVATION");
        paiement.setReferenceId(reservationId);
        paiement.setMontant(montant);
        paiement.setModePaiement(mode);
        paiement.setMomentPaiement(moment);
        paiementRepo.save(paiement);
        
        // Mettre à jour réservation
        res.setMontantPaye(res.getMontantPaye().add(montant));
        res.setMontantRestant(res.getMontantTotal().subtract(res.getMontantPaye()));
        
        if (res.getMontantRestant().compareTo(BigDecimal.ZERO) <= 0) {
            res.setStatut("PAYE");
        } else {
            res.setStatut("CONFIRME");
        }
        
        return reservationRepository.save(res);
    }
    
    public void annulerReservation(Long reservationId) {
        Reservation res = reservationRepository.findById(reservationId).orElseThrow();
        
        // Libérer les places
        Voyage voyage = res.getVoyage();
        voyage.setNombrePlacesDisponibles(
            voyage.getNombrePlacesDisponibles() + res.getNombrePlaces()
        );
        voyageRepository.save(voyage);
        
        res.setStatut("ANNULE");
        reservationRepository.save(res);
        
        // Notifier liste d'attente
        List<ListeAttente> attentes = listeAttenteRepo
            .findByTrajetIdAndStatut(voyage.getTrajet().getId(), "EN_ATTENTE");
        
        for (ListeAttente attente : attentes) {
            if (attente.getNombrePlacesDemandees() <= voyage.getNombrePlacesDisponibles()) {
                attente.setStatut("NOTIFIE");
                attente.setDateNotification(LocalDateTime.now());
                listeAttenteRepo.save(attente);
                break;
            }
        }
    }

    public Reservation reserverPlaces(Long clientId, String villeDepart, String villeArrivee, LocalDate date, LocalTime heure, int nombrePlaces) {
        // 1. Chercher le trajet
        Trajet trajet = trajetRepository.findByVilleDepartAndVilleArrivee(villeDepart, villeArrivee);
        if (trajet == null) throw new RuntimeException("Trajet non trouvé");

        // 2. Chercher le voyage correspondant (date/heure)
        LocalDateTime dateDepart = LocalDateTime.of(date, heure);
        List<Voyage> voyages = voyageRepository.findByTrajet_VilleDepartAndTrajet_VilleArriveeAndDateDepart(villeDepart, villeArrivee, dateDepart);
        Voyage voyage = voyages.stream().filter(v -> v.getNombrePlacesDisponibles() >= nombrePlaces).findFirst().orElse(null);
        if (voyage == null) throw new RuntimeException("Aucun voyage disponible");

        // 3. Vérifier la capacité de la voiture
        if (voyage.getNombrePlacesDisponibles() < nombrePlaces) throw new IllegalArgumentException("Pas assez de places");

        // 4. Créer la réservation
        Personne client = personneRepository.findById(clientId).orElseThrow();
        Reservation reservation = new Reservation();
        reservation.setVoyage(voyage);
        reservation.setClient(client);
        reservation.setNombrePlaces(nombrePlaces);
        reservation.setMontantTotal(voyage.getPrixParPlace().multiply(BigDecimal.valueOf(nombrePlaces)));
        reservation.setStatut("EN_ATTENTE");
        reservation.setDateReservation(LocalDateTime.now());
        reservationRepository.save(reservation);

        // 5. Mettre à jour le nombre de places disponibles
        voyage.setNombrePlacesDisponibles(voyage.getNombrePlacesDisponibles() - nombrePlaces);
        voyageRepository.save(voyage);

        return reservation;
    }
}
