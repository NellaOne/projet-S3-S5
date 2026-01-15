package com.taxiBrousse.app.controller;

import com.taxiBrousse.app.dto.DateDisponibleDTO;
import com.taxiBrousse.app.dto.TrajetDTO;
import com.taxiBrousse.app.dto.VoyageDisponibleDTO;
import com.taxiBrousse.app.service.*;
import com.taxiBrousse.app.model.*;
import com.taxiBrousse.app.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import java.math.BigDecimal;

/**
 * ReservationController - Gestion des réservations
 * 
 * Structure UI/UX :
 * 1. Choix du TRAJET (1ère liste déroulante)
 * 2. Choix de la DATE (2ème liste déroulante dynamique)
 * 3. Choix de l'HEURE/VOYAGE (3ème liste déroulante dynamique)
 * 4. Confirmation et paiement
 */
@Controller
@RequestMapping("/reservations")
public class ReservationController {
    @Autowired private ReservationService reservationService;
    @Autowired private VoyageService voyageService;
    @Autowired private ReservationRepository reservationRepo;
    @Autowired private VoyageRepository voyageRepo;
    @Autowired private TrajetRepository trajetRepo;
    @Autowired private PersonneRepository personneRepo;
    
    // ============================================
    // AFFICHAGE FORMULAIRES
    // ============================================
    
    @GetMapping
    public String list(Model model) {
        model.addAttribute("reservations", reservationRepo.findAll());
        return "reservations/list";
    }
    
    /**
     * Affiche le formulaire de réservation
     * avec la 1ère liste déroulante (TRAJETS)
     */
    @GetMapping("/nouvelle")
    public String nouvelleForm(Model model) {
        // 1ère liste déroulante : Liste de tous les trajets
        List<Trajet> trajets = trajetRepo.findByActifTrue();
        model.addAttribute("trajets", trajets);
        
        // Villes pour affichage alternatif
        Set<String> villes = new HashSet<>();
        for (Trajet t : trajets) {
            villes.add(t.getVilleDepart());
            villes.add(t.getVilleArrivee());
        }
        model.addAttribute("villes", villes);
        
        // Clients disponibles
        model.addAttribute("clients", 
            personneRepo.findByTypePersonneAndActifTrue("CLIENT"));
        
        return "reservations/form";
    }
    
    // ============================================
    // ENDPOINTS API (Pour listes déroulantes dynamiques)
    // ============================================
    
    /**
     * API : 2ème liste déroulante - Dates disponibles
     * Appelée quand l'utilisateur sélectionne un trajet
     * 
     * Réponse JSON : Liste des dates + nombre de voyages
     */
    @GetMapping("/api/dates/{trajetId}")
    @ResponseBody
    public ResponseEntity<List<DateDisponibleDTO>> getDatesDisponibles(
            @PathVariable Long trajetId) {
        List<DateDisponibleDTO> dates = voyageService.getDatesDisponibles(trajetId);
        return ResponseEntity.ok(dates);
    }
    
    /**
     * API : 3ème liste déroulante - Heures/Voyages disponibles
     * Appelée quand l'utilisateur sélectionne une date
     * 
     * Réponse JSON : Liste des voyages avec détails (heure, places, prix)
     */
    @GetMapping("/api/heures/{trajetId}/{date}")
    @ResponseBody
    public ResponseEntity<List<VoyageDisponibleDTO>> getHeuresDisponibles(
            @PathVariable Long trajetId,
            @PathVariable String date) {
        LocalDate d = LocalDate.parse(date);
        List<VoyageDisponibleDTO> heures = voyageService.getHeuresDisponibles(trajetId, d);
        return ResponseEntity.ok(heures);
    }
    
    /**
     * API : Détail d'un voyage (session) avant réservation
     */
    @GetMapping("/api/voyage/{voyageId}")
    @ResponseBody
    public ResponseEntity<VoyageDisponibleDTO> getVoyageDetail(@PathVariable Long voyageId) {
        Voyage voyage = voyageRepo.findById(voyageId)
            .orElseThrow(() -> new RuntimeException("Voyage non trouvé"));
        
        // Calculer les places disponibles
        int placesReservees = reservationRepo
            .findByVoyageIdAndStatutNot(voyageId, "ANNULE")
            .stream()
            .mapToInt(Reservation::getNombrePlaces)
            .sum();
        
        int placesDisponibles = voyage.getVehicule().getNombrePlaces() - placesReservees;
        
        VoyageDisponibleDTO dto = new VoyageDisponibleDTO(
            voyage.getId(),
            voyage.getDateDepart().toLocalTime(),
            placesDisponibles,
            voyage.getPrixParPlace(),
            voyage.getCodeVoyage(),
            voyage.getVehicule().getImmatriculation(),
            voyage.getVehicule().getNombrePlaces(),
            voyage.getChauffeur().getNom() + " " + 
                (voyage.getChauffeur().getPrenom() != null ? 
                 voyage.getChauffeur().getPrenom() : "")
        );
        
        return ResponseEntity.ok(dto);
    }
    
