module GithubWebhookService
  class Parser
    attr_accessor :comment, :pull_request, :issue, :sender
    def initialize(comment: {}, pull_request: {}, issue: {}, sender: {})
      @comment = Comment.new(comment: comment) if comment.present?
      @pull_request = PullRequest.new(pull_request: pull_request) if pull_request.present?
      @issue = Issue.new(issue: issue) if issue.present?
      @sender = Sender.new(sender: sender) if sender.present?
    end
  end

  class Comment
    attr_accessor :commentter, :url, :body
    def initialize(comment:)
      @commentter = comment[:user][:login]
      @url = comment[:html_url]
      @body = comment[:body]
    end

    def mentioned
      @body.scan(/@\w+/)
    end
  end

  class PullRequest
    attr_accessor :title, :owner, :assignee, :url, :merged
    def initialize(pull_request:)
      @title = pull_request[:title]
      @owner = pull_request.dig(:user, :login)
      @assignee = pull_request.dig(:assignee, :login)
      @url = pull_request[:html_url]
      @merged = pull_request[:merged]
    end
  end

  class Issue
    attr_accessor :title, :owner
    def initialize(issue:)
      @title = issue[:title]
      @owner = issue[:user][:login]
    end
  end

  class Sender
    attr_accessor :name
    def initialize(sender:)
      @name = sender[:login]
    end
  end
end
