# frozen_string_literal: true

class Openrouter::Client
  def post(prompt)
    retries = 0
    begin
      response = connection.post('', request_body(prompt)).body
    rescue StandardError => e
      unless e.respond_to?(:response) && e.response && e.response[:status] == 429 && retries < 4
        raise Faraday::Error, e.message
      end

      retries += 1
      sleep(3)
      retry
    end

    response['choices'][0]['message']['content']
  end

  private

  def connection
    @connection ||= Faraday.new(url) do |f|
      f.request :json
      f.response :json
      f.headers['Content-Type'] = 'application/json'
      f.headers['Authorization'] = "Bearer #{config.bearer_token}"
      f.adapter Faraday.default_adapter
    end
  end

  def config
    Openrouter.config
  end

  def url
    config.url
  end

  def request_body(prompt)
    {
      model: config.model,
      messages: [
        { role: 'system', content: 'You are a helpful assistant.' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.0,
      max_tokens: 300
    }
  end
end
