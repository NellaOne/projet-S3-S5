package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VoyageRepository extends JpaRepository<Voyage, Long> {
    List<Voyage> findByStatut(String statut);
    List<Voyage> findByDateDepartBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT v FROM Voyage v WHERE v.statut = 'PLANIFIE' AND v.nombrePlacesDisponibles > 0 ORDER BY v.dateDepart")
    List<Voyage> findVoyagesDisponibles(); 

    @Query("SELECT v FROM Voyage v JOIN v.trajet t WHERE t.villeDepart = :villeDepart AND t.villeArrivee = :villeArrivee AND DATE(v.dateDepart) = :date AND extract(hour from v.dateDepart) = :heure AND v.statut = 'PLANIFIE' AND v.nombrePlacesDisponibles > 0")
    List<Voyage> findVoyagesByVillesAndDateHeure(@org.springframework.data.repository.query.Param("villeDepart") String villeDepart,
                                                @org.springframework.data.repository.query.Param("villeArrivee") String villeArrivee,
                                                @org.springframework.data.repository.query.Param("date") java.time.LocalDate date,
                                                @org.springframework.data.repository.query.Param("heure") int heure);

    

    // VoyageRepository.java
List<Voyage> findByTrajet_VilleDepartAndTrajet_VilleArriveeAndDateDepart(
    String villeDepart, String villeArrivee, LocalDateTime dateDepart
);
}
