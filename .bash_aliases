alias vi='vim'
alias sr='screen -r'
alias ff='find . | ack '
alias tree='tree -FC'
if [[ $SYSTEM_TYPE == 'Darwin' ]]; then
	alias ls='ls -CFG'
	alias ll='ls -alFG'
	alias la='ls -AG'
	alias l='ls -CFG'
fi
