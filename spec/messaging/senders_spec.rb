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

    start_index = 40
    emailaddress = "my-sender@foobar.com"
    seeding = 1
    dkim = "[identifier]._domainkey.[senderdomain]"

    subject { @dyn.senders }

    it "should list results with the default startindex" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/senders?apikey=#{@DEFAULT_API_KEY}&startindex=0")
      subject.send(:list)
      expect(stub).to have_been_requested
    end

    it "should list results with a specified start index" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/senders?apikey=#{@DEFAULT_API_KEY}&startindex=#{start_index}")
      subject.send(:list, start_index)
      expect(stub).to have_been_requested
    end

    it "should create sender with default seeding" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress, "seeding" => "0"})

      subject.send(:create, emailaddress)

      expect(stub).to have_been_requested
    end

    it "should create sender with specified seeding" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress, "seeding" => "#{seeding}"})

      subject.send(:create, emailaddress, seeding)

      expect(stub).to have_been_requested
    end

    it "should update sender with default seeding" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress, "seeding" => "0"})

      subject.send(:update, emailaddress)

      expect(stub).to have_been_requested
    end

    it "should update sender with specified seeding" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress, "seeding" => "#{seeding}"})

      subject.send(:update, emailaddress, seeding)

      expect(stub).to have_been_requested
    end

    it "should destroy sender with the given email address" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders/delete")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

      subject.send(:destroy, emailaddress)

      expect(stub).to have_been_requested
    end

    it "should get details" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/senders/details?apikey=#{@DEFAULT_API_KEY}&emailaddress=#{emailaddress}")
      subject.send(:details, emailaddress)
      expect(stub).to have_been_requested
    end

    it "should get status" do
      stub = stub_request(:get, "#{@API_BASE_PATH}/senders/status?apikey=#{@DEFAULT_API_KEY}&emailaddress=#{emailaddress}")
      subject.send(:status, emailaddress)
      expect(stub).to have_been_requested
    end

    it "should set the dkim for the given email address" do
      stub = stub_request(:post, "#{@API_BASE_PATH}/senders/dkim")
      .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress, "dkim"=>dkim})

      subject.send(:dkim, emailaddress, dkim)

      expect(stub).to have_been_requested
    end

  end

end