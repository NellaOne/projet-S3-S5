package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TrajetRepository extends JpaRepository<Trajet, Long> {
    List<Trajet> findByActifTrue();
    Trajet findByCode(String code);

    Trajet findByVilleDepartAndVilleArrivee(String villeDepart, String villeArrivee);
    
    @Query("SELECT t FROM Tarif t WHERE t.trajet.id = :trajetId AND t.typeVehicule.id = :typeVehiculeId AND t.actif = true AND t.typeTarif = 'NORMAL'")
    Tarif findTarifByTrajetId(Long trajetId, Long typeVehiculeId);
}
