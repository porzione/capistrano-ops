# frozen_string_literal: true

namespace :systemd do
  SC = :systemctl
  JC = :journalctl

  desc 'Systemd list units'
  task :list do
    on fetch(:ops_servers), in: :sequence do
      execute SC, '--user -l list-unit-files'
    end
  end

  desc 'Systemd list timers'
  task :timers do
    on fetch(:ops_servers), in: :sequence do
      execute SC, '--user list-timers -l --user --all '
    end
  end

  desc 'Systemd reload daemon'
  task :reload do
    on fetch(:ops_servers) do
      execute SC, '--user daemon-reload'
    end
  end

  desc 'Systemd unit status'
  task :status, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      puts capture(SC, "-l --user --no-pager status #{unit}; true")
    end
  end

  # time format: systemd:uj[puma,-2h]
  # https://www.freedesktop.org/software/systemd/man/systemd.time.html
  desc 'Systemd unit journal'
  task :uj, :unit, :since, :until do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    cmd = "--no-hostname --no-pager _UID=$(id -u) --user-unit #{unit}"
    since = args[:since] || fetch(:ops_sj_since)
    cmd = "#{cmd} -S #{since}"
    cmd = "#{cmd} -U #{args[:until]}" if args[:until]
    SSHKit.config.use_format :blackhole
    on fetch(:ops_servers) do
      execute JC, cmd, interaction_handler: DumbIH.new(host)
    end
  end

  desc 'Systemd journal follow with optional user unit'
  task :ujf, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    cmd = "--no-hostname --no-pager -f -n#{fetch :ops_nlines} " \
          "--user-unit #{unit} _UID=$(id -u)"
    SSHKit.config.use_format :blackhole
    on fetch(:ops_servers) do
      execute JC, cmd, interaction_handler: DumbIH.new(host)
    end
  end

  desc 'Systemd unit is-active'
  task :is_active, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user is-active #{unit}; true"
    end
  end

  desc 'Systemd unit is-failed'
  task :is_failed, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers) do |host|
      res = test(SC, "--user is-failed #{unit}")
      msg = "#{host}: #{res ? 'Fail' : 'OK'}"
      info msg
    end
  end

  desc 'Systemd show unit'
  task :show, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user show #{unit}"
    end
  end

  desc 'Systemd enable unit'
  task :enable, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user enable #{unit}"
    end
  end

  desc 'Systemd disable unit'
  task :disable, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user disable #{unit}"
    end
  end

  desc 'Systemd reset failed unit'
  task :reset, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user reset-failed #{unit}"
    end
  end

  desc 'Systemd start unit'
  task :start, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user start #{unit}"
    end
  end

  desc 'Systemd stop unit'
  task :stop, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user stop #{unit}"
    end
  end

  desc 'Systemd reload unit'
  task :reload, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user reload #{unit}"
    end
  end

  desc 'Systemd restart unit'
  task :restart, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user restart #{unit}"
    end
  end

  desc 'Systemd reload-or-restart unit'
  task :relrst, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user reload-or-restart #{unit}"
    end
  end

  desc 'Systemd kill unit'
  task :kill, :unit do |_t, args|
    unit = args[:unit] || fetch(:ops_svc)
    on fetch(:ops_servers), in: :sequence do
      execute SC, "--user kill #{unit}"
    end
  end
end
