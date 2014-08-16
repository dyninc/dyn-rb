require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "suppressions()" do

    subject { @dyn.suppressions }

    start_date = 1
    end_date = 2
    start_index = 40
    emailaddress = "abc@foobar.com"

    it "should be countable" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions/count?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}")

      subject.send(:count, start_date, end_date)

      expect(stub).to have_been_requested
    end

    it "should list results for a date range with the default startindex" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}&startindex=0")

      subject.send(:list,start_date, end_date)

      expect(stub).to have_been_requested
    end

    it "should list results for a date range with a specified start index" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}&startindex=#{start_index}")

      subject.send(:list, start_date, end_date, start_index)

      expect(stub).to have_been_requested
    end

    it "should create a new suppression list entry" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/suppressions")
        .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

      subject.send(:create, emailaddress)

      expect(stub).to have_been_requested
    end

    it "should activates an email address on the suppression list" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/suppressions/activate")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

      subject.send(:activate, emailaddress)

      expect(stub).to have_been_requested
    end

  end

end