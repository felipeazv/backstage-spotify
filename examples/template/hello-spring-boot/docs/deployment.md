# Deployment Guide

This guide covers various deployment options for the Hello Spring Boot Backstage Service.

## Prerequisites

Before deploying, ensure you have:

- Java 17+ runtime (for JAR deployment)
- Docker (for container deployment)
- Kubernetes cluster (for Kubernetes deployment)
- Maven 3.6+ (for building from source)

## Deployment Options

### 1. JAR Deployment (Simple)

#### Build the Application
```bash
mvn clean package
```

#### Run the Application
```bash
java -jar target/hello-spring-boot-backstage-0.0.1-SNAPSHOT.jar
```

#### Environment Variables
You can override configuration using environment variables:

```bash
export SERVER_PORT=8081
export SPRING_PROFILES_ACTIVE=production
java -jar target/hello-spring-boot-backstage-0.0.1-SNAPSHOT.jar
```

#### Production Considerations
- Use a process manager (systemd, supervisor, etc.)
- Configure proper logging
- Set appropriate JVM options
- Use a reverse proxy (nginx, Apache)

### 2. Docker Deployment

#### Build Docker Image
```bash
docker build -t hello-spring-boot-backstage:latest .
```

#### Run Docker Container
```bash
docker run -d \
  --name hello-spring-boot \
  -p 8080:8080 \
  -e SERVER_PORT=8080 \
  hello-spring-boot-backstage:latest
```

#### Docker Compose
Use the provided `docker-compose.yml`:

```bash
docker-compose up -d
```

#### Docker Environment Variables
```yaml
environment:
  - SERVER_PORT=8080
  - SPRING_PROFILES_ACTIVE=production
  - JAVA_OPTS=-Xmx512m -Xms256m
```

### 3. Kubernetes Deployment

#### Prerequisites
- Kubernetes cluster
- kubectl configured
- Container registry access (for pushing images)

#### Build and Push Image
```bash
# Build image
docker build -t your-registry/hello-spring-boot-backstage:latest .

# Push to registry
docker push your-registry/hello-spring-boot-backstage:latest
```

#### Deploy to Kubernetes
```bash
kubectl apply -f kubernetes.yaml
```

#### Kubernetes Configuration
The provided `kubernetes.yaml` includes:

- **Deployment**: Application pods
- **Service**: Load balancer service
- **ConfigMap**: Application configuration
- **Secret**: Sensitive configuration
- **Ingress**: External access (optional)

#### Customizing Kubernetes Deployment

**Resource Limits**:
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

**Environment Variables**:
```yaml
env:
- name: SERVER_PORT
  value: "8080"
- name: SPRING_PROFILES_ACTIVE
  value: "kubernetes"
```

**Health Checks**:
```yaml
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /actuator/health
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 4. Cloud Platform Deployment

#### AWS (Elastic Beanstalk)
1. Create an Elastic Beanstalk application
2. Upload the JAR file
3. Configure environment variables
4. Deploy

#### Google Cloud Platform
1. Build container image
2. Push to Google Container Registry
3. Deploy to Cloud Run or GKE

#### Azure
1. Create Azure Spring Apps service
2. Deploy JAR or container
3. Configure settings

## Configuration Management

### Application Properties
Configuration is managed through `application.yml`:

```yaml
server:
  port: 8080

spring:
  application:
    name: hello-spring-boot-backstage

logging:
  level:
    root: INFO
    com.example: DEBUG
```

### Environment-Specific Configuration
Create profile-specific files:

- `application-dev.yml` - Development configuration
- `application-prod.yml` - Production configuration
- `application-k8s.yml` - Kubernetes configuration

### External Configuration
Use environment variables or external configuration services:

```bash
# Environment variables
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/mydb
export SPRING_DATASOURCE_USERNAME=myuser
export SPRING_DATASOURCE_PASSWORD=mypassword

# Configuration server
export SPRING_CLOUD_CONFIG_URI=http://config-server:8888
```

## Monitoring and Logging

### Application Monitoring
The application includes Spring Boot Actuator for monitoring:

- **Health**: `/actuator/health`
- **Metrics**: `/actuator/metrics`
- **Info**: `/actuator/info`
- **Environment**: `/actuator/env`

### Log Configuration
Configure logging in `application.yml`:

```yaml
logging:
  level:
    root: INFO
    com.example: DEBUG
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
  file:
    name: logs/application.log
```

### External Monitoring
Integrate with monitoring tools:

- **Prometheus**: For metrics collection
- **Grafana**: For visualization
- **ELK Stack**: For log aggregation
- **Datadog**: For APM

## Security Considerations

### HTTPS Configuration
Enable HTTPS in production:

```yaml
server:
  port: 8443
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: password
    key-store-type: PKCS12
    key-alias: tomcat
```

### Authentication
Implement authentication for production:

```yaml
spring:
  security:
    user:
      name: user
      password: password
```

### Network Security
- Use firewalls
- Implement network policies (Kubernetes)
- Use VPNs for internal communication
- Enable TLS for all communications

## Troubleshooting

### Common Issues

**Port Already in Use**:
```bash
# Find process using port
lsof -i :8080

# Kill process
kill -9 <PID>
```

**Memory Issues**:
```bash
# Increase heap size
export JAVA_OPTS="-Xmx1024m -Xms512m"
```

**Docker Issues**:
```bash
# Check container logs
docker logs <container-id>

# Check container status
docker ps
```

**Kubernetes Issues**:
```bash
# Check pod status
kubectl get pods

# Check pod logs
kubectl logs <pod-name>

# Describe pod for events
kubectl describe pod <pod-name>
```

### Health Check Failures
If health checks fail:

1. Check application logs
2. Verify dependencies are available
3. Check resource limits
4. Review configuration

### Performance Issues
For performance problems:

1. Monitor resource usage
2. Check for memory leaks
3. Optimize database queries
4. Review thread pool configuration

## Backup and Recovery

### Configuration Backup
- Store configuration files in version control
- Backup environment-specific configurations
- Document deployment procedures

### Data Backup
If using databases:
- Implement regular backups
- Test restore procedures
- Consider replication for high availability

## Scaling

### Horizontal Scaling
Scale by adding more instances:

**Kubernetes**:
```bash
kubectl scale deployment hello-spring-boot --replicas=3
```

**Docker Compose**:
```bash
docker-compose up --scale hello-spring-boot=3
```

### Load Balancing
Use load balancers for multiple instances:

- **Kubernetes**: Service with multiple pods
- **Docker**: Docker Swarm or external load balancer
- **Cloud**: Cloud load balancers

### Auto-scaling
Configure auto-scaling based on metrics:

**Kubernetes HPA**:
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hello-spring-boot-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hello-spring-boot
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70