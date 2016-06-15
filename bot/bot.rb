class Bot < SlackRubyBot::Bot
  command 'register' do |client, data, match|
    expression = match['expression']
    unless direct_message?(data)
      client.say(channel: data.channel, text: "Please register with direct message...")
      return
    end
    user = User.new(channel_id: data.channel, github_username: expression)
    if user.save!
      client.say(channel: user.channel_id, text: "registered #{user.github_username}")
    else
      client.say(channel: user.channel_id, text: "failed")
    end
  end

  command 'delete' do |client, data, match|
    expression = match['expression']
    user = User.find_by(github_username: expression)
    if user.present?
      user.delete
      client.say(channel: user.channel_id, text: "goodbye my friend...")
    else
      client.say(channel: user.channel_id, text: "i can't find #{expression}")
    end
  end

  private

  def direct_message?(data)
    data.channel && data.channel[0] == 'D'
  end
end
