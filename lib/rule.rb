module GitAuth
  class Rule
  
    attr_accessor :members, :pattern
    attr_reader :expanded_members
    
    def initialize(members, pattern)
      @members = members
      @pattern = pattern
    end
    
    def user_pattern(user)
      Regexp.new pattern.sub("{user}",user) 
    end
    
    def expand!
      unless @expanded_members
        @expanded_members = Group.expand! @members
      end
      @expanded_members
    end
  end
end