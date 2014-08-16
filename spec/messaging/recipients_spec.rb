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