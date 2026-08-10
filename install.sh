#!/bin/bash
# see https://stackoverflow.com/a/1482133
dir=$(dirname -- "$( readlink -f -- "$0";  )";)

$dir/home/bin/lnk "$dir/home" "$HOME"

# source bashrc once to set up
source "$HOME/.bashrc"

# GitHub codespace only
if [ "$CODESPACES" = "true" ]; then
  # install claude and github mcp
  if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
    --scope user \
    --header 'Authorization: Bearer ${CLAUDE_MCP}'
fi
