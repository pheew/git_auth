module GitAuth
  class Rule
  
    attr_accessor :members, :pattern
    attr_reader :expanded_members, :config
    
    def initialize(members, pattern, config)
      @members = members
      @pattern = pattern
      @config = config
    end
    
    def user_pattern(user)
      Regexp.new pattern.sub("{user}",user) 
    end

    def expand!
      unless @expanded_members
        @expanded_members = Group.expand!(@config, @members)
      end
      @expanded_members
    end
  end
end
