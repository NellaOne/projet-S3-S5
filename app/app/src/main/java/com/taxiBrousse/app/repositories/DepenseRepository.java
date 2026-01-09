package com.taxiBrousse.app.repositories;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface DepenseRepository extends JpaRepository<Depense, Long> {
    List<Depense> findByTypeDepense(String type);
    List<Depense> findByDateDepenseBetween(LocalDate start, LocalDate end);
    
    @Query("SELECT SUM(d.montant) FROM Depense d WHERE d.dateDepense BETWEEN ?1 AND ?2 AND d.statut = 'PAYE'")
    BigDecimal calculateTotalDepensesByPeriod(LocalDate start, LocalDate end);
}
