require 'twilio-ruby'
require 'open-uri'
namespace :server do
  desc "is lavatech.com up?"
  task :up => :environment do
  	begin
    	io = open("http://www.lavatech.com/")
    	if io.status[0] != "200"
    		notify_down
    	end
    rescue => e
    	notify_down
    	raise e
    end
    begin
      io = open("http://www.baysidelaw.com/")
      if io.status[0] != "200"
        notify_down
      end
    rescue => e
      notify_down
      raise e
    end
  end
end

def notify_down
	account_sid = ENV["TWILIO_SID"]
	auth_token = ENV["TWILIO_AUTH_TOKEN"]
	@client = Twilio::REST::Client.new account_sid, auth_token
	@client.account.sms.messages.create(
		:from => ENV["TWILIO_PHONE"],
		:to => ENV["JIM_PHONE"],
		:body => "lavatech.com or baysidelaw.com is down!"
	)
end
