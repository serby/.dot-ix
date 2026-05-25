#
# ~/.zshrc  --  loaded ONLY for interactive shells.
#
# Aliases, prompt, completions, key bindings, and shell-integration hooks live here.
# PATH and tool versions live in ~/.zshenv (so MCP servers, IDE subshells, and scripts inherit them).
#

(( ${+functions[_zsh_profile_mark]} )) && _zsh_profile_mark zshrc:start

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Higher fd limit; matters for parallel build/test runs.
ulimit -n 2048

# Custom prompt.
source "$HOME/.dot-ix/.zsh-prompt"

#
# Tool integrations that hook the interactive prompt.
#

# mise: prompt hook for tool-version switching. The shim dir is already on PATH
# from .zshenv, so non-interactive shells still resolve tools via mise --
# this only adds the auto-switch UX.
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# rbenv: prompt hook + completions.
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

# bun completions.
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# iTerm2 shell integration (marks, command status, triggers).
[[ -f "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# VS Code integrated-terminal shell integration.
if [[ "$TERM_PROGRAM" == "vscode" ]] && (( $+commands[code] )); then
  source "$(code --locate-shell-integration-path zsh)"
fi

#
# Behaviour tweaks.
#
unsetopt correct  # zsh's autocorrect is more annoying than helpful at the prompt.

#
# Tab title: name the iTerm tab after the current dir.
#
function tab_title { print -Pn "\e]0;%~\a" }
autoload -Uz add-zsh-hook
add-zsh-hook precmd tab_title

# Random-ish iTerm tab badge colour for visual disambiguation across tabs.
print -n "\e]6;1;bg;red;brightness;$((128 + RANDOM % 127))\a"
print -n "\e]6;1;bg;green;brightness;$((128 + RANDOM % 127))\a"
print -n "\e]6;1;bg;blue;brightness;$((128 + RANDOM % 127))\a"

#
# Aliases.
#
alias weather='curl wttr.in'
alias notes='code ~/Notes/notes'

#
# Functions.
#

# Show image dimensions / bit depth in one line.
imageinfo() {
  gm identify -format "%wx%h %b unique_colors:%k bit_depth:%q - %i\n" "$1"
}

(( ${+functions[_zsh_profile_mark]} )) && _zsh_profile_mark zshrc:end
