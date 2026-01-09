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

// VoyageService.java
@Service
@Transactional
public class VoyageService {
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private ListeAttenteRepository listeAttenteRepo;
    
    public Voyage creerVoyage(Voyage voyage) {
        // Générer code unique
        voyage.setCodeVoyage("VOY" + System.currentTimeMillis());
        voyage.setNombrePlacesDisponibles(voyage.getVehicule().getNombrePlaces());
        
        // Mettre à jour statut véhicule
        Vehicule vehicule = voyage.getVehicule();
        vehicule.setStatut("EN_SERVICE");
        vehiculeRepo.save(vehicule);
        
        return voyageRepo.save(voyage);
    }
    
    public List<Voyage> getVoyagesDisponibles() {
        return voyageRepo.findVoyagesDisponibles();
    }
    
    public Voyage demarrerVoyage(Long voyageId) {
        Voyage voyage = voyageRepo.findById(voyageId).orElseThrow();
        voyage.setStatut("EN_COURS");
        return voyageRepo.save(voyage);
    }
    
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
}
