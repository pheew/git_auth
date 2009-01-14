module GitAuth
  class Auth
    
    def self.can_write?(user_name, ref, repo)
      
      Log.debug "Verifying write permissions for user \"#{user_name}\" with pattern \"#{ref}\""
      
      
      allowed = false
      
      Config.current_config(repo).writers.each do |writer|
        if writer.expanded_members.include?(user_name) && ref =~ writer.user_pattern(user_name)
          allowed = true
          break
        end
      end    
      
      Log.debug "User was #{ allowed ? 'allowed' : 'denied'} write access for ref: \"#{ref}\""
        
      allowed
      
    end
    
    def self.can_read?(user, repo)
      Log.debug "Verifying read permissions for user \"#{user}\" on repo \"#{repo}\""
      Config.current_config(repo).readers.expanded_members.include? user
    end
    
  end
end