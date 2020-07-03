local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
DIR=%{$fg_bold[blue]%}%~%{$reset_color%}
COMPUTER=%{$fg_bold[green]%}DOCKER-IMG%{$reset_color%}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"

PROMPT='${ret_status} $COMPUTER $DIR $(git_prompt_info)'

