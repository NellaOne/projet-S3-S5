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
@RequestMapping("/finances")
public class FinanceController {
    @Autowired private FinanceService financeService;
    @Autowired private DepenseRepository depenseRepo;
    
    @GetMapping
    public String dashboard(Model model) {
        LocalDate today = LocalDate.now();
        LocalDate debut = today.withDayOfMonth(1);
        LocalDate fin = today.withDayOfMonth(today.lengthOfMonth());
        
        Map<String, Object> bilan = financeService.getBilanFinancier(debut, fin);
        model.addAllAttributes(bilan);
        
        return "finances/dashboard";
    }
    
    @GetMapping("/bilan")
    public String bilan(@RequestParam LocalDate dateDebut,
                       @RequestParam LocalDate dateFin,
                       Model model) {
        Map<String, Object> bilan = financeService.getBilanFinancier(dateDebut, dateFin);
        model.addAllAttributes(bilan);
        return "finances/bilan";
    }
    
    @GetMapping("/depenses")
    public String depenses(Model model) {
        model.addAttribute("depenses", depenseRepo.findAll());
        return "finances/depenses";
    }
    
    @PostMapping("/depenses/creer")
    public String creerDepense(@ModelAttribute Depense depense, RedirectAttributes redirectAttrs) {
        financeService.creerDepense(depense);
        redirectAttrs.addFlashAttribute("success", "Dépense enregistrée");
        return "redirect:/finances/depenses";
    }

    
}
