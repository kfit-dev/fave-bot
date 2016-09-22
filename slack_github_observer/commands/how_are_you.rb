module SlackGithubObserver
  module Commands
    class HowAreYou < SlackRubyBot::Commands::Base
      command 'how are you'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "hi <@#{data.user}>, i am working on Jira notification integration. I am trying to private message you if you are mentioned on any Jira Activity. Any feedback please talk to my master...")
      end
    end
  end
end