# Cookbook

## Multi environment deploy

``` ruby
# deploy.rb

set :domain, '...'

task :staging do
  set :deploy_to, 'home/deploy/www/app-staging/'
  set :rails_env, 'staging'
  set :branch, 'develop'
end

task :production do
  set :deploy_to, 'home/deploy/www/app/'
  set :rails_env, 'production'
  set :branch, 'master'
end

task :deploy do
  ...
end
```

```
$ mina staging deploy
$ mina production deploy
```

## Copy `config/application.yml` to your server

```
task :deploy do
  run(:local) do
    comamnd "scp config/application.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/application.yml"
  end

  deploy do
    invoke ...
  end
end
```

## Deploy plain HTML websites
```
require 'mina/git'
require 'mina/deploy'
...
desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{npm install}
      end
    end
  end
end
```
-------------------------------
\* *feel free to add your own recipes*
