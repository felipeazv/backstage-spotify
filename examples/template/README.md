# Backstage Templates

This directory contains Scaffolder templates for quickly generating new services and applications in your Backstage catalog.

## Available Templates

### Spring Boot Service Template

**File**: `spring-boot-service-template.yaml`

A comprehensive template for scaffolding modern Spring Boot microservices with optional PostgreSQL persistence layer.

#### Template Parameters

When scaffolding a service using this template, you'll be prompted for:

- **Service Name** - The name of your Spring Boot service
- **Service Description** - A brief description of what the service does
- **Package Name** - The Java package name (e.g., com.company.service)
- **Java Version** - Choose between Java 17 or 21 (default: 21)
- **Spring Boot Version** - Choose between 3.2.0 or 3.4.2 (default: 3.4.2)
- **Repository URL** - GitHub repository URL for the generated code
- **Kubernetes Namespace** - Target Kubernetes namespace (default: apps)
- **Use PostgreSQL** - Enable PostgreSQL with Flyway migrations and pre-seeded sample data (default: false)

#### Features

**Core Features** (always included):
- Spring Boot with Java 21 (or 17)
- REST API endpoints with Swagger documentation
- Spring Boot Actuator for health checks and metrics
- Docker support with multi-stage builds
- Kubernetes deployment manifests
- ArgoCD integration

**PostgreSQL Features** (when enabled):
- PostgreSQL database driver integration
- Spring Data JPA for ORM
- Flyway database migrations
- Pre-seeded hello_table with 10 adjective-noun entry pairs
- REST endpoint to retrieve seeded entries
- Database connection configuration via environment variables

#### Generated Project Structure

```
service-name/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/service/
│   │   │       ├── controller/         (if PostgreSQL: HelloEntryController)
│   │   │       ├── persistence/        (if PostgreSQL: JPA entities, repositories)
│   │   │       └── config/
│   │   └── resources/
│   │       ├── application.yml          (includes DB config if PostgreSQL enabled)
│   │       └── db/migration/            (if PostgreSQL: Flyway migrations)
│   └── test/
├── k8s/                               (Kubernetes manifests)
├── docs/                              (Documentation)
├── Dockerfile
├── docker-compose.yml
├── pom.xml                            (Maven build with conditional dependencies)
├── catalog-info.yaml
└── README.md
```

#### Generated Files Overview

**pom.xml**
- Conditionally includes PostgreSQL driver, Spring Data JPA, and Flyway dependencies when PostgreSQL is enabled
- Base Spring Boot starter dependencies always included

**application.yml**
- Conditional PostgreSQL datasource configuration with environment variable overrides
- Flyway configuration pointing to `db/migration` directory
- Logging and actuator settings

**Flyway Migrations** (PostgreSQL only)
- `V1__create_hello_table.sql` - Creates hello_table and inserts 10 sample entries

**REST Controllers**
- Basic hello endpoint (always included)
- `GET /api/v1/entries` endpoint to list hello_table entries (PostgreSQL only)
- Full Swagger/OpenAPI documentation

#### Usage Example

1. Open your Backstage instance
2. Navigate to **Create** → **Choose a template**
3. Select **Spring Boot Service Template**
4. Fill in the required parameters:
   - Service Name: `my-service`
   - Description: `My awesome microservice`
   - Repository: `https://github.com/myorg/my-service`
   - **Toggle "Use PostgreSQL" ON** to enable database features
5. Review generated code in the new repository
6. The service is automatically registered in your Backstage catalog

#### Testing PostgreSQL Template

After scaffolding with PostgreSQL enabled:

```bash
cd my-service

# Start PostgreSQL and the service
docker-compose up

# In another terminal, verify the service is running
curl http://localhost:8080/api/v1/entries

# Expected response (JSON array of seeded entries):
[
  {"id": 1, "alias": "persuasive-donkey"},
  {"id": 2, "alias": "hopeful-stair"},
  ...
  {"id": 10, "alias": "vivid-horizon"}
]
```

#### Customizing Generated Services

After scaffolding, you can customize the generated service by:

- Adding new Flyway migration files (e.g., `V2__add_new_table.sql`) to `src/main/resources/db/migration/`
- Creating additional REST endpoints in the controller package
- Modifying database entities in the persistence package
- Updating the Dockerfile and Kubernetes manifests for your deployment needs

#### Template Customization

To modify the template itself:

1. Edit `spring-boot-service-template.yaml` to change parameters or steps
2. Modify files in `hello-spring-boot/` directory (the content source)
3. Update conditional sections (between `{%- if values.usePostgres %}` markers) for PostgreSQL-specific content
4. Commit and test with Backstage scaffolder

---

## Other Templates

### Node.js Template
**File**: `nodejs-template.yaml`

A basic Node.js service template.

### Example Templates
**File**: `template.yaml`

Additional example templates for reference.
