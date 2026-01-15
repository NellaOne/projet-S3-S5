package com.taxiBrousse.app.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * VoyageAnalyticsDTO - DTO pour l'affichage analytique des voyages
 * 
 * Contient TOUS les colonnes du voyage pivot + métriques calculées
 */
@Data
@NoArgsConstructor
public class VoyageAnalyticsDTO {
    
    // ✅ COLONNES DE LA TABLE VOYAGE
    private Long id;
    private String codeVoyage;
    private LocalDateTime dateDepart;
    private String statut;
    
    // 🔗 RÉFÉRENCES
    private String trajetCode;
    private String villeDepart;
    private String villeArrivee;
    private BigDecimal distanceKm;
    
    // 🚗 VÉHICULE
    private String immatriculation;
    private Long nombrePlacesPremium;
    private Long nombrePlacesStandard;
    private Long nombrePlaces;
    
    // 👤 CHAUFFEUR
    private String chauffeurNom;
    private String chauffeurPrenom;
    
    // 💰 TARIFICATION
    private BigDecimal prixParPlace;
    
    // 📊 MÉTRIQUES ANALYTIQUES
    private BigDecimal chiffreAffaire;           // CA réalisé (montant_paye total)
    private BigDecimal caPremium;                 // CA réalisé (places premium)
    private BigDecimal caStandard;                // CA réalisé (places standard)
    private BigDecimal montantTotalReserve;       // Montant total des réservations
    private int nbReservations;                   // Nombre de réservations
    private long placesPremiumVendues;            // Places premium réservées
    private long placesStandardVendues;           // Places standard réservées
    private long placesVendues;                   // Places totales réservées
    private double tauxOccupation;                // % du véhicule rempli
    private BigDecimal caParPlace;                // CA moyen par place vendue
    private BigDecimal caMaxPossible;             // CA max possible pour ce voyage
    
    // ✅ CONSTRUCTEUR PERSONNALISÉ (correspond à l'ordre d'appel du contrôleur)
    public VoyageAnalyticsDTO(
            Long id,
            String codeVoyage,
            LocalDateTime dateDepart,
            String statut,
            String trajetCode,
            String villeDepart,
            String villeArrivee,
            BigDecimal distanceKm,
            String immatriculation,
            Long nombrePlacesPremium,
            Long nombrePlacesStandard,
            Long nombrePlaces,
            String chauffeurNom,
            String chauffeurPrenom,
            BigDecimal prixParPlace,
            BigDecimal chiffreAffaire,
            BigDecimal caPremium,
            BigDecimal caStandard,
            BigDecimal montantTotalReserve,
            int nbReservations,
            long placesPremiumVendues,
            long placesStandardVendues,
            long placesVendues,
            double tauxOccupation,
            BigDecimal caParPlace,
            BigDecimal caMaxPossible) {
        this.id = id;
        this.codeVoyage = codeVoyage;
        this.dateDepart = dateDepart;
        this.statut = statut;
        this.trajetCode = trajetCode;
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.distanceKm = distanceKm;
        this.immatriculation = immatriculation;
        this.nombrePlacesPremium = nombrePlacesPremium;
        this.nombrePlacesStandard = nombrePlacesStandard;
        this.nombrePlaces = nombrePlaces;
        this.chauffeurNom = chauffeurNom;
        this.chauffeurPrenom = chauffeurPrenom;
        this.prixParPlace = prixParPlace;
        this.chiffreAffaire = chiffreAffaire;
        this.caPremium = caPremium;
        this.caStandard = caStandard;
        this.montantTotalReserve = montantTotalReserve;
        this.nbReservations = nbReservations;
        this.placesPremiumVendues = placesPremiumVendues;
        this.placesStandardVendues = placesStandardVendues;
        this.placesVendues = placesVendues;
        this.tauxOccupation = tauxOccupation;
        this.caParPlace = caParPlace;
        this.caMaxPossible = caMaxPossible;
    }
    
    // ✅ GETTERS/SETTERS (Lombok @Data génère automatiquement)
    // + Méthodes de formatage pour l'affichage
    
    public String getCaFormatted() {
        return String.format("%,.0f Ar", chiffreAffaire);
    }
    
    public String getTauxOccupationFormatted() {
        return String.format("%.1f%%", tauxOccupation);
    }
    
    public String getCaParPlaceFormatted() {
        return String.format("%,.0f Ar", caParPlace);
    }
    
    public String getChauffeurComplet() {
            return chauffeurNom + (chauffeurPrenom != null && !chauffeurPrenom.isEmpty() ? (" " + chauffeurPrenom) : "");
            }
}
