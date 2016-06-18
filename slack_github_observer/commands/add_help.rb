module SlackGithubObserver
  module Commands
    class AddHelp < SlackRubyBot::Commands::Base
      require 'cgi'
      command "add help"

      def self.call(client, data, match)
        content_string = match['expression'].encode("UTF-8")
        content_string = CGI.unescapeHTML(content_string)
        pattern = /<(.*?)>/
        content = content_string.to_s.scan(pattern).flatten
        command = content[0].present? ? content[0] : ""
        description = content[1].present? ? content[1] : ""
        long_description = content[2].present? ? content[2] : ""
        help = BotCommandHelp.new(command: command, description: description, long_description: long_description)
        if help.save
          client.say(channel: data.channel, text: "Saved #{help.command} description.")
        else
          client.say(channel: data.channel, text: "Failed to saved")
        end
      end
    end
  end
end