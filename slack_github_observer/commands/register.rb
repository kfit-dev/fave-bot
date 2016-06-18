module SlackGithubObserver
  module Commands
    class Register < SlackRubyBot::Commands::Base
      command 'register'
      
      def self.call(client, data, match)
        expression = match['expression']
        unless direct_message?(data)
          client.say(channel: data.channel, text: "Please register with direct message...")
          return
        end
        if expression.blank?
          client.say(channel: data.channel, text: "Please register with your github user name. For more information please type help.")
          return
        end
        user = User.new(channel_id: data.channel, github_username: expression, slack_username: data.user)
        if user.save!
          client.say(channel: user.channel_id, text: "registered #{user.github_username}")
        else
          client.say(channel: user.channel_id, text: "failed")
        end
      end

      private

      def direct_message?(data)
        data.channel && data.channel[0] == 'D'
      end

    end
  end
end