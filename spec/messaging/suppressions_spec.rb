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

  describe "/suppressions" do

    describe "/count" do

      it "a date range" do
        start_date = 1
        end_date = 2

        stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions/count?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}")

        @dyn.suppressions.count(start_date,end_date)

        expect(stub).to have_been_requested
      end

    end

    describe "/list" do

      it "a date range with default startindex" do
        start_date = 1
        end_date = 2

        stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}&startindex=0")

        @dyn.suppressions.list(start_date,end_date)

        expect(stub).to have_been_requested
      end

      it "a date range with a specific start index" do
        start_date = 1
        end_date = 2
        start_index = 40

        stub = stub_request(:get, "#{@API_BASE_PATH}/suppressions?apikey=#{@DEFAULT_API_KEY}&startdate=#{start_date}&enddate=#{end_date}&startindex=#{start_index}")

        @dyn.suppressions.list(start_date,end_date,start_index)

        expect(stub).to have_been_requested
      end

    end

    describe "/create" do

      it "creates" do
        emailaddress = "abc@foobar.com"

        stub = stub_request(:post, "#{@API_BASE_PATH}/suppressions")
          .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

        @dyn.suppressions.create(emailaddress)

        expect(stub).to have_been_requested
      end

    end

    describe "/activate" do

      it "activates" do
        emailaddress = "abc@foobar.com"

        stub = stub_request(:post, "#{@API_BASE_PATH}/suppressions/activate")
        .with(:body => {"apikey"=>"#{@DEFAULT_API_KEY}", "emailaddress"=>emailaddress})

        @dyn.suppressions.activate(emailaddress)

        expect(stub).to have_been_requested
      end

    end

  end

end