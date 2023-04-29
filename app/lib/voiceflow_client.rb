class VoiceflowClient < ApplicationClient

  BASE_URI = "https://general-runtime.voiceflow.com"
  API_KEY = ENV.fetch("VOICEFLOW_API_KEY")

  def default_headers
    {
      "Authorization" => API_KEY,
      "Content-Type" => "application/json"
    }
  end

  def interact(user_id, user_input)
    response = post "/state/user/#{user_id}/interact", action: {type: "text", payload: user_input}
    message = response.detect {|trace| trace.type == "text"}&.payload&.message
    return message if message.present?
    return "Sorry, I'm taking a break right now ☕️"
  end
end
