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
public class Colis {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_colis")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String codeColis;
    
    @ManyToOne
    @JoinColumn(name = "voyage_id")
    private Voyage voyage;
    
    @ManyToOne
    @JoinColumn(name = "expediteur_id")
    private Personne expediteur;
    
    private String destinataireNom;
    private String destinataireTelephone;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private BigDecimal poidsKg;
    
    @Column(nullable = false)
    private BigDecimal tarif;
    
    @Column(length = 50)
    private String statut = "ENREGISTRE"; // ENREGISTRE, EN_TRANSIT, LIVRE, ANNULE
    
    private LocalDateTime dateEnvoi = LocalDateTime.now();
    private LocalDateTime dateLivraison;
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
}
