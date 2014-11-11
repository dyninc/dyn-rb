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
    class Base
      attr_accessor :zone

      # Publish any pending changes to the zone - required to make any alterations permanent.
      #
      # See: https://manage.dynect.net/help/docs/api2/rest/resources/Zone.html
      #
      # @param [String] The zone to publish - if one is provided when instantiated, we use that.
      # @return [Hash] The dynect API response
      def publish
        @dyn.put("Zone/#{@zone}", { "publish" => true })
      end

      # Discard any pending changes in the session - required if you don't with to persist changes.
      #
      # See: https://help.dynect.net/delete-zone-change-set-api/
      #
      # @param [String] The zone to discard changes for - if one is provided when instantiated, we use that.
      # @return [Hash] The dynect API response
      def discard_change_set
        @dyn.delete("ZoneChanges/#{@zone}")
      end

      # Freeze the zone.
      #
      # See: https://manage.dynect.net/help/docs/api2/rest/resources/Zone.html
      #
      # @param [String] The zone to freeze - if one is provided when instantiated, we use that.
      # @return [Hash] The dynect API response
      def freeze
        @dyn.put("Zone/#{@zone}", { "freeze" => true })
      end

      # Thaw the zone.
      #
      # See: https://manage.dynect.net/help/docs/api2/rest/resources/Zone.html
      #
      # @param [String] The zone to thaw - if one is provided when instantiated, we use that.
      # @return [Hash] The dynect API response
      def thaw
        @dyn.put("Zone/#{@zone}", { "thaw" => true })
      end

    end
  end
end
