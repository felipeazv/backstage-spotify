#!/bin/bash
export KUBECONFIG=${KUBECONFIG:-~/.kube/config}
export KUBE_PAGER=cat

cd /Users/felipeazevedo/Projects/backstage-k8s/catalog/tmp-scaffolded-service

echo "Applying k8s manifest..."
kubectl apply -f k8s/deployment.yaml

echo ""
echo "Waiting 30 seconds for resources to initialize..."
sleep 30

echo ""
echo "=== Namespace ==="
kubectl get ns apps

echo ""
echo "=== ConfigMap ==="
kubectl get cm -n apps

echo ""
echo "=== Secret ==="
kubectl get secrets -n apps

echo ""
echo "=== Services ==="
kubectl get svc -n apps

echo ""
echo "=== StatefulSet ==="
kubectl get statefulset -n apps

echo ""
echo "=== Deployments ==="
kubectl get deployment -n apps

echo ""
echo "=== Pods ==="
kubectl get pods -n apps

echo ""
echo "=== Postgres Pod Details ==="
kubectl get pods -n apps -l app=sample-service-postgres -o jsonpath='{.items[0].metadata.name}{"\t"}{.items[0].status.phase}'

echo ""
echo "=== Sample Service Pod Details ==="
kubectl get pods -n apps -l app=sample-service -o jsonpath='{.items[0].metadata.name}{"\t"}{.items[0].status.phase}'

echo ""
echo "Deploy complete. Use: kubectl port-forward -n apps svc/sample-service 7007:8080"
