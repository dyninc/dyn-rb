require 'spec_helper'

describe Dyn::Messaging::Client do

  describe "send_mail()" do

    subject { @dyn.send_mail }

    headers = {
    	'xheader1' => 'value1',
    	'xheader2' => 'value2'
    }

    it "should send an email" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/send")
        .with(:body => {"apikey" => "#{@DEFAULT_API_KEY}", "from" => "a", "to" => "b", "subject" => "c", "bodytext" => "d", "bodyhtml" => "e", "cc" => "f", "replyto" => "g"}.merge(headers))

      subject.send(:create, "a", "b", "c", "d", "e", "f", "g", headers)

      expect(stub).to have_been_requested
    end


  end

end