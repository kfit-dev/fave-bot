module SlackGithubObserver
  module Commands
    class Unknown < SlackRubyBot::Commands::Base
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "Sorry <@#{data.user}>, I don't understand that command!")
      end
    end
  end
end