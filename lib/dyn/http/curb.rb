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
require 'curb'

module Dyn
  module HttpClient
    class CurbClient < Base
      private

      def fixup_request(original)
        headers = original[:headers]

        if !original[:body].nil? && headers["Content-Type"].nil?
          headers = headers.merge({"Content-Type" => "application/x-www-form-urlencoded"})
        end

        original.merge({:headers => headers})
      end

      def perform_request(method, uri, body, headers)
        options = {}
        options[:data] = body unless body.nil?
        options[:max_redirects] = 0
        headers = headers ? headers : {}

        response = Curl.http(method.to_s.upcase.to_sym, @base_url + uri, options) do |http|
          headers.each do |k,v|
            http.headers[k] = v
          end
        end

        Response.new(response.status.split(" ").shift.to_i, response.body, parse_headers(response.header_str))
      end
      
      def parse_headers(header_data)
        headers = {}

        header_data.split(/\r\n/).each do |header|
          if header =~ %r|^HTTP/1.[01]|
            # ignore
          else
            parts = header.split(':', 2)
            unless parts.empty?
              parts[1].strip! unless parts[1].nil?
              if headers.has_key?(parts[0])
                headers[parts[0]] = [headers[parts[0]]] unless headers[parts[0]].kind_of? Array
                headers[parts[0]] << parts[1]
              else
                headers[parts[0]] = parts[1]
              end
            end
          end
        end

        headers
      end
    end
    
    unless defined?(DefaultClient)
      class DefaultClient < Dyn::HttpClient::CurbClient
      end
    end
  end
end