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
