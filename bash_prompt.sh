# =============================================================================
# bash_prompt.sh  —  Custom Bash prompt: CWD (basename) + git branch
#
# Shows only the current directory name (not full path) in cyan, followed by
# the active git branch in green when inside a repo, then the $ sign.
#
# Example:
#   dev-vm-tools (main) $
#   src $              ← not in a git repo
#
# Source this file from ~/.bashrc:
#   source /path/to/bash_prompt.sh
# Or let install.sh append the sourcing line automatically.
# =============================================================================

git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        echo -e "\e[32m($branch)\e[0m"
    fi
}

PS1='\[\e[36m\]\W\[\e[0m\] $(git_branch) \$ '
