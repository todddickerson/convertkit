require "spec_helper"

module ConvertKit
  describe Form do
  	let(:client) { ConvertKit::Client.new("f9922361d11e7339cc1cde3d54c071") }
    let(:form_list) do
      {
        "forms": [
          {
            "id": 4812649,
            "subscriber_count": 0,
            "created_at": "2014-12-20T17:49:34Z",
            "updated_at": "2014-12-20T17:49:44Z",
            "name": "Test form",
            "details": "https://api.convertkit.com/v3/forms/4812649?api_key=f9922361d11e7339cc1cde3d54c071",
            "embed": "https://api.convertkit.com/v3/forms/4812649/embed?api_key=f9922361d11e7339cc1cde3d54c071"
          }
        ]
      }
    end
    let(:form_object) do
      {
        "id": 4812649,
        "title": "This form is here to test the API",
        "description": "<p>Describe your offer</p>",
        "button_msg": "Send me the offer",
        "success_msg": "Thanks! Now check your email.",
        "created_at": "2014-12-20T17:49:34Z",
        "updated_at": "2014-12-20T17:49:44Z"
      }
    end
    let(:add_subscription) do
      {
        "status": "created",
        "form": "Test",
        "created_at": "2013-12-05T21:15:05Z",
        "subscription_status": "active",
        "email": "test@test.com",
        "fname": "Steve",
        "course_opted": true
      }
    end

    before do
      stub_request(:get, "https://api.convertkit.com/v3/forms?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels")
        .to_return(body: form_list.to_json)
      stub_request(:get, "https://api.convertkit.com/v3/forms/4812649?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels")
        .to_return(body: form_object.to_json)
      stub_request(:post, "https://api.convertkit.com/v3/forms/4812649/subscribe?from=clickfunnels").
         with(:body => "api_key=f9922361d11e7339cc1cde3d54c071&email=test%40test.com&name=Steve&course_opted=true").
         to_return(body: add_subscription.to_json)
    end

  	it "returns a array of form objects" do

  		forms = client.forms()

  		expect(forms).to be_a(Array)
  		expect(forms.count).to eq(1)
  		expect(forms.first).to be_a(ConvertKit::Form)

  		# Check the data is set
  		form = forms.first
  		expect(form.id).to eq(4812649)
  		expect(form.subscriber_count).to eq(0)
  		expect(form.name).to eq("Test form")
  	end

    context 'when user does not have any forms' do
      context 'and API returns []' do
        let(:form_list) { { forms: [] } }

        it { expect(client.forms()).to eq [] }
      end

      context 'and API returns nil' do
        let(:form_list) { {} }

        it { expect(client.forms()).to eq [] }
      end
    end

  	it "returns a single form" do
  		form = ConvertKit::Form.find(4812649, client)

  		expect(form).to be_a(ConvertKit::Form)

  		# Check the data is set
  		expect(form.id).to eq(4812649)
  		expect(form.title).to eq("This form is here to test the API")
  		expect(form.description).to eq("<p>Describe your offer</p>")
  		expect(form.button_msg).to eq("Send me the offer")
  		expect(form.success_msg).to eq("Thanks! Now check your email.")
  	end

  	it "allows you to subscribe to a form" do
  		form = ConvertKit::Form.new(4812649, client)
  		response = form.subscribe(email: "test@test.com", name: "Steve")

  		expect(response["status"]).to eq("created")
  	end

  end
end
