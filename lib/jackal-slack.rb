require 'jackal'

module Jackal
  module Slack
    autoload :Notification, 'jackal-slack/notification'
  end
end

require 'jackal-slack/formatter'
require 'jackal-slack/version'

Jackal.service(
  :slack,
  :description => 'Send messages to Slack',
  :configuration => {
    :webhook_url => {
      :description => 'Webhook URL to send messages'
    }
  }
)