    // ============================================
    // CRÉATION RÉSERVATION
    // ============================================
    
    /**
     * POST : Crée une réservation
     * Appelé après sélection du trajet/date/heure/client/places
     */
    @PostMapping("/creer")
    public String creer(
            @RequestParam Long voyageId,
            @RequestParam Long clientId,
            @RequestParam(required = false) Integer nombrePlacesPremium,
            @RequestParam(required = false) Integer nombrePlacesStandard,
            @RequestParam(required = false) Integer nombrePlaces,
            RedirectAttributes redirectAttrs) {
        try {
            Reservation reservation;
            
            // Si places premium/standard fournis, les utiliser
            if (nombrePlacesPremium != null && nombrePlacesStandard != null) {
                reservation = reservationService.creerReservation(
                    voyageId, clientId, nombrePlacesPremium, nombrePlacesStandard);
            } else {
                // Sinon utiliser le nombre de places classique (compatibilité)
                reservation = reservationService.creerReservation(
                    voyageId, clientId, nombrePlaces != null ? nombrePlaces : 1);
            }
            
            redirectAttrs.addFlashAttribute("success", 
                "Réservation créée : " + reservation.getCodeReservation());
            
            return "redirect:/reservations/" + reservation.getId();
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Erreur : " + e.getMessage());
            return "redirect:/reservations/nouvelle";
        }
    }
    
    /**
     * POST : Calcule les montants pour les deux types de places
     */
    @PostMapping("/api/calculer-montants")
    @ResponseBody
    public ResponseEntity<Map<String, BigDecimal>> calculerMontants(
            @RequestParam Long voyageId,
            @RequestParam(required = false) Integer nombrePlacesPremium,
            @RequestParam(required = false) Integer nombrePlacesStandard) {
        try {
            if (nombrePlacesPremium == null) nombrePlacesPremium = 0;
            if (nombrePlacesStandard == null) nombrePlacesStandard = 0;
            
            Map<String, BigDecimal> montants = voyageService.calculerMontantsReservation(
                voyageId, nombrePlacesPremium, nombrePlacesStandard);
            
            return ResponseEntity.ok(montants);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    /**
     * Ancien flux (compatibilité) - Réservation rapide
     */
    @PostMapping("/creer-rapide")
    public String creerRapide(
            @RequestParam Long clientId,
            @RequestParam String villeDepart,
            @RequestParam String villeArrivee,
            @RequestParam String date,
            @RequestParam String heure,
            @RequestParam int nombrePlaces,
            RedirectAttributes redirectAttrs) {
        try {
            LocalDate d = LocalDate.parse(date);
            int h = Integer.parseInt(heure.split(":")[0]);
            
            Reservation created = reservationService.reserverPlaces(
                clientId, villeDepart, villeArrivee, d, h, nombrePlaces);
            
            redirectAttrs.addFlashAttribute("success", 
                "Réservation créée : " + created.getCodeReservation());
            
            return "redirect:/reservations/" + created.getId();
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Erreur : " + e.getMessage());
            return "redirect:/reservations/nouvelle";
        }
    }
    
    // ============================================
    // DÉTAILS & MODIFICATION
    // ============================================
    
    /**
     * Affiche les détails d'une réservation
     */
    @GetMapping("/{id}")
    public String details(@PathVariable Long id, Model model) {
        Reservation reservation = reservationRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));
        
        model.addAttribute("reservation", reservation);
        model.addAttribute("modesRevenusDispo", 
            Arrays.asList("ESPECE", "MOBILE_MONEY", "CARTE", "VIREMENT"));
        
        return "reservations/details";
    }
    
    /**
     * POST : Enregistre un paiement
     */
    @PostMapping("/{id}/paiement")
    public String paiement(
            @PathVariable Long id,
            @RequestParam BigDecimal montant,
            @RequestParam String mode,
            @RequestParam String moment,
            RedirectAttributes redirectAttrs) {
        try {
            reservationService.effectuerPaiement(id, montant, mode, moment);
            redirectAttrs.addFlashAttribute("success", "Paiement enregistré");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Erreur : " + e.getMessage());
        }
        return "redirect:/reservations/" + id;
    }
    
    /**
     * POST : Annule une réservation
     */
    @PostMapping("/{id}/annuler")
    public String annuler(@PathVariable Long id, RedirectAttributes redirectAttrs) {
        try {
            reservationService.annulerReservation(id);
            redirectAttrs.addFlashAttribute("success", "Réservation annulée");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Erreur : " + e.getMessage());
        }
        return "redirect:/reservations";
    }
    
    /**
     * POST : Confirme une réservation
     */
    @PostMapping("/{id}/confirmer")
    public String confirmer(@PathVariable Long id, RedirectAttributes redirectAttrs) {
        try {
            reservationService.confirmerReservation(id);
            redirectAttrs.addFlashAttribute("success", "Réservation confirmée");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Erreur : " + e.getMessage());
        }
        return "redirect:/reservations/" + id;
    }
}
   
