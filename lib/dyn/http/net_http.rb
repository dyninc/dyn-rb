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
require 'net/http'
require 'net/https'

module Dyn
  module HttpClient
    class NetHttpClient < Base
      private

      def fixup_request(original)
        original.merge({:method => original[:method].to_s})
      end

      def perform_request(method, uri, body, headers)
        client = Net::HTTP.new(@host, @port)
        client.use_ssl = true if @base_url.start_with? "https://"

        client.start do |http|
          response = http.send_request(method, uri, body, headers)

          the_headers = {}
          response.each_capitalized {|k,v| the_headers[k] = v}

          return Response.new(response.code.to_i, response.body, the_headers)
        end
      end
    end

    unless defined?(DefaultClient)
      class DefaultClient < Dynect::HttpClient::NetHttpClient
      end
    end
  end
end