require "spec_helper"

module ConvertKit
  describe Tag do
    let(:client) { ConvertKit::Client.new("f9922361d11e7339cc1cde3d54c071") }
    let(:tag_list) do
      {
        "tags": [
          {
            "id": 4812649,
            "name": "Tag Test",
            "created_at": "2016-02-28T08:07:00Z"
          }
        ]
      }
    end
    let(:tag_object) do
      {
        "id": 4812649,
        "name": "Tag Test",
        "created_at": "2016-02-28T08:07:00Z"
      }
    end
    let(:create_tag_response) do
      {
        "account_id": 1,
        "created_at": "2017-04-12T11:10:32Z",
        "deleted_at": "null",
        "id": 1,
        "name": "Example Tag",
        "state": "available",
        "updated_at": "2017-04-12T11:10:32Z"
      }
    end

    before do
      stub_request(:get, "https://api.convertkit.com/v3/tags?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels")
        .to_return(body: tag_list.to_json)
      stub_request(:get, "https://api.convertkit.com/v3/tags/4812649?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels")
        .to_return(body: tag_object.to_json)
      stub_request(:post, "https://api.convertkit.com/v3/tags?from=clickfunnels").
         with(:body => "api_key=f9922361d11e7339cc1cde3d54c071&tag[name]=New%20Tag").
         to_return(body: create_tag_response.to_json)
    end

    it "returns a array of tags objects" do

      tags = client.tags()

      expect(tags).to be_a(Array)
      expect(tags.count).to eq(1)
      expect(tags.first).to be_a(ConvertKit::Tag)

      # Check the data is set
      tag = tags.first
      expect(tag.id).to eq(4812649)
      expect(tag.name).to eq("Tag Test")
    end

    it "returns a single tag" do
      tag = ConvertKit::Tag.find(4812649, client)

      expect(tag).to be_a(ConvertKit::Tag)

      # Check the data is set
      expect(tag.id).to eq(4812649)
      expect(tag.name).to eq("Tag Test")
      expect(tag.created_at).to eq("2016-02-28T08:07:00Z")
    end

    it "create tags" do
      response = client.create_tags("name": "New Tag")

      expect(response["state"]).to eq("available")
      expect(response["name"]).to eq("Example Tag")
    end
  end
end
