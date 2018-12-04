require 'httparty'

module ConvertKit
  class Client
    include HTTParty

    attr_reader :key, :uri, :version

    def initialize(key, uri = "https://api.convertkit.com", version = nil)
      @key     = key
      @uri     = uri
      @version = version || 3
    end

    def form(id)
      form = ConvertKit::Form.new(id, self)
      form.client = self

      form
    end

    def get_request(path)
      json = self.class.get("#{@uri}/v#{@version}#{path}?api_key=#{@key}&from=clickfunnels")
      JSON.parse(json.body)
    end

    def post_request(path, params, follow_redirects: false)
      url = "#{@uri}/v#{@version}#{path}?from=clickfunnels"

      json = self.class.post(
        url,
        follow_redirects: follow_redirects,
        body: {
          api_key: @key,
        }.merge(params)
      )

      JSON.parse(json.body)
    end
  end
end
