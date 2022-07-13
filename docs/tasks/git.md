# Git Tasks

These tasks provide [Git](https://git-scm.com/) functionality, mainly for cloning a repository.

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/git'
```

The above will also load [`default`](./default) tasks.

## Variables

These tasks use the following variables.

### `:branch`

Specifies which repository branch to clone during the [`git:clone`](#gitclone) task.

If you want to instead clone from a commit, set the [`:commit`](#commit) variable.

Default value: `master`

### `:commit`

Specifies which commit to clone from the repository during the [`git:clone`](#gitclone) task.

If a value isn't set, Mina will instead clone from a [`:branch`](#branch).

Mina doesn't set a default value.

### `:remove_git_dir`

Determines whether to delete the `.git` folder after cloning the repository.

Default value: `true`

### `:remote`

Specifies the name of the [Git remote](https://git-scm.com/docs/git-remote) used for the [`git:ensure_pushed`](#gitensurepushed) task.

Default value: `origin`

### `:repository`

Specifies the repository you want to clone. The value should be a [Git URL](https://git-scm.com/docs/git-clone#_git_urls).

Mina doesn't set a default value, you have to set this variable yourself.

Example: `git@github.com:example/repo.git`

## Tasks

### `git:clone`

Clones a repository.

The repository is specified by the [`:repository`](#repository) variable.

You must ensure that the machine which will do the cloning has appropriate access rights. If the repo is private, it's recommended that you configure an SSH key on your Git provider.

You can clone either a branch or a commit. If cloning a branch, the branch must specified with the [`:branch`](#branch) variable. In case you want to clone from a commit, set the [`:commit`](#commit) variable.

After cloning the repo, Mina will delete the `.git` folder. To keep it, set [`:remove_git_dir`](#removegitdir) to `false`.

Example:
```ruby
# config/deploy.rb

task :deploy do
  deploy do
    invoke 'git:clone'
  end
end
```

### `git:revision`

Prints the commit hash of the current release.

When you use [`git:clone`](#gitclone), Mina will create a `.mina_git_revision` file where it will save the HEAD commit hash. Then, when you use this task, Mina will SSH to the server, position to the current release path (see docs for [`:current_path`](./deploy.md#currentpath)), and print the contents of `.mina_git_revision`.

Example:
```bash
$ mina git:revision
1a76574b953508fd42340226781aa267f41fec99 # The current deploy is running on this commit
```

### `git:ensure_pushed`

Ensures that the local branch has been pushed to the remote. In case there's a difference between the local checkout and the origin branch (e.g. when you commit something but don't push it), Mina will exit with an error message.

The remote against which the local checkout is compared is defined by the [`:remote`](#remote) variable.

Example:
```ruby
# config/deploy.rb

task :deploy do
  invoke 'git:ensure_pushed'

  deploy do
    invoke 'git:clone'
  end
end
```

And then if I try to:
```bash
$ git commit -m "My commit that I won't yet push to remote"
$ mina deploy
Your branch master needs to be pushed to origin before deploying
```
the deploy fails because my latest commit hasn't been pushed.
