# frozen_string_literal: true

namespace :logs do
  NLINES = 500

  desc 'tail specified log or all'
  task :tail, :file do |_, args|
    SSHKit.config.use_format :blackhole
    file = args[:file] || 'production'
    cmd = "-f #{shared_path}/log/#{file}.log -n #{NLINES}"
    on roles(:app), in: :parallel do |host|
      execute :tail, cmd, interaction_handler: DumbIH.new(host)
    end
  end
end
