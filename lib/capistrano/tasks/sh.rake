# frozen_string_literal: true

namespace :deploy do
  desc 'Run shell command as root'
  task :rootsh, :cmd do |_t, args|
    if args[:cmd]
      on roles(:app), in: :sequence do |host|
        host.user = 'root'
        execute args[:cmd]
      end
    end
  end

  desc 'Run shell command'
  task :sh, :cmd do |_t, args|
    if args[:cmd]
      cmd = "source ~/.bash_profile && #{args[:cmd]}"
      on roles(:app), in: :sequence do |_host|
        execute cmd
      end
    end
  end
end
