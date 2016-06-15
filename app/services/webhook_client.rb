class WebhookClient
  def initialize(payload, event)
    @payload = payload
    @event = event
  end

  def chat
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: 'D1GJCSMHC', text: "#{@event}", as_user: true)
    client.chat_postMessage(channel: 'D1GJCSMHC', text: "lala", as_user: true)
  end
end