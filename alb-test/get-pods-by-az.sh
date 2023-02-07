#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CURRENT_CONTEXT=$(kubectl config current-context)
REGION=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$CURRENT_CONTEXT\")].context.cluster}" | cut -d : -f 4)

for az in a b c d
do
  AZ=$REGION$az
  echo -n "------"
  echo -n -e "${GREEN}$AZ${NC}"
  echo "------"
  for node in $(kubectl get nodes -l topology.kubernetes.io/zone=$AZ --no-headers | grep -v NotReady | cut -d " " -f1)
  do
    if [[ "$node" == *"fargate"* ]];
    then
      continue
    fi
    echo -e "  ${RED}$node:${NC}"
    kubectl get pods --no-headers --field-selector spec.nodeName=${node} 2>&1 | while read line; do echo "       ${line}"; done
  done
  echo ""
done
