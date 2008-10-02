module GitAuth
  class Auth
    
    def self.can_write?(user_name, ref)
      
      Log.debug "Verifying write permissions for user \"#{user_name}\" with pattern \"#{ref}\""
      
      
      allowed = false
      
      Config.config.writers.each do |writer|
        if writer.expanded_members.include?(user_name) && ref =~ writer.user_pattern(user_name)
          allowed = true
          break
        end
      end    
      
      Log.debug "User was #{ allowed ? 'allowed' : 'denied'} write access for ref: \"#{ref}\""
        
      allowed
      
    end
    
    def self.can_read?(user)
      Log.debug "Verifying read permissions for user \"#{user}\""
      Config.config.readers.expanded_members.include? user
    end
    
  end
end