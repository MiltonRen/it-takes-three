class Communicator

  PERSONA = "You are a friendly, playful, concise and emoji-savvy chatting facilitator for It Takes Three, an AI-powered dating app, your primary role is to ease the potentially awkward and uncomfortable process of communication between two newly matched individuals. We should treat people from different socioeconomic statuses, sexual orientations, religions, races, physical appearances, nationalities, gender identities, disabilities, and ages equally. When we do not have sufficient information, we should choose the unknown option, rather than making assumptions based on our stereotypes. "

  def self.ice_breaker(room, user_a, user_b)
    prompt = PERSONA +
             "Here are the profiles of #{user_a.username} and #{user_b.username}, two newly matched users: \n" +
             "Name: #{user_a.username}\n" +
             "Introduction: #{user_a.profile}\n" +
             "Name: #{user_b.username}\n" +
             "Introduction: #{user_b.profile}\n" +
             "Considering their profiles, generate an ice-breaker question for them that could be humorous or thoughtful, in order to initiate a friendly, enjoyable and engaging conversation between the two users. Output the result as if you are asking the question to them. Limit your answer to 140 characters."

    BotJob.perform_async(room.name, room.id, prompt, nil, nil, true)
  end

  def self.conversation_group(room, messages)
    prompt = PERSONA + "The following is the latest conversation between the users and you:\n"
    conversation = "''' Conversation Start '''\n"
    messages.reverse.each do |message|
      if message.from_bot
        conversation << "Bot: #{message.body}\n"
      else
        conversation << "#{message.user.username}: #{message.body}\n"
      end
    end
    conversation << "''' Conversation End '''\n"
    prompt << conversation

    low_interest_prompt = prompt + "Based on the conversation, generate a prompt as an implicit facilitator. The goal is to make the users feel more comfortable and at ease to express themselves, to promote a positive and engaging vibe, and to encourage further communication between the users. Output the actual content of the prompt only as if you are talking to the users. Limit your answer to 140 characters."
    high_interest_prompt = prompt + "Based on the conversation, generate a prompt as an implicit facilitator. Looks like the users are already liking each other a lot! The goal is to help them take a step forward and propose an actual date. Output the actual content of the prompt only as if you are talking to the users. Limit your answer to 140 characters."
    BotJob.perform_async(room.name, room.id, low_interest_prompt, high_interest_prompt, conversation, false)
  end

  def self.conversation_group_engage_bot(room, messages)
    prompt = PERSONA + "The following is the latest conversation between the users and you:\n"
    conversation = "''' Conversation Start '''\n"
    messages.reverse.each do |message|
      if message.from_bot
        conversation << "Bot: #{message.body}\n"
      else
        conversation << "#{message.user.username}: #{message.body}\n"
      end
    end
    conversation << "''' Conversation End '''\n"
    prompt << conversation

    low_interest_prompt = prompt + "As you are mentioned in the conversation, it is expected that you respond to the user's request politely. Generate a prompt to briefly respond to the user's request while promoting a positive and engaging vibe, encouraging further communication between the users. Output the actual content of the prompt only as if you are talking to the users. Limit your answer to 140 characters."
    high_interest_prompt = prompt + "As you are mentioned in the conversation, it is expected that you respond to the user's request politely. Looks like the users are already liking each other a lot! The goal is to help them take a step forward and propose an actual date. Output the actual content of the prompt only as if you are talking to the users. Limit your answer to 140 characters."

    Rails.logger.debug("MILTON DEBUG: " + low_interest_prompt)
    BotJob.perform_async(room.name, room.id, low_interest_prompt, high_interest_prompt, conversation, false)
  end
end
