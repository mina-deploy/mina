Migrating from 0.3.x to 1.0
--------------------
# DSL

## old
* `queue`         -> `command`  # adds command to queue
* `queue!`        -> `command`  # it will output the command if verbose is true
* `to`            -> `on`       # changes queue name
* `in_directory`  -> `in_path`  # wraps commands to be run in specified path

## new
* `run`                         # runs commands on a specified backend
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

All `*_path` variables (`:current_path`, `:shared_path`, ...) now include `:deploy_to`
* `#{fetch(:deploy_to)}/#{fetch(:current_path)}` -> `fetch(:current_path)`
