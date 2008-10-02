module GitAuth
  class Group
  
    attr_accessor :name, :members
    attr_reader :expanded_members
    
    def initialize(name, members)
      @name = name
      @members = members
    end
  
  
    def expand!
      unless @expanded_members
        @expanded_members = Group.expand! @members
      end
      @expanded_members
    end
  
    def self.expand!(members)
      _expanded_members = members.collect do |mem|
        # Check for @ at the start
        puts "Member: #{mem.inspect}\n"
        if mem[0] == 64
          Config::config.groups[mem[1..(mem.length - 1)]].expand!
        else
          mem
        end
      end
      _expanded_members.flatten
    end
  end
end