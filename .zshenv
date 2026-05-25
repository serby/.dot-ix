#
# ~/.zshenv  --  loaded by EVERY zsh invocation (login, interactive, scripts, MCP servers, IDE-spawned subshells).
#
# Anything a child process must inherit (PATH, tool versions, locale) belongs here.
# Aliases, prompt, completions, and other interactive UX belong in ~/.zshrc.
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

#
# Tool managers (must be early so their shims/bins are visible to non-interactive shells).
#

# mise: shims dir on PATH. Shims invoke mise to resolve the active tool version
# from ~/.config/mise/config.toml or .tool-versions. This is the supported pattern
# for non-interactive shells; `mise activate` belongs in .zshrc for the prompt hook.
[[ -d "$HOME/.local/share/mise/shims" ]] && path=("$HOME/.local/share/mise/shims" $path)

# Homebrew: needs to run before later PATH entries that depend on it.
# Sets HOMEBREW_PREFIX, MANPATH, INFOPATH, and prepends /opt/homebrew/{bin,sbin}.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#
# User PATH (in priority order; first wins).
#
path=(
  "$HOME/.toolbox/bin"
  "$HOME/.aim/mcp-servers"
  "$HOME/bin"
  "$HOME/.dot-ix/bin"
  "$HOME/.bun/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "$HOME/Notes/notes/scripts"
  /usr/local/opt/curl/bin
  ./node_modules/.bin
  $path
)

#
# Tool homes / SDK roots.
#
export BUN_INSTALL="$HOME/.bun"
export ANDROID_SDK="$HOME/Library/Android/sdk"
export ANDROID_PATH="$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$ANDROID_SDK/build-tools"

# Java: prefer Java 17 if present. java_home is slow (~50ms) but only runs once per shell.
if [[ -x /usr/libexec/java_home ]]; then
  _java17="$(/usr/libexec/java_home -v 17 2>/dev/null)"
  if [[ -n "$_java17" ]]; then
    export JAVA_HOME="$_java17"
    export GRADLE_OPTS="-Dorg.gradle.java.home=$_java17"
  fi
  unset _java17
fi
# Apply log4j CVE-2021-44228 mitigation to every JVM we spawn.
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

# Swiftly (Swift toolchain manager). env.sh prepends ~/.swiftly/bin and sets SWIFTLY_HOME.
[[ -f "$HOME/.swiftly/env.sh" ]] && source "$HOME/.swiftly/env.sh"

# DV iOS Insights MCP server location (consumed by the MCP launcher).
export DV_INSIGHTS_MCP_PATH="$HOME/Development/workspace/DViOSInsights/src/DViOSInsights/mcp"

#
# Locale, editor, pager.
#
export LANG="${LANG:-en_US.UTF-8}"
export EDITOR='code-wait'
export VISUAL='code-wait'
export PAGER='less'
export BROWSER='open'
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Less: pick lesspipe(.sh) if either is on PATH.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Per-user TMPDIR (matches prezto convention).
if [[ ! -d "${TMPDIR:-}" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"

#
# Prezto compatibility: ensure non-login non-interactive shells still see .zprofile-defined env.
# Prezto's stock .zshenv does this; we replicate it so we don't depend on the .dot-ix template.
#
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
