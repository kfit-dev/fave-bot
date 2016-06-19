class GithubWebhookClient
  def initialize(payload, event)
    @payload = payload
    @event = event
  end

  def chat
    @client = Slack::Web::Client.new
    case @event
    when "issue_comment"
      issue_comment_message
    when "pull_request_review_comment"
      pull_request_review_comment_message
    when "commit_comment"
      commit_comment_message
    when "pull_request"
      pull_request_message
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
        sender = @payload[:sender][:login]
        pr_comment_url = @payload[:comment][:html_url]
        user = User.find_by(github_username: name)
        next unless user.present?
        text = "#{sender} has mentioned you in a pull request comment. Please refer to this url: #{pr_comment_url}"
        @client.chat_postMessage(channel: user.channel_id, text: "#{text}", as_user: true)
      end
    end
  end

  def pull_request_message
    action = @payload[:action]
    if action == "assigned"
      pr = @payload[:pull_request]
      assigner = pr[:user][:login]
      assignee = pr[:assignee][:login]
      pr_url = pr[:url]
      pr_number = pr[:number]
      pr_title = pr[:title]
      user = User.find_by(github_username: assignee)
      return if user.nil?
      @client.chat_postMessage(channel: user.channel_id, text: "#{assigner} has assigned you on PR #{pr_title}, url: #{pr_url}", as_user: true)
    end
  end

  def pull_request_review_comment_message
    action = @payload[:action]
    comment = @payload[:comment]
    commenter = comment[:user][:login]
    comment_url = comment[:html_url]
    pr_title = @payload[:pull_request][:title]
    comment_body = comment[:body]
    pr_owner = @payload[:pull_request][:user][:login]
    mentioned = comment_body.scan(/@\w+/)
    comment_mention_message(commenter, comment_url, mentioned) if mentioned.present?
    user = User.find_by_github_username(pr_owner)
    return if user.nil? || commenter == "houndci-bot"
      text = %Q(
#{commenter} has #{action} a review comment.
Comment: #{comment_body}.
Pull Request: *#{pr_title}*.
Url: #{comment_url})
      @client.chat_postMessage(channel: user.channel_id, text: text, as_user: true)
  end

  def comment_mention_message(commenter, url, mentioned)
    mentioned.each do |name|
      name.slice!(0)
      user = User.find_by(github_username: name)
      next unless user.present?
       text = %Q(
#{commenter} has mentioned you in a comment.
Url: #{url})
    @client.chat_postMessage(channel: user.channel_id, text: text, as_user: true)
    end
  end

  def commit_comment_message
    action = @payload[:action]
    comment = @payload[:comment]
    comment_url = comment[:html_url]
    commenter = comment[:user][:login]
    comment_body = comment[:body]
    mentioned = comment_body.scan(/@\w+/)
    comment_mention_message(commenter, comment_url, mentioned) if mentioned.present?
  end

  def unhandle_event_message
    @client.chat_postMessage(channel: 'D1GJCSMHC', text: "unhandle webhook event: #{@event}", as_user: true)
  end
end
