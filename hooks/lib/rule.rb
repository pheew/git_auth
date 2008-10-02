module GitAuth
  class Rule
  
    attr_accessor :members, :pattern, :right
    attr_reader :expanded_members
    
    def initialize(members, pattern, right)
      @members = members
      @pattern = pattern
      @right = right
    end
    
    def expand!
      unless @expanded_members
        @expanded_members = Group.expand! @members
      end
      @expanded_members
    end
  end
end