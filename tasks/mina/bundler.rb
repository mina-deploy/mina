require 'mina/default'

set :bundle_bin, 'bundle'
set :bundle_path, 'vendor/bundle'
set :bundle_withouts, 'development test'
set :bundle_options, -> { %{--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment} }
set :shared_dirs, fetch(:shared_dirs, []).push(fetch(:bundle_path))

namespace :bundle do
  desc 'Install gem dependencies using Bundler.'
  task :install do
    comment %{Installing gem dependencies using Bundler}
    command %{#{fetch(:bundle_bin)} install #{fetch(:bundle_options)}}
  end

  desc 'Cleans up unused gems in your bundler directory'
  task :clean do
    comment %{Cleans up unsed gems}
    command %{#{fetch(:bundle_bin)} clean #{fetch(:bundle_options)}}
  end
end
