module GitAuth
  class Group
  
    attr_accessor :name, :members
    attr_reader :expanded_members, :config
    
    def initialize(name, members, config)
      @config = config;
      @name = name
      @members = members
    end
  
  
    def expand!
      unless @expanded_members
        @expanded_members = Group.expand!(@config, @members)
      end
      @expanded_members
    end
  
    def self.expand!(config, members)
      _expanded_members = members.collect do |mem|
        # Check for @ at the start
        if mem[0] == 64
          config.groups[mem[1..(mem.length - 1)]].expand!
        else
          mem
        end
      end
      _expanded_members.flatten
    end
  end
end
