#
# .zprofile  --  loaded by login zsh shells, after .zshenv but before .zshrc.
#
# Most env now lives in .zshenv (so non-login subshells, MCP servers, and IDEs see it too).
# Use this file only for login-only one-shots and tool integrations that explicitly require
# a login-shell hook.
#

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
