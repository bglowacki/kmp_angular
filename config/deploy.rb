# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'deployapp'
set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{node_modules app/bower_components}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :default_env, {
    path: ["/usr/local/rbenv/shims",
           "#{shared_path}/node_modules/bower/bin",
           "#{shared_path}/node_modules/grunt-cli/bin",
           "/usr/local/rbenv/versions/#{fetch(:rbenv_ruby)}/bin",
           "$PATH"].join(":")
}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :setup do
  task :yo do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :npm, "install yo"
      end
    end
  end
end


namespace :deploy do
  task :bower_install do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bower, "install"
      end
    end
  end
  after :published, :bower_install

  task :build do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :grunt, "build"
      end
    end
  end
  after :bower_install, :build


end
