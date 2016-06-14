class PayloadController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
  end

  def create
    render plain: "OK"
  end
end