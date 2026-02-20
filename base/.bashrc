#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;36m\]\w\[\e[0m\]\$ "
# PS1="\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]\h \[\e[33m\]\w\[\e[0m\] \$ "

#ssh-rasp
alias rasp="ssh dannielmamede@192.168.0.81"

#eza
alias ls="eza --sort=type --icons"
alias la="eza -la --icons"

#starship
eval "$(starship init bash)"

#yazi
function ll() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

#zoxide
eval "$(zoxide init bash)"

#PATH .local/bin 
export PATH="$HOME/.local/bin:$PATH"

#comando gcp
gcp() {
  git add .
  git commit -m "update $(date '+%Y-%m-%d %H:%M')"
  git push
}

# pnpm
export PNPM_HOME="/home/dannielmamede/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.npm-global/bin:$PATH"
