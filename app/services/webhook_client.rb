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
    comment_body = @payload[:comment][:body]
    mentioned = comment_body.scan(/@\w+/)
    if mentioned.present?
      mentioned.each do |name|
        name.slice!(0)
        user = User.find_by(github_username: name)
        next unless user.present?
        @client.chat_postMessage(channel: user.channel_id, text: "#{@event}", as_user: true)
        @client.chat_postMessage(channel: user.channel_id, text: "#{comment_body}", as_user: true)
      end
    end
  end

  def pull_request_review_comment_message
  end

  def commit_comment_message
  end

  def unhandle_event_message
    @client.chat_postMessage(channel: 'D1GJCSMHC', text: "unhandle webhook event: #{@event}", as_user: true)
  end
end
