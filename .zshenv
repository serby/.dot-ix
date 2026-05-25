#
# ~/.zshenv  --  loaded by EVERY zsh invocation (login, interactive, scripts, MCP servers, IDE-spawned subshells).
#
# Anything a child process must inherit (PATH, tool versions, locale) belongs here.
# Aliases, prompt, completions, and other interactive UX belong in ~/.zshrc.
#

#
# Startup profiling. Set ZSH_PROFILE=1 in the environment before launching zsh
# to get a per-file timing table at the end of .zlogin. Set ZSH_PROFILE=zprof
# to also enable zsh's built-in function-level profiler (printed last).
# Cost when unset: one parameter test per mark. Sub-microsecond.
#
if [[ -n "$ZSH_PROFILE" ]]; then
  zmodload zsh/datetime
  typeset -gA _zsh_profile_marks
  _zsh_profile_marks[__start__]=$EPOCHREALTIME
  _zsh_profile_order=()
  _zsh_profile_mark() {
    _zsh_profile_marks[$1]=$EPOCHREALTIME
    _zsh_profile_order+=($1)
  }
  # Print a per-file timing table to stderr. Files report end-minus-start;
  # gaps between files (zsh's own work loading the next file) are shown only
  # when meaningful so the table stays scannable.
  _zsh_profile_report() {
    local file start end ms prev_end gap_ms
    local total_start=${_zsh_profile_marks[__start__]}
    print -u2 -- "zsh startup profile:"
    prev_end=$total_start
    for file in zshenv zprofile zshrc zlogin; do
      start=${_zsh_profile_marks[${file}:start]}
      end=${_zsh_profile_marks[${file}:end]}
      [[ -z "$start" ]] && continue
      gap_ms=$(( (start - prev_end) * 1000 ))
      (( gap_ms > 1 )) && printf '  %-20s %7.2f ms\n' "(gap)" "$gap_ms" >&2
      ms=$(( (end - start) * 1000 ))
      printf '  %-20s %7.2f ms\n' "$file" "$ms" >&2
      prev_end=$end
    done
    ms=$(( (EPOCHREALTIME - total_start) * 1000 ))
    printf '  %-20s %7.2f ms\n' "total" "$ms" >&2
  }
  [[ "$ZSH_PROFILE" == zprof ]] && zmodload zsh/zprof
  _zsh_profile_mark zshenv:start
fi

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

(( ${+functions[_zsh_profile_mark]} )) && _zsh_profile_mark zshenv:end
