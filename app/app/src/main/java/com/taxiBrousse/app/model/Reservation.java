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
public class Reservation {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reservation")
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    private String codeReservation;
    
    @ManyToOne
    @JoinColumn(name = "voyage_id")
    private Voyage voyage;
    
    @ManyToOne
    @JoinColumn(name = "client_id")
    private Personne client;
    
    @Column(nullable = false)
    private Integer nombrePlaces = 1;
    
    @Column(nullable = false)
    private BigDecimal montantTotal;
    
    private BigDecimal montantPaye = BigDecimal.ZERO;
    private BigDecimal montantRestant;
    
    @Column(length = 50)
    private String modeReservation = "SUR_PLACE"; // SUR_PLACE, TELEPHONE, EN_LIGNE
    
    @Column(length = 50)
    private String statut = "EN_ATTENTE"; // EN_ATTENTE, CONFIRME, PAYE, ANNULE, TERMINE
    
    private LocalDateTime dateReservation = LocalDateTime.now();
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    private LocalDateTime dateModification = LocalDateTime.now();
    
}
