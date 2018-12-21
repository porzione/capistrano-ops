# frozen_string_literal: true

require 'tempfile'

namespace :r_pg do
  include Database
  DEL = %q(grep -v -E '^((CREATE|DROP)\ EXTENSION|COMMENT|SCHEMA\ ON)').freeze

  # cap stage pg:dump[~/tmp/db.sql.xz]
  # TODO: select compress tool from file ext gz|xz|bz2
  desc 'Dump first'
  task :dump, :file do |_, args|
    abort 'no file provided' unless args[:file]
    yt = Tempfile.new('db_yml')
    yf = "#{fetch :deploy_to}/current/config/database.yml"
    on roles(:app), in: :sequence do
      download! yf, yt.path
      db_url = yml2url(yt.path)
      tmp = capture :mktemp
      execute :pg_dump, "-c '#{db_url}' | #{DEL} | xz > #{tmp}"
      download! tmp, File.expand_path(args[:file])
      execute :rm, tmp
      break
    end
    yt.unlink
  end

  # cap stage pg:dump_all[~/tmp/]
  desc 'Dump all'
  task :dump_all, :dir do |_, args|
    abort 'no dir provided' unless args[:dir]
    dir = File.expand_path(args[:dir])
    abort 'it is not dir' unless File.directory?(dir)
    yt = Tempfile.new('db_yml')
    yf = "#{fetch :deploy_to}/current/config/database.yml"
    on roles(:app) do
      download! yf, yt.path
      db_url = yml2url(yt.path)
      tmp = capture :mktemp
      execute :pg_dump, "-c '#{db_url}' | #{DEL} | xz > #{tmp}"
      download! tmp, "#{dir}/#{host.hostname}.sql.xz"
      execute :rm, tmp
    end
  end

  # cap -z 1.2.3.4 stage pg:restore[~/tmp/com1234.sql.xz]
  # TODO: restore
  # desc 'Restore'
  # task :restore, :file do |_, args|
  #   abort 'no file provided' unless args[:file]
  #   on roles(:app) do
  #     db_url =
  #     tmp = capture :mktemp
  #     upload! File.expand_path(args[:file]), tmp
  #     execute :xzcat, "#{tmp} | psql '#{db_url}'"
  #     execute :rm, tmp
  #   end
  # end
end
