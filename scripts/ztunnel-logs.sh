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

magic_prompt

pe "kubectl logs -n istio-system -l app=ztunnel  -f | grep everything"
