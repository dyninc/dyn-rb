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
  module HttpClient
    class Base
      attr_reader :host, :port, :base_url
      attr_accessor :default_headers, :request_handler, :response_handler

      def initialize(host, port, protocol = 'http')
        @host = host
        @port = port
        @base_url = "#{protocol}://#{host}:#{port.to_s}"
        @default_headers = {"User-Agent" => "dyn-rb 0.0.1"}
      end

      def request(method, uri, body, headers)
        if (method == :HEAD) && body
          raise ArgumentError, "#{method} must not contain a body!"
        end
        headers = @default_headers.merge(headers || {})
        original = {:method => method, :base_url => @base_url, :path => uri, :body => body, :headers => headers}
        fixedup  = fixup_request(original)

        @request_handler.call(fixedup) if @request_handler

        response = perform_request(fixedup[:method], fixedup[:path], fixedup[:body], fixedup[:headers])

        @response_handler.call({:status => response.status, :body => response.body, :headers => response.headers}) if @response_handler

        response
      end

      def head(uri, body, headers)
        request(:HEAD, uri, body, headers)
      end

      def get(uri, body, headers)
        request(:GET, uri, body, headers)
      end

      def post(uri, body, headers)
        request(:POST, uri, body, headers)
      end

      def put(uri, body, headers)
        request(:PUT, uri, body, headers)
      end

      def delete(uri, body, headers)
        request(:DELETE, uri, body, headers)
      end

      private

      def fixup_request(original)
        original
      end

      def perform_request(method, uri, body, headers)
        raise 'not implemented!'
      end
    end

    class Response
      attr_reader :status, :body, :headers
    
      def initialize(status, body, headers)
        @status  = status
        @body    = body
        @headers = headers
      end
    end
  end
end
