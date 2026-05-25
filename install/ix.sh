#!/bin/sh
# Cross-platform tool installs (Darwin + Linux).

echo Installing mise
# mise is a polyglot tool-version manager. Replaces nvm for Node, pyenv for
# Python, etc. The installer drops mise into ~/.local/bin and shims into
# ~/.local/share/mise/shims (which .zshenv adds to PATH).
curl -fsSL https://mise.run | sh

# Make mise available for the rest of this script.
export PATH="$HOME/.local/bin:$PATH"

echo Installing Node.js LTS via mise
mise use --global node@lts

echo Installing Bun
curl -fsSL https://bun.sh/install | bash

echo Installing Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
