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
public class Configuration {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_configuration")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 100)
    private String cle;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String valeur;
    
    @Column(length = 50)
    private String typeValeur; // STRING, NUMBER, BOOLEAN
    
    @Column(length = 100)
    private String categorie;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private LocalDateTime dateModification = LocalDateTime.now();
}
