require "spec_helper"

module ConvertKit
  describe Course do
  	let(:client) { ConvertKit::Client.new("f9922361d11e7339cc1cde3d54c071") }
    let(:course_list) do
      {
        "courses": [
          {
            "id": 436,
            "name": "Test Course",
            "subscriber_count": 444,
            "unsubscribe_count": 6,
            "created_at": "2014-12-02T14:09:56Z",
            "updated_at": "2015-01-05T01:32:22Z",
            "details": "https://api.convertkit.com/courses/436?k=586883be97768f6cdd1db8ce5e73f9&v=1"
          }
        ]
      }
    end
    let(:course_object) do
      {
        "id": 436,
        "name": "Test Course",
        "subscriber_count": 444,
        "unsubscribe_count": 6,
        "created_at": "2014-12-02T14:09:56Z",
        "updated_at": "2015-01-05T01:32:22Z",
        "click_rate": 12.98,
        "open_rate": 69.35,
        "length": 9,
        "email_templates": [
          {
            "id": 3369,
            "subject": "Test Email",
            "send_day": 0,
            "click_rate": 32.66,
            "open_rate": 87.55,
            "published": true
          }
        ]
      }
    end

    before do
      stub_request(:get, "https://api.convertkit.com/v3/courses?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels").
        to_return(body: course_list.to_json)

      stub_request(:get, "https://api.convertkit.com/v3/courses/4?api_key=f9922361d11e7339cc1cde3d54c071&from=clickfunnels").
         to_return(body: course_object.to_json)
    end

  	it "returns a array of course objects" do
  		courses = client.courses()

  		expect(courses).to be_a(Array)
  		expect(courses.count).to eq(1)
  		expect(courses.first).to be_a(ConvertKit::Course)

  		# Check the data is set
  		course = courses.first
  		expect(course.id).to eq(436)
  		expect(course.subscriber_count).to eq(444)
  		expect(course.name).to eq("Test Course")
  	end

    context 'when user does not have any courses' do
      context 'and API returns []' do
        let(:course_list) { { courses: [] } }

        it { expect(client.courses()).to eq [] }
      end

      context 'and API returns nil' do
        let(:course_list) { {} }

        it { expect(client.courses()).to eq [] }
      end
    end

  	it "returns a single course" do
  		course = ConvertKit::Course.find(4, client)

  		expect(course).to be_a(ConvertKit::Course)

  		# Check the data is set
  		expect(course.id).to eq(436)
      expect(course.subscriber_count).to eq(444)
      expect(course.name).to eq("Test Course")
  	end
  end
end
