#!/usr/bin/env ruby
require "rubygems"
require "bundler"
Bundler.setup

require "rspec"
require 'webmock/rspec'
require "pp"

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/dyn-rb.rb'))

describe Dyn::Messaging::Client do

  describe "Sample" do

    it "gets bounces" do

      # comment this in to make the test pass
      #stub_request(:get, "https://emailapi.dynect.net/rest/json/reports/bounces?apikey=1&endtime=3&startindex=0&starttime=2")
      #  .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'dyn-rb 1.0.3'})

      dyn = Dyn::Messaging::Client.new(1)
      response =  dyn.bounces.list(2,3)

      a_request(:get, "https://emailapi.dynect.net/rest/json/reports/bounces?apikey=1&endtime=3&startindex=0&starttime=2")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'dyn-rb 1.0.3'}).should have_been_made

    end

  end

end