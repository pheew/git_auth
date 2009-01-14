module GitAuth
  
  class Log
    
    def self.tell_user(msg)
      STDERR << msg << "\n"
    end
    
    def self.debug(msg)
      	STDERR << msg << "\n"
    end
    
  end
  
end