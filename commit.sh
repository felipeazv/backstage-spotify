#!/bin/bash
cd /Users/felipeazevedo/Projects/backstage-k8s/catalog
export PAGER=cat
export GIT_PAGER=cat
git add examples/template/hello-spring-boot/k8s/deployment.yaml examples/template/hello-spring-boot/docker-compose.yml
git commit -m "feat: Add Kubernetes PostgreSQL support with StatefulSet and ConfigMap/Secret

- Add conditional PostgreSQL StatefulSet with 5Gi volume claim
- Create ConfigMap for database connection details
- Create Secret for database password
- Add Headless Service for PostgreSQL StatefulSet
- Add init container to wait for PostgreSQL readiness
- Inject database environment variables from ConfigMap/Secret
- All PostgreSQL resources conditionally created when usePostgres=true"
