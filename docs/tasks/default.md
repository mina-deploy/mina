# Default Tasks

Default tasks provide essential functionality for task execution on remote servers. Your `deploy.rb` should at least include these tasks (if they're not already included by other tasks).

Load the tasks by adding:
```ruby
# config/deploy.rb
require 'mina/default'
```

## Variables

These tasks use the following variable.

### `:domain`

Specifies the domain to which Mina SSH-s.

Mina doesn't set a default value, you have to set this variable yourself.

### `:port`

Specifies which SSH port to use when connecting to the server.

Default value: `22` ([SSH well-known port](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers))

## `:deploy_to`

Specifies the folder to which Mina positions after opening the SSH connection.

Mina doesn't set a default value, you have to set this variable yourself.

## `:user`

Specifies the user on the server with which Mina SSH-s.

If a value isn't set, Mina will try to open an SSH connection with just the [domain](#domain).

Mina doesn't set a default value, set this only if necessary.

## `:forward_agent`

Specifies whether to use SSH agent forwarding.

Mina doesn't set a default value (meaning agent forwarding won't be used by default).

## `:identity_file`

Overrides the default SSH identity file.

Mina doesn't set a default value, set this only if necessary.

## `:ssh_options`

Provides additional command-line options to the SSH command.

Mina doesn't set a default value.

## Tasks

### `ssh_keyscan_repo`

Extracts the host from the `:repository` variable and adds the host's public key to [known hosts](https://www.ssh.com/academy/ssh/host-key#known-host-keys), if it hasn't been already added.

For example, if `:repository` is set to `https://github.com/example/repo`, the task will add the public key for `github.com` to known hosts.

This can be useful if you're cloning a repository via SSH. Without running the task, you'd have to answer this prompt:
```
The authenticity of host '***' can't be established.
RSA key fingerprint is ***.
Are you sure you want to continue connecting (yes/no)?
```
If you're running Mina on CI, you won't have access to stdin, so you wouldn't be able to answer the prompt. By invoking this task, the prompt will be bypassed.

Example:
```ruby
# config/deploy.rb

task :deploy do
  deploy do
    invoke :ssh_keyscan_repo
    invoke 'git:clone' # The task runs without the host authenticity prompt 
  end
end
```

### `ssh_keyscan_domain`

This tasks runs locally (on the machine from which Mina is invoked) and it adds the remote host set by `:domain` and `:port` variables to known hosts.

The purpose of this task is the same as in the above task: skipping the prompt for adding the host to known hosts.

This task can be useful if you're deploying on CI, where you're in non-interactive mode. In that case, you want to execute this task before any other tasks which connect to the remote host (e.g. the deploy task):
```bash
$ mina ssh_keyscan_domain # adds the remote host to known hosts
$ mina deploy # connects to the remote host
```

### `run[command]`

Runs a command on the server. The command will be executed in the folder set by [`:deploy_to`](#deployto) variable.

The command is supplied as a Rake argument. For example:
```bash
$ mina "run[ls -la]"
```
will connect to the remote server, position to `:deploy_to` folder, and execute `ls -la`.

### `ssh`

Connects to the server, positions to the [`:deploy_to`](#deployto) folder and starts the default shell (determined by the `SHELL` environment variable).

Example:
```bash
$ mina ssh
```
