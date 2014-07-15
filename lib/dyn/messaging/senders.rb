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
    class Senders
      def initialize(dyn)
        @dyn = dyn
      end

      def list(startindex="0")
        @dyn.get("#{resource_path}", {startindex:startindex})
      end

      def create(email, seeding="0")
        @dyn.post("#{resource_path}", {emailaddress:email, seeding:seeding})
      end

      def update(email, seeding="0")
        @dyn.post("#{resource_path}", {emailaddress:email, seeding:seeding})
      end

      def destroy(email)
        @dyn.post("#{resource_path}/delete", {emailaddress:email})
      end

      def details(email)
        @dyn.get("#{resource_path}/details", {emailaddress:email})
      end

      def status(email)
        @dyn.get("#{resource_path}/status", {emailaddress:email})
      end

      def dkim(email, dkim)
        @dyn.post("#{resource_path}/dkim", {emailaddress:email, dkim:dkim})
      end
      
      private
      
      def resource_path
        "senders"
      end
    end
  end
end
