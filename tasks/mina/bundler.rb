# frozen_string_literal: true

require 'mina/default'

set :bundle_bin, 'bundle'
set :bundle_path, 'vendor/bundle'
set :bundle_withouts, 'development test'
set :bundle_options, -> { %(--without #{fetch(:bundle_withouts)} --path "#{fetch(:bundle_path)}" --deployment) }
set :shared_dirs, fetch(:shared_dirs, []).push(fetch(:bundle_path))

namespace :bundle do
  desc 'Install gem dependencies using Bundler.'
  task :install do
    comment %(Installing gem dependencies using Bundler)
    command %(#{fetch(:bundle_bin)} config set --local without '#{fetch(:bundle_withouts)}')
    command %(#{fetch(:bundle_bin)} config set --local path '#{fetch(:bundle_path)}')
    command %(#{fetch(:bundle_bin)} config set --local deployment 'true')
    command %(#{fetch(:bundle_bin)} install)
  end

  desc 'Cleans up unused gems in your bundler directory'
  task :clean do
    comment %(Cleaning up unused gems)
    command %(#{fetch(:bundle_bin)} clean)
  end
end
