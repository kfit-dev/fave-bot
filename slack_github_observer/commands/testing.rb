module SlackGithubObserver
  module Commands
    class Testing < SlackRubyBot::Commands::Base
      command 'testing'
      def self.call(client, data, match)
        client.say(channel: data.channel, text: "testing 123...")
      end
    end
  end
end