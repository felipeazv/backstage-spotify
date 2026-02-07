#!/bin/bash

# Create a temporary directory to prepare the source code
TEMP_DIR=$(mktemp -d)
SOURCE_DIR="$TEMP_DIR/app"

# Copy the entire project structure
cp -r . "$SOURCE_DIR"

# Remove unnecessary files and directories
rm -rf "$SOURCE_DIR/.git"
rm -rf "$SOURCE_DIR/node_modules"
rm -rf "$SOURCE_DIR/target"
rm -rf "$SOURCE_DIR/e2e-test-report"
rm -rf "$SOURCE_DIR/.idea"
rm -rf "$SOURCE_DIR/.vscode"
rm -rf "$SOURCE_DIR/.DS_Store"
rm -rf "$SOURCE_DIR/*.log"
rm -rf "$SOURCE_DIR/*.tmp"

# Create the ConfigMap
kubectl create configmap backstage-source \
  --from-file="$SOURCE_DIR" \
  --namespace=backstage-spotify \
  --dry-run=client -o yaml | kubectl apply -f -

# Clean up
rm -rf "$TEMP_DIR"

echo "ConfigMap 'backstage-source' created successfully in namespace 'backstage-spotify'"