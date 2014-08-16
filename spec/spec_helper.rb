#!/usr/bin/env ruby
require "rubygems"
require "bundler"
Bundler.setup

require "spec_helper"
require "rspec"
require "webmock/rspec"

require File.expand_path(File.join(File.dirname(__FILE__), "../lib/dyn-rb.rb"))

Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    @DEFAULT_API_KEY = 1
    @API_BASE_PATH = 'https://emailapi.dynect.net/rest/json'

    @dyn = Dyn::Messaging::Client.new(@DEFAULT_API_KEY)
  end

end