#!/usr/bin/env python3

import subprocess
import sys
import os

os.chdir('/Users/felipeazevedo/Projects/backstage-k8s/catalog')

try:
    # Stage files
    subprocess.run(['git', 'add', 
                   'examples/template/hello-spring-boot/k8s/deployment.yaml',
                   'examples/template/hello-spring-boot/docker-compose.yml'],
                   check=True, capture_output=True)
    
    # Create commit
    result = subprocess.run(['git', 'commit', '-m',
                            '''feat: Add Kubernetes PostgreSQL support with StatefulSet and ConfigMap/Secret

- Add conditional PostgreSQL StatefulSet with 5Gi volume claim
- Create ConfigMap for database connection details
- Create Secret for database password
- Add Headless Service for PostgreSQL StatefulSet
- Add init container to wait for PostgreSQL readiness
- Inject database environment variables from ConfigMap/Secret
- All PostgreSQL resources conditionally created when usePostgres=true'''],
                           capture_output=True, text=True)
    
    print("STDOUT:", result.stdout)
    print("STDERR:", result.stderr)
    print("Return code:", result.returncode)
    
    # Show the commit
    result = subprocess.run(['git', 'log', '--oneline', '-1'],
                           capture_output=True, text=True)
    print("\nLatest commit:")
    print(result.stdout)

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
