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
@RequestMapping("/voyages")
public class VoyageController {
    @Autowired private VoyageService voyageService;
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private PersonneRepository personneRepo;
    @Autowired private TrajetRepository trajetRepo;
    @Autowired private TarifRepository tarifRepo;
    
    @GetMapping
    public String list(Model model) {
        model.addAttribute("voyages", voyageRepo.findAll());
        return "voyages/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauForm(Model model) {
        model.addAttribute("voyage", new Voyage());
        model.addAttribute("vehicules", vehiculeRepo.findByStatut("DISPONIBLE"));
        model.addAttribute("chauffeurs", personneRepo.findByTypePersonneAndStatut("CHAUFFEUR", "ACTIF"));
        model.addAttribute("aides", personneRepo.findByTypePersonneAndStatut("AIDE_CHAUFFEUR", "ACTIF"));
        model.addAttribute("trajets", trajetRepo.findByActifTrue());
        return "voyages/form";
    }
    
    @PostMapping("/creer")
    public String creer(@ModelAttribute Voyage voyage, RedirectAttributes redirectAttrs) {
        // Récupérer le tarif pour calculer prix
        List<Tarif> tarifs = tarifRepo.findByTrajetIdAndActifTrue(voyage.getTrajet().getId());
        if (!tarifs.isEmpty()) {
            Tarif tarif = tarifs.get(0);
            voyage.setPrixParPlace(tarif.getPrixBase());
        }
        
        Voyage created = voyageService.creerVoyage(voyage);
        redirectAttrs.addFlashAttribute("success", "Voyage créé avec succès");
        return "redirect:/voyages/" + created.getId();
    }
    
    @GetMapping("/{id}")
    public String details(@PathVariable Long id, Model model) {
        Voyage voyage = voyageRepo.findById(id).orElseThrow();
        model.addAttribute("voyage", voyage);
        return "voyages/details";
    }
    
    @PostMapping("/{id}/demarrer")
    public String demarrer(@PathVariable Long id, RedirectAttributes redirectAttrs) {
        voyageService.demarrerVoyage(id);
        redirectAttrs.addFlashAttribute("success", "Voyage démarré");
        return "redirect:/voyages/" + id;
    }
    
    @PostMapping("/{id}/terminer")
    public String terminer(@PathVariable Long id, RedirectAttributes redirectAttrs) {
        voyageService.terminerVoyage(id);
        redirectAttrs.addFlashAttribute("success", "Voyage terminé");
        return "redirect:/voyages/" + id;
    }
    
    @GetMapping("/disponibles")
    public String disponibles(Model model) {
        model.addAttribute("voyages", voyageService.getVoyagesDisponibles());
        return "voyages/disponibles";
    }
}
