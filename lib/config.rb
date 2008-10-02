module GitAuth
  class Config
    
    attr_accessor :defaults, :groups, :rules
    
    def initialize(file)
      process_config_file File.read(file)
    end
    
  
    def get_relevant_rules(name, ref)
      Config.config.rules.select do |rule| 
        pattern = rule.user_pattern(name)
        puts "Evaluating " + pattern.source
        
        (rule.expanded_members.include? name) && ( !ref.match(pattern).nil?)
      end
   end
    
    def get_relevant_defaults(ref)
      Config.config.defaults.select { |default| ref =~ default.pattern }
    end
  
    def self.config
      unless @config
        config_dir = Pathname.new(File.dirname(__FILE__)).realpath
        @config = Config.new File.join config_dir, "../config/auth.conf"
        @config.groups.each { |name, gr| gr.expand! }
        @config.rules.each { |rule| rule.expand! }
      end
      @config
    end
  
    def self.reload!
      @config = nil
      config
    end
  
    
    private 
    def process_config_file(config_file_contents)
      _defaults, _groups, _rules = config_file_contents.match(/\[defaults\](.*)\[groups\](.*)\[rules\](.*)/mix).captures.collect { |section| section.strip }
      
      @defaults = []
      _defaults.split("\n").reject { |d| d.strip.empty? }.each do |def_line|
        r, p = def_line.strip.split(":").collect { |part| part.strip }
        @defaults << Default.new(p, r)
      end
      
      @groups = {}
      _groups.split("\n").reject { |g| g.strip.empty? }.each do |group|
        name, members = group.strip.split(":").collect { |part| part.strip }
        @groups[name] = Group.new(name, members.split(",").collect { |mem| mem.strip })
      end
      
      @rules = []
      _rules.split("\n").reject { |r| r.strip.empty? }.each do |rule|
        parts = rule.strip.split(":").collect { |p| p.strip }
        members = parts[0].split(",").collect { |p| p.strip }
        right, pattern = parts[1].split(",").collect { |p| p.strip }
        @rules << Rule.new(members, pattern, right)
      end 
    end
    
  end
  
end