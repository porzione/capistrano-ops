# frozen_string_literal: true

namespace :deploy do
  desc 'Run shell command as root'
  task :rootsh, :cmd do |_t, args|
    about('command') unless args[:cmd]

    on roles(:app), in: :sequence do |host|
      host.user = 'root'
      execute args[:cmd]
    end
  end

  desc 'Run shell command'
  task :sh, :cmd do |_t, args|
    about('command') unless args[:cmd]

    cmd = "source ~/.bash_profile && #{args[:cmd]}"
    on roles(:app), in: :sequence do |_host|
      execute cmd
    end
  end

  # desc 'Temp clean task'
  # task :clean do
  #   on fetch(:ops_servers) do
  #     within release_path do
  #       with fetch(:ops_env_variables) do
  #         execute :echo, :clean, fetch(:ops_clean_options)
  #       end
  #     end
  #   end
  # end
end
