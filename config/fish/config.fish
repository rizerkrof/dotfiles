set -U fish_greeting

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

if type -q eza
   alias eza 'exa --group-directories-first --git';
   alias l 'exa -blF --icons --sort type';
   alias la 'l -a';
   alias ll 'exa -abghilmu --git-repos --icons --sort type --octal-permissions';
   alias llm 'll --sort=modified'
   alias tree 'exa --tree'
end

if type -q bat
   alias cat 'bat'
end

if command -q zoxide
   zoxide init fish --cmd cd | source
end

if command -q kitten
   alias icat 'kitten icat'
end