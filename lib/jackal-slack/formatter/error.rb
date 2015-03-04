require 'jackal-slack'

module Jackal
  module Slack
    module Formatter
      # Format job errors for display
      class Error < Jackal::Formatter

        # Source service
        SOURCE = '*'
        # Destination service
        DESTINATION = 'slack'

        # Provide error message output
        #
        # @param payload [Smash]
        def format(payload)
          if(payload[:status] == 'error' && payload[:error])
            msgs = payload.fetch(:data, :slack, :messages, [])
            msgs.push(
              Smash.new(
                :message => "#{payload.get(:error, :reason)} (`#{payload.get(:error, :callback)}`)",
                :color => 'danger',
                :description => "Job Failure (#{payload[:id]})"
              )
            )
            payload.set(:data, :slack, :messages, msgs)
          end
        end

      end
    end
  end
end
