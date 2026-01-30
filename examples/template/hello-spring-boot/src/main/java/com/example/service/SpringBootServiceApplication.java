package {{packageName}};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main application class for the {{serviceName}} Spring Boot service.
 * 
 * This service provides:
 * - Health check endpoints via Spring Boot Actuator
 * - Hello API endpoint for testing
 * - OpenAPI/Swagger documentation (if enabled)
 * 
 * @author Backstage Template Generator
 * @version {{springBootVersion}}
 */
@SpringBootApplication
public class SpringBootServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootServiceApplication.class, args);
    }
}