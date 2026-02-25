package com.example.service.persistence;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * JPA entity mapping to the hello_table created by Flyway migration V1.
 */
@Entity
@Table(name = "hello_table")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HelloEntry {

    @Id
    private Long id;

    @Column(nullable = false, length = 100)
    private String alias;
}
