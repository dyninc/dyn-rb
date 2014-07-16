require 'dyn-rb'

d = Dyn::Traffic::Client.new('yourcustomername', 'yourusername', 'yourpassword')

d.zone = "example.com"

# puts d.zone.create(:rname => "test@example.com", :ttl => 30)
puts d.zone.get_all.inspect

d.a.fqdn("foo.example.com").ttl(3600).address("192.168.1.1").save(:replace)
d.cname.fqdn("foo2.example.com").cname("ec2-10-10-10-10.amazonaws.com").save(:replace)
d.http_redirect.fqdn("cool.example.com").code(301).keep_uri("Y").url("https://maint.example.com").save(:replace)

puts d.zone.publish

# sleep 10

# puts d.http_redirect.fqdn("cool.example.com").code(301).keep_uri("Y").url("https://maint.example.com").delete
# puts d.zone.publish

#
# gslb = d.gslb
# gslb.fqdn("sunshine.example.com").ttl(30).region_code("global")
# gslb.min_healthy(1).serve_count(2)
# gslb.monitor(:protocol => "HTTP", :interval => 1, :port => 8000, :path => "/healthcheck", :host => "sunshine.example.com")
# gslb.add_host(:address => "1.1.1.1", :label => "friendly_name", :weight => 10, :serve_mode => "obey")
# gslb.add_host(:address => "1.1.1.2", :label => "friendly_name2", :weight => 10, :serve_mode => "obey")
#
# sleep 5
#
# puts gslb.save.inspect
# puts gslb.publish
#
# puts gslb.inspect
#
#
# sleep 5
#
# puts d.zone.delete.inspect
# puts d.zone.get_all.inspect
#
# puts d.get('Contact').inspect
#
# puts d.logout
#
