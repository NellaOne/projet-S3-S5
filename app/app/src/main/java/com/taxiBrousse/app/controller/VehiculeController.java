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
@RequestMapping("/vehicules")
public class VehiculeController {
    @Autowired private VehiculeRepository vehiculeRepo;
    @Autowired private VehiculeService vehiculeService;
    @Autowired private TypeVehiculeRepository typeVehiculeRepo;
    
    @GetMapping
    public String list(Model model) {
        model.addAttribute("vehicules", vehiculeRepo.findByActifTrue());
        return "vehicules/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauForm(Model model) {
        model.addAttribute("vehicule", new Vehicule());
        model.addAttribute("types", typeVehiculeRepo.findAll());
        return "vehicules/form";
    }
    
    @PostMapping("/creer")
    public String creer(@ModelAttribute Vehicule vehicule, RedirectAttributes redirectAttrs) {
        vehiculeRepo.save(vehicule);
        redirectAttrs.addFlashAttribute("success", "Véhicule créé");
        return "redirect:/vehicules";
    }
    
    @GetMapping("/{id}")
    public String details(@PathVariable Long id, Model model) {
        model.addAttribute("vehicule", vehiculeRepo.findById(id).orElseThrow());
        return "vehicules/details";
    }
}
