package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TarifRepository extends JpaRepository<Tarif, Long> {
    List<Tarif> findByTrajetIdAndActifTrue(Long trajetId);
}
