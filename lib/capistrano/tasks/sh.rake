# frozen_string_literal: true

namespace :shell do
  desc 'Run shell command'
  task :sh, :cmd, :user do |_t, args|
    about('command?') unless args[:cmd]

    on fetch(:ops_servers), in: :sequence do |_host|
      with fetch(:ops_env_variables) do
        within release_path do
          host.user = args[:user] if args[:user]
          execute args[:cmd]
        end
      end
    end
  end

  desc 'Run shell command in parallel'
  task :psh, :cmd, :user do |_t, args|
    about('command?') unless args[:cmd]

    on fetch(:ops_servers), in: :parallel do |_host|
      with fetch(:ops_env_variables) do
        within release_path do
          host.user = args[:user] if args[:user]
          execute args[:cmd]
        end
      end
    end
  end

  desc 'Run shell command with sourced ~/.bash_profile'
  task :ish, :cmd, :user do |_t, args|
    about('command?') unless args[:cmd]

    cmd = "source ~/.bash_profile && #{args[:cmd]}"
    on fetch(:ops_servers), in: :sequence do |_host|
      with fetch(:ops_env_variables) do
        within release_path do
          host.user = args[:user] if args[:user]
          execute :'/bin/true', "&& #{cmd}"
        end
      end
    end
  end

  # task :echo do
  #   on fetch(:ops_servers) do
  #     within release_path do
  #       with fetch(:ops_env_variables) do
  #         execute :echo, fetch(:ops_echo_options)
  #       end
  #     end
  #   end
  # end
end
