class BotJob
  include Sidekiq::Job

  VF_CLIENT = VoiceflowClient.new(token: nil)

  def perform(room_name, room_id, prompt)
    response = VF_CLIENT.interact(room_name, prompt)
    return if response.blank?

    Message.create!(
      body: response,
      room_id: room_id,
      from_bot: true,
      user_id: 1, # I know this is horrible : ) let's make the first user the bot
    )
  end
end
