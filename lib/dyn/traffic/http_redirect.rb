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
    class HTTPRedirect
      attr_accessor :fqdn, :code, :keep_uri, :url

      def initialize(dyn, zone, fqdn=nil)
        @dyn = dynect
        @zone = zone
        @fqdn = fqdn
        @code = nil
        @keep_uri = nil
        @url = nil
      end

      def fqdn(value=nil)
        value ? (@fqdn = value; self) : @fqdn
      end

      def code(value=nil)
        value ? (@code = value; self) : @code
      end

      def keep_uri(value=nil)
        value ? (@keep_uri = value; self) : @keep_uri
      end

      def url(value=nil)
        value ? (@url = value; self) : @url
      end

      def resource_path
        "HTTPRedirect"
      end

      def get(fqdn = nil, record_id=nil)
        @dyn.get("#{resource_path}/#{zone}/#{fqdn}/")
      end

      def save(replace=false)
        if replace == true || replace == :replace
          @dyn.put("#{resource_path}/#{@zone}/#{@fqdn}/", self)
        else
          @dyn.post("#{resource_path}/#{@zone}/#{@fqdn}/", self)
        end
        self
      end

      def delete
        @dyn.delete("#{resource_path}/#{@zone}/#{@fqdn}/")
      end

      def to_json
        {
          "zone" => @zone,
          "fqdn" => @fqdn,
          "code" => @code,
          "keep_uri" => @keep_uri,
          "url" => @url
        }.to_json
      end
    end
  end
end
