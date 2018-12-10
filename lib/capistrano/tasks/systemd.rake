# frozen_string_literal: true

namespace :systemd do
  J_LEN = 200
  SC = :systemctl
  JC = :journalctl

  desc 'Systemd list units'
  task :list do
    on roles(:app), in: :sequence do
      execute SC, '--user -l list-unit-files'
    end
  end

  desc 'Systemd list timers'
  task :timers do
    on roles(:app), in: :sequence do
      execute SC, '--user list-timers -l --user --all '
    end
  end

  desc 'Systemd reload daemon'
  task :reload do
    on roles(:app) do
      execute SC, '--user daemon-reload'
    end
  end

  desc 'Systemd unit status'
  task :status, :unit do |_t, args|
    on roles(:app), in: :sequence do
      puts capture(SC, "-l --user --no-pager status #{args[:unit]}")
    end
  end

  # time format https://www.freedesktop.org/software/systemd/man/systemd.time.html
  # systemd:uj[puma,-2h]
  desc 'Systemd unit journal'
  task :uj, :unit, :since, :until do |_t, args|
    cmd = '--no-hostname --no-pager _UID=$(id -u)'
    cmd = "#{cmd} --user-unit #{args[:unit]}" if args[:unit]
    since = args[:since] || '-1h'
    cmd = "#{cmd} -S #{since}"
    cmd = "#{cmd} -U #{args[:until]}" if args[:until]
    SSHKit.config.use_format :blackhole
    on roles(:app) do
      execute JC, cmd, interaction_handler: DumbIH.new(host)
    end
  end

  desc 'Systemd journal follow with optional user unit'
  task :ujf, :unit do |_t, args|
    cmd = "--no-hostname --no-pager -f -n#{J_LEN} _UID=$(id -u)"
    cmd = "#{cmd} --user-unit #{args[:unit]}" if args[:unit]
    SSHKit.config.use_format :blackhole
    on roles(:app) do
      execute JC, cmd, interaction_handler: DumbIH.new(host)
    end
  end

  desc 'Systemd unit is-active'
  task :is_active, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user is-active #{args[:unit]}; true"
      end
    end
  end

  desc 'Systemd unit is-failed'
  task :is_failed, :unit do |_t, args|
    if args[:unit]
      on roles(:app) do |host|
        res = test(SC, "--user is-failed #{args[:unit]}")
        msg = "#{host}: #{res ? 'Fail' : 'OK'}"
        info msg
      end
    end
  end

  desc 'Systemd show unit'
  task :show, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user show #{args[:unit]}"
      end
    end
  end

  desc 'Systemd enable unit'
  task :enable, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user enable #{args[:unit]}"
      end
    end
  end

  desc 'Systemd disable unit'
  task :disable, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user disable #{args[:unit]}"
      end
    end
  end

  desc 'Systemd reset failed unit'
  task :reset, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user reset-failed #{args[:unit]}"
      end
    end
  end

  desc 'Systemd start unit'
  task :start, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user start #{args[:unit]}"
      end
    end
  end

  desc 'Systemd stop unit'
  task :stop, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user stop #{args[:unit]}"
      end
    end
  end

  desc 'Systemd reload unit'
  task :reload, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user reload #{args[:unit]}"
      end
    end
  end

  desc 'Systemd restart unit'
  task :restart, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user restart #{args[:unit]}"
      end
    end
  end

  desc 'Systemd reload-or-restart unit'
  task :relrst, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user reload-or-restart #{args[:unit]}"
      end
    end
  end

  desc 'Systemd kill unit'
  task :kill, :unit do |_t, args|
    if args[:unit]
      on roles(:app), in: :sequence do
        execute SC, "--user kill #{args[:unit]}"
      end
    end
  end
end
