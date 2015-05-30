require 'jackal-slack'
require 'pry'

class Jackal::Slack::Notification
  # stub out actual call to slack-notifier
  def post_to_slack(payload, description, attachments)
    payload.set(:attachment, attachments.first)
    payload.set(:description, description)
  end
end

describe Jackal::Slack::Notification do

  before do
    @runner = run_setup(:test)
    # because minitest has no before(:all)? ¯\_(ツ)_/¯
    # TODO, figure out why this crashes actor without memoization
    (track_execution(Jackal::Slack::Notification); $setup_ran = true) unless $setup_ran
  end

  after  { @runner.terminate if @runner && @runner.alive? }

  let(:notification) { Carnivore::Supervisor.supervisor[:jackal_slack_input] }

  describe 'valid?' do
    it 'executes with valid payload' do
      result = transmit_and_wait(valid_payload)
      result.executed?.must_equal true
    end

    it 'fails to execute when webhook_url is missing from config' do
      Carnivore::Config.set(:jackal, :slack, :config, :webhook_url, nil)
      result = transmit_and_wait(valid_payload)
      result.executed?.must_equal false
    end

    it 'fails to execute when expected payload data is missing' do
      arr = [{ :slack => 'bogus' }, { :slack => { :messages => nil }}]
      arr.each do |h|
        result = transmit_and_wait(Jackal::Utils.new_payload(:test, h))
        result.executed?.must_equal false
      end
    end

  end

  describe 'execute' do
    it 'passes correct data/format to slack-notifier' do
      result = transmit_and_wait(valid_payload)
      result.wont_be_nil
      result.get(:data, :slack, :messages).must_equal nil

      result['description'].must_equal 'Result:'

      attachment_expectations = { :text => 'testing',
                                  :fallback => 'testing',
                                  :mrkdwn_in => [:text, :fallback] }
      attachment_expectations.each { |k, v| result['attachment'][k].must_equal(v) }
    end
  end

  private

  def executed?(payload_result)
    payload_result['data']['executed'] == true
  end

  def transmit_and_wait(payload, wait_time = 1)
    notification.transmit(payload)
    source_wait(wait_time) { !MessageStore.messages.empty? }
    MessageStore.messages.pop
  end

  def valid_payload
    h = { :slack => { :messages => [ { :message => 'testing' } ]}}
    Jackal::Utils.new_payload(:test, h)
  end

end
