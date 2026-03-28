# frozen_string_literal: true

class Openrouter::Client
  def post(messages:, response_format: nil, temperature: Openrouter.config.temperature,
           max_tokens: Openrouter.config.max_tokens)
    request_body = build_request_body(
      messages: messages,
      response_format: response_format,
      temperature: temperature,
      max_tokens: max_tokens
    )

    post_with_retries(request_body)
  end

  private

  def build_request_body(messages:, response_format:, temperature:, max_tokens:)
    body = {
      model: Openrouter.config.model,
      messages: messages,
      temperature: temperature,
      max_tokens: max_tokens
    }
    body[:response_format] = response_format if response_format
    body
  end

  def post_with_retries(request_body)
    retries = 0

    loop do
      http_response = connection.post('', request_body)
      return http_response.body unless retryable?(http_response.status, retries)

      retries += 1
      sleep(3)
    rescue StandardError => e
      raise Faraday::Error, e.message
    end
  end

  def retryable?(status, retries)
    status == 429 && retries < 4
  end

  def connection
    @connection ||= Faraday.new(Openrouter.config.url) do |f|
      f.request :json
      f.response :json
      f.headers['Content-Type'] = 'application/json'
      f.headers['Authorization'] = "Bearer #{Openrouter.config.bearer_token}"
      f.adapter Faraday.default_adapter
    end
  end
end
