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
    class Accounts
      def initialize(dyn)
        @dyn = dyn
      end

      def list(startindex="0")
        @dyn.get("#{resource_path}", {startindex:startindex})
      end

      def create(username, password, companyname, phone, address, city, state, zipcode, country, timezone, bounceurl, spamurl, unsubscribeurl, tracelinks, trackunsubscribes, generatenewapikey)
        @dyn.post("#{resource_path}", {username:username, password:password, companyname:companyname, phone:phone, address:address, city:city, state:state, zipcode:zipcode, country:country, timezone:timezone, bounceurl:bounceurl, spamurl:spamurl, unsubscribeurl:unsubscribeurl, tracelinks:tracelinks, trackunsubscribes:trackunsubscribes, generatenewapikey:generatenewapikey})
      end

      def destroy(username)
        @dyn.post("#{resource_path}/delete", {username:username})
      end

      def list_xheaders
        @dyn.get("#{resource_path}/xheaders")
      end

      def update_xheaders(xh1, xh2, xh3, xh4)
        @dyn.post("#{resource_path}/xheaders", {xheader1:xh1,xheader2:xh2,xheader3:xh3,xheader4:xh4})
      end
      
      private
      
      def resource_path
        "accounts"
      end
    end
  end
end
