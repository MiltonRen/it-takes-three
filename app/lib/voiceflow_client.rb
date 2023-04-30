class VoiceflowClient < ApplicationClient

  BASE_URI = "https://general-runtime.voiceflow.com"
  API_KEY_GPT = ENV.fetch("VOICEFLOW_API_KEY_GPT")
  API_KEY_DETECTION = ENV.fetch("VOICEFLOW_API_KEY_DETECTION")

  def default_headers
    {
      "Content-Type" => "application/json"
    }
  end

  def launch(user_id)
    post "/state/user/#{user_id}/interact", {"Authorization" => API_KEY_GPT }, action: {type: "launch"}
    post "/state/user/#{user_id}/interact", {"Authorization" => API_KEY_DETECTION }, action: {type: "launch"}
  end

  def interact(user_id, user_input)
    response = post "/state/user/#{user_id}/interact", {"Authorization" => API_KEY_GPT }, action: {type: "text", payload: user_input}
    response.detect {|trace| trace.type == "text"}&.payload&.message
  end

  # returns integer 0-2 indicating how interested users are
  def detect(user_id, user_input)
    response = post "/state/user/#{user_id}/interact", {"Authorization" => API_KEY_DETECTION }, action: {type: "text", payload: user_input}
    message = response.detect {|trace| trace.type == "text"}&.payload&.message
    message.to_i
  end
end
