Configuration.new do

  jackal do
    require ["carnivore-actor", "jackal-slack"]

    slack do
      config do
        webhook_url 'https://hooks.slack.com/services/bogus/endpoint'
        channel '#foo'
        username 'jackal-slack-test'
      end

      sources do
        input  { type 'actor' }
        output { type 'spec' }
      end

      callbacks ['Jackal::Slack::Notification']
    end
  end

end
