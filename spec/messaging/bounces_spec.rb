require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "bounces()" do

    subject { @dyn.bounces }
    it_should_behave_like "a collection", "reports/bounces"

    it "should list results for a specific receiver email address" do
      start_time = 1
      end_time = 2
      start_index = 40
      email_address = "abc@domain.com"

      stub = stub_request(:get, "#{@API_BASE_PATH}/reports/bounces?apikey=#{@DEFAULT_API_KEY}&starttime=#{start_time}&endtime=#{end_time}&startindex=#{start_index}&emailaddress=#{email_address}")
      subject.send(:list, start_time, end_time, start_index, email_address)
      expect(stub).to have_been_requested
    end

  end

end