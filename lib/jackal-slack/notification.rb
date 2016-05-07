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
          payload.get(:data, :slack, :messages)
        end
      end

      # Send messages to Slack
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |payload|
          if(config[:webhook_url])
            payload[:data][:slack][:messages].each do |slack_msg|
              msg = slack_msg[:message].to_s
              msg_attachment = {
                fallback: msg,
                text: msg,
                color: slack_msg[:color],
                mrkdwn_in: slack_msg.fetch(:markdown, true) ? [:text, :fallback] : []
              }

              desc = slack_msg.fetch(:description, 'Result:')
              post_to_slack(desc, [msg_attachment])
            end
            payload[:data][:slack].delete(:messages)
          else
            warn 'Cannot send slack notifications. No web hook URL defined.'
          end
          job_completed(:slack, payload, message)
        end
      end

      # Post message to Slack
      #
      # @param description [String] slack output description
      # @param attachments [Array<Hash>] slack output attachments
      # @return [TrueClass]
      def post_to_slack(description, attachments)
        notifier = ::Slack::Notifier.new(config[:webhook_url])
        notifier.ping(description, attachments: attachments)
        true
      end

    end
  end
end
