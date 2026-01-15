package com.taxiBrousse.app.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "audit_log")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuditLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_audit_log")
    private Long id;

    @Column(name = "table_name", nullable = false, length = 100)
    private String tableName;

    @Column(name = "record_id", nullable = false)
    private Long recordId;

    @Column(nullable = false, length = 50)
    private String action; // INSERT, UPDATE, DELETE

    @Column(name = "utilisateur_id")
    private Long utilisateurId;

    @Column(columnDefinition = "TEXT")
    private String anciennes_valeurs;

    @Column(columnDefinition = "TEXT")
    private String nouvelles_valeurs;

    @Column(name = "date_action", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime dateAction = LocalDateTime.now();
}
