# frozen_string_literal: true

MAIL = <<~MAIL
  mailer = Class.new(ActionMailer::Base) do
    def test_msg
      mail(
        from:    '%s',
        to:      '%s',
        subject: 'Test Message',
        body:    'Test message body')
    end
  end
  mailer.test_msg.deliver!
MAIL

namespace :r_mailer do
  desc 'Test mailer'
  task :test, :from, :to do |_, args|
    abort 'no provided from addr' unless args[:from]
    abort 'no provided to addr' unless args[:to]
    rbcode = StringIO.new format(MAIL, args[:from], args[:to])
    SSHKit.config.use_format :simpletext
    SSHKit::Backend::Netssh.configure do |ssh|
      ssh.connection_timeout = 30
      ssh.pty = true
    end
    on roles(:app), in: :sequence do
      t = capture(:mktemp)
      upload! rbcode, t
      with fetch(:ops_env_variables) do
        within release_path do
          cmd = "-ic 'source ~/.bash_profile && bundle exec rails runner #{t}'"
          execute :bash, cmd
          execute :rm, t
        end
      end
    end
  end
end
