package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PersonneRepository extends JpaRepository<Personne, Long> {
    List<Personne> findByTypePersonneAndActifTrue(String type);
    Personne findByCin(String cin);
    List<Personne> findByTypePersonneAndStatut(String type, String statut);
}
