require 'jackal-slack'
module Jackal
  # Status on Slack
  module Slack
    class Notification < Jackal::Callback

      def setup(*_)
        require 'slack-notifier'
      end

      # Validity of message
      #
      # @param message [Carnivore::Message]
      # @return [Truthy, Falsey]
      def valid?(message)
        super do |payload|
          payload.get(:data, :slack)
        end
      end

      def execute(message)
        failure_wrap(message) do |payload|
          payload[:data][:slack][:messages].each do |slack_msg|
            notifier = slack_notifier
            msg = slack_msg[:message].to_s
            a_ok_note = {
              fallback: msg,
              text: msg,
              color: slack_msg[:color]
            }
            notifier.ping("Test kitchen run result:", attachments: [a_ok_note])
          end

          job_completed(:slack_notification, payload, message)
        end
      end

      # Return slack_notifier object using team & token from data or config
      # depending on what's loaded in the environment
      def slack_notifier
        ::Slack::Notifier.new(Carnivore::Config.get(:slack, :webhook_url))
      end

    end
  end
end
