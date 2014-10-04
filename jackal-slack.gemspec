$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'jackal-slack/version'
Gem::Specification.new do |s|
  s.name = 'jackal-slack'
  s.version = Jackal::Slack::VERSION.version
  s.summary = 'Jackal Slack'
  s.author = 'Heavywater'
  s.email = 'support@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/jackal-slack'
  s.description = 'Jackal Slack'
  s.require_path = 'lib'
  s.add_dependency 'jackal'
  s.add_dependency 'slack-notifier'
  s.files = Dir['**/*']
end
