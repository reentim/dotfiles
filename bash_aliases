alias vi='vim'
alias sr='screen -r'
alias ff='find . | ack '
alias tree='tree -FC'
alias l='ls -l'
if [[ $SYSTEM_TYPE == 'Darwin' ]]; then
	alias ls='ls -CFG'
	alias ll='ls -alFG'
	alias la='ls -AG'
	alias l='ls -l'
fi
alias rspec='rspec --color --tty'
alias bx='bundle exec'
alias r='rails'
# SPEC=model bundle exec rspec spec/models/user_generator_spec.rb
