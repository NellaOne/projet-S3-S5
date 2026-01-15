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
public class Paiement {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paiement")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String codePaiement;
    
    @Column(nullable = false, length = 50)
    private String typePaiement; // RESERVATION, COLIS, AUTRE
    
    @Column(nullable = false)
    private Long referenceId;
    
    @Column(nullable = false)
    private BigDecimal montant;
    
    @Column(nullable = false, length = 50)
    private String modePaiement; // ESPECE, MOBILE_MONEY, CARTE, VIREMENT
    
    private String momentPaiement; // RESERVATION, DEPART, ARRIVEE
    
    private LocalDateTime datePaiement = LocalDateTime.now();
    
    private String referenceTransaction;
    
    @ManyToOne
    @JoinColumn(name = "recu_par_id")
    private Personne recuPar;
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
}
