# ArgoCD GitOps Configuration

This folder contains ArgoCD configuration for auto-discovering and deploying applications via GitOps.

## Architecture

```
backstage-spotify (this repo)
├── argocd/
│   ├── applicationset.yaml    # Auto-discovers apps from JSON configs
│   └── apps/                   # App configuration files
│       └── <app-name>.json     # One JSON per application
│
└── examples/template/
    └── spring-boot-service-template.yaml  # Creates new apps + ArgoCD config
```

## How It Works

### ApplicationSet Auto-Discovery

The `applicationset.yaml` uses ArgoCD's Git generator to:
1. Scan `argocd/apps/*.json` for application configurations
2. Auto-create ArgoCD Applications for each JSON file found
3. Sync changes automatically when JSON files are added/modified

### Application Config Format

Each app needs a JSON file in `argocd/apps/`:

```json
{
  "name": "my-service",
  "repoUrl": "https://github.com/felipeazv/my-service.git",
  "appPath": "k8s",
  "namespace": "apps"
}
```

| Field | Description |
|-------|-------------|
| `name` | Application name (used in ArgoCD UI) |
| `repoUrl` | Git repository containing the app and k8s manifests |
| `appPath` | Path to Kubernetes manifests within the repo |
| `namespace` | Target Kubernetes namespace for deployment |

## Scaffolding New Services

When you scaffold a new Spring Boot service via Backstage:

### Step 1: Use the Template
1. Go to Backstage → Create → Spring Boot Service Template
2. Fill in service details (name, description, namespace)
3. Click Create

### Step 2: What Happens Automatically
1. **New Repo Created**: A new GitHub repo with your service code + `k8s/` folder
2. **PR Created**: A PR is opened to this repo adding `argocd/apps/<your-service>.json`
3. **Catalog Registered**: Service appears in Backstage catalog

### Step 3: Merge the PR
1. Review the auto-generated PR in `backstage-spotify` repo
2. Merge the PR
3. ArgoCD ApplicationSet detects the new JSON file
4. Your service is automatically deployed to minikube!

## Manual Steps (if not using Backstage)

### Adding a New Application Manually

1. Create your app repo with a `k8s/` folder containing Kubernetes manifests
2. Create a JSON config file:
   ```bash
   cat > argocd/apps/my-app.json << 'EOF'
   {
     "name": "my-app",
     "repoUrl": "https://github.com/felipeazv/my-app.git",
     "appPath": "k8s",
     "namespace": "apps"
   }
   EOF
   ```
3. Commit and push:
   ```bash
   git add argocd/apps/my-app.json
   git commit -m "Add ArgoCD config for my-app"
   git push
   ```
4. ArgoCD will auto-discover and deploy within ~3 minutes

### Removing an Application

1. Delete the JSON file:
   ```bash
   git rm argocd/apps/my-app.json
   git commit -m "Remove ArgoCD config for my-app"
   git push
   ```
2. ArgoCD will automatically delete the application and its resources (due to `prune: true`)

## Verification

Check applications in ArgoCD:
```bash
kubectl get applications -n argocd
```

Check ApplicationSet status:
```bash
kubectl describe applicationset backstage-apps -n argocd
```

View in ArgoCD UI:
```bash
kubectl port-forward -n argocd svc/argocd-server 8080:80
# Open http://localhost:8080
```

## Sync Policies

All applications created by the ApplicationSet have:
- **Automated Sync**: Changes in Git are auto-deployed
- **Self-Heal**: Manual changes in cluster are reverted
- **Prune**: Deleted resources in Git are removed from cluster
- **CreateNamespace**: Target namespace is created if missing

## Troubleshooting

### App not appearing in ArgoCD
1. Check if JSON file is valid: `cat argocd/apps/<app>.json | jq .`
2. Verify the repo is accessible: `argocd repo list`
3. Check ApplicationSet logs: `kubectl logs -n argocd -l app.kubernetes.io/name=argocd-applicationset-controller`

### App stuck in OutOfSync
1. Check if `k8s/` path exists in the app repo
2. Verify manifests are valid YAML
3. Check app events: `kubectl describe application <app-name> -n argocd`

