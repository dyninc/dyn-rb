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
require 'patron'

module Dyn
  module HttpClient
    class PatronClient < Base
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

        response = Patron::Session.new.request(method.to_s.downcase.to_sym, @base_url + uri, headers, options)

        Response.new(response.status, response.body, response.headers)
      end
    end
    
    unless defined?(DefaultClient)
      class DefaultClient < Dynect::HttpClient::PatronClient
      end
    end
  end
end
