#!/usr/bin/env bash
# Install the INSERT_OWNER apt source, then: sudo apt-get install -y INSERT_REPO
set -euo pipefail
REPO_URL="${REPO_URL:-@REPO_URL@}"
curl -fsSL "$REPO_URL/INSERT_REPO.list" -o /tmp/INSERT_REPO.list
sudo install -m 0644 /tmp/INSERT_REPO.list /etc/apt/sources.list.d/INSERT_REPO.list
sudo apt-get update -qq
echo "OK — run: sudo apt-get install -y INSERT_REPO"
