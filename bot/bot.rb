class Bot < SlackRubyBot::Bot
  command 'say' do |client, data, match|
    client.say(channel: data.channel, text: "lala")
  end

  command 'hello' do |client, data, match|
    client.say(channel: data.channel, text: match['expression'])
  end
end
