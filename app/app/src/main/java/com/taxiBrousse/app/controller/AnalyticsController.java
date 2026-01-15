package com.taxiBrousse.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;

import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;
import com.taxiBrousse.app.dto.VoyageAnalyticsDTO;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * AnalyticsController - Dashboard Analytique des Voyages
 * 
 * Gestion des filtres:
 * - Par CIRCUIT (trajet)
 * - Par CHIFFRE D'AFFAIRE (CA Min/Max)
 * - Combiné (tous les critères)
 */
@Controller
@RequestMapping("/analytics")
public class AnalyticsController {
    
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private TrajetRepository trajetRepo;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private com.taxiBrousse.app.service.VoyageService voyageService;
    
    // ============================================
    // DASHBOARD PRINCIPAL
    // ============================================
    
    /**
     * Affiche le dashboard d'analytics avec filtres
     */
    @GetMapping
    public String dashboard(
            @RequestParam(required = false) Long trajetId,
            @RequestParam(required = false) BigDecimal caMin,
            @RequestParam(required = false) BigDecimal caMax,
            @RequestParam(required = false) String statut,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Model model) {
        
        // Récupérer tous les trajets pour les filtres
        List<Trajet> trajets = trajetRepo.findByActifTrue();
        model.addAttribute("trajets", trajets);
        
        // Appliquer les filtres
        List<Voyage> voyages = voyageRepo.findAll();
        
        // Filtre par trajet
        if (trajetId != null) {
            voyages = voyages.stream()
                .filter(v -> v.getTrajet().getId().equals(trajetId))
                .collect(Collectors.toList());
        }
        
        // Filtrer par CA
        voyages = voyages.stream()
            .filter(v -> {
                BigDecimal ca = calculerCA(v.getId());
                boolean validMin = caMin == null || ca.compareTo(caMin) >= 0;
                boolean validMax = caMax == null || ca.compareTo(caMax) <= 0;
                return validMin && validMax;
            })
            .collect(Collectors.toList());
        
        // Filtre par statut
        if (statut != null && !statut.isEmpty()) {
            voyages = voyages.stream()
                .filter(v -> v.getStatut().equals(statut))
                .collect(Collectors.toList());
        }
        
        // Pagination
        int fromIndex = Math.min(page * size, voyages.size());
        int toIndex = Math.min(fromIndex + size, voyages.size());
        List<Voyage> voyagesPagines = voyages.subList(fromIndex, toIndex);
        
        // Enrichir avec les données analytiques
        List<VoyageAnalyticsDTO> analyticsData = voyagesPagines.stream()
            .map(this::enrichirVoyageAnalytics)
            .sorted(Comparator.comparing(VoyageAnalyticsDTO::getDateDepart).reversed())
            .collect(Collectors.toList());
        
        model.addAttribute("voyages", analyticsData);
        model.addAttribute("totalVoyages", voyages.size());
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) voyages.size() / size));
        
        // Paramètres de filtre actuels
        if (trajetId != null) model.addAttribute("selectedTrajetId", trajetId);
        if (caMin != null) model.addAttribute("caMin", caMin);
        if (caMax != null) model.addAttribute("caMax", caMax);
        if (statut != null) model.addAttribute("selectedStatut", statut);
        
        // Statistiques globales
        model.addAttribute("totalCA", voyages.stream()
            .map(v -> calculerCA(v.getId()))
            .reduce(BigDecimal.ZERO, BigDecimal::add));
        
        model.addAttribute("totalReservations", voyages.stream()
            .mapToLong(v -> reservationRepo.findByVoyageIdAndStatutNot(v.getId(), "ANNULE").size())
            .sum());
        
        return "analytics/dashboard";
    }
    
    /**
     * API : Filtre par circuit (trajet)
     */
    @GetMapping("/api/par-circuit/{trajetId}")
    @ResponseBody
    public ResponseEntity<List<VoyageAnalyticsDTO>> parCircuit(@PathVariable Long trajetId) {
        Trajet trajet = trajetRepo.findById(trajetId)
            .orElseThrow(() -> new RuntimeException("Trajet non trouvé"));
        
        List<VoyageAnalyticsDTO> voyages = voyageRepo.findByTrajetId(trajetId).stream()
            .map(this::enrichirVoyageAnalytics)
            .sorted(Comparator.comparing(VoyageAnalyticsDTO::getDateDepart).reversed())
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(voyages);
    }
    
    /**
     * API : Filtre par plage de CA
     */
    @GetMapping("/api/par-ca")
    @ResponseBody
    public ResponseEntity<List<VoyageAnalyticsDTO>> parCA(
            @RequestParam BigDecimal caMin,
            @RequestParam BigDecimal caMax) {
        
        List<VoyageAnalyticsDTO> voyages = voyageRepo.findAll().stream()
            .filter(v -> {
                BigDecimal ca = calculerCA(v.getId());
                return ca.compareTo(caMin) >= 0 && ca.compareTo(caMax) <= 0;
            })
            .map(this::enrichirVoyageAnalytics)
            .sorted(Comparator.comparing(VoyageAnalyticsDTO::getChiffreAffaire).reversed())
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(voyages);
    }
    
    /**
     * API : Filtre combiné (circuit + CA + statut)
     */
    @GetMapping("/api/filtre-complet")
    @ResponseBody
    public ResponseEntity<List<VoyageAnalyticsDTO>> filtreComplet(
            @RequestParam(required = false) Long trajetId,
            @RequestParam(required = false) BigDecimal caMin,
            @RequestParam(required = false) BigDecimal caMax,
            @RequestParam(required = false) String statut) {
        
        List<Voyage> voyages = voyageRepo.findAll().stream()
            .filter(v -> trajetId == null || v.getTrajet().getId().equals(trajetId))
            .filter(v -> {
                BigDecimal ca = calculerCA(v.getId());
                BigDecimal min = caMin != null ? caMin : BigDecimal.ZERO;
                BigDecimal max = caMax != null ? caMax : new BigDecimal("999999999.99");
                return ca.compareTo(min) >= 0 && ca.compareTo(max) <= 0;
            })
            .filter(v -> statut == null || v.getStatut().equals(statut))
            .collect(Collectors.toList());
        
        List<VoyageAnalyticsDTO> result = voyages.stream()
            .map(this::enrichirVoyageAnalytics)
            .sorted(Comparator.comparing(VoyageAnalyticsDTO::getDateDepart).reversed())
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(result);
    }
    
    // ============================================
    // MÉTHODES UTILITAIRES
    // ============================================
    
    /**
     * Enrichit les données d'un voyage avec les analytics
     */
    private VoyageAnalyticsDTO enrichirVoyageAnalytics(Voyage voyage) {
        List<Reservation> reservations = reservationRepo
            .findByVoyageIdAndStatutNot(voyage.getId(), "ANNULE");
        
        BigDecimal ca = reservations.stream()
            .map(Reservation::getMontantPaye)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        BigDecimal montantTotal = reservations.stream()
            .map(Reservation::getMontantTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        long placesVendues = reservations.stream()
            .mapToLong(Reservation::getNombrePlaces)
            .sum();
        
        double tauxOccupation = voyage.getVehicule().getNombrePlaces() > 0
            ? (placesVendues * 100.0) / voyage.getVehicule().getNombrePlaces()
            : 0;
        
        BigDecimal caParPlace = placesVendues > 0
            ? ca.divide(BigDecimal.valueOf(placesVendues), 2, java.math.RoundingMode.HALF_UP)
            : BigDecimal.ZERO;
        
        // Calcul CA max - gérer les cas où le tarif n'existe pas
        BigDecimal caMax = BigDecimal.ZERO;
        try {
            caMax = voyageService.calculerCaMaxVoyage(voyage.getId());
        } catch (RuntimeException e) {
            // Tarif non trouvé - utiliser 0 par défaut pour ne pas bloquer le dashboard
            System.err.println("Tarif non trouvé pour voyage " + voyage.getId() + ": " + e.getMessage());
            caMax = BigDecimal.ZERO;
        }
        return new VoyageAnalyticsDTO(
            voyage.getId(),
            voyage.getCodeVoyage(),
            voyage.getDateDepart(),
            voyage.getStatut(),
            voyage.getTrajet().getCode(),
            voyage.getTrajet().getVilleDepart(),
            voyage.getTrajet().getVilleArrivee(),
            voyage.getTrajet().getDistanceKm(),
            voyage.getVehicule().getImmatriculation(),
            Long.valueOf(voyage.getVehicule().getNombrePlacesPremium()),
            Long.valueOf(voyage.getVehicule().getNombrePlacesStandard()),
            Long.valueOf(voyage.getVehicule().getNombrePlaces()),
            voyage.getChauffeur().getNom(),
            voyage.getChauffeur().getPrenom(),
            voyage.getPrixParPlace(),
            ca,
            BigDecimal.ZERO, // caPremium (à calculer si besoin)
            BigDecimal.ZERO, // caStandard (à calculer si besoin)
            montantTotal,
            reservations.size(),
            0, // placesPremiumVendues
            0, // placesStandardVendues
            placesVendues,
            tauxOccupation,
            caParPlace,
            caMax
        );
    }
    
    /**
     * Calcule le CA d'un voyage
     */
    private BigDecimal calculerCA(Long voyageId) {
        return reservationRepo.findByVoyageIdAndStatutNot(voyageId, "ANNULE")
            .stream()
            .map(Reservation::getMontantPaye)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
