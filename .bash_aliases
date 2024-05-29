alias ll="ls -lFN"
alias la="ls -laFN"
alias lh="ls -lhFN"

alias installed="apt-mark showmanual"
alias nspawn="sudo systemd-nspawn"
alias sl="sudo su --login"

export HISTCONTROL=ignoreboth

if [[ -x $(command -v nvim) ]]; then
    export MANPAGER="nvim +Man!"
fi
