# frozen_string_literal: true

require 'json'

namespace :config do
  desc 'List servers'
  task :servers, :type do |_, args|
    servers = []
    t = args[:type]
    env.servers.each do |host|
      case t
      when 'json'
        server = {
          host:  host.hostname,
          user:  host.user,
          roles: host.properties.roles.to_a
        }
        server[:port] = host.port if host.port
        servers << server
      when 'full'
        puts "#{host.hostname} #{host.roles.to_a.sort.join ','}"
      else
        puts host.hostname
      end
    end
    puts JSON.pretty_generate(servers) if t == 'json'
  end
end
