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
public class FinanceService {
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private ColisRepository colisRepo;
    @Autowired private DepenseRepository depenseRepo;
    @Autowired private PaiementRepository paiementRepo;
    
    public Map<String, Object> getBilanFinancier(LocalDate dateDebut, LocalDate dateFin) {
        LocalDateTime startTime = dateDebut.atStartOfDay();
        LocalDateTime endTime = dateFin.atTime(23, 59, 59);
        
        // Recettes réservations
        BigDecimal recettesReservations = reservationRepo
            .calculateRecetteByPeriod(startTime, endTime);
        if (recettesReservations == null) recettesReservations = BigDecimal.ZERO;
        
        // Recettes colis
        List<Colis> colis = colisRepo.findAll().stream()
            .filter(c -> c.getDateEnvoi().isAfter(startTime) && 
                        c.getDateEnvoi().isBefore(endTime) &&
                        !c.getStatut().equals("ANNULE"))
            .toList();
        BigDecimal recettesColis = colis.stream()
            .map(Colis::getTarif)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // Dépenses
        BigDecimal depenses = depenseRepo
            .calculateTotalDepensesByPeriod(dateDebut, dateFin);
        if (depenses == null) depenses = BigDecimal.ZERO;
        
        BigDecimal recettesTotal = recettesReservations.add(recettesColis);
        BigDecimal benefice = recettesTotal.subtract(depenses);
        
        Map<String, Object> bilan = new HashMap<>();
        bilan.put("recettesReservations", recettesReservations);
        bilan.put("recettesColis", recettesColis);
        bilan.put("recettesTotal", recettesTotal);
        bilan.put("depenses", depenses);
        bilan.put("benefice", benefice);
        bilan.put("dateDebut", dateDebut);
        bilan.put("dateFin", dateFin);
        
        return bilan;
    }
    
    public Depense creerDepense(Depense depense) {
        depense.setCodeDepense("DEP" + System.currentTimeMillis());
        return depenseRepo.save(depense);
    }
    
    public Depense approuverDepense(Long depenseId, Long approuveurId) {
        Depense depense = depenseRepo.findById(depenseId).orElseThrow();
        Personne approuveur = new Personne();
        approuveur.setId(approuveurId);
        depense.setApprouvePar(approuveur);
        depense.setStatut("APPROUVE");
        return depenseRepo.save(depense);
    }
}
