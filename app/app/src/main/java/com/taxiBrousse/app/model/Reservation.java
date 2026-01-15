package com.taxiBrousse.app.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

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
    
    @Column(name = "nombre_places_premium", nullable = false)
    private Integer nombrePlacesPremium = 0;
    
    @Column(name = "nombre_places_standard", nullable = false)
    private Integer nombrePlacesStandard = 0;
    
    @Column(name = "nombre_places", columnDefinition = "BIGINT GENERATED ALWAYS AS (nombre_places_premium + nombre_places_standard) STORED")
    private Integer nombrePlaces;
    
    @Column(name = "montant_total_premium", nullable = false)
    private BigDecimal montantTotalPremium = BigDecimal.ZERO;
    
    @Column(name = "montant_total_standard", nullable = false)
    private BigDecimal montantTotalStandard = BigDecimal.ZERO;
    
    @Generated(GenerationTime.ALWAYS)
    @Column(name = "montant_total", insertable = false, updatable = false)
    private BigDecimal montantTotal;
    
    private BigDecimal montantPaye = BigDecimal.ZERO;
    
    @Generated(GenerationTime.ALWAYS)
    @Column(name = "montant_restant", insertable = false, updatable = false)
    private BigDecimal montantRestant;

    @Column(length = 50)
    private String modeReservation = "SUR_PLACE"; // SUR_PLACE, TELEPHONE, EN_LIGNE
        // Getter/Setter pour montantRestant (si Lombok ne le gère pas à cause du champ généré)
        public BigDecimal getMontantRestant() {
            return montantRestant;
        }
        public void setMontantRestant(BigDecimal montantRestant) {
            this.montantRestant = montantRestant;
        }
    
    @Column(length = 50)
    private String statut = "EN_ATTENTE"; // EN_ATTENTE, CONFIRME, PAYE, ANNULE, TERMINE
    
    private LocalDateTime dateReservation = LocalDateTime.now();
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    private LocalDateTime dateModification = LocalDateTime.now();
    
}
