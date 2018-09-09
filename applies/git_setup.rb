# Initialize git and make a initial commit
info "Init git repo and do an initial commit"
git :init
git checkout: "-b development"
git add: "."
git commit: %Q{ -m 'Initial commit'  --quiet}
info "Git initialized and initial commit made to branch 'develop'"
info "Add a git repo with: git remote -a repo_url"
