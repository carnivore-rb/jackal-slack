require 'jackal'

module Jackal
  module Slack
    autoload :Notification, 'jackal-slack/notification'
  end
end

require 'jackal-slack/formatter'
require 'jackal-slack/version'
