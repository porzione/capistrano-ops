# frozen_string_literal: true

# SSHKit interaction_handler just for to collect remote output
class DumbIH
  def initialize(host)
    @host = host
    @buf = ''
  end

  def on_data(_command, _stream_name, data, _channel)
    if data.match?(/\n$/)
      if @buf.empty?
        print data
      else
        print @buf + data
        @buf = ''
      end
    else
      @buf += data
    end
  end

  def on_extended_data(_ch, _type, data)
    warn "ERR:#{@host}: #{data}"
  end
end

namespace :load do
  task :defaults do
    set :ops_roles, :all
    set :ops_servers, -> { release_roles(fetch(:ops_roles)) }
    set :ops_env_variables, {}
    set :ops_log, 'production'
    # default systemd service like dj.service when called without
    # service name
    set :ops_svc, 'puma.service'
    set :ops_sj_since, '-30m'
    set :ops_nlines, 50
  end
end
