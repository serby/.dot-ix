echo Installing NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

echo Install nodejs
nvm install --lts

echo Installing Bun
curl -fsSL https://bun.sh/install | bash

echo Installing Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

