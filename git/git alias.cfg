git config --global alias.delete-merged-local-branches "! git branch --merged develop | grep -Ev '(^\*|develop)' | xargs -n 1 git branch -d"
git config --global alias.delete-merged-remote-branches "! git branch -r --merged develop | grep -Ev '(^\*|develop)' | cut -d '/' -f2- | xargs -n 1 git push --delete origin"
git config --global alias.ls "log --pretty=format:%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn] --decorate"
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st "status -sb"
git config --global alias.br branch
git config --global alias.hist 'log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
git config --global alias.type "cat-file -t"
git config --global alias.dump "cat-file -p"
git config --global alias.code "co develop"
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.update-develop "! git co develop ; git pull"
