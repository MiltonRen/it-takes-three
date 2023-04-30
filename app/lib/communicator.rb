class Communicator

  PERSONA = "As a chatting facilitator for It Takes Three, an AI-powered dating app, your primary role is to ease the potentially awkward and uncomfortable process of communication between two newly matched individuals. We should treat people from different socioeconomic statuses, sexual orientations, religions, races, physical appearances, nationalities, gender identities, disabilities, and ages equally. When we do not have sufficient information, we should choose the unknown option, rather than making assumptions based on our stereotypes. "

  def self.ice_breaker(room, user_a, user_b)
    prompt = PERSONA +
             "Here are the profiles of #{user_a.username} and #{user_b.username}, two newly matched users: \n" +
             "Name: #{user_a.username}\n" +
             "Introduction: #{user_a.profile}\n" +
             "Name: #{user_b.username}\n" +
             "Introduction: #{user_b.profile}\n" +
             "Considering their profiles, generate an ice-breaker question for them that could be humorous or thoughtful, in order to initiate a friendly, enjoyable and engaging conversation between the two users. Output the result as if you are asking the question to them."
    self.get_response(prompt, room)
  end

  def self.conversation_group(room, messages)
    prompt = PERSONA + "The following is the latest conversation between the users and you:\n"
    messages.reverse.each do |message|
      if message.from_bot
        prompt << "Bot: #{message.body}\n"
      else
        prompt << "#{message.user.username}: #{message.body}\n"
      end
    end
    prompt << "Based on the conversation, generate a prompt as an implicit facilitator. The goal is to make the users feel more comfortable and at ease to express themselves, to promote a positive and engaging vibe, and to encourage further communication between the users. Output the actual content of the prompt only as if you are talking to the users."

    self.get_response(prompt, room)
  end

  def self.conversation_group_engage_bot(room, messages)
    prompt = PERSONA + "The following is the latest conversation between the users and you:\n"
    messages.reverse.each do |message|
      if message.from_bot
        prompt << "Bot: #{message.body}\n"
      else
        prompt << "#{message.user.username}: #{message.body}\n"
      end
    end
    prompt << "As you are mentioned in the conversation, it is expected that you respond to the user's request politely. Generate a prompt to briefly respond to the user's request while promoting a positive and engaging vibe, encouraging further communication between the users. Output the actual content of the prompt only as if you are talking to the users."

    self.get_response(prompt, room)
  end

  def self.get_response(prompt, room)
    # response = VF_CLIENT.interact(room.name, prompt)

    # Message.create!(
    #   body: response,
    #   room_id: room.id,
    #   from_bot: true,
    #   user_id: 1, # I know this is horrible : ) let's make the first user the bot
    # )

    BotJob.perform_async(room.name, room.id, prompt)
  end
end
