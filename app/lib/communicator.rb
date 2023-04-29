# MILTON TODO: 
# - make this async
# - need to reset room talking_with_bot status if last talk with bot was too long ago

class Communicator
  def self.ice_breaker(room, user_a, user_b)
    prompt = "We have two people matched on a dating app:\n" +
             "Name: #{user_a.username}\n" +
             "Introduction: #{user_a.profile}\n" +
             "Name: #{user_b.username}\n" +
             "Introduction: #{user_b.profile}\n" +
             "Come up with an ice breaker question for the above 2 users, related with both of their introductions."
    self.get_response(prompt, room)
  end

  def self.conversation_group(room, messages)
    summary = messages.map(&:body).join(', ')
    self.get_response("Summary so far: #{summary}", room)
  end

  def self.conversation_group_engage_bot(room, messages)
    sum = messages.map(&:body).map(&:first).join("")
    self.get_response("Thank you for engaging me! #{sum}", room)
  end

  def self.get_response(prompt, room)
    Message.create!(
      body: prompt,
      room_id: room.id,
      from_bot: true,
      user_id: 1, # I know this is horrible : ) let's make the first user the bot
    )
  end
end
