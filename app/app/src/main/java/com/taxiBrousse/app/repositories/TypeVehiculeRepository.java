package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.TypeVehicule;

import java.util.List;

@Repository
public interface TypeVehiculeRepository extends JpaRepository<TypeVehicule, Long> {
    List<TypeVehicule> findByActifTrue();
    TypeVehicule findByNom(String nom);
}
