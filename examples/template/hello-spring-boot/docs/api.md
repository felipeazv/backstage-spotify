# API Documentation

This document describes the REST API endpoints provided by the Hello Spring Boot Backstage Service.

## Base URL

```
http://localhost:8080
```

## Endpoints

### Health Check

#### Get Application Health
```http
GET /actuator/health
```

**Description**: Returns the health status of the application and its dependencies.

**Response**:
```json
{
  "status": "UP",
  "components": {
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 999999999,
        "free": 999999999,
        "threshold": 10485760
      }
    },
    "ping": {
      "status": "UP"
    }
  }
}
```

**Status Codes**:
- `200` - Application is healthy
- `503` - Application is unhealthy

---

### Hello Service

#### Get Hello Message
```http
GET /hello
```

**Description**: Returns a simple greeting message.

**Response**:
```json
{
  "message": "Hello from Spring Boot!"
}
```

**Status Codes**:
- `200` - Success

**Example Request**:
```bash
curl http://localhost:8080/hello
```

**Example Response**:
```json
{
  "message": "Hello from Spring Boot!"
}
```

---

#### Get Personalized Hello Message
```http
GET /hello/{name}
```

**Description**: Returns a personalized greeting message.

**Path Parameters**:
- `name` (string, required): The name to include in the greeting

**Response**:
```json
{
  "message": "Hello, {name}!"
}
```

**Status Codes**:
- `200` - Success
- `400` - Invalid name parameter

**Example Request**:
```bash
curl http://localhost:8080/hello/World
```

**Example Response**:
```json
{
  "message": "Hello, World!"
}
```

---

### Spring Boot Actuator Endpoints

#### Get Application Info
```http
GET /actuator/info
```

**Description**: Returns application information.

**Response**:
```json
{
  "app": {
    "name": "hello-spring-boot-backstage",
    "version": "0.0.1-SNAPSHOT",
    "description": "A Spring Boot service scaffolded from Backstage template"
  }
}
```

#### Get Metrics
```http
GET /actuator/metrics
```

**Description**: Returns available metrics.

**Response**:
```json
{
  "names": [
    "jvm.memory.max",
    "jvm.threads.states",
    "process.files.max",
    "jvm.gc.memory.promoted",
    "tomcat.cache.access",
    "system.load.average.1m",
    "jvm.memory.used",
    "jvm.gc.max.data.size",
    "jvm.memory.committed",
    "system.cpu.count",
    "logback.events",
    "tomcat.threads.config.max",
    "process.uptime",
    "jvm.gc.pause",
    "tomcat.threads.current",
    "jvm.threads.daemon",
    "system.cpu.usage",
    "jvm.gc.memory.allocated",
    "tomcat.servlet.error",
    "process.cpu.usage",
    "tomcat.threads.busy",
    "tomcat.global.request.max",
    "tomcat.global.sent",
    "jvm.buffer.memory.used",
    "tomcat.global.request",
    "tomcat.sessions.created",
    "jvm.threads.live",
    "jvm.threads.peak",
    "tomcat.global.received",
    "tomcat.sessions.expired",
    "jvm.classes.loaded",
    "tomcat.threads.max",
    "jvm.gc.live.data.size",
    "tomcat.global.error",
    "jvm.buffer.count",
    "jvm.classes.unloaded",
    "tomcat.sessions.rejected",
    "process.files.open",
    "jvm.gc.heap.usage",
    "jvm.gc.heap.used",
    "jvm.buffer.total.capacity",
    "tomcat.sessions.active.current",
    "tomcat.sessions.alive.max",
    "jvm.gc.heap.committed"
  ]
}
```

#### Get Specific Metric
```http
GET /actuator/metrics/{metric-name}
```

**Description**: Returns specific metric data.

**Path Parameters**:
- `metric-name` (string, required): The name of the metric to retrieve

**Example Request**:
```bash
curl http://localhost:8080/actuator/metrics/jvm.memory.used
```

**Example Response**:
```json
{
  "name": "jvm.memory.used",
  "description": "The amount of used memory",
  "baseUnit": "bytes",
  "measurements": [
    {
      "statistic": "VALUE",
      "value": 123456789
    }
  ],
  "availableTags": [
    {
      "tag": "area",
      "values": [
        "heap",
        "nonheap"
      ]
    },
    {
      "tag": "id",
      "values": [
        "Compressed Class Space",
        "PS Survivor Space",
        "PS Old Gen",
        "Metaspace",
        "PS Eden Space",
        "Code Cache"
      ]
    }
  ]
}
```

## Error Handling

### Error Response Format

When an error occurs, the API returns a standardized error response:

```json
{
  "timestamp": "2023-01-01T12:00:00.000+00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Invalid request parameter",
  "path": "/hello/invalid-name"
}
```

### Common Error Codes

- `400` - Bad Request: Invalid input parameters
- `404` - Not Found: Resource not found
- `500` - Internal Server Error: Unexpected server error
- `503` - Service Unavailable: Service is temporarily unavailable

## Rate Limiting

The API does not implement rate limiting for development purposes. In production, consider implementing rate limiting based on your requirements.

## Security

This is a development service and does not implement authentication or authorization. For production use, implement appropriate security measures such as:

- HTTPS/TLS encryption
- Authentication (OAuth2, JWT, etc.)
- Authorization and access control
- Input validation and sanitization

## CORS

Cross-Origin Resource Sharing (CORS) is configured to allow requests from any origin during development. Update the CORS configuration for production use.