module GithubWebhookService
  # Entry point of each payload parser
  class Parser
    attr_accessor :comment, :pull_request, :issue, :sender, :review
    def initialize(comment: {}, pull_request: {}, issue: {}, sender: {},
                   review: {})
      @comment = Comment.new(comment: comment) if comment.present?
      @pull_request = PullRequest.new(pull_request: pull_request) if pull_request.present?
      @issue = Issue.new(issue: issue) if issue.present?
      @sender = Sender.new(sender: sender) if sender.present?
      @review = Review.new(review: review) if review.present?
    end
  end

  # payload[:review] section parser
  class Review
    attr_accessor :reviewer, :url, :body, :state
    def initialize(review:)
      @reviewer = review[:user][:login]
      @url = review[:html_url]
      @body = review[:body]
      @state = review[:state]
    end
  end

  # payload[:comment] section parser
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

  # payload[:pull_request] section parser
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

  # payload[:issue] section parser
  class Issue
    attr_accessor :title, :owner
    def initialize(issue:)
      @title = issue[:title]
      @owner = issue[:user][:login]
    end
  end

  # payload[:sender] section parser
  class Sender
    attr_accessor :name
    def initialize(sender:)
      @name = sender[:login]
    end
  end
end
