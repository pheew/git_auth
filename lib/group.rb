module GitAuth
  class Group
  
    attr_accessor :name, :members
    attr_reader :repo
    
    def initialize(name, members, repo)
      @repo = repo;
      @name = name
      @members = members
    end
  
  
    def expanded_members
      unless @expanded_members
        @expanded_members = Group.expand!(@members, @repo)
      end
      @expanded_members
    end
  
    def self.expand!(members, repo)
      _expanded_members = members.collect do |mem|
        # Check for @ at the start
        if mem[0] == 64
          Config::current_config(repo).groups[mem[1..(mem.length - 1)]].expand!
        else
          mem
        end
      end
      _expanded_members.flatten
    end
  end
end
