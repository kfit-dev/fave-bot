class PayloadController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
  end

  def create
    event = request.headers["X-GitHub-Event"]
    client = GithubWebhookClient.new(params[:payload], event)
    client.chat
    render plain: "ok"
  end
end