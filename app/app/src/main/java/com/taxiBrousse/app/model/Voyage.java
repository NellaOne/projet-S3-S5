package com.taxiBrousse.app.model;


import java.math.BigDecimal;
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
public class Voyage {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_voyage")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String codeVoyage;
    
    @ManyToOne
    @JoinColumn(name = "vehicule_id")
    private Vehicule vehicule;
    
    @ManyToOne
    @JoinColumn(name = "chauffeur_id")
    private Personne chauffeur;
    
    @ManyToOne
    @JoinColumn(name = "aide_chauffeur_id")
    private Personne aideChauffeur;
    
    @ManyToOne
    @JoinColumn(name = "trajet_id")
    private Trajet trajet;
    
    @Column(nullable = false)
    private LocalDateTime dateDepart;
    
    private LocalDateTime dateArriveePrevue;
    private LocalDateTime dateArriveeReelle;
    
    @Column(length = 50)
    private String statut = "PLANIFIE"; // PLANIFIE, EN_COURS, TERMINE, ANNULE
    
    // ✅ SUPPRIMÉ : nombrePlacesDisponibles est calculé via VUE SQL
    // private Integer nombrePlacesDisponibles;
    
    @Column(nullable = false)
    private BigDecimal prixParPlace;
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    private LocalDateTime dateCreation = LocalDateTime.now();
    private LocalDateTime dateModification = LocalDateTime.now();
}
