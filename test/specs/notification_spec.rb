require 'jackal-slack'
require 'pry'

class Jackal::Slack::Notification
  def post_to_slack(description, attachments)
    $attachments = attachments
    $description = description
  end
end

describe Jackal::Slack::Notification do

  before do
    @runner = run_setup(:test)
  end

  after do
    @runner.terminate if @runner && @runner.alive?
  end

  let(:notification) do
    Carnivore::Supervisor.supervisor[:jackal_slack_input]
  end

  describe 'execute' do
    it 'passes correct data/format to slack-notifier' do
      notification.transmit(slack_payload)
      source_wait { !MessageStore.messages.empty? }
      result = MessageStore.messages.first

      attachment  = $attachments.first

      attachment[:text].must_equal 'testing'
      attachment[:fallback].must_equal 'testing'
      attachment[:mrkdwn_in].must_equal [:text, :fallback]

      $description.must_equal 'Result:'
    end
  end

  private

  def slack_payload
    h = { :slack => { :messages => [ { :message => 'testing' } ] } }
    Jackal::Utils.new_payload(:test, h)
  end

end
