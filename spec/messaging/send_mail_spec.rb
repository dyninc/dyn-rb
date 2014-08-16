#!/usr/bin/env ruby
require "rubygems"
require "bundler"
Bundler.setup

require "spec_helper"
require "rspec"
require "webmock/rspec"

require File.expand_path(File.join(File.dirname(__FILE__), "../../lib/dyn-rb.rb"))

describe Dyn::Messaging::Client do

  before(:all) do
    @DEFAULT_API_KEY = 1
    @API_BASE_PATH = 'https://emailapi.dynect.net/rest/json'

    @dyn = Dyn::Messaging::Client.new(@DEFAULT_API_KEY)
  end

  describe "send_mail()" do

    subject { @dyn.send_mail }

    it "should send an email" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/send")
        .with(:body => {"apikey" => "#{@DEFAULT_API_KEY}", "from" => "a", "to" => "b", "subject" => "c", "bodytext" => "d", "bodyhtml" => "e", "cc" => "f", "replyto" => "g", "xheaders" => "h"})

      subject.send(:create, "a", "b", "c", "d", "e", "f", "g", "h")

      expect(stub).to have_been_requested
    end


  end

end