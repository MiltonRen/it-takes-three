class Communicator
  
  VF_CLIENT = VoiceflowClient.new(token: nil)

  def self.ice_breaker(room, user_a, user_b)
    prompt = "We have two people matched on a dating app:\n" +
             "Name: #{user_a.username}\n" +
             "Introduction: #{user_a.profile}\n" +
             "Name: #{user_b.username}\n" +
             "Introduction: #{user_b.profile}\n" +
             "Come up with an ice breaker question for the above 2 users, related with both of their introductions:"
    self.get_response(prompt, room)
  end

  def self.conversation_group(room, messages)
    prompt = "Here's the latest conversation for the two people and the Bot:\n"
    messages.reverse.each do |message|
      if message.from_bot
        prompt << "Bot: #{message.body}\n"
      else
        prompt << "#{message.user.username}: #{message.body}\n"
      end
    end
    prompt << "Now come up with the next line as the Bot so the conversation can continue and be interesting:"

    self.get_response(prompt, room)
  end

  def self.conversation_group_engage_bot(room, messages)
    prompt = "Here's the latest conversation for the two people and the Bot:\n"
    messages.reverse.each do |message|
      if message.from_bot
        prompt << "Bot: #{message.body}\n"
      else
        prompt << "#{message.user.username}: #{message.body}\n"
      end
    end
    prompt << "As a Bot, you are just mentioned by the user directly! They really want your input. Now come up with the next line as Bot:"

    self.get_response(prompt, room)
  end

  def self.get_response(prompt, room)
    response = VF_CLIENT.interact(room.name, prompt)

    Message.create!(
      body: response,
      room_id: room.id,
      from_bot: true,
      user_id: 1, # I know this is horrible : ) let's make the first user the bot
    )
  end

  # use this to test bot responses in the console
  def self.test(id, prompt)
    VF_CLIENT.interact(id, prompt)
  end
end
