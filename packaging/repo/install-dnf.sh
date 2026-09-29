#!/usr/bin/env bash
# Install the INSERT_OWNER dnf repo, then: sudo dnf install -y INSERT_REPO
set -euo pipefail
REPO_URL="${REPO_URL:-@REPO_URL@}"
curl -fsSL "$REPO_URL/INSERT_REPO.repo" -o /tmp/INSERT_REPO.repo
sudo install -m 0644 /tmp/INSERT_REPO.repo /etc/yum.repos.d/INSERT_REPO.repo
echo "OK — run: sudo dnf install -y INSERT_REPO"
