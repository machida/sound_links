# frozen_string_literal: true

class AppleMusicRepository
  API_KEY =  Rails.application.credentials.apple_music[:key_id]
  API_SECRET_KEY = Rails.application.credentials.apple_music[:private_key]
  APPLE_TEAM_ID = Rails.application.credentials.apple_music[:team_id]

  SEARCH_URL = "https://api.music.apple.com/v1/catalog/jp/search?"
  SEARCH_TRACKS_NUMBER = 5

  def search(query)
    search_uri = URI.parse(SEARCH_URL + { term: query, limit: SEARCH_TRACKS_NUMBER, types: "songs" }.to_query)

    search_request = Net::HTTP::Get.new(search_uri)
    search_request["Authorization"] = "Bearer #{authentication_token}"

    response = api_response(search_uri, search_request)

    format(response)
  end

  private

    # TODO spotify_repositoryとほぼ同じ構造なので、モジュールに切り分けたい
    def api_response(uri, request)
      Net::HTTP.start(uri.hostname, uri.port, request_schema(uri)) do |http|
        http.request(request)
      end
    end

    def request_schema(uri)
      { use_ssl: uri.scheme == "https" }
    end

    def authentication_payload
      {
        iss: APPLE_TEAM_ID,
        iat: Time.now.to_i,
        exp: Time.now.to_i + 3600
      }
    end

    def authentication_token
      private_key = OpenSSL::PKey::EC.new(API_SECRET_KEY)
      JWT.encode(authentication_payload, private_key, 'ES256', kid: API_KEY)
    end

    def format(response)
      JSON.parse(response.body)["results"]["songs"]["data"].map do |item|
        {
          apple_music_title: item["attributes"]["name"],
          apple_music_artists: item["attributes"]["artistName"],
          apple_music_url: item["attributes"]["url"]
        }
      end
    end
end