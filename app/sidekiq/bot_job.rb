class BotJob
  include Sidekiq::Job

  VF_CLIENT = VoiceflowClient.new(token: nil)

  def perform(room_name, room_id, prompt, high_interest_prompt, conversation, launch)
    VF_CLIENT.launch(room_name) if launch

    response = if high_interest_prompt.present? && conversation.present?
      interest = VF_CLIENT.detect(room_name, conversation)
      if interest > 0
        VF_CLIENT.interact(room_name, high_interest_prompt)
      else
        VF_CLIENT.interact(room_name, prompt)
      end
    else
      VF_CLIENT.interact(room_name, prompt)
    end
    return if response.blank?

    Message.create!(
      body: response,
      room_id: room_id,
      from_bot: true,
      user_id: 1, # I know this is horrible : ) let's make the first user the bot
    )
  end
end
