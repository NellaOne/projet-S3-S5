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

import java.math.BigDecimal;


@Controller
@RequestMapping("/reservations")
public class ReservationController {
    @Autowired private ReservationService reservationService;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private PersonneRepository personneRepo;
    
    @GetMapping
    public String list(Model model) {
        model.addAttribute("reservations", reservationRepo.findAll());
        return "reservations/list";
    }
    
    @GetMapping("/nouvelle")
    public String nouvelleForm(@RequestParam(required = false) String villeDepart,
                               @RequestParam(required = false) String villeArrivee,
                               @RequestParam(required = false) String date,
                               @RequestParam(required = false) String heure,
                               Model model) {
        Reservation reservation = new Reservation();
        model.addAttribute("reservation", reservation);
        model.addAttribute("clients", personneRepo.findByTypePersonneAndActifTrue("CLIENT"));
        model.addAttribute("villes", Arrays.asList("Fianarantsoa", "Ambolomadinika Toamasina"));
        model.addAttribute("datePrefill", date);
        model.addAttribute("heurePrefill", heure);
        model.addAttribute("villeDepartPrefill", villeDepart);
        model.addAttribute("villeArriveePrefill", villeArrivee);
        return "reservations/form";
    }
    
    @PostMapping("/creer")
    public String creer(@RequestParam Long clientId,
                        @RequestParam String villeDepart,
                        @RequestParam String villeArrivee,
                        @RequestParam String date,
                        @RequestParam String heure,
                        @RequestParam int nombrePlaces,
                        RedirectAttributes redirectAttrs) {
        java.time.LocalDate d = java.time.LocalDate.parse(date);
        int h = Integer.parseInt(heure.split(":")[0]);
        Reservation created = reservationService.reserverPlaces(clientId, villeDepart, villeArrivee, d, h, nombrePlaces);
        redirectAttrs.addFlashAttribute("success", "Réservation créée : " + created.getCodeReservation());
        return "redirect:/reservations/" + created.getId();
    }
    
    @GetMapping("/{id}")
    public String details(@PathVariable Long id, Model model) {
        Reservation reservation = reservationRepo.findById(id).orElseThrow();
        model.addAttribute("reservation", reservation);
        return "reservations/details";
    }
    
    @PostMapping("/{id}/paiement")
    public String paiement(@PathVariable Long id,
                          @RequestParam BigDecimal montant,
                          @RequestParam String mode,
                          @RequestParam String moment,
                          RedirectAttributes redirectAttrs) {
        reservationService.effectuerPaiement(id, montant, mode, moment);
        redirectAttrs.addFlashAttribute("success", "Paiement enregistré");
        return "redirect:/reservations/" + id;
    }
    
    @PostMapping("/{id}/annuler")
    public String annuler(@PathVariable Long id, RedirectAttributes redirectAttrs) {
        reservationService.annulerReservation(id);
        redirectAttrs.addFlashAttribute("success", "Réservation annulée");
        return "redirect:/reservations/" + id;
    }
}
