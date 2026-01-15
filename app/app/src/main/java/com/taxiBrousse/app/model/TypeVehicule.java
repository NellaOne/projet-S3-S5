package com.taxiBrousse.app.model;


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
    @Column(name = "id_type_vehicule")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 20)
    private String code;
    
    @Column(nullable = false, unique = true, length = 100)
    private String nom;
    
    @Column(nullable = false)
    private Integer capaciteStandard;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Boolean actif = true;
    
    private LocalDateTime dateCreation = LocalDateTime.now();
}
