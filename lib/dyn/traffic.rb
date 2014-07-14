#
# Author:: Sunny Gleason (<sunny@thesunnycloud.com>)
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2013 Dyn, Inc.
# Copyright:: Copyright (c) 2010 Opscode, Inc.
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
  module Traffic
    class Client
      require 'json'
      require 'dyn/exceptions'
      require 'dyn/traffic/base'
      require 'dyn/traffic/gslb'
      require 'dyn/traffic/http_redirect'
      require 'dyn/traffic/qps_report'
      require 'dyn/traffic/resource'
      require 'dyn/traffic/secondary_zone'
      require 'dyn/traffic/session'
      require 'dyn/traffic/zone'
      require 'dyn/http/http_client'

      unless defined?(Dyn::HttpClient::DefaultClient)
        require 'dyn/http/net_http'
      end

      attr_accessor :customer_name, :user_name, :password, :rest, :auth_token

      # Creates a new base object for interacting with Dyn's REST API
      #
      # @param [String] Your dyn customer name
      # @param [String] Your dyn user name
      # @param [String] Your dyn password
      # @param [String] The zone you are going to be editing
      # @param [Boolean] Whether to connect immediately or not - runs login for you
      # @param [Boolean] Verbosity
      def initialize(customer_name, user_name, password, zone=nil, connect=true, verbose=false, max_redirects=10)
        @customer_name = customer_name
        @user_name = user_name
        @password = password
        @rest = Dyn::HttpClient::DefaultClient.new("api2.dynect.net", "443", "https")
        @rest.default_headers = {
          'User-Agent'   => 'dyn-rb 1.0.2',
          'Content-Type' => 'application/json'
        }
        @zone = zone 
        @verbose = verbose
        @session = Dyn::Traffic::Session.new(self)
        login if connect
      end

      # Login to Dyn - must be done before any other methods called.
      #
      # See: https://manage.dynect.net/help/docs/api2/rest/resources/Session.html
      #
      # @return [Hash] The dynect API response
      def login
       response = @session.create
       @auth_token = response["token"]
       @rest.default_headers = { 'Content-Type' => 'application/json', 'Auth-Token' => @auth_token }
       response
      end

      # Logout of Dyn - generally the last operation performed
      #
      # See: https://manage.dynect.net/help/docs/api2/rest/resources/Session.html
      #
      # @return [Hash] The dynect API response
      def logout
       response = @session.delete
       @auth_token = nil
       @rest.default_headers = { 'Content-Type' => 'application/json' }
       response
      end

      # for convenience...
      def publish
        zone.publish
      end

      ##
      # Zone attribute setter
      ##
      def zone=(zone)
        @zone = zone
      end

      ##
      # HTTPRedirect API
      ##
      def http_redirect(options = {})
        Dyn::Traffic::HTTPRedirect.new(self, @zone, options)
      end

      ##
      # Session API
      ##
      def session
        Dyn::Traffic::Session.new(self)
      end

      ##
      # GSLB API
      ##
      def gslb(options = {})
        Dyn::Traffic::GSLB.new(self, @zone, options)
      end

      ##
      # Zone API
      ##
      def zone
        Dyn::Traffic::Zone.new(self, @zone)
      end

      # Convert a CamelCasedString to an under_scored_string.
      def self.underscore(string)
        word = string.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      ##
      # Resource Record API
      ##
      %w{AAAA A CNAME DNSKEY DS KEY LOC MX NS PTR RP SOA SRV TXT}.each do |record_type|
        define_method underscore(record_type) do
          Dyn::Traffic::Resource.new(self, @zone, "#{record_type}")
        end
      end

      # Raw GET request, formatted for Dyn. See list of endpoints at:
      #
      # https://manage.dynect.net/help/docs/api2/rest/resources/
      #
      # @param [String] The partial path to GET - for example, 'User' or 'Zone'.
      # @param [Hash] Additional HTTP headers
      def get(path_part, additional_headers = {}, &block)
        api_request { @rest.get('/REST/' + path_part, nil, additional_headers, &block) }
      end

      # Raw DELETE request, formatted for Dyn. See list of endpoints at:
      #
      # https://manage.dynect.net/help/docs/api2/rest/resources/
      #
      # @param [String] The partial path to DELETE - for example, 'User' or 'Zone'.
      # @param [Hash] Additional HTTP headers
      def delete(path_part, additional_headers = {}, &block)
        api_request { @rest.delete('/REST/' + path_part, "", additional_headers, &block) }
      end

      # Raw POST request, formatted for Dyn. See list of endpoints at:
      #
      # https://manage.dynect.net/help/docs/api2/rest/resources/
      #
      # Read the API documentation, and submit the proper data structure from here.
      #
      # @param [String] The partial path to POST - for example, 'User' or 'Zone'.
      # @param [Hash] The data structure to submit as the body, is automatically turned to JSON.
      # @param [Hash] Additional HTTP headers
      def post(path_part, payload, additional_headers = {}, &block)
        api_request { @rest.post('/REST/' + path_part, payload.to_json, additional_headers, &block) }
      end

      # Raw PUT request, formatted for Dyn. See list of endpoints at:
      #
      # https://manage.dynect.net/help/docs/api2/rest/resources/
      #
      # Read the API documentation, and submit the proper data structure from here.
      #
      # @param [String] The partial path to PUT - for example, 'User' or 'Zone'.
      # @param [Hash] The data structure to submit as the body, is automatically turned to JSON.
      # @param [Hash] Additional HTTP headers
      def put(path_part, payload, additional_headers = {}, &block)
        api_request { @rest.put('/REST/' + path_part, payload.to_json, additional_headers, &block) }
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
          if e.http_code == 307
            e.response.sub!('/REST/','') if e.response =~ /^\/REST\//
            get(e.response)
          end
          e.response
        end
        
        parse_response(JSON.parse(response_body || '{}'))
      end

      # 
      def parse_response(response)
        case response["status"]
        when "success"
          response["data"]
        when "incomplete"
          # we get 'incomplete' when the API is running slow and claims the session has a previous job running
          # raise an error and return the job ID in case we want to ask the API what the job's status is
          error_messages = []
          error_messages.push( "This session may have a job _still_ running (slowly). Call /REST/Job/#{response["job_id"]} to get its status." )
          response["msgs"].each do |error_message|
            error_messages << "#{error_message["LVL"]} #{error_message["ERR_CD"]} #{error_message["SOURCE"]} - #{error_message["INFO"]}"
          end
          raise Dyn::Exceptions::IncompleteRequest.new( "#{error_messages.join("\n")}", response["job_id"] )
        when "failure"
          error_messages = []
          response["msgs"].each do |error_message|
            error_messages << "#{error_message["LVL"]} #{error_message["ERR_CD"]} #{error_message["SOURCE"]} - #{error_message["INFO"]}"
          end
          raise Dyn::Exceptions::RequestFailed, "Request failed: #{error_messages.join("\n")}" 
        end
      end
    end
  end
end
