#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kubectl delete accesspolicy -n kagent agent-access-policy user-access-policy
kubectl delete mcpservers -n kagent server-everything
kubectl delete agent -n kagent demoagent
kubectl delete authorizationpolicy -n kagent accesspolicy-agent-access-policy-waypoint accesspolicy-user-access-policy-waypoint mcpserver-server-everything-waypoint
kubectl delete gateway -n kagent mcpserver-server-everything-waypoint
kubectl delete httproute -n kagent mcpserver-server-everything-waypoint
kubectl delete gloootrafficpolicy -n kagent accesspolicy-agent-access-policy-waypoint accesspolicy-user-access-policy-waypoint
sed -i '' 's/action: DENY/action: ALLOW/g' "$SCRIPT_DIR/../access-policies/user-access-policy.yaml"
kubectl rollout restart deployment -n kagent kagent-controller
rm -rf demoagent
