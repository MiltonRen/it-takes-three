# MILTON TODO: 
# - make this async
# - need to reset room talking_with_bot status if last talk with bot was too long ago

class Communicator
  def self.conversation_group(room, messages)

    summary = messages.map(&:body).join(', ')
    Message.create!(
      body: "Summary so far: " + summary,
      room_id: room.id,
      from_bot: true,
      user_id: 1, # I know this is horrible : ) let's make the first user the bot
    )
  end
end
