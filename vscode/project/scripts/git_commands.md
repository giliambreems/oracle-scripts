# List of frequently used GIT command's

| Category | Command                          | Description |
| ----     | ----                             | ----        |
| add      | `git add .`                      | *add all changes in all files (recursive) into the staging area* |
|          | `git add . -u`                   | *add all changes in all tracked files (recursive) into the staging area (tracked files only)* |
||||
| branch   | `git branch <branch_name>`       | *create new branch <branch_name>* |
|          | `git branch -d <branch_name>`    | *delete local branch <branch_name>* |
|          | `git branch -D <branch_name>`    | *delete local branch <branch_name> with force* |
||||
| checkout | `git checkout <branch_name>`     | *switch to branch <branch_name>* |
|          | `git checkout -b <branch_name>`  | *switch to branch <branch_name> and create it when it doesn't exist yet* |
||||
| clean    | `git clean -f -d`                | *remove all untracked files in working folder (-d = recursively, -x =ignored files as well )* |
||||
| clone    | `git clone <git_repository>`     | *create a local copy of a remote git repository <git_repository>*
||||
| commit   | `git commit -m "commit message"` | *commit all changes in the staging area* |
|          | `git commit --amend --no-edit`   | *add all changes in the staging area to the last/previous commit and leave the commit message as-is. __Use ONLY when previous commit has not been published/pushed yet!__* |
|          | `git commit --amend -m "..."`    | *add all changes in the staging area to the last/previous commit and/or change the commit message to ... __Use ONLY when previous commit has not been published/pushed yet!__* |
||||
| fetch    | `git fetch`                      | *gather any commits from the target branch that do not exist in your current branch and stores them in your local repository* |
|          | `git fetch -p`                   | *fetch and prune: after the fetch, branches which no longer exists on the remote will be deleted locally (cleanup)* |
||||
| init     | `git init`                       | *create a new/empty git repository in the current folder* |
||||
| log      | `git log`                        | *list all actions that have been executed on the current branch* |
||||
| merge    | `git merge <branch_name>`        | *pull all changes from branch <branch_name> into the current branch* |
||||
| pull     | `git pull`                       | *fetch and merge any commits from the target branch* |
||||
| push     | `git push`                       | *write/push all committed changes from active branch to the remote repository* |
|          | `git push --set-upstream origin <branch_name>` | *set upstream of current branch to remote (origin). Needed when pushing branch to the remote for the first time* |
|          | `git push origin -d <branch_name>` | *delete remote branch <branch_name>* |
||||
| reset    | `git reset`                      | *undo all changes in the staging area* |
|          | `git reset --quiet`              | *undo all changes in the staging area without any notification* |
|          | `git reset --hard`               | *undo all changes in the working area, uncommited changes will be lost* |
||||
| status   | `git status`                     | *list all files that have been added/modified/deleted and not committed yet* |
| | | |


# List of advanced GIT command's

| Command | Description |
| ----    | ----        |
| <code>git branch --merged main \| grep -Ev '(^\\*\|main)' \| xargs -n 1 git branch -d</code> | *delete all branches from local repo, that have been completely merged into the main branch* |
| <code>git branch -r --merged main \| grep -Ev '(^\\*\|main)' \| cut -d '/' -f2- \| xargs -n 1 git push --delete origin</code> | *delete all branches from remote, that have been completely merged into the main branch* |
| <code>git --no-pager diff --ignore-space-change ./db > all.patch</code> | *Create a git diff/patch file with all ./db changes* |
| <code>working_branch=\`git branch --show-current\` ; git checkout main ; git pull ; git checkout \${working_branch} </code>| *Bring local main branch up-to-date with remote, branch switching included* |
| | |


# List of GIT config commands for the project

| Command                                    | Description |
| ----                                       | ----        |
| `git config --global user.name "<firstname> <lastname>"` | *set your name as username to git* |
| `git config --global user.email <yourmail>@mindef.nl` | *set your email as mail address to git* |
| `git config core.autocrlf true`   | *set line ending setting to automatic* |
| `git config core.safecrlf false`  | *set ignore notifications about irreversable line ending conversions* |
| `git config http.sslverify false` | *set sslVerify over HTTPS off* |
| | |

# List of usefull GIT config alias commands

| Command                                    | Description |
| ----                                       | ----        |
| `git config --global alias.co checkout` | |
| `git config --global alias.ci commit` | |
| `git config --global alias.amend "ci --amend --no-edit"` | |
| `git config --global alias.st "status -sb"` | |
| `git config --global alias.br branch` | |
| `git config --global alias.type "cat-file -t"` | |
| `git config --global alias.dump "cat-file -p"` | |
| `git config --global alias.coma "co main"` | |
| `git config --global alias.unstage 'reset HEAD --'` | |
| `git config --global alias.last 'log -1 HEAD'` | |
| `git config --global alias.update-main "! git co main ; git pull"` | |
| `git config --global alias.update-main "! BRANCH=`\\\``git br --show-current`\\\``; touch .update-main; git stash -u; git co main; git pull; git co "\${BRANCH}"; git stash pop; rm .update-main"` | |
| `git config --global alias.update-master "! git co main ; git pull"` | |
| `git config --global alias.update-master "! BRANCH=`\\\``git br --show-current`\\\``; touch .update-main; git stash -u; git co main; git pull; git co "\${BRANCH}"; git stash pop; rm .update-main"` | |
| `git config --global alias.publish "! git push --set-upstream origin `\\\``git br --show-current`\\\``"` | |
| `git config --global alias.ls "log --pretty=format:%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn] --decorate"` | |
| `git config --global alias.delete-merged-local-branches "! git branch --merged main \| grep -Ev '(^\*\|main)' \| xargs -n 1 git branch -d"` | |
| `git config --global alias.delete-merged-remote-branches "! git branch -r --merged main \| grep -Ev '(^\*\|main)' \| cut -d '/' -f2- \| xargs -n 1 git push --delete origin"` | |
| `git config --global alias.hist 'log --pretty=format:"%h %ad \| %s%d [%an]" --graph --date=short'` | |
| | |
