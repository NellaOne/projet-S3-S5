package com.taxiBrousse.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;
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
public class Personne {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_personne")
    private Long id;
    
    @Column(nullable = false, length = 50)
    private String typePersonne; // CHAUFFEUR, AIDE_CHAUFFEUR, EMPLOYE, CLIENT
    
    @Column(nullable = false, length = 100)
    private String nom;
    
    private String prenom;
    
    @Column(unique = true, length = 50)
    private String cin;
    
    private LocalDate dateNaissance;
    
    @Column(columnDefinition = "TEXT")
    private String adresse;
    
    private String telephone;
    private String email;
    
    // Pour chauffeurs
    private String permisNumero;
    private String permisCategorie;
    private LocalDate permisDateExpiration;
    
    // Pour employés
    private LocalDate dateEmbauche;
    private BigDecimal salaireBase;
    
    @Column(length = 50)
    private String statut = "ACTIF"; // ACTIF, INACTIF, CONGE, SUSPENDU
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    private Boolean actif = true;
    private LocalDateTime dateCreation = LocalDateTime.now();
    private LocalDateTime dateModification = LocalDateTime.now();
}
