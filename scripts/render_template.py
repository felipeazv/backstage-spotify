#!/usr/bin/env python3
import os
import shutil
import re
from pathlib import Path

SRC = Path('examples/template/hello-spring-boot')
OUT = Path('tmp-scaffolded-service')

values = {
    'name': 'sample-service',
    'namespace': 'apps',
    'repoOwner': 'me',
    'repoName': 'sample-service',
    'javaVersion': '21',
    'version': '3.4.2',
    'package': 'com.example.service',
    'usePostgres': True,
}

if OUT.exists():
    shutil.rmtree(OUT)
shutil.copytree(SRC, OUT)

# Process files in-place under OUT
if_pattern = re.compile(r"\{%-?\s*if\s+values\.usePostgres\s*-?%\}", re.MULTILINE)
endif_pattern = re.compile(r"\{%-?\s*endif\s*-?%\}", re.MULTILINE)
var_pattern = re.compile(r"\$\{\{\s*values\.([a-zA-Z0-9_]+)\s*\}\}")

for path in OUT.rglob('*'):
    if path.is_file():
        text = path.read_text()
        # Handle simple if/endif blocks for usePostgres
        out = ''
        i = 0
        while True:
            m = if_pattern.search(text, i)
            if not m:
                out += text[i:]
                break
            start = m.start()
            out += text[i:start]
            # find endif
            n = endif_pattern.search(text, m.end())
            if not n:
                # malformed template; include rest
                block = text[m.end():]
                include = block if values['usePostgres'] else ''
                out += include
                i = len(text)
                break
            block = text[m.end():n.start()]
            if values['usePostgres']:
                out += block
            # advance
            i = n.end()
        # replace variables
        def var_repl(m):
            k = m.group(1)
            return str(values.get(k, m.group(0)))
        out = var_pattern.sub(var_repl, out)
        path.write_text(out)

# Run checks
checks = []
# pom.xml contains postgresql dependency when usePostgres True
pom = OUT / 'pom.xml'
checks.append(('pom has postgresql', pom.exists() and 'postgresql' in pom.read_text()))
# application.yml contains datasource
appy = OUT / 'src' / 'main' / 'resources' / 'application.yml'
checks.append(('application.yml has datasource', appy.exists() and 'datasource' in appy.read_text()))
# migration file exists
mig = OUT / 'src' / 'main' / 'resources' / 'db' / 'migration' / 'V1__create_hello_table.sql'
checks.append(('migration present', mig.exists()))
# k8s deployment contains StatefulSet or postgres
k8s = OUT / 'k8s' / 'deployment.yaml'
checks.append(('k8s has postgres', k8s.exists() and 'postgres' in k8s.read_text()))
# docker-compose contains postgres
dc = OUT / 'docker-compose.yml'
checks.append(('docker-compose has postgres', dc.exists() and 'postgres' in dc.read_text()))

ok = True
for name, passed in checks:
    print(f"{name}: {'OK' if passed else 'MISSING'}")
    if not passed:
        ok = False

if not ok:
    print('\nRendered output is at', OUT.resolve())
    exit(2)
else:
    print('\nAll checks passed. Rendered output at', OUT.resolve())
    exit(0)
