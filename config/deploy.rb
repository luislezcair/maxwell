# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'maxwell'
set :repo_url, 'git@github.com:luislezcair/maxwell.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log',
#                      color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, '.rbenv-vars'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
#                      'public/system'
remove :linked_dirs, 'public/assets'

append :linked_dirs,
       'public/packs',
       'public/system',
       'public/files',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'log'

set :rbenv_ruby, File.read('.ruby-version').strip

# Whenever config
set :whenever_environment, fetch(:stage)
set :whenever_variables, lambda {
  "'environment=#{fetch :whenever_environment}" \
  "&rbenv_root=#{fetch :rbenv_path}'"
}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before
# first deploy.
# set :ssh_options, verify_host_key: :secure

SSHKit.config.command_map[:sidekiq] = 'bundle exec sidekiq'
SSHKit.config.command_map[:sidekiqctl] = 'bundle exec sidekiqctl'

# Como no usarmos Sprockets, no necesitamos ejecutar esta parte del deploy de
# assets.
Rake::Task['deploy:assets:backup_manifest'].clear_actions
