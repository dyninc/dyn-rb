apikey = "yourapikey"

require 'dyn-rb'
dyn = Dyn::Messaging::Client.new(apikey)

from = 'Sender <sender@example.com>'
to = 'Recipient <client@somecompany.com>'
subject = 'Test send from Ruby Client'
bodytext = 'This is a test of the Ruby Client'
xheaders = {
    	'X-Campaign' => 'value1',
    	'X-Local' => 'value2',
    	'X-TheFooRemains' => 'true',
    	'X-theFourth' => 'empty'
    }


# accounts
puts "creating account..."
sub_acct_apikey = dyn.accounts.create("account@example.com", "secrets", "big company", "(123) 456-7890", "123 main street", "boston", "MA", "12345", "east coast", "http://www.bounce.com", "http://www.spam.com", "http://www.unsubscribeme.com", "http://www.trackopensplease.com", "http://www.tracklinksplease.com", "http://www.trackunsubscribesplease.com", "generatenewapikeyplease")
puts sub_acct_apikey

puts "adding xheaders..."
puts dyn.accounts.update_xheaders("X-HeaderName1","X-Testing2","X-Wondering3","X-Observational4")

puts "retrieving xheaders list..."
puts dyn.accounts.list_xheaders

puts "updating xheaders"
args = xheaders.keys
puts dyn.accounts.update_xheaders(*args)

puts "listing updated headers"
puts dyn.accounts.list_xheaders

puts "deleting account..."
puts dyn.accounts.destroy("account@example.com")


# senders
puts "retrieving senders list..."
puts dyn.senders.list
puts dyn.senders.list(2)
# 
puts "creating sender..."
puts dyn.senders.create("person@example.com",0)
puts dyn.senders.list

puts "getting details..."
puts dyn.senders.details("person@example.com")

puts "getting status..."
puts dyn.senders.status("person@example.com")

puts "updating dkim..."
dyn.senders.dkim("person@example.com", "987")
puts dyn.senders.details("person@example.com")

puts "deleting sender..."
puts dyn.senders.destroy("person@example.com")
puts dyn.senders.list


# send mail
# make sure sender is in approved list
dyn.senders.create('sender@example.com')
puts "sending mail..."
puts dyn.send_mail.create(from, to, subject, bodytext, "<html>hi html</html>", "ccaddress@example.com", "replyto@recipient.com", xheaders)

