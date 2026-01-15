package com.taxiBrousse.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO pour affichage de la 1ère liste déroulante
 * (Choix du trajet/film)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TrajetDTO {
    private Long id;
    private String code;
    private String villeDepart;
    private String villeArrivee;
    private String description;
    
    // Pour affichage lisible
    public String getLabel() {
        return String.format("%s → %s (%s km)", villeDepart, villeArrivee, code);
    }
}
