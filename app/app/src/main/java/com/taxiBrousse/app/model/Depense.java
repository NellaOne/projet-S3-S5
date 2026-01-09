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
public class Depense {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String codeDepense;
    
    @Column(nullable = false, length = 100)
    private String typeDepense; // CARBURANT, REPARATION, VISITE_TECHNIQUE, SALAIRE, ENTRETIEN, AUTRE
    
    @ManyToOne
    @JoinColumn(name = "vehicule_id")
    private Vehicule vehicule;
    
    @ManyToOne
    @JoinColumn(name = "garage_id")
    private Garage garage;
    
    @ManyToOne
    @JoinColumn(name = "beneficiaire_id")
    private Personne beneficiaire;
    
    @Column(nullable = false)
    private BigDecimal montant;
    
    @Column(nullable = false)
    private LocalDate dateDepense;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private String factureNumero;
    private String factureUrl;
    
    @ManyToOne
    @JoinColumn(name = "approuve_par_id")
    private Personne approuvePar;
    
    @Column(length = 50)
    private String statut = "EN_ATTENTE"; // EN_ATTENTE, APPROUVE, PAYE, REJETE
    
    private LocalDateTime dateCreation = LocalDateTime.now();
    
}
