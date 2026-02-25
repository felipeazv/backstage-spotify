# Spring Boot Service

A modern Spring Boot service template with comprehensive features.

## Features

- **Spring Boot 3.4.2** with Java 21
- **REST API** with hello endpoint
- **Health Checks** via Spring Boot Actuator
- **API Documentation** via Swagger UI
- **Docker Support** with multi-stage builds
- **Optional PostgreSQL** integration with persistent data storage
- **Flyway Migrations** for automated database schema management
- **Pre-seeded Sample Data** with adjective-noun pairs when PostgreSQL is enabled

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
- **Hello Entries** (PostgreSQL only): `GET /api/v1/entries` - Returns all seeded entries from the hello_table

## PostgreSQL Integration (Optional)

When the **PostgreSQL** option is enabled during template scaffolding, the service includes:

### Database Configuration

The service connects to PostgreSQL with these environment variables (defaults shown):

```bash
DB_HOST=localhost          # PostgreSQL host
DB_PORT=5432              # PostgreSQL port
DB_NAME=service_db        # Database name
DB_USER=postgres          # Database user
DB_PASSWORD=postgres      # Database password
```

### Flyway Migrations

Database schema and initial data are managed through Flyway migrations located in `src/main/resources/db/migration/`:

- `V1__create_hello_table.sql` - Creates the `hello_table` and seeds 10 adjective-noun entries

#### Pre-seeded Sample Data

When PostgreSQL is enabled, the following data is automatically inserted:

| ID  | Alias                |
|-----|---------------------|
| 1   | persuasive-donkey  |
| 2   | hopeful-stair      |
| 3   | curious-mountain   |
| 4   | brave-lantern      |
| 5   | gentle-river       |
| 6   | witty-compass      |
| 7   | radiant-pebble     |
| 8   | daring-feather     |
| 9   | serene-anchor      |
| 10  | vivid-horizon      |

### Running with PostgreSQL

#### Using Docker Compose

```bash
docker-compose up
```

This will start both PostgreSQL and the Spring Boot service. Flyway will automatically run migrations on startup.

#### Manual Setup

1. Start PostgreSQL:
   ```bash
   docker run -d --name postgres \
     -e POSTGRES_DB=service_db \
     -e POSTGRES_PASSWORD=postgres \
     -p 5432:5432 \
     postgres:15
   ```

2. Run the application:
   ```bash
   mvn spring-boot:run
   ```

3. Access the entries endpoint:
   ```bash
   curl http://localhost:8080/api/v1/entries
   ```

### Database Persistence

With PostgreSQL enabled, all data persists across container restarts. Flyway ensures schema consistency and migrations are idempotent and safe to re-run.

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
