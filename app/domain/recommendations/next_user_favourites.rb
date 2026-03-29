# frozen_string_literal: true

module Recommendations
  class NextUserFavourites
    SYSTEM_PROMPT = <<~PROMPT.strip
      You are a recommendation engine. You will receive a JSON object with four fields:

      - "all_items": the full list of available menu items
      - "ordered_items": items the user has previously ordered
      - "existing_user_favourites": items the user has explicitly marked as favourites
      - "disliked_user_items": items the user has explicitly disliked

      Your task is to pick up to 13 item IDs from "all_items" that the user is most likely to enjoy, based on patterns from "ordered_items" and "existing_user_favourites". Consider item names, descriptions, and prices to find similar or complementary items.

      Rules:
      - You MUST only pick IDs that exist in "all_items". Never invent or assume IDs.
      - You MAY include items that already appear in "existing_user_favourites".
      - You MUST NOT include items that are not in "all_items".
      - You SHOULD NOT include items that appear in "disliked_user_items".
      - Return exactly this JSON format and nothing else — no explanation, no markdown, no extra fields:

      {"next_user_favorites": [1, 5, 12]}
    PROMPT

    def call(all_items:, ordered_items:, existing_user_favourites:, disliked_user_items:) # rubocop:disable Metrics/MethodLength
      response_body = openrouter_client.post(
        messages: messages(
          all_items: all_items,
          ordered_items: ordered_items,
          existing_user_favourites: existing_user_favourites,
          disliked_user_items: disliked_user_items
        ),
        response_format: { type: 'json_object' },
        max_tokens: 800
      )

      content = extract_content(response_body)
      parse_ids(content)
    rescue StandardError => e
      if defined?(Rails)
        Rails.logger.warn("[Recommendations::NextUserFavourites] error=#{e.class}: #{e.message}")
        Rails.logger.warn("[Recommendations::NextUserFavourites] raw_response_on_error=#{response_body}")
      end
      raise Faraday::Error, "Invalid Openrouter response: #{e.message}"
    end

    private

    def extract_content(response_body)
      choice0 = response_body.dig('choices', 0) || {}
      message = choice0['message'] || {}

      message['content'] || choice0['text'] || message['reasoning'] || message.dig('reasoning_details', 0, 'text')
    end

    def openrouter_client
      @openrouter_client ||= Openrouter.client
    end

    def messages(all_items:, ordered_items:, existing_user_favourites:, disliked_user_items:)
      payload = {
        all_items: all_items,
        ordered_items: ordered_items,
        existing_user_favourites: existing_user_favourites,
        disliked_user_items: disliked_user_items
      }

      [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: payload.to_json }
      ]
    end

    def parse_ids(content)
      ids = content.to_s.scan(/\b\d+\b/).map(&:to_i).uniq

      Rails.logger.info("[Recommendations::NextUserFavourites] parsed_menu_item_ids=#{ids.inspect}") if defined?(Rails)

      ids.first(13) if ids.any?
    end
  end
end
