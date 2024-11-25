
_zsh_autosuggest_strategy_copilot() {
	# Reset options to defaults and enable LOCAL_OPTIONS
	emulate -L zsh

	# Enable globbing flags so that we can use (#m) and (x~y) glob operator
	setopt EXTENDED_GLOB

	# Escape backslashes and all of the glob operators so we can use
	# this string as a pattern to search the $history associative array.
	# - (#m) globbing flag enables setting references for match data
	# TODO: Use (b) flag when we can drop support for zsh older than v5.0.8
	local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"

	# Get the history items that match the prefix, excluding those that match
	# the ignore pattern
	local pattern="$prefix*"
	if [[ -n $ZSH_AUTOSUGGEST_HISTORY_IGNORE ]]; then
		pattern="($pattern)~($ZSH_AUTOSUGGEST_HISTORY_IGNORE)"
	fi

	# Give the first history item matching the pattern as the suggestion
	# - (r) subscript flag makes the pattern match on values
	typeset -g suggestion="$prefix, hey, fuck a dick"
}

# FYI supermaven (mitm capt => shows one websocket connection with messages tab in body... also has simple api key... would be super easy to replicate messages)
# https://github.com/supermaven/zsh-websocket-client
# uses `sm-agent` binary... stdio interface, does it also have non-stdio interface?!
#   see saved flows in dotfiles (not checked in)
#   can I just use this!
#   https://github.com/supermaven-inc/supermaven-nvim/blob/main/lua/supermaven-nvim/binary/binary_handler.lua#L74
#
#   FYI:
#     source zsh-autosuggestions.zsh && source src/strategies/copilot.zsh && ZSH_AUTOSUGGEST_STRATEGY=copilot
