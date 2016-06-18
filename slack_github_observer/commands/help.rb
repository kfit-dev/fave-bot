module SlackGithubObserver
  module Commands
    class Help < SlackRubyBot::Commands::Base
      command "help"
      

      def self.call(client, data, match)
        command = match["expression"]
        command_help = BotCommandHelp.find_by(command: command)
        if command_help.present?
          text = get_description(command_help)
          client.say(channel: data.channel, text: "#{text}")
        else
          client.say(channel: data.channel, text: "I don't know.")
        end
      end

      def self.get_description(command_help)
        text = %Q(
Command: #{command_help.command}.
Description: #{command_help.description}.
Long Description: #{command_help.long_description}.)
      end
    end
  end
end