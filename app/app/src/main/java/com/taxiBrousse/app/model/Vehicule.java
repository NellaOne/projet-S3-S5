package com.taxiBrousse.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data @NoArgsConstructor @AllArgsConstructor
public class Vehicule {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String immatriculation;
    
    @ManyToOne
    @JoinColumn(name = "type_vehicule_id")
    private TypeVehicule typeVehicule;
    
    private String marque;
    private String modele;
    private Integer annee;
    private String couleur;
    
    @Column(nullable = false)
    private Integer nombrePlaces;
    
    @Column(length = 50)
    private String statut = "DISPONIBLE"; // DISPONIBLE, EN_SERVICE, EN_MAINTENANCE, HORS_SERVICE
    
    private BigDecimal kilometrageActuel = BigDecimal.ZERO;
    
    private LocalDate dateAcquisition;
    private LocalDate dateDerniereVisiteTechnique;
    private LocalDate dateProchaineVisiteTechnique;
    
    private Boolean actif = true;
    private LocalDateTime dateCreation = LocalDateTime.now();
    private LocalDateTime dateModification = LocalDateTime.now();
}
