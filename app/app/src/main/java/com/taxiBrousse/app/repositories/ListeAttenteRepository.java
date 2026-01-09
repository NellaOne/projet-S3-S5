package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ListeAttenteRepository extends JpaRepository<ListeAttente, Long> {
    List<ListeAttente> findByStatut(String statut);
    List<ListeAttente> findByTrajetIdAndStatut(Long trajetId, String statut);
}
