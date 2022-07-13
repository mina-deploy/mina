# Install Task

The install task creates a template `deploy.rb` file you can use as the basis for your own tasks.

This task is loaded automatically when needed, you don't have to require it manually.

When you invoke the task:
```bash
$ mina init
```
Mina will copy the template config to the `config/deploy.rb` path.
