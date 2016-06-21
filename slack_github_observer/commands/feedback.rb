module SlackGithubObserver
  module Commands
    class Feedback < SlackRubyBot::Commands::Base
      command 'feedback'
      def self.call(client, data, match)
        feedback = match["expression"]
        client.say(channel: "D1GJCSMHC", text: "#{feedback}")
      end
    end
  end
end