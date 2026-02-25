package com.example.service.persistence;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service layer for {@link HelloEntry} operations.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class HelloEntryService {

    private final HelloEntryRepository repository;

    /**
     * Returns all entries from hello_table.
     */
    public List<HelloEntry> findAll() {
        return repository.findAll();
    }
}
