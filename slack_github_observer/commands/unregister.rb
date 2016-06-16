command 'unregister' do |client, data, match|
  expression = match['expression']
  user = User.find_by(github_username: expression)
  if user.present?
    user.delete
    client.say(channel: user.channel_id, text: "goodbye my friend...")
  else
    client.say(channel: user.channel_id, text: "i can't find #{expression}")
  end
end