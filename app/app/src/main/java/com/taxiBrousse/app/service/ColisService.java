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
public class ColisService {
    @Autowired private ColisRepository colisRepo;
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private PaiementRepository paiementRepo;
    
    public Colis enregistrerColis(Colis colis) {
        colis.setCodeColis("COL" + System.currentTimeMillis());
        return colisRepo.save(colis);
    }
    
    public Colis livrerColis(Long colisId) {
        Colis colis = colisRepo.findById(colisId).orElseThrow();
        colis.setStatut("LIVRE");
        colis.setDateLivraison(LocalDateTime.now());
        return colisRepo.save(colis);
    }
    
    public List<Colis> getColisByVoyage(Long voyageId) {
        return colisRepo.findByVoyageId(voyageId);
    }
}
