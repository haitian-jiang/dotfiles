# jht.zsh-theme, based on ys and smt
typeset +H my_gray="$FG[247]"
MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="|"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔%{$reset_color%}"

#ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
#ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
#ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
#ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
#ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"


ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[blue]%} +"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} X"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} r"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%} U"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="➤ %{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

# function prompt_char() {
#   git branch >/dev/null 2>/dev/null && echo "%{$fg[magenta]%}↪%{$reset_color%}" && return
#   hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
#   darcs show repo >/dev/null 2>/dev/null && echo "%{$fg_bold[green]%}❉%{$reset_color%}" && return
#   echo "%{$fg[magenta]%}➜%{$reset_color%}"
# }

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "[$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}]"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "[$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}]"
            else
                echo "[$COLOR${MINUTES}m%{$reset_color%}]"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "[$COLOR~]"
        fi
    fi
}

# Conda
# local conda_prompt='$(conda_prompt_info)'
conda_prompt_info() {
    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        echo -n "%{$fg[white]%}($CONDA_DEFAULT_ENV) %{$reset_color%}"
    else
        echo -n ''
    fi
}

# venv
venv_prompt_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo -n "%{$fg[white]%}($(basename $VIRTUAL_ENV)) %{$reset_color%}"
    else
        echo -n ''
    fi
}

# name by GPU
gpu_summary() {
  nvidia-smi --query-gpu=name --format=csv,noheader \
    | sed -E 's/.*(L40S|L4|L40|A100|H100|H200|A6000).*/\1/' \
    | sort \
    | uniq -c \
    | awk '{printf "%s-%d,", $2, $1}' \
    | sed 's/,$//'
}

host_or_gpu() {
  # Check if the nvidia-smi command exists and is executable
  if command -v nvidia-smi &> /dev/null; then
    local summary
    # Execute gpu_summary and capture its output
    summary=$(gpu_summary)
    # Check if the summary is not empty
    if [[ -n "$summary" ]]; then
      echo "$summary"
    else
      # Fallback to hostname if gpu_summary returns nothing
      hostname
    fi
  else
    # If nvidia-smi doesn't exist, just print the hostname
    hostname
  fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

PROMPT='
$(conda_prompt_info)\
$(venv_prompt_info)\
%(#,%{$fg[red]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$my_gray%}@ \
%{$terminfo[bold]$fg[green]%}$(host_or_gpu) \
%{$my_gray%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%} \
$(git_prompt_short_sha)$(git_prompt_info) \
%{$my_gray%}[%*] \
$exit_code
%{$fg[magenta]%}👉%{$reset_color%} '
# %{$fg[red]%}%!%{$reset_color%} \
#%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \

RPROMPT='$(git_time_since_commit)$(git_prompt_status)%{$reset_color%}'
