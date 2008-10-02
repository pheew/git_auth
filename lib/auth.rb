module GitAuth
  class Auth
    def self.has_rights?(user_name, ref, right)
      
      defaults = Config.config.get_relevant_defaults ref
      rules = Config.config.get_relevant_rules user_name, ref
      allowed = false
  
      defaults.each do |d|
        allowed = d.right.include? right
      end
      puts "After defaults processing: #{allowed}"
      
      rules.each do |r|
        allowed = r.right.include? right
      end
      puts "After rules processing: #{allowed}"
      
      allowed
      
    end
  end
end