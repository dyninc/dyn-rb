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