package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VoyageRepository extends JpaRepository<Voyage, Long> {
    List<Voyage> findByStatut(String statut);
    List<Voyage> findByDateDepartBetween(LocalDateTime start, LocalDateTime end);
    List<Voyage> findByTrajetId(Long trajetId);
    List<Voyage> findByTrajetIdAndStatut(Long trajetId, String statut);
    
    // ✅ NOUVELLES REQUÊTES POUR LISTES DYNAMIQUES
    
    /**
     * Récupère les dates où il y a des voyages disponibles pour un trajet
     * (pour la 2ème liste déroulante)
     */
    @Query(value = "SELECT DISTINCT CAST(v.date_depart AS DATE)::text " +
           "FROM voyage v " +
           "WHERE v.trajet_id = :trajetId " +
           "AND v.statut = 'PLANIFIE' " +
           "AND v.date_depart > CURRENT_TIMESTAMP", nativeQuery = true)
    List<String> findDatesDisponiblesParTrajet(
        @org.springframework.data.repository.query.Param("trajetId") Long trajetId
    );
    
    /**
     * Récupère les voyages disponibles pour un trajet à une date donnée
     * (pour la 3ème liste déroulante)
     * Utilise CAST pour comparaison de dates
     */
    @Query("SELECT v FROM Voyage v " +
           "WHERE v.trajet.id = :trajetId " +
           "AND CAST(v.dateDepart AS date) = :date " +
           "AND v.statut = 'PLANIFIE' " +
           "ORDER BY v.dateDepart")
    List<Voyage> findVoyagesParTrajetEtDate(
        @org.springframework.data.repository.query.Param("trajetId") Long trajetId,
        @org.springframework.data.repository.query.Param("date") LocalDate date
    );
    
    /**
     * Ancienne requête (à garder pour compatibilité)
     */
    @Query("SELECT v FROM Voyage v WHERE v.statut = 'PLANIFIE' ORDER BY v.dateDepart")
    List<Voyage> findVoyagesDisponibles(); 

    @Query("SELECT v FROM Voyage v JOIN v.trajet t " +
           "WHERE t.villeDepart = :villeDepart " +
           "AND t.villeArrivee = :villeArrivee " +
           "AND CAST(v.dateDepart AS date) = :date " +
           "AND EXTRACT(HOUR FROM v.dateDepart) = :heure " +
           "AND v.statut = 'PLANIFIE'")
    List<Voyage> findVoyagesByVillesAndDateHeure(
        @org.springframework.data.repository.query.Param("villeDepart") String villeDepart,
        @org.springframework.data.repository.query.Param("villeArrivee") String villeArrivee,
        @org.springframework.data.repository.query.Param("date") LocalDate date,
        @org.springframework.data.repository.query.Param("heure") int heure
    );

    List<Voyage> findByTrajet_VilleDepartAndTrajet_VilleArriveeAndDateDepart(
        String villeDepart, String villeArrivee, LocalDateTime dateDepart
    );
}

