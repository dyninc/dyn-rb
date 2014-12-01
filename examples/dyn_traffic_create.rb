#!/usr/bin/env ruby

# inspired by https://github.com/floehmann/dynect_create
# updated to use 'dyn-rb' gem

require 'rubygems'
require 'dyn-rb'
require 'micro-optparse'

opts = Parser.new do |mo|
  mo.option :host, "Host name to add (Note: don't add domain)", :type => :string, :default => ""
  mo.option :ip, "IP address of host's A record", :type => :string, :default => ""
  mo.option :ip6, "IPv6 address of host's AAAA record", :type => :string, :default => ""
  mo.option :cname, "CNAME fqdn", :type => :string, :default => ""
  mo.option :rrttl, "TTL for all records in this update", :type => :integer, :default => 300
end.process!

## Set variables 
DYN_CUST = ENV['DYN_CUST'] || 'customer'
DYN_USER = ENV['DYN_USER'] || 'user'
DYN_PASS = ENV['DYN_PASS'] || 'secretword'
DYN_ZONE = ENV['DYN_ZONE'] || 'example.com'

# These are required
ip = opts[:ip]
host = opts[:host].downcase

# Someday required... 
ip6 = opts[:ip6]

# Add check for valid number
rrttl = opts[:rrttl].to_s

# Fix these checks and add them for valid ipv4/ipv6 addresses

# Make sure host is fully qualified
if ( host =~ /#{DYN_ZONE}/i )
    fullhost = host
else
    fullhost = "#{host}.#{DYN_ZONE}"
end

# Check CNAME is fully qualified
if not (opts[:cname].empty? and opts[:cname].nil?)
  cname = opts[:cname].downcase
  if not cname =~ /.*\..*/i
      abort("Error: CNAME must be fully qualified.")
  end 
else
  cname = ''
end

## Set up session
dyn = Dyn::Traffic::Client.new(DYNECT_CUST, DYNECT_USER, DYNECT_PASS, DYNECT_ZONE, true)

## If an A or AAAA record exists update it with PUT
## Otherwise add it with POST
##
## Need to figure out how to handle the error better.

## Create or Update an A Record for the given host
if not (ip.empty? and fullhost.empty?)
  begin 
    a_rec = dyn.a.get(fullhost)
    a_addr = a_rec.rdata['address']
    puts "Updating A record #{fullhost} -> #{ip} to #{a_addr}"
    dyn.a.fqdn(fullhost).ttl(rrttl).address(ip).save(true)
  rescue Dyn::Exceptions::RequestFailed
    puts "Adding A record #{fullhost} -> #{ip}"
    dyn.a.fqdn(fullhost).ttl(rrttl).address(ip).save(false)
  end
end

## Create or Update an AAAA Record for the given host
if not (ip6.empty? and ip6.nil?)
  begin 
    aaaa_rec = dyn.aaaa.get(fullhost)
    aaaa_addr = aaaa_rec.rdata['address']
    puts "Updating AAAA record #{fullhost} -> #{ip6} to #{aaaa_addr}"
    dyn.aaaa.fqdn(fullhost).ttl(rrttl).address(ip6).save(true)
  rescue Dyn::Exceptions::RequestFailed
    puts "Adding AAAA record #{fullhost} -> #{ip6}"
    dyn.aaaa.fqdn(fullhost).ttl(rrttl).address(ip6).save(false)
  end
end

## Create a new CNAME record
if not (cname.empty? and cname.nil?)
  begin 
    cname_rec = dyn.cname.get(cname)
    cname_fqdn = cname_rec.fqdn
    cname_target = cname_rec.rdata['cname']
    puts "WARN: CNAME exists #{cname_fqdn} -> #{cname_target} ...  Not adding."
  rescue Dyn::Exceptions::RequestFailed
    puts "Adding CNAME #{cname} -> #{fullhost}"
    dyn.cname.fqdn(cname).ttl(rrttl).cname(fullhost).save
  end
end

## Publish zone
puts "Publishing #{DYN_ZONE}"
dyn.publish

## End session
puts "Logging off"
dyn.logout

