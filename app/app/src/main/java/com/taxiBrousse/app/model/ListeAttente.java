package com.taxiBrousse.app.model;

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
public class ListeAttente {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "trajet_id")
    private Trajet trajet;
    
    @ManyToOne
    @JoinColumn(name = "client_id")
    private Personne client;
    
    @Column(nullable = false)
    private Integer nombrePlacesDemandees;
    
    private LocalDate dateDepartSouhaitee;
    
    @Column(length = 50)
    private String statut = "EN_ATTENTE"; // EN_ATTENTE, NOTIFIE, CONVERTI, ANNULE
    
    private LocalDateTime dateInscription = LocalDateTime.now();
    private LocalDateTime dateNotification;
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
}
