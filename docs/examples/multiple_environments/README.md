# Multiple environments

A project can have multiple environments deployed to different servers. For example, your web application may have a staging and a production environment, and you'd like to deploy to both of those environments with Mina.

Let's imagine that we have a single codebase with two environments: staging and production. Let's also imagine that these environments have different deploy rules:
- their domains are different
- the folder on each server is different
- we want to SSH to each server with a different user
- we want to use different Git branches for each environment

To achieve this behavior with a single deploy script, what we can do is define separate tasks for each environment, each with their own variables, like so:
```ruby
# config/deploy.rb

set :repository, 'git@github.com:org/repo.git'

task :staging do
  set :domain, 'staging.example.com'
  set :deploy_to, 'home/deploy/www/app-staging/'
  set :user, 'staging_ssh_user'
  set :branch, 'staging'
end

task :production do
  set :domain, 'production.example.com'
  set :deploy_to, 'home/deploy/www/app-production/'
  set :user, 'production_ssh_user'
  set :branch, 'master'
end
```

Variables outside the tasks are common to both environments, in this case the `repository` variable is used in both environments.

Let's also say that we have a deploy task in the same script:
```ruby
task :deploy do
  deploy do
    invoke 'git:clone'
  end
end
```

Now, when we want to deploy to the staging environment, we can simply do this:
```bash
$ mina staging deploy
```

This command will first invoke the `staging` task (thereby setting variables necessary for SSH-ing to the staging environment), and then invoke the `deploy` task, which will perform the actual deploy.

When we want to deploy to production, we similarily do:
```bash
$ mina production deploy
```

Find the complete `deploy.rb` example [here](./deploy.rb).

