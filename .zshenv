#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# export AWS_ACCESS_KEY_ID=AKIAY6QOX2J4JPJD3JDN
# export AWS_SECRET_ACCESS_KEY=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