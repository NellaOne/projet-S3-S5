package com.taxiBrousse.app.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Data @NoArgsConstructor @AllArgsConstructor
public class Trajet {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_trajet")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String code;
    
    @Column(nullable = false, length = 100)
    private String villeDepart;
    
    @Column(nullable = false, length = 100)
    private String villeArrivee;
    
    @Column(nullable = false)
    private BigDecimal distanceKm;
    
    private Integer dureeEstimeeMinutes;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Boolean actif = true;
    private LocalDateTime dateCreation = LocalDateTime.now();
}
