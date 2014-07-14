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
    class SendMail
      def initialize(dyn)
        @dyn = dyn
      end

      def create(from, to, subject, bodytext, bodyhtml, cc, replyto, xheaders)
        @dyn.post("#{resource_path}", {from:from, to:to, subject:subject, bodytext:bodytext, cc:cc, replyto:replyto, xheaders:xheaders})
      end
      
      private
      
      def resource_path
        "send"
      end
    end
  end
end
