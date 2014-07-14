apikey = "yourapikey"

require 'dyn-rb'
dyn = Dyn::Messaging::Client.new(apikey)

# senders
# puts "retrieving senders list..."
# puts dyn.senders.list(2).inspect
# 
# puts "creating sender..."
# puts dyn.senders.create("person@example.com", 0).inspect
# 
# puts "updating sender..."
# puts dyn.senders.update("person@example.com", 2).inspect
# 
# puts "getting details..."
# puts dyn.senders.details("person@example.com").inspect
# 
# puts "getting status..."
# puts dyn.senders.status("person@example.com").inspect
# 
# puts "updating dkim..."
# puts dyn.senders.dkim("person@example.com", "3").inspect

# # puts "deleting sender..."
# # puts dyn.senders.destroy("person@example.com").inspect

# accounts
# puts "creating account..."
# puts dyn.accounts.create("account@example.com", "secrets", "big company", "(123) 456-7890", "123 main street", "boston", "MA", "12345", "east coast", "http://www.bounce.com", "http://www.spam.com", "http://www.unsubscribeme.com", "http://www.trackopensplease.com", "http://www.tracklinksplease.com", "http://www.trackunsubscribesplease.com", "generatenewapikeyplease").inspect
# 
# puts "retrieving accounts list..."
# puts dyn.accounts.list.inspect
# 
# puts "retrieving xheaders list..."
# puts dyn.accounts.list_xheaders.inspect
# 
# puts "updating xheaders..."
# puts dyn.accounts.update_xheaders("X-header1").inspect

# # puts "deleting account..."
# # puts dyn.accounts.destroy("account@example.com").inspect

# recipients
# puts "retrieving status of recipient..."
# puts dyn.recipients.status("example@example.com").inspect
# 
# puts "activating recipient..."
# puts dyn.recipients.activate("example@example.com").inspect

# suppressions
# puts "retrieving suppressions list..."
# puts dyn.suppressions.list("2013-11-11", "2013-12-12").inspect
# 
# puts "retrieving suppressions count..."
# puts dyn.suppressions.count("2013-11-11", "2013-12-12").inspect
# 
# puts "adding to suppression list..."
# puts dyn.suppressions.create("example@example.com").inspect
# 
# puts "activating from suppression list..."
# puts dyn.suppressions.activate("example@example.com").inspect

# delivery
# puts "retrieving delivery count..."
# puts dyn.delivery.count("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect
# 
# puts "retrieving delivery list..."
# puts dyn.delivery.list("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect

# sent
# puts "retrieving sent count..."
# puts dyn.sent_mail.count("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect
# 
# puts "retrieving sent list..."
# puts dyn.sent_mail.list("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect

# bounces
# puts "retrieving bounces count..."
# puts dyn.bounces.count("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect
# 
# puts "retrieving bounces list..."
# puts dyn.bounces.list("2013-11-11", "2013-12-12", 0, "example@example.com", "dani@thesunnycloud.com", "hardbounce", "noheaders" "X-example4").inspect

# complaints
# puts "retrieving complaints count..."
# puts dyn.complaints.count("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect
# 
# puts "retrieving complaints list..."
# puts dyn.complaints.list("2013-11-11", "2013-12-12", "example@example.com", "X-example4").inspect

# issues
# puts "retrieving issues count..."
# puts dyn.issues.count("2013-11-11", "2013-12-12").inspect
# 
# puts "retrieving issues list..."
# puts dyn.issues.list("2013-11-11", "2013-12-12").inspect

# opens
# puts "retrieving opens count..."
# puts dyn.opens.count("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving opens list..."
# puts dyn.opens.list("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving unique opens count..."
# puts dyn.opens.unique_count("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving unique list..."
# puts dyn.opens.unique("2013-11-11", "2013-12-12", "X-example4").inspect

# clicks
# puts "retrieving clicks count..."
# puts dyn.clicks.count("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving clicks list..."
# puts dyn.clicks.list("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving unique clicks count..."
# puts dyn.clicks.unique_count("2013-11-11", "2013-12-12", "X-example4").inspect
# 
# puts "retrieving unique list..."
# puts dyn.clicks.unique("2013-11-11", "2013-12-12", "X-example4").inspect

# send mail
# puts "sending mail..."
# puts dyn.send_mail.create("example@example.com", "recipient@recipient.com", "hi!", "from the ruby api!", "<html>hi html</html>", "replyto@example.com", "ccaddress@recipient.com", "xheader1").inspect
