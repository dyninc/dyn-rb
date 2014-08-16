require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "recipients()" do
    emailaddress = "abc@foobar.com"

    subject { @dyn.recipients }

    it "should retrieve the status of an email address" do

      stub = stub_request(:get, "#{@API_BASE_PATH}/recipients/status?apikey=#{@DEFAULT_API_KEY}&emailaddress=#{emailaddress}")

      subject.send(:status, emailaddress)

      expect(stub).to have_been_requested
    end

    it "should activate an email address" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/recipients/activate")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

      subject.send(:activate, emailaddress)

      expect(stub).to have_been_requested
    end
  end

end