# frozen_string_literal: true

set :simulate, true
set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, Mina.root_path.to_s
set :shared_paths, ['config/database.yml', 'log']
set :keep_releases, 2
