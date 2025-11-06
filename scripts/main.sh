#!/bin/bash

if [[ "$TEST" == "true" ]]; then
  echo "TEST mode enabled"
  DEMO_TYPE_SPEED=1000
  DEMO_NO_WAIT=true
fi

########################
# include the magic
########################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/demo-magic.sh"

# Override command color to remove bold
DEMO_CMD_COLOR="\033[0;37m"  # Non-bold white

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

# TEST mode configuration


# NO_SECURITY mode configuration
if [[ "$NO_SECURITY" == "true" ]]; then
  echo "NO_SECURITY mode enabled - skipping security setup"
fi

# Source environment variables and export them
set -o allexport
source "$SCRIPT_DIR/../resources/.env.production"
set +o allexport

# Check required environment variables
if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Error: OPENAI_API_KEY is not set in .env.production"
  exit 1
fi

if [[ -z "$DOCKER_REPO" ]]; then
  echo "Error: DOCKER_REPO is not set in .env.production"
  exit 1
fi

# Get the next Docker image tags based on the latest tag in Docker Hub
echo "Fetching latest tag from Docker Hub for ${DOCKER_REPO}..."
LATEST_TAG=$(curl -s "https://hub.docker.com/v2/repositories/${DOCKER_REPO}/tags?page_size=100" | \
  jq -r '.results[].name' | \
  grep -E '^[0-9]+$' | \
  sort -n | \
  tail -1)

if [[ -z "$LATEST_TAG" ]]; then
  echo "No numeric tags found, starting from 1"
  LATEST_TAG=0
fi

TAG1=$((LATEST_TAG + 1))
TAG2=$((LATEST_TAG + 2))

echo "Latest tag: ${LATEST_TAG}"
echo "Using tags: ${TAG1} and ${TAG2}"

# hide the evidence
clear

# Put your stuff here
magic_prompt

pe "kagent init adk python demoagent --model-name gpt-4 --model-provider OpenAI"

pei "cd demoagent"

pe "kagent build ."

if [[ "$TEST" != "true" ]]; then
  pe "kagent run"
fi

pe "kagent add-mcp server-everything --command npx --arg @modelcontextprotocol/server-everything"

pei "kagent build ."

if [[ "$TEST" != "true" ]]; then
  pei "kagent run"
fi

pei "cp ../resources/.env.production ."

pe "kagent deploy . --env-file .env.production --namespace kagent --image ${DOCKER_REPO}:${TAG1} --platform linux/amd64,linux/arm64"

if [[ "$NO_SECURITY" != "true" ]]; then
  pe "kubectl label namespaces kagent istio.io/dataplane-mode=ambient"

  pe "kubectl label mcpservers.kagent.dev server-everything kagent.solo.io/waypoint=true"

  pe "kubectl apply -f ../resources/access-policies"

  pe "kubectl apply -f ../resources/access-policies"
fi

cmd
