package {{ values.package }}.controller;

import {{ values.package }}.persistence.HelloEntry;
import {{ values.package }}.persistence.HelloEntryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * REST controller exposing the hello_table entries.
 */
@RestController
@RequestMapping("/api/v1/entries")
@RequiredArgsConstructor
@Tag(name = "Hello Entries API", description = "Endpoints for reading hello_table entries seeded by Flyway")
public class HelloEntryController {

    private final HelloEntryService service;

    /**
     * Returns all hello_table entries.
     *
     * @return list of {@link HelloEntry}
     */
    @GetMapping
    @Operation(summary = "List all hello entries", description = "Returns all rows from hello_table")
    public ResponseEntity<List<HelloEntry>> listAll() {
        return ResponseEntity.ok(service.findAll());
    }
}
