export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME"/git/gitconfig

export VIRTUAL_ENV_DISABLE_PROMPT=1

export EDITOR=nvim

export GOPATH="$XDG_DATA_HOME"/go
export GOBIN="$XDG_DATA_HOME"/go/bin

export PATH="$PATH":"$HOME"/.local/bin
export PATH="$PATH":"$GOBIN"

if [ -d "/opt/homebrew/bin" ]; then
	export PATH="/opt/homebrew/bin":"$PATH"
fi

if [ -d "$HOME/.orbstack/bin" ]; then
	export PATH="$HOME/.orbstack/bin":"$PATH"
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LESSHISTFILE=/dev/null

export NVIM_APPNAME=litenvim
