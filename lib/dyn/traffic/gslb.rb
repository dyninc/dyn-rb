#
# Author:: Sunny Gleason (<sunny@thesunnycloud.com>)
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Evan  (<evan@pagerduty.com>)
# Copyright:: Copyright (c) 2013 Dyn, Inc.
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# Copyright:: Copyright (c) 2013 PagerDuty, Inc.
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
    class GSLB < Base
      def initialize(dyn, zone, options)
        @dyn           = dyn
        @zone          = zone
        @resource_path = "GSLB/#{@zone}"

        @fqdn         = options[:fqdn]
        @ttl          = options[:ttl] || 30
        @host_list    = options[:host_list] || {}
        @contact_nick = options[:contact_nick] || 'owner'
      
        @region_code  = options[:region_code] || 'global'
        @monitor      = options[:monitor] || {}
        @serve_count  = options[:serve_count] || 1
        @min_healthy  = options[:min_healthy] || 1
      end

      def [](host_list_key)
        @host_list[host_list_key]
      end

      def fqdn(value=nil)
        value ? (@fqdn = value; self) : @fqdn
      end

      def contact_nick(value=nil)
        value ? (@contact_nick = value; self) : @contact_nick
      end

      def ttl(value=nil)
        value ? (@ttl = value; self) : @ttl
      end

      def min_healthy(value=nil)
        value ? (@min_healthy = value; self) : @min_healthy
      end

      def serve_count(value=nil)
        value ? (@serve_count = value; self) : @serve_count
      end

      def region_code(value=nil)
        # US West, US Central, US East, EU West, EU Central, EU East, Asia, global
        value ? (@region_code = value; self) : @region_code
      end

      def host_list(value=nil)
        value ? (@host_list = value; self) : @host_list
      end

      def monitor(value=nil)
        # :protocol => 'HTTP', :interval => 1, :retries => 2, :timeout => 10, :port => 8000,
        # :path => '/healthcheck', :host => 'example.com', :header => 'X-User-Agent: DynECT Health\n', :expected => 'passed'
        if value
          @monitor = {}
          value.each do |k,v|
            @monitor[k] = v
          end
        end
        @monitor
      end

      def add_host(value)
        # :address => 'x.x.x.x', :label => 'friendly-name', :weight => 10, :serve_mode => 'obey'
        @host_list[value[:address]] = value
        self
      end

      def resource_path
        "GSLB/#{@zone}"
      end

      def get(fqdn=nil, region_code='global')
        if fqdn
          results = @dyn.get("#{@resource_path}/#{fqdn}")
          region = {}
          results["region"].each {|r| region = r if r["region_code"] == region_code}
          raise Dyn::Exceptions::RequestFailed, "Cannot find #{region_code} GSLB pool for #{fqdn}" if region.empty?

          # Default monitor timeout is 0, but specifying timeout 0 on a put or post results in an exception
          results["monitor"].delete("timeout") if results["monitor"]["timeout"] == 0

          host_list = {}
          region["pool"].each do |h|
            host_list[h["address"]] = {
                                      :address => h["address"],
                                      :label => h["label"],
                                      :weight => h["weight"],
                                      :serve_mode => h["serve_mode"]
                                      }
          end
          Dyn::Traffic::GSLB.new(@dyn, results["zone"], {
                                   :fqdn => results["fqdn"],
                                   :ttl => results["ttl"],
                                   :host_list => host_list,
                                   :contact_nick => results["contact_nickname"],
                                   :region_code => region["region_code"],
                                   :monitor => results["monitor"],
                                   :serve_count => region["serve_count"],
                                   :min_healthy => region["min_healthy"]
                                   })
        else
          @dyn.get(resource_path)
        end
      end

      def find(fqdn, query_hash)
        results = []
        get(fqdn).each do |rr|
          query_hash.each do |key, value|
            results << rr if rr[key.to_s] == value
          end
        end
        results
      end

      def save(replace=false)
        if replace == true || replace == :replace
          @dyn.put("#{@resource_path}/#{@fqdn}", self)
        else
          @dyn.post("#{@resource_path}/#{@fqdn}", self)
        end
        self
      end

      def delete
        @dyn.delete("#{@resource_path}/#{fqdn}")
      end

      def to_json
        {
          "ttl"   => @ttl,
          "monitor" => @monitor,
          "region" => {
            "region_code" => @region_code,
            "serve_count" => @serve_count,
            "min_healthy" => @min_healthy,
            "pool" => @host_list.values
          },
          "contact_nickname" => @contact_nick
        }.to_json
      end
    end
  end
end
