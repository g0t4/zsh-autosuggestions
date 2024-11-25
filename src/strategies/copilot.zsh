
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

    # *** CACHE ask_service params (which are changed in fish shell currently)
    if [[ -z $ask_service ]]; then
        # *** FYI this is cached per shell process, takes 40ms to query so yeah I don't wanna slow down my prototype, I need to see how it feels with minimal lag and in a real impl I could easily invalidate my zsh cache when I change it in fish and/or vice versa
        # read value from fish shell universal variable named "ask_service"
        ask_service=$(fish -c 'echo $ask_service')
    fi

    # ! TODO wire up to copilot codex completions
    # TODO wire up to copilot chat completions
    # TODO add context to prompt, i.e. recent command history
    #    I suspect recent history will make it easier to build commands from a short prefix, dotnet build, do => dotnet run!
    #    later, try PWD/list files in PWD or tree with limits
	_python3="${WESCONFIG_DOTFILES}/.venv/bin/python3"
	_single_py="${WESCONFIG_DOTFILES}/zsh/universals/3-last/ask-openai/single.py"
	response=$( $_python3 $_single_py $ask_service 2>&1 \
            <<STDIN_CONTEXT
env: zsh on $(uname)
task: you are a strategy in zsh-autosuggetions, to complete the following prompt, your response must repeate the prompt verbatim and then the rest of the command that you are suggesting.
prompt: $prefix
STDIN_CONTEXT
)


	# Give the first history item matching the pattern as the suggestion
	# - (r) subscript flag makes the pattern match on values
	# typeset -g suggestion="${prefix}${response}"
	typeset -g suggestion="${response}"
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
