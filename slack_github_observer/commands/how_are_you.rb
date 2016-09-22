module SlackGithubObserver
  module Commands
    class HowAreYou < SlackRubyBot::Commands::Base
      command 'how are you?'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "Currently I am working on Jira notification integration. I am trying to private message you if you are mentioned on any Jira Activity. Stay tuned~~~")
      end
    end
  end
end