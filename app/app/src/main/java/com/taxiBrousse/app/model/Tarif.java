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
public class Tarif {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tarif")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "trajet_id")
    private Trajet trajet;
    
    @ManyToOne
    @JoinColumn(name = "type_vehicule_id")
    private TypeVehicule typeVehicule;
    
    @Column(name = "prix_place_standard", nullable = false)
    private BigDecimal prixPlaceStandard;
    
    @Column(name = "prix_place_premium", nullable = false)
    private BigDecimal prixPlacePremium;
    
    @Column(length = 50)
    private String typeTarif = "NORMAL"; // NORMAL, FETE, WEEKEND, NUIT
    
    private LocalDate dateDebut;
    private LocalDate dateFin;
    
    private BigDecimal multiplicateur = BigDecimal.ONE;
    
    private Boolean actif = true;
    private LocalDateTime dateCreation = LocalDateTime.now();
}
