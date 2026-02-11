# Backstage Developer Portal

A fully-featured [Backstage](https://backstage.io) developer portal running on Kubernetes with GitOps-based service scaffolding.

## Features

- **Service Scaffolding**: Create new Spring Boot microservices with a single click
- **GitOps Integration**: Automatic ArgoCD application creation for each scaffolded service
- **CI/CD Pipeline**: GitHub Actions workflow for multi-arch Docker builds (amd64 + arm64)
- **Container Registry**: Automatic push to GitHub Container Registry (ghcr.io)
- **Kubernetes Deployment**: Services auto-deploy to minikube via ArgoCD
- **Software Catalog**: Track all your services, APIs, and documentation in one place
- **TechDocs**: Integrated documentation with MkDocs

## Architecture

```
┌─────────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Backstage     │────▶│   GitHub     │────▶│ GitHub Actions  │
│   (Scaffolder)  │     │   (Repo)     │     │ (CI/CD Build)   │
└─────────────────┘     └──────────────┘     └─────────────────┘
                                                      │
                                                      ▼
┌─────────────────┐     ┌──────────────┐     ┌─────────────────┐
│   ArgoCD        │◀────│   ghcr.io    │◀────│  Docker Image   │
│   (GitOps)      │     │  (Registry)  │     │  (Multi-arch)   │
└─────────────────┘     └──────────────┘     └─────────────────┘
        │
        ▼
┌─────────────────┐
│   Kubernetes    │
│   (minikube)    │
└─────────────────┘
```

## Quick Start

### Prerequisites

- [minikube](https://minikube.sigs.k8s.io/) running locally
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configured
- [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) installed
- [GitHub Personal Access Token](https://github.com/settings/tokens) with `repo`, `workflow`, `delete_repo` scopes

### Start the Infrastructure

```bash
# Start minikube
minikube start

# Deploy ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port-forward ArgoCD
kubectl port-forward -n argocd svc/argocd-server 8080:80 &

# Deploy Backstage (via ArgoCD)
argocd app sync backstage-spotify
```

### Access the Applications

| Application | URL | Credentials |
|-------------|-----|-------------|
| Backstage | http://localhost:7007 | GitHub/Google OAuth |
| ArgoCD | https://localhost:8080 | admin / (see above) |

```bash
# Port-forward Backstage
kubectl port-forward -n backstage svc/backstage 7007:7007 &
```

## Creating a New Service

1. Open Backstage at http://localhost:7007
2. Navigate to **Create** → **Spring Boot Service Template**
3. Fill in the service details:
   - **Name**: Your service name (e.g., `my-service`)
   - **Namespace**: Kubernetes namespace (default: `apps`)
   - **Description**: Service description
   - **Java Version**: 17 or 21
   - **Spring Boot Version**: 3.4.x
4. Click **Create**

### What Happens Automatically

1. **GitHub Repository Created**: With Spring Boot project structure
2. **GitHub Actions Triggered**: Builds multi-arch Docker image
3. **Image Pushed to ghcr.io**: Available as `ghcr.io/felipeazv/<service-name>:latest`
4. **ArgoCD PR Created**: Adds service to GitOps management
5. **Service Deployed**: ArgoCD syncs and deploys to Kubernetes

## Project Structure

```
catalog/
├── app-config.yaml              # Backstage configuration
├── app-config.production.yaml   # Production overrides
├── kubernetes-backstage-minikube.yaml  # K8s deployment manifest
├── argocd/
│   ├── applicationset.yaml      # ArgoCD ApplicationSet for auto-discovery
│   └── apps/                    # Service application configs
├── examples/
│   ├── template/
│   │   ├── spring-boot-service-template.yaml  # Scaffolder template definition
│   │   └── hello-spring-boot/   # Template skeleton
│   │       ├── .github/workflows/build.yaml   # CI/CD workflow
│   │       ├── k8s/
│   │       │   ├── deployment.yaml            # K8s manifests
│   │       │   └── ghcr-secret.yaml           # Registry auth
│   │       ├── src/                           # Java source
│   │       ├── Dockerfile
│   │       └── pom.xml
│   └── entities.yaml            # Example catalog entities
└── packages/
    ├── app/                     # Backstage frontend
    └── backend/                 # Backstage backend
        └── Dockerfile           # Backstage Docker image
```

## Service Template Features

The Spring Boot template includes:

- **Spring Boot 3.4.x** with Java 17/21
- **Spring Actuator** for health checks (`/actuator/health`)
- **OpenAPI/Swagger** documentation
- **Docker multi-stage build** for small images
- **Multi-architecture support** (amd64 + arm64 for M1/M2 Macs)
- **Kubernetes manifests** with readiness/liveness probes
- **GitHub Actions CI/CD** with automatic ghcr.io push
- **TechDocs** integration with MkDocs

## Development

### Local Development

```bash
# Install dependencies
yarn install

# Start Backstage locally
yarn start

# Build backend for Docker
yarn build:backend
```

### Rebuild Backstage Docker Image

```bash
# Build for minikube
eval $(minikube docker-env)
yarn build:backend
DOCKER_BUILDKIT=1 docker build --no-cache -t backstage:v5 -f packages/backend/Dockerfile .

# Update deployment
kubectl set image deployment/backstage backstage=backstage:v5 -n backstage
```

### Verify Services

```bash
# List all services in apps namespace
kubectl get pods -n apps

# Check service health
kubectl exec -n apps deploy/<service-name> -- wget -qO- http://localhost:8080/actuator/health

# Port-forward a service
kubectl port-forward -n apps svc/<service-name> 8080:8080

# Check ArgoCD sync status
argocd app list
```

## Troubleshooting

### Service not deploying

1. Check GitHub Actions build: `gh run list --repo felipeazv/<service-name>`
2. Check ArgoCD sync: `argocd app get <service-name>`
3. Check pod status: `kubectl describe pod -n apps -l app=<service-name>`

### Image pull errors

```bash
# Verify ghcr-secret exists
kubectl get secret ghcr-secret -n apps

# Check image exists
docker pull ghcr.io/felipeazv/<service-name>:latest
```

### Backstage template issues

```bash
# Verify template in running pod
kubectl exec -n backstage deploy/backstage -- ls /app/examples/template/hello-spring-boot/

# Check Backstage logs
kubectl logs -n backstage deploy/backstage --tail=100
```

## Configuration

### GitHub Integration

Update `app-config.yaml`:

```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

### Update GitHub Token

```bash
kubectl patch secret backstage-secrets -n backstage \
  -p='{"stringData":{"GITHUB_TOKEN":"ghp_your_new_token"}}'
kubectl rollout restart deployment/backstage -n backstage
```

## License

Apache 2.0
