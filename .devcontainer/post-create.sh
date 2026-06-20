#!/bin/bash
set -e

if [ -f "Gemfile" ]; then
  bundle install
  bin/setup --skip-server
  bin/setup-hooks
else
  gem install rails --no-document
fi

# ---- kwik-e harness setup (Adrian's personal AI tooling) ----
# /workspaces/kwik-e-mart is mounted via docker-compose's ../..:/workspaces;
# expose the CLI in PATH and register the plugin in Claude. All guarded —
# silent no-op if kwik-e-mart isn't present on the host. Teammates unaffected.
if [ -d /workspaces/kwik-e-mart/bin ]; then
  grep -qF '/workspaces/kwik-e-mart/bin' ~/.zshrc 2>/dev/null \
    || echo 'export PATH="/workspaces/kwik-e-mart/bin:$PATH"' >> ~/.zshrc
  grep -qF '/workspaces/kwik-e-mart/bin' ~/.bashrc 2>/dev/null \
    || echo 'export PATH="/workspaces/kwik-e-mart/bin:$PATH"' >> ~/.bashrc 2>/dev/null || true
  echo "kwik-e CLI on PATH."

  if command -v claude >/dev/null 2>&1; then
    claude plugin marketplace add /workspaces/kwik-e-mart >/dev/null 2>&1 || true
    claude plugin install kwik-e@kwik-e-mart >/dev/null 2>&1 || true
    echo "kwik-e Claude plugin installed."
  fi
fi
