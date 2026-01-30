# Spring Boot Service

A modern Spring Boot service template with comprehensive features.

## Features

- **Spring Boot 3.4.2** with Java 21
- **REST API** with hello endpoint
- **Health Checks** via Spring Boot Actuator
- **API Documentation** via Swagger UI
- **Docker Support** with multi-stage builds

## Quick Start

### Prerequisites

- Java 21
- Maven 3.6+
- Docker (optional)

### Running Locally

1. Clone the repository
2. Build the application:
   ```bash
   mvn clean package
   ```
3. Run the application:
   ```bash
   java -jar target/spring-boot-service-0.0.1-SNAPSHOT.jar
   ```

### API Endpoints

- **Hello World**: `GET /api/v1/hello`
- **Health Check**: `GET /actuator/health`
- **API Documentation**: `GET /swagger-ui.html`

### Docker

Build and run with Docker:

```bash
docker build -t spring-boot-service .
docker run -p 8080:8080 spring-boot-service:latest
```

Or use Docker Compose:

```bash
docker-compose up
```

## Configuration

The application can be configured via `application.yml` or environment variables.

## Development

### Code Style

This project uses Lombok to reduce boilerplate code. Make sure your IDE has Lombok support enabled.

### Testing

Run tests with:
```bash
mvn test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for your changes
5. Submit a pull request

## License

This project is licensed under the MIT License.
