# config valid for current version and patch releases of Capistrano
lock '~> 3.11.2'

set :application, 'QnA'
set :repo_url, 'git@github.com:natalya-bogdanova/QnA.git'

set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

after 'deploy:publishing', 'unicorn:restart'
