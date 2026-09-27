#!/bin/sh

# 1. Check for GitHub CLI
if ! command -v gh > /dev/null 2>&1; then
    echo "gh could not be found" 1>&2
    exit 1
fi

# 2. Cleanup (Ignore errors if they don't exist)
# WARNING: this destroys the GitHub repository named `workshop-automation`
# in your account, including a fork of the workshop if that is what it is.
if gh repo view workshop-automation > /dev/null 2>&1; then
    owner=$(gh api user -q .login)
    echo "About to DELETE the existing GitHub repository $owner/workshop-automation."
    echo "Everything in it (branches, pull requests, issues) will be lost."
    printf "Type 'yes' to continue: "
    read -r answer
    if [ "$answer" != "yes" ]; then
        echo "Aborted." 1>&2
        exit 1
    fi
    gh repo delete workshop-automation --yes > /dev/null 2>&1
fi
git remote rm upstream > /dev/null 2>&1

# 3. Ensure Git is initialized and has a commit
if [ ! -d ".git" ]; then
    git init
fi

# Ensure we have at least one commit
if ! git rev-parse HEAD > /dev/null 2>&1; then
    git add .
    git commit -m "Initial commit"
fi

# 4. Standardize branch name to 'main'
git branch -M main

# 5. Create and push
# Using --push here can be finicky if the remote 'upstream' isn't set yet.
# We'll create the repo first, then push manually to be safe.
gh repo create workshop-automation --public --source=. --remote=upstream

# 6. Explicitly push the main branch
git push -u upstream main

