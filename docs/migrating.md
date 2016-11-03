Migrating from 0.3.x to 1.0
--------------------
# DSL

## old
* `queue`         -> `command`  # adds command to queue
* `queue!`        -> `command`  # it will output the command if verbose is true
* `to`            -> `on`       # changes queue name
* `in_directory`  -> `in_path`  # wraps commands to be run in specified path
* `invoke :'task[param]'` -> `invoke :task, param`  # passes params to the task

## new
* `run`                         # runs commands on a specified backend, this has replaced old before and after hooks
* `comment`                     # adds a 'echo -----> #{command}' to queue

**Other commands have been removed!**

# Setting variables

## same
* `set`                         # remained for setting variables

## new
* `fetch`                       # **ALL** variables now need to be fetched with `fetch`. Removed `method_missing`
* `set?`
* `ensure!`

# Deploy variables

* `shared_paths` -> separate into `shared_dirs` & `shared_files`

All `*_path` variables (`:current_path`, `:shared_path`, ...) now include `:deploy_to`
* `#{fetch(:deploy_to)}/#{fetch(:current_path)}` -> `fetch(:current_path)`

# Using new mina on old projects

* run `mina setup`
* if you do not want for bundle to install gems copy `current/vendor/bundle` to `/shared/vendor/bundle`
* if you do not want to precompile assets copy `current/public/assets` to `shared/public/assets`
* if you want to precompile you will need to run deploy with `force_asset_precompile=true`
