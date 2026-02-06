#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kubectl delete accesspolicy -n default agent-access-policy user-access-policy
kubectl delete mcpservers -n default server-everything
kubectl delete agent -n default demoagent
kubectl delete authorizationpolicy -n default accesspolicy-agent-access-policy-waypoint accesspolicy-user-access-policy-waypoint mcpserver-server-everything-waypoint
kubectl delete gateway -n default mcpserver-server-everything-waypoint
kubectl delete httproute -n default mcpserver-server-everything-waypoint
kubectl delete gloootrafficpolicy -n default accesspolicy-agent-access-policy-waypoint accesspolicy-user-access-policy-waypoint
sed -i '' 's/action: DENY/action: ALLOW/g' "$SCRIPT_DIR/../resources/access-policies/user-access-policy.yaml"
kubectl label namespaces default istio.io/dataplane-mode-
kubectl rollout restart deployment -n kagent kagent-controller
rm -rf demoagent
