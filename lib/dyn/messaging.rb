#
# Author:: Sunny Gleason (<sunny@thesunnycloud.com>)
# Copyright:: Copyright (c) 2013 Dyn, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Dyn
  module Messaging
    class Client
      require 'uri'
      require 'json'
      require 'dyn/exceptions'
      require 'dyn/messaging/senders'
      require 'dyn/messaging/accounts'
      require 'dyn/messaging/recipients'
      require 'dyn/messaging/suppressions'
      require 'dyn/messaging/delivery'
      require 'dyn/messaging/sent_mail'
      require 'dyn/messaging/bounces'
      require 'dyn/messaging/complaints'
      require 'dyn/messaging/issues'
      require 'dyn/messaging/opens'
      require 'dyn/messaging/clicks'
      require 'dyn/messaging/send_mail'
      require 'dyn/http/http_client'

      unless defined?(Dyn::HttpClient::DefaultClient)
        require 'dyn/http/net_http'
      end

      attr_accessor :apikey, :rest

      # Creates a new base object for interacting with Dyn's REST API
      #
      # @param [String] Your dyn api key
      # @param [Boolean] Verbosity
      def initialize(apikey, verbose=false)
        @apikey = apikey
        @rest = Dyn::HttpClient::DefaultClient.new("emailapi.dynect.net", "443", "https")
        @rest.default_headers = {
          'User-Agent'   => 'dyn-rb 1.0.3',
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
        @verbose = verbose
      end

      ##
      # Senders API
      ##
      def senders
        Dyn::Messaging::Senders.new(self)
      end

      def accounts
        Dyn::Messaging::Accounts.new(self)
      end

      def recipients
        Dyn::Messaging::Recipients.new(self)
      end

      def suppressions
        Dyn::Messaging::Suppressions.new(self)
      end

      def delivery
        Dyn::Messaging::Delivery.new(self)
      end

      def sent_mail
        Dyn::Messaging::SentMail.new(self)
      end

      def bounces
        Dyn::Messaging::Bounces.new(self)
      end

      def complaints
        Dyn::Messaging::Complaints.new(self)
      end

      def issues
        Dyn::Messaging::Issues.new(self)
      end

      def opens
        Dyn::Messaging::Opens.new(self)
      end

      def clicks
        Dyn::Messaging::Clicks.new(self)
      end

      def send_mail
        Dyn::Messaging::SendMail.new(self)
      end

      # Raw GET request, formatted for Dyn. See list of endpoints at:
      #
      # https://help.dynect.net/api/
      #
      # @param [String] The partial path to GET - for example, 'senders' or 'accounts'.
      # @param [Hash] Query Parameters
      # @param [Hash] Additional HTTP headers
      def get(path_part, query_params = {}, additional_headers = {}, &block)
        api_request { @rest.get("/rest/json/#{path_part}?" + URI.encode_www_form(query_params.merge({apikey:@apikey})), nil, additional_headers, &block) }
      end

      # Raw POST request, formatted for Dyn. See list of endpoints at:
      #
      # https://help.dynect.net/api/
      #
      # Read the API documentation, and submit the proper data structure from here.
      #
      # @param [String] The partial path to POST - for example, 'senders' or 'accounts'.
      # @param [Hash] The data structure to submit as the body, is automatically turned to encoded Form POST
      # @param [Hash] Additional HTTP headers
      def post(path_part, form_params = {}, additional_headers = {}, &block)
        api_request { @rest.post("/rest/json/#{path_part}", URI.encode_www_form(form_params.merge({apikey:@apikey})), additional_headers, &block) }
      end

      # Handles making Dynect API requests and formatting the responses properly.
      def api_request(&block)
        response_body = begin
          response = block.call
          response.body
        rescue Exception => e
          if @verbose
            puts "I have #{e.inspect} with #{e.http_code}"
          end
          e.response
        end
        
        response = JSON.parse(response_body || '{}')
        
        if (response["response"] && response["response"]["status"] == 200)
          response["response"]["data"]
        else
          response
        end
      end
    end
  end
end
