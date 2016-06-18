module SlackGithubObserver
  module Commands
    class Unregister < SlackRubyBot::Commands::Base
      command "unregister"

      def self.call(client, data, match)
        expression = match['expression']
        user = User.find_by(github_username: expression)
        if user.present?
          user.delete
          client.say(channel: data.channel, text: "goodbye my friend...")
        else
          client.say(channel: data.channel, text: "i can't find #{expression}")
        end
      end
    end
  end
end
