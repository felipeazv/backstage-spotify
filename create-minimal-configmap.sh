#!/bin/bash

# Create a temporary directory to prepare the source code
TEMP_DIR=$(mktemp -d)
SOURCE_DIR="$TEMP_DIR/app"

# Create the directory structure
mkdir -p "$SOURCE_DIR"
mkdir -p "$SOURCE_DIR/packages/app"
mkdir -p "$SOURCE_DIR/packages/backend"
mkdir -p "$SOURCE_DIR/examples"
mkdir -p "$SOURCE_DIR/examples/template"
mkdir -p "$SOURCE_DIR/examples/users"

# Copy essential files only
cp package.json "$SOURCE_DIR/"
cp yarn.lock "$SOURCE_DIR/" 2>/dev/null || true
cp tsconfig.json "$SOURCE_DIR/" 2>/dev/null || true
cp backstage.json "$SOURCE_DIR/" 2>/dev/null || true

# Copy app package
cp -r packages/app/package.json "$SOURCE_DIR/packages/app/" 2>/dev/null || true
cp -r packages/app/src "$SOURCE_DIR/packages/app/" 2>/dev/null || true
cp -r packages/app/public "$SOURCE_DIR/packages/app/" 2>/dev/null || true

# Copy backend package
cp -r packages/backend/package.json "$SOURCE_DIR/packages/backend/" 2>/dev/null || true
cp -r packages/backend/src "$SOURCE_DIR/packages/backend/" 2>/dev/null || true
cp -r packages/backend/Dockerfile "$SOURCE_DIR/packages/backend/" 2>/dev/null || true

# Copy examples
cp -r examples/entities.yaml "$SOURCE_DIR/examples/" 2>/dev/null || true
cp -r examples/org.yaml "$SOURCE_DIR/examples/" 2>/dev/null || true
cp -r examples/template/template.yaml "$SOURCE_DIR/examples/template/" 2>/dev/null || true
cp -r examples/template/spring-boot-service-template.yaml "$SOURCE_DIR/examples/template/" 2>/dev/null || true
cp -r examples/users/felipe.yaml "$SOURCE_DIR/examples/users/" 2>/dev/null || true

# Create the ConfigMap
kubectl create configmap backstage-source \
  --from-file="$SOURCE_DIR" \
  --namespace=backstage-spotify \
  --dry-run=client -o yaml | kubectl apply -f -

# Clean up
rm -rf "$TEMP_DIR"

echo "ConfigMap 'backstage-source' created successfully in namespace 'backstage-spotify'"