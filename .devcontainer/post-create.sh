#!/bin/bash
set -e

if [ -f "Gemfile" ]; then
  bundle install
  bin/setup --skip-server
  bin/setup-hooks
else
  gem install rails --no-document
fi

if [ -x "bin/setup-claude-memory" ]; then
  bin/setup-claude-memory
fi
