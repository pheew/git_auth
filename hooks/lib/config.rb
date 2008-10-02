module GitAuth
  class Config
    
    def initialize(file)
      config_file_contents = File.read(file)
      
      defaults, groups, rules = config_file_contents.match(/\[defaults\](.*)\[groups\](.*)\[rules\](.*)/mix).captures.collect { |section| section.strip }
      
      @defaults = []
      defaults.split("\n").reject { |d| d.empty? }.each do |def_line|
        r, p = def_line.split(":").collect { |p| p.strip }
        @defaults << Default.new(p, r)
      end
      
      @groups = []
      @rules = []
    end
    
    attr_accessor :defaults, :groups, :rules
  
    def self.config
      @config ||= Config.new "config/auth.conf"
    end
    
  end
  
ends