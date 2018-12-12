# frozen_string_literal: true

namespace :deploy do
  desc 'Upload file'
  task :upload, :src, :dst, :user do |_, args|
    abort 'provide src and dst' unless args[:src] && args[:dst]

    on roles(:app), in: :parallel do
      host.user = args[:user] if args[:user]
      upload! args[:src], args[:dst]
    end
  end

  desc 'Download file'
  task :download, :src, :dst, :user do |_, args|
    abort 'provide src and dst' unless args[:src] && args[:dst]

    on roles(:app), in: :parallel do
      host.user = args[:user] if args[:user]
      download! args[:src], args[:dst]
    end
  end

  task :ssh_copy_id, :src do |_, args|
    src = File.expand_path args[:src]
    abort 'provide existing src' unless File.exist?(src)

    on roles(:app) do |host|
      user = args[:user] || host.user
      cmd = "ssh-copy-id -i #{src} -p #{host.port} #{user}@#{host.hostname}"
      run_locally do
        execute cmd
      end
    end
  end
end
