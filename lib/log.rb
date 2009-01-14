require "syslog"
module GitAuth
  
  class Log
    
    def self.tell_user(msg)
      STDERR << msg << "\n"
    end
    
    def self.debug(msg)
	 Syslog.open "GitAuth ssh_serve.rb" do |log|
	log.debug msg
	end
      	STDERR << msg << "\n"
    end
    
  end
  
end
