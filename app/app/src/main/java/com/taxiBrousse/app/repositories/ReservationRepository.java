package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByClientId(Long clientId);
    List<Reservation> findByVoyageId(Long voyageId);
    List<Reservation> findByStatut(String statut);
    
    // ✅ NOUVELLE : Pour calculer les places réservées EN TEMPS RÉEL
    List<Reservation> findByVoyageIdAndStatutNot(Long voyageId, String statut);
    
    @Query("SELECT SUM(r.montantTotal) FROM Reservation r WHERE r.dateReservation BETWEEN ?1 AND ?2 AND r.statut != 'ANNULE'")
    BigDecimal calculateRecetteByPeriod(LocalDateTime start, LocalDateTime end);
}
