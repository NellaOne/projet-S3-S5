package com.taxiBrousse.app.controller;

import com.taxiBrousse.app.service.*;
import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class HomeController {
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private DepenseRepository depenseRepo;
    
    @GetMapping("/")
    public String home(Model model) {
        // Statistiques dashboard
        long totalVoyages = voyageRepo.count();
        long voyagesEnCours = voyageRepo.findByStatut("EN_COURS").size();
        long totalReservations = reservationRepo.count();
        long vehiculesDisponibles = vehiculeRepo.findByStatut("DISPONIBLE").size();
        
        model.addAttribute("totalVoyages", totalVoyages);
        model.addAttribute("voyagesEnCours", voyagesEnCours);
        model.addAttribute("totalReservations", totalReservations);
        model.addAttribute("vehiculesDisponibles", vehiculesDisponibles);
        
        // Voyages récents
        List<Voyage> voyagesRecents = voyageRepo.findAll()
            .stream()
            .sorted((a, b) -> b.getDateCreation().compareTo(a.getDateCreation()))
            .limit(5)
            .toList();
        model.addAttribute("voyagesRecents", voyagesRecents);
        
        return "index";
    }
}
