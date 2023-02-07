#!/bin/bash
#

NO_NODE=$1

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CURRENT_CONTEXT=$(kubectl config current-context)
CLUSTER_NAME=$(echo $CURRENT_CONTEXT|cut -d "/" -f 2)
REGION=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$CURRENT_CONTEXT\")].context.cluster}" | cut -d : -f 4)

for nodegroup in $(aws eks list-nodegroups --cluster-name $CLUSTER_NAME  --query 'nodegroups[*]' --output text)
do
	echo "Setting the node number: $NO_NODE in nodegroup: $nodegroup"
	aws eks update-nodegroup-config --nodegroup-name $nodegroup --cluster-name $CLUSTER_NAME --scaling-config desiredSize=$NO_NODE

done

exit 0

