package com.taxiBrousse.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Data @NoArgsConstructor @AllArgsConstructor
public class Maintenance {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_maintenance")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "vehicule_id")
    private Vehicule vehicule;
    
    @ManyToOne
    @JoinColumn(name = "garage_id")
    private Garage garage;
    
    @Column(nullable = false, length = 100, name="type_maintenance")
    private String typeMaintenance; // VISITE_TECHNIQUE, REPARATION, ENTRETIEN
    
    @Column(nullable = false)
    private LocalDate dateDebut;
    
    private LocalDate dateFinPrevue;
    private LocalDate dateFinReelle;
    
    private BigDecimal coutPrevu;
    private BigDecimal coutReel;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(columnDefinition = "TEXT")
    private String piecesChangees;
    
    @Column(length = 50)
    private String statut = "EN_COURS"; // EN_COURS, TERMINE, ANNULE
    
    private LocalDateTime dateCreation = LocalDateTime.now();
}
