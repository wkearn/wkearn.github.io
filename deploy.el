(with-temp-file "timestamp" ())

(async-shell-command "git stash")

(async-shell-command "git checkout develop")

(async-shell-command "stack exec site clean")
(async-shell-command "stack exec site build")

(async-shell-command "git fetch --all")
(async-shell-command "git checkout master")

(async-shell-command "robocopy _site docs /MIR")

(async-shell-command "git add -A")

(async-shell-command (concat "git commit -m \"Publish " (current-time-string) "\""))

(async-shell-command "git push origin master")

(async-shell-command "git checkout develop")

(async-shell-command "git stash pop")
