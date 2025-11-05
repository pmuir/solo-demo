#!/bin/bash

########################
# include the magic
########################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/demo-magic.sh"

# Override command color to remove bold
DEMO_CMD_COLOR="\033[0;37m"  # Non-bold white

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

# Source environment variables and export them
set -o allexport
source "$SCRIPT_DIR/../resources/.env.production"
set +o allexport

# hide the evidence
clear

# Put your stuff here
magic_prompt

pe "kagent init adk python demoagent --model-name gpt-4 --model-provider OpenAI"

pei "cd demoagent"

pe "kagent build ."

pe "kagent run"

pei "cp ../resources/.env.production ."

pe "kagent deploy . --env-file .env.production --namespace kagent --image pmuir/demoagent:11 --platform linux/amd64,linux/arm64"

pe "kagent add-mcp server-everything --command npx --arg @modelcontextprotocol/server-everything"

pei "kagent build ."

pei "kagent run"

pei "kagent deploy . --env-file .env.production --namespace kagent --image pmuir/demoagent:12 --platform linux/amd64,linux/arm64"

pe "kubectl label namespaces kagent istio.io/dataplane-mode=ambient "

pe "kubectl label mcpservers.kagent.dev server-everything kagent.solo.io/waypoint=true"

pe "kubectl apply -f ../resources/access-policies"

pe "kubectl apply -f ../resources/access-policies"

cmd
