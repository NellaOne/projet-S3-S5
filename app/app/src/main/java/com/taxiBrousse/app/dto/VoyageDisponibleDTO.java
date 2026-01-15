package com.taxiBrousse.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalTime;

/**
 * DTO pour affichage de la 3ème liste déroulante
 * (Heures disponibles pour un trajet à une date donnée)
 * ET pour affichage du détail du voyage (session) avant réservation
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VoyageDisponibleDTO {
    private Long id;  // id_voyage
    private LocalTime heureDepart;
    private Integer placesDisponibles;
    private BigDecimal prixParPlace;
    private String codeVoyage;
    private String vehiculeImmatriculation;
    private Integer capaciteTotale;
    private String chauffeurNom;
    
    // Pour affichage lisible
    public String getLabel() {
        return String.format("%s - %d places - %,.0f MGA", 
            heureDepart, 
            placesDisponibles, 
            prixParPlace);
    }
}
