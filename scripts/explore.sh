#!/bin/bash

########################
# include the magic
########################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/demo-magic.sh"

# Override command color to remove bold
DEMO_CMD_COLOR="\033[0;37m"  # Non-bold white

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

# Source environment variables
. ../resources/.env.production

# hide the evidence
clear

# Put your stuff here

pei "cd demoagent"

pe "kagent deploy . --env-file .env.production --namespace kagent --image pmuir/demoagent:1 --platform linux/amd64,linux/arm64 --dry-run > deploy.yaml"
