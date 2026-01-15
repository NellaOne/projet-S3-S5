package com.taxiBrousse.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * DTO pour affichage de la 2ème liste déroulante
 * (Dates disponibles pour un trajet)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DateDisponibleDTO {
    private LocalDate date;
    private Integer nbVoyagesDispo;  // Nombre de voyages à cette date
    private String displayLabel;  // "15 janvier 2026 (3 voyages)"
}
