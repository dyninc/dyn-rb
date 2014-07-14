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
    class Opens
      def initialize(dyn)
        @dyn = dyn
      end

      def count(starttime, endtime)
        @dyn.get("#{resource_path}/count", {starttime:starttime, endtime:endtime})
      end

      def list(starttime, endtime, startindex=0)
        @dyn.get("#{resource_path}", {starttime:starttime, endtime:endtime, startindex:startindex})
      end

      def unique_count(starttime, endtime)
        @dyn.get("#{resource_path}/count/unique", {starttime:starttime, endtime:endtime})
      end

      def unique(starttime, endtime, startindex=0)
        @dyn.get("#{resource_path}/unique", {starttime:starttime, endtime:endtime, startindex:startindex})
      end
      
      private
      
      def resource_path
        "reports/opens"
      end
    end
  end
end
