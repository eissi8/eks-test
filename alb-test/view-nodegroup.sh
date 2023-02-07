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
	echo "------ $nodegroup ------"
	for asg in $(aws eks describe-nodegroup --cluster-name $CLUSTER_NAME --nodegroup-name $nodegroup --query 'nodegroup.resources.autoScalingGroups[*].name' --output text)
	do
		for instanceid in $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $asg --query 'AutoScalingGroups[*].Instances[*].InstanceId' --output text)                                 	
		do
			privatename=$(aws ec2 describe-instances --instance-ids $instanceid  --query 'Reservations[*].Instances[*].PrivateDnsName' --output text)
			kubectl get pod -o wide --field-selector spec.nodeName=$privatename
		done
	done
	echo "-------"
done

exit 0

