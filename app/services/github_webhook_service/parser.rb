module GithubWebhookService
  class Parser
    attr_accessor :comment, :pull_request, :issue
    def initialize(comment: {}, pull_request: {}, issue: {})
      @comment = Comment.new(comment: comment) if comment.present?
      @pull_request = PullRequest.new(pull_request: pull_request) if pull_request.present?
      @issue = Issue.new(issue: issue) if issue.present?
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
    attr_accessor :title, :owner, :assignee, :url
    def initialize(pull_request:)
      @title = pull_request[:title]
      @owner = pull_request[:user][:login]
      @assignee = pull_request[:assignee][:login]
      @url = pull_request[:html_url]
    end
  end

  class Issue
    attr_accessor :title, :owner
    def initialize(issue:)
      @title = issue[:title]
      @owner = issue[:user][:login]
    end
  end
end