# Dyn SDK for Ruby - Developer Preview

NOTE: This is a developer preview - we welcome your feedback!
Please reach out via pull request or GitHub issue.

Making DNS Updates as easy as:

    require 'dyn-rb'

    # 1: create the client
    dyn = Dyn::Traffic::Client.new(customer, username, password)

    # 2: set the zone
    dyn.zone = "example.com"

    # 3a: create an A record
    dyn.a.fqdn("foo.example.com").ttl(3600).address("192.168.1.1").save(:replace)

    # 3b: create a CNAME record
    dyn.cname.fqdn("foo2.example.com").cname("ec2-10-10-10-10.amazonaws.com").save(:replace)

    # 3c: create an HTTP redirect
    dyn.http_redirect.fqdn("cool.example.com").code(301).keep_uri("Y").url("https://maint.example.com").save(:replace)

    # 4: publish the changes
    dyn.zone.publish


Working with GSLB looks like:

    require 'dyn-rb'
   
    # 1: create the client
    dyn = Dyn::Traffic::Client.new(customer, username, password)
   
    # 2: set the zone
    dyn.zone = "example.com"
   
    # 3: get the GSLB service
    gslb = dyn.gslb
   
    # 4: set up GSLB parameters
    gslb.fqdn("sunshine.example.com").ttl(30).region_code("global")
    gslb.min_healthy(1).serve_count(2)
    gslb.monitor(:protocol => "HTTP", :interval => 1, :port => 8000, :path => "/healthcheck", :host => "sunshine.example.com")
    gslb.add_host(:address => "1.1.1.1", :label => "friendly_name", :weight => 10, :serve_mode => "obey")
    gslb.add_host(:address => "1.1.1.2", :label => "friendly_name2", :weight => 10, :serve_mode => "obey")
   
    # 5: save changes
    gslb.save
   
    # 6: publish zone
    dyn.zone.publish


# API Endpoints Supported

* Session API: create/destroy
* Record API: AAAA A CNAME DNSKEY DS KEY LOC MX NS PTR RP SOA SRV TXT
* GSLB API: get/create/update/delete
* Zone API: publish/freeze/thaw

# Ruby HTTP Clients Supported

* net_http
* curb
* patron

# Known Issues

* None yet
