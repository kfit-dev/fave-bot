$:.unshift File.dirname(__FILE__)
require 'bot'

Thread.abort_on_exception = true

unless $0 =~ /rake$/
  Thread.new do
    SlackGithubObserver::Bot.run
  end
end