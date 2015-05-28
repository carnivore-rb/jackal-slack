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
  s.license = 'Apache 2.0'
  s.require_path = 'lib'
  s.add_dependency 'jackal', '>= 0.3.3', '< 1.0'
  s.add_dependency 'slack-notifier', '~> 1.0'

  s.add_development_dependency 'carnivore-actor'

  s.files = Dir['lib/**/*'] + %w(jackal-slack.gemspec README.md CHANGELOG.md CONTRIBUTING.md LICENSE)
end
