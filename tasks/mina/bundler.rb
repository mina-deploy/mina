require 'mina/default'

set :bundle_version, 2
set :bundle_bin, 'bundle'
set :bundle_path, 'vendor/bundle'
set :bundle_withouts, 'development test'
set :bundle_config, -> { { without: fetch(:bundle_withouts), path: fetch(:bundle_path),  deployment: true } }
set :bundle_install_options, -> { %{--jobs=3 --retry=3} }
set :bundle_options, -> { %{--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment} }
set :shared_dirs, fetch(:shared_dirs, []).push(fetch(:bundle_path))

namespace :bundle do
  desc 'Install gem dependencies using Bundler.'
  task :install do
    comment %{Installing gem dependencies using Bundler}
    if fetch(:bundle_version) == 2
      fetch(:bundle_config).each do |name, value|
        command %{#{fetch(:bundle_bin)} config set #{name} "#{value}"}
      end
      command %{#{fetch(:bundle_bin)} install #{fetch(:bundle_install_options)}}
    else
      command %{#{fetch(:bundle_bin)} install #{fetch(:bundle_options)}}
    end
  end

  desc 'Cleans up unused gems in your bundler directory'
  task :clean do
    comment %{Cleans up unsed gems}
    command %{#{fetch(:bundle_bin)} clean #{fetch(:bundle_options)}}
  end
end
