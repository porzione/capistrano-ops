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

namespace :ops do
  desc 'Temp clean task'
  task :clean do
    on fetch(:ops_servers) do
      within release_path do
        with fetch(:ops_env_variables) do
          execute :echo, :clean, fetch(:ops_clean_options)
        end
      end
    end
  end
end

# Capistrano::DSL.stages.each do |stage|
#   after stage, 'ops:smth'
# end

namespace :load do
  task :defaults do
    set :ops_roles, :all
    set :ops_servers, -> { release_roles(fetch(:ops_roles)) }
    set :ops_env_variables, {}
    set :ops_clean_options, ''
  end
end
