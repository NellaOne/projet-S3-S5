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
public class Garage {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_garage")
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String nom;
    
    @Column(columnDefinition = "TEXT")
    private String adresse;
    
    private String telephone;
    private String email;
    
    @Column(columnDefinition = "TEXT")
    private String specialite;
    
    private Boolean actif = true;
    private LocalDateTime dateCreation = LocalDateTime.now();
}
