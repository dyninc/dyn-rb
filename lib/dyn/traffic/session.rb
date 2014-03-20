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
    class Session < Base
      def initialize(dyn)
        @dyn = dyn
      end
      
      def create
        @dyn.post('Session', { 'customer_name' => @dyn.customer_name, 'user_name' => @dyn.user_name, 'password' => @dyn.password }, {})
      end

      def delete
        @dyn.delete('Session')
      end
    end
  end
end