# frozen_string_literal: true

RSpec.describe Openrouter::Client do
  let(:client) { described_class.new }

  describe '#post' do
    let(:messages) do
      [
        { role: 'system', content: 'You are a helpful assistant.' },
        { role: 'user', content: 'Hello. Labas.' }
      ]
    end

    let(:response_body) { { id: 'test-id', choices: [{ message: { content: 'Labas, kaip sekasi?' } }] } }

    before do
      stub_request(:post, 'https://openrouter.ai/api/v1/chat/completions')
        .with(
          headers: {
            'Authorization' => /Bearer .+/,
            'Content-Type' => 'application/json',
          }
        )
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'makes a request and returns response' do
      response = client.post(messages)

      expect(response).to eq('Labas, kaip sekasi?')
    end

    context 'when request fails' do
      let(:connection) { instance_double(Faraday::Connection) }

      before do
        allow(Faraday).to receive(:new).and_return(connection)
        allow(connection).to receive(:post).and_raise(Faraday::Error, 'test error')
      end

      it 'raises an error' do
        expect { client.post(messages) }.to raise_error(Faraday::Error, 'test error')
      end
    end
  end
end
