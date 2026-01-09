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
}
