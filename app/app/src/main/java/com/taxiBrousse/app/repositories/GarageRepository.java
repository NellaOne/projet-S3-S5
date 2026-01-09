package com.taxiBrousse.app.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.taxiBrousse.app.model.Garage;

import java.util.List;

@Repository
public interface GarageRepository extends JpaRepository<Garage, Long> {
    List<Garage> findByActifTrue();
    Garage findByNom(String nom);
}
