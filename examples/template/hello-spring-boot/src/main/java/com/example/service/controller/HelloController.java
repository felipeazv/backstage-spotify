package {{packageName}}.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

/**
 * Hello Controller for {{serviceName}}
 * 
 * Provides a simple hello world endpoint for testing and demonstration purposes.
 */
@RestController
@RequestMapping("/api/v1")
@Tag(name = "Hello API", description = "Hello world endpoint for testing")
public class HelloController {

    /**
     * Returns a hello world message
     * 
     * @return ResponseEntity with hello message
     */
    @GetMapping("/hello")
    @Operation(summary = "Get hello message", description = "Returns a simple hello world message")
    public ResponseEntity<String> sayHello() {
        return ResponseEntity.ok("Hello from {{serviceName}}! Service is running with Java {{javaVersion}} and Spring Boot {{springBootVersion}}");
    }
}