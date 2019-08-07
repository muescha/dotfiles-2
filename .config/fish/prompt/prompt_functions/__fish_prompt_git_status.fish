function __fish_prompt_git_status --description 'Display git info in the fish prompt'
    # Fail if we don't have git installed
    in-path git
    or return 0

    # Fail if we're not inside a git repo
    set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
    or return 0

    set -l icon_untracked "?"
    set -l icon_added "+"
    set -l icon_modified "~"
    set -l icon_renamed "»"
    set -l icon_deleted "-"
    set -l icon_stashed "\$"
    set -l icon_unmerged "<>"
    set -l icon_diverged "↕"
    set -l icon_ahead "↑"
    set -l icon_behind "↓"

    set -l icon_clean "√"

    set -l GIT_PROMPT_ORDER untracked added modified renamed deleted stashed unmerged diverged ahead behind

    set -l git_status
    set -l is_ahead
    set -l is_behind

    set -l full_git_status

    set -l index (git status --porcelain 2>/dev/null -b)
    set -l trimmed_index (string split \n $index | string sub --start 1 --length 2)

    for i in $trimmed_index
        if test (string match '\?\?' $i)
            set git_status untracked $git_status
        end
        if test (string match '*A*' $i)
            set git_status added $git_status
        end
        if test (string match '*M*' $i)
            set git_status modified $git_status
        end
        if test (string match '*R*' $i)
            set git_status renamed $git_status
        end
        if test (string match '*D*' $i)
            set git_status deleted $git_status
        end
        if test (string match '*U*' $i)
            set git_status unmerged $git_status
        end
    end

    # Check for stashes
    if test -n (echo (command git rev-parse --verify refs/stash 2>/dev/null))
        set git_status stashed $git_status
    end

    # Check whether the branch is ahead
    if test (string match '*ahead*' $index)
        set is_ahead true
    end

    # Check whether the branch is behind
    if test (string match '*behind*' $index)
        set is_behind true
    end

    # Check whether the branch has diverged
    if test "$is_ahead" = "true" -a "$is_behind" = "true"
        set git_status diverged $git_status
    else if test "$is_ahead" = "true"
        set git_status ahead $git_status
    else if test "$is_behind" = "true"
        set git_status behind $git_status
    end

    set -l full_git_status
    for i in $GIT_PROMPT_ORDER
        if contains $i in $git_status
            set -l status_color (echo fish_prompt_color_git_$i)
            set -l full_color "$$status_color"

            set -l status_symbol icon_$i
            set -l full_status_symbol "$$status_symbol"
            set -l status_with_color (set_color $full_color ; echo $full_status_symbol ; set_color normal)

            set full_git_status "$full_git_status$status_with_color"

        end
    end

    if [ "$full_git_status" ]
        set full_git_status (echo $full_git_status | sed -e 's/ //')
        echo -n " "
        echo  "[$full_git_status]" | sed -e 's/ //' | tr -d '\n'
    end
end
