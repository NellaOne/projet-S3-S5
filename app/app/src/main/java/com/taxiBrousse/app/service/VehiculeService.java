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
public class VehiculeService {
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private DepenseRepository depenseRepo;
    
    public List<Vehicule> getVehiculesDisponibles() {
        return vehiculeRepo.findByStatut("DISPONIBLE");
    }
    
    public Vehicule mettreEnMaintenance(Long vehiculeId, String description) {
        Vehicule vehicule = vehiculeRepo.findById(vehiculeId).orElseThrow();
        vehicule.setStatut("EN_MAINTENANCE");
        return vehiculeRepo.save(vehicule);
    }
    
    public List<Vehicule> getVehiculesAlerteMaintenance() {
        List<Vehicule> vehicules = vehiculeRepo.findAll();
        LocalDate today = LocalDate.now();
        
        return vehicules.stream()
            .filter(v -> v.getDateProchaineVisiteTechnique() != null &&
                        v.getDateProchaineVisiteTechnique().isBefore(today.plusDays(30)))
            .toList();
    }
}
