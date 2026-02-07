# ArgoCD Applications
This folder contains ArgoCD Application manifests for all apps deployed via GitOps.

## Structure
```
argocd/
├── apps/                    # Individual application manifests
│   ├── hello-spring-boot.yaml
│   └── ...
└── README.md
```

## Usage

### Deploy a single app
```bash
kubectl apply -f argocd/apps/hello-spring-boot.yaml
```

### Deploy all apps
```bash
kubectl apply -f argocd/apps/
```

## Adding a new application
1. Create a new YAML file in `argocd/apps/`
2. Follow the template structure from existing apps
3. The application should point to the app's repo and k8s folder
