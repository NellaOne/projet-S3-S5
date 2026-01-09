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
public class TypeVehicule {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 100)
    private String nom;
    
    @Column(nullable = false)
    private Integer capacitePassagers;
    
    private BigDecimal capaciteBagages;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Boolean actif = true;
    
    private LocalDateTime dateCreation = LocalDateTime.now();
}
