module SlackGithubObserver
  module Commands
    class GetUserInfo < SlackRubyBot::Commands::Base
      command 'get info'
      def self.call(client, data, match)
        user = User.find_by(github_username: match['expression'])
        if user.present?
          text = "Channel id: #{user.channel_id}, Github: #{user.github_username}, Slack: <@#{user.slack_username}>"
          client.say(channel: data.channel, text: "#{text}", gif: 'info')
        else
          client.say(channel: data.channel, text: "Sorry this user #{match['expression']} cannot be found.", gif: 'info')
        end
      end
    end
  end
end