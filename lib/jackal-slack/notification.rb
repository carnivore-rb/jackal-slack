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
          config[:webhook_url] &&
            payload.get(:data, :slack) &&
            !payload.fetch(:data, :slack, :messages, []).empty?
        end
      end

      def execute(message)
        failure_wrap(message) do |payload|
          payload[:data][:slack][:messages].each do |slack_msg|
            msg = slack_msg[:message].to_s
            msg_attachment = {
              fallback: msg,
              text: msg,
              color: slack_msg[:color],
              mrkdwn_in: slack_msg.fetch(:markdown, true) ? [:text, :fallback] : []
            }

            desc = slack_msg.fetch(:description, 'Result:')
            post_to_slack(payload, desc, [msg_attachment])
          end
          job_completed(:slack_notification, payload, message)
        end
      end

      # Isolate this method so it can be stubbed out in tests
      def post_to_slack(payload, description, attachments)
        notifier = ::Slack::Notifier.new(config[:webhook_url])
        notifier.ping(description, attachments: attachments)
      end

    end
  end
end
