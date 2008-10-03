module GitAuth
  class Config
    
    attr_accessor :settings, :groups, :readers, :writers
    
    def initialize(file)
      process_config_file File.read(file)
    end

    def self.config
      unless @config
        current_path = Pathname.new(File.dirname(__FILE__)).realpath
        @config = Config.new( File.join( current_path, "../config/auth.conf" ))
        @config.groups.each { |name, gr| gr.expand! }
        
        @config.readers.expand!
        
        @config.writers.each { |writer| writer.expand! }
      end
      @config
    end
  
    def self.reload!
      @config = nil
      config
    end
  
    
    private 
    def process_config_file(config_file_contents)
      _settings, _groups, _readers, _writers = config_file_contents.match(/\[settings\](.*)\[groups\](.*)\[readers\](.*)\[writers\](.*)/mix).captures.collect { |section| section.strip }
      
      @settings = _settings.split("\n").reject { |s| s.strip.empty? }.collect { |s| s.strip.downcase } 
      
      @groups = {}
      _groups.split("\n").reject { |g| g.strip.empty? }.each do |group|
        name, members = group.strip.split(":").collect { |part| part.strip }
        @groups[name] = Group.new(name, members.split(",").collect { |mem| mem.strip })
      end
      
      @readers = Group.new("Readers",  _readers.split("\n").reject { |r| r.strip.empty? }.collect { |r| r.strip })
        
      @writers = []
      _writers.split("\n").reject { |r| r.strip.empty? }.each do |rule|
        
        members_raw, pattern = rule.strip.split(":").collect { |p| p.strip }
        members = members_raw.split(",").collect { |m| m.strip }

        @writers << Rule.new(members, pattern)
      end 
    end
    
  end
  
end