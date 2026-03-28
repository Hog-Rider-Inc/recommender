# frozen_string_literal: true

RSpec.describe Openrouter::Client do
  let(:client) { described_class.new }

  describe '#post' do
    let(:messages) { [{ role: 'user', content: 'Hello' }] }

    let(:response_body) do
      { 'id' => 'test-id', 'choices' => [{ 'message' => { 'content' => 'Labas, kaip sekasi?' } }] }
    end

    before do
      allow(ENV).to receive(:fetch).with('OPENROUTER_URL').and_return('https://ai.com/chat')
      allow(ENV).to receive(:fetch).with('OPENROUTER_API_KEY').and_return('test-api-key')
      allow(ENV).to receive(:fetch).with('OPENROUTER_AI_MODEL').and_return('test-model')

      stub_request(:post, 'https://ai.com/chat')
        .with(
          headers: {
            'Authorization' => /Bearer .+/,
            'Content-Type' => 'application/json'
          }
        )
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'makes a request and returns response body' do
      response = client.post(messages: messages)

      expect(response).to eq(response_body)
    end

    context 'when request fails' do
      let(:connection) { instance_double(Faraday::Connection) }

      before do
        allow(Faraday).to receive(:new).and_return(connection)
        allow(connection).to receive(:post).and_raise(Faraday::Error, 'test error')
      end

      it 'raises an error' do
        expect { client.post(messages: messages) }.to raise_error(Faraday::Error, 'test error')
      end
    end

    context 'when request is rate limited with 429 responses' do
      let(:rate_limited_stub) do
        stub_request(:post, 'https://ai.com/chat')
          .with(
            headers: {
              'Authorization' => /Bearer .+/,
              'Content-Type' => 'application/json'
            }
          )
          .to_return(
            { status: 429, headers: { 'Content-Type' => 'application/json' } },
            { status: 429, headers: { 'Content-Type' => 'application/json' } },
            { status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' } }
          )
      end

      before do
        rate_limited_stub
        allow(client).to receive(:sleep)
      end

      it 'retries on 429 and eventually returns response' do
        response = client.post(messages: messages)

        expect(response).to eq(response_body)
        expect(client).to have_received(:sleep).with(3).twice
        expect(rate_limited_stub).to have_been_requested.times(3)
      end
    end
  end
end
