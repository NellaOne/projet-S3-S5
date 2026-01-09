package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ColisRepository extends JpaRepository<Colis, Long> {
    List<Colis> findByVoyageId(Long voyageId);
    List<Colis> findByStatut(String statut);
}
