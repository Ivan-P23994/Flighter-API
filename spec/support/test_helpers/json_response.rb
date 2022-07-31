module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers(token = '')
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token.to_s
      }
    end
  end
end
