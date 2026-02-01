# Hello Spring Boot Backstage Service

A Spring Boot service scaffolded from Backstage template, providing a simple REST API for demonstration purposes.

## Overview

This service is a basic Spring Boot application that demonstrates how to create a microservice using Backstage templates. It includes:

- REST API endpoints
- Configuration management
- Docker containerization
- Health checks
- Basic monitoring

## Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Docker (optional, for containerization)

### Running Locally

1. Clone the repository
2. Build the application:
   ```bash
   mvn clean package
   ```
3. Run the application:
   ```bash
   java -jar target/hello-spring-boot-backstage-0.0.1-SNAPSHOT.jar
   ```
4. Access the API at `http://localhost:8080`

### Using Docker

1. Build the Docker image:
   ```bash
   docker build -t hello-spring-boot-backstage .
   ```
2. Run the container:
   ```bash
   docker run -p 8080:8080 hello-spring-boot-backstage
   ```

## API Endpoints

### Health Check
- **GET** `/actuator/health`
- Returns application health status

### Hello Endpoint
- **GET** `/hello`
- Returns a simple greeting message
- **Response**: `{"message":"Hello from Spring Boot!"}`

### Hello with Name
- **GET** `/hello/{name}`
- Returns a personalized greeting
- **Response**: `{"message":"Hello, {name}!"}`

## Configuration

The application uses Spring Boot's configuration system. Key configuration options:

- **Server Port**: `server.port` (default: 8080)
- **Application Name**: `spring.application.name`
- **Logging Level**: `logging.level.root`

Configuration files are located in `src/main/resources/application.yml`.

## Architecture

This service follows standard Spring Boot patterns:

- **Controller Layer**: Handles HTTP requests
- **Service Layer**: Business logic (currently minimal)
- **Configuration**: Spring Boot configuration
- **Actuator**: Health checks and monitoring

## Development

### Adding New Endpoints

1. Create a new controller class in `com.example.service.controller`
2. Add `@RestController` annotation
3. Define your endpoints using `@GetMapping`, `@PostMapping`, etc.

### Testing

Run tests with:
```bash
mvn test
```

### Code Style

The project follows standard Java and Spring Boot conventions. Use:
- Proper package structure
- Meaningful class and method names
- Appropriate use of annotations
- Consistent formatting

## Deployment

### Kubernetes

Use the provided `kubernetes.yaml` for Kubernetes deployment:

```bash
kubectl apply -f kubernetes.yaml
```

### Docker Compose

Use the provided `docker-compose.yml` for local development with dependencies:

```bash
docker-compose up
```

## Monitoring

The application includes Spring Boot Actuator for monitoring:

- **Health**: `/actuator/health`
- **Metrics**: `/actuator/metrics`
- **Info**: `/actuator/info`
- **Environment**: `/actuator/env`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for your changes
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions:
- Check the [API documentation](api.md)
- Review the [deployment guide](deployment.md)
- Create an issue in the repository