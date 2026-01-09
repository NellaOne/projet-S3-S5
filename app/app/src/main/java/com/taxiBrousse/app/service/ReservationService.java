package com.taxiBrousse.app.service;

import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.*;

@Service
@Transactional
public class ReservationService {
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private PaiementRepository paiementRepo;
    @Autowired private ListeAttenteRepository listeAttenteRepo;
    
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
        voyageRepo.save(voyage);
        
        return reservationRepo.save(reservation);
    }
    
    public Reservation effectuerPaiement(Long reservationId, BigDecimal montant, String mode, String moment) {
        Reservation res = reservationRepo.findById(reservationId).orElseThrow();
        
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
        
        return reservationRepo.save(res);
    }
    
    public void annulerReservation(Long reservationId) {
        Reservation res = reservationRepo.findById(reservationId).orElseThrow();
        
        // Libérer les places
        Voyage voyage = res.getVoyage();
        voyage.setNombrePlacesDisponibles(
            voyage.getNombrePlacesDisponibles() + res.getNombrePlaces()
        );
        voyageRepo.save(voyage);
        
        res.setStatut("ANNULE");
        reservationRepo.save(res);
        
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
}
