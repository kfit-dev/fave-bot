$:.unshift File.dirname(__FILE__)
require 'bot'

Thread.abort_on_exception = true

Thread.new do
  SlackGithubObserver::Bot.run
end
