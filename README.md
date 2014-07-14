# Dyn SDK for Ruby

NOTE: This SDK is brand new - we welcome your feedback!
Please reach out via pull request or GitHub issue.

Install via:

    gem install dyn-rb

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

Working with Messaging is as easy as:

    require 'dyn-rb'
    
    # 1: create the client
    dyn = Dyn::Messaging::Client.new(apikey)
    
    # 2: work with accounts
    puts "retrieving accounts list..."
    puts dyn.accounts.list.inspect
    
    # 3: work with senders
    dyn.senders.create("person@example.com", 0)
    
    # 4: work with recipients
    puts dyn.recipients.status("example@example.com").inspect
    
    # 5: send mail
    dyn.send_mail.create("example@example.com", "recipient@recipient.com", "hi!", "from the ruby api!", "<html>hi html</html>", "replyto@example.com", "ccaddress@recipient.com", "xheader1")
    
    # 6: check reports
    puts dyn.delivery.list("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect

# Examples

See more comprehensive examples in the "examples" folder!

# API Endpoints Supported

* Traffic - Session API: create/destroy
* Traffic - Record API: AAAA A CNAME DNSKEY DS KEY LOC MX NS PTR RP SOA SRV TXT
* Traffic - GSLB API: get/create/update/delete
* Traffic - Http Redirect API: get/create/update/delete
* Traffic - Zone API: publish/freeze/thaw
* Messaging - All Endpoints Supported

# Ruby HTTP Clients Supported

* net_http
* curb
* patron

# Known Issues

* None yet

# License

Apache License v2.0
