class PayloadController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :verify_signature, only: :create

  def index
  end
  
  def create
    event = request.headers["X-GitHub-Event"]
    client = GithubWebhookService::Client.new(params[:payload], event)
    client.chat
    render plain: "ok"
  end

  private
  
  def verify_signature
    request.body.rewind
    payload_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      render status: 401
    end
  end
end