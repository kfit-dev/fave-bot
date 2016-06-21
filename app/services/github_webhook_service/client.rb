module GithubWebhookService
  class Client
    def initialize(payload, event)
      @payload = payload
      @event = event
      @action = @payload[:action]
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
      parser = GithubWebhookService::Parser.new(comment: @payload[:comment], issue: @payload[:issue])
      comment = parser.comment
      comment_mention_message(comment.commentter, comment.url, comment.mentioned) if comment.mentioned.present?
      issue = parser.issue
      user = User.find_by_github_username(issue.owner)
      return if user.nil?
      text = %Q(
#{comment.commentter} has #{@action} a review comment.
Comment: #{comment.body}.
Pull Request: *#{issue.title}*
Url: #{comment.url})
      post_message_as_user(user.channel_id, text)
    end

    def pull_request_message
      parser = GithubWebhookService::Parser.new(pull_request: @payload[:pull_request], sender: @payload[:sender])
      pull_request = parser.pull_request
      sender = parser.sender
      case @action
      when "assigned"
        user = User.find_by(github_username: pull_request.assignee)
        return if user.nil?
        text = %Q(
#{pull_request.owner} has assigned you on pull request *#{pull_request.title}*.
Url: #{pull_request.url})
        post_message_as_user(user.channel_id, text)
      when "closed"
        user = User.find_by(github_username: pull_request.owner)
        return if user.nil?
        text = %Q(
#{pull_request.title} has been closed by #{sender.name}
Url: #{pull_request.url})
        post_message_as_user(user.channel_id, text)
      end
    end

    def pull_request_review_comment_message
      parser = GithubWebhookService::Parser.new(comment: @payload[:comment], pull_request: @payload[:pull_request])
      comment = parser.comment
      pull_request = parser.pull_request
      comment_mention_message(comment.commentter, comment.url, comment.mentioned) if comment.mentioned.present?
      user = User.find_by_github_username(pull_request.owner)
      return if user.nil? || comment.commentter == "houndci-bot"
        text = %Q(
#{comment.commentter} has #{@action} a review comment.
Comment: #{comment.body}.
Pull Request: *#{pull_request.title}*.
Url: #{comment.url})
      post_message_as_user(user.channel_id, text: text)
    end

    def comment_mention_message(commenter, url, mentioned)
      mentioned.each do |name|
        name.slice!(0)
        user = User.find_by(github_username: name)
        next unless user.present?
         text = %Q(
#{commenter} has mentioned you in a comment.
Url: #{url})
      post_message_as_user(user.channel_id, text: text)
      end
    end

    def commit_comment_message
      parser = GithubWebhookService::Parser.new(comment: @payload[:comment], pull_request: @payload[:pull_request])
      comment = parser.comment
      comment_mention_message(comment.commentter, comment.url, comment.mentioned) if comment.mentioned.present?
    end

    def unhandle_event_message
      post_message_as_user('D1GJCSMHC', "unhandle webhook event: #{@event}")
    end

    def post_message_as_user(channel, text)
    	@client.chat_postMessage(channel: channel, text: text, as_user: true)
    end
  end
end
