class WebhookClient
  def initialize(payload, event)
    @payload = payload
    @event = event
  end

  def chat
    @client = Slack::Web::Client.new
    case @event
    when "issue_comment"
      issue_comment_message
    when "pull_request_review_comment_message"
      pull_request_review_comment_message
    when "commit_comment_message"
      commit_comment_message
    else
      unhandle_event_message
    end
  end

  private

  def issue_comment_message
    @client.chat_postMessage(channel: 'D1GJCSMHC', text: "#{@event}", as_user: true)
    @client.chat_postMessage(channel: 'D1GJCSMHC', text: "#{@payload[:comment][:body]}", as_user: true)
  end

  def pull_request_review_comment_message
  end

  def commit_comment_message
  end

  def unhandle_event_message
    @client.chat_postMessage(channel: 'D1GJCSMHC', text: "#{@event}", as_user: true)
  end
end