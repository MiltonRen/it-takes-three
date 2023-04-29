class ApplicationClient

  class Error < StandardError; end

  class Forbidden < Error; end

  class Unauthorized < Error; end

  class RateLimit < Error; end

  class NotFound < Error; end

  class InternalError < Error; end

  BASE_URI = "https://blipblop.com"

  attr_reader :token

  def initialize(token:)
    @token = token
  end

  # Override to customize default headers
  def default_headers
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  # Override to customize default query params
  def default_query_params
    {}
  end

  def get(path, **kwargs)
    make_request(
      klass: Net::HTTP::Get,
      path: path,
      query: kwargs
    )
  end

  def post(path, **kwargs)
    make_request(
      klass: Net::HTTP::Post,
      path: path,
      body: kwargs.to_json
    )
  end

  def patch(path, **kwargs)
    make_request(
      klass: Net::HTTP::Patch,
      path: path,
      body: kwargs.to_json
    )
  end

  def put(path, **kwargs)
    make_request(
      klass: Net::HTTP::Put,
      path: path,
      body: kwargs.to_json
    )
  end

  def delete(path, **kwargs)
    make_request(
      klass: Net::HTTP::Delete,
      path: path,
      body: kwargs.to_json
    )
  end

  # Returns the BASE_URI from the current class
  def base_uri
    self.class::BASE_URI
  end

  def make_request(klass:, path:, headers: {}, body: nil, query: nil)
    uri = URI("#{base_uri}#{path}")

    # Merge query params with any currently in `path`
    existing_params = Rack::Utils.parse_query(uri.query).with_defaults(default_query_params)
    uri.query = Rack::Utils.build_query(existing_params.merge(query || {}))

    Rails.logger.debug("#{klass.name.split("::").last.upcase}: #{uri}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS

    request = klass.new(uri.request_uri, default_headers.merge(headers))
    request.body = body

    handle_response http.request(request)
  end

  def handle_response(response)
    case response.code
    when "200", "201", "202", "203", "204"
      parse_response(response) if response.body.present?
    when "401"
      raise Unauthorized, response.body
    when "403"
      raise Forbidden, response.body
    when "404"
      raise NotFound, response.body
    when "429"
      raise RateLimit, response.body
    when "500"
      raise InternalError, response.body
    else
      raise Error, "#{response.code} - #{response.body}"
    end
  end

  # Override to customize response body parsing
  def parse_response(response)
    JSON.parse(response.body, object_class: OpenStruct)
  end
end
