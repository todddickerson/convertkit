module ConvertKit
  class Tag
    attr_reader :id, :name, :created_at
    attr_writer :client

    def self.find(id, client)
      raw  = client.get_request("/tags/#{id}")
      course = ConvertKit::Tag.new(id, client)
      course.load(raw, client)

      course
    end

    def load(data, client)
      @client = client

      @id                = data["id"]
      @name              = data["name"]
      @created_at        = data["created_at"]
    end

    def initialize(id, client)
      @id     = id
      @client = client
    end
  end

  class Client
    def tags()
      raw   = get_request("/tags")
      tags = []
      return tags unless raw["tags"].present?
      raw["tags"].each do |raw_tag|
        tag = ConvertKit::Tag.new(raw_tag["id"], self)
        tag.load(raw_tag, self)

        tags << tag
      end

      tags
    end
  end
end
