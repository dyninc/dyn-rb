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

  describe "/bounces" do

    describe "/count" do

      it "a date range" do
        start_time = 1
        end_time = 2

        stub = stub_request(:get, "#{@API_BASE_PATH}/reports/bounces/count?apikey=#{@DEFAULT_API_KEY}&starttime=#{start_time}&endtime=#{end_time}")

        @dyn.bounces.count(start_time,end_time)

        expect(stub).to have_been_requested
      end

    end

    describe "/list" do

      it "a date range with default startindex" do
        start_time = 1
        end_time = 2

        stub = stub_request(:get, "#{@API_BASE_PATH}/reports/bounces?apikey=#{@DEFAULT_API_KEY}&starttime=#{start_time}&endtime=#{end_time}&startindex=0&emailaddress=")

        @dyn.bounces.list(start_time,end_time)

        expect(stub).to have_been_requested
      end

      it "a date range with a specific start index" do
        start_time = 1
        end_time = 2
        start_index = 40

        stub = stub_request(:get, "#{@API_BASE_PATH}/reports/bounces?apikey=#{@DEFAULT_API_KEY}&starttime=#{start_time}&endtime=#{end_time}&startindex=#{start_index}&emailaddress=")

        @dyn.bounces.list(start_time,end_time,start_index)

        expect(stub).to have_been_requested
      end

      it "an email address" do
        start_time = 1
        end_time = 2
        start_index = 40
        email_address = "abc@domain.com"

        stub = stub_request(:get, "#{@API_BASE_PATH}/reports/bounces?apikey=#{@DEFAULT_API_KEY}&starttime=#{start_time}&endtime=#{end_time}&startindex=#{start_index}&emailaddress=#{email_address}")

        @dyn.bounces.list(start_time,end_time,start_index,email_address)

        expect(stub).to have_been_requested
      end

    end
  end

end