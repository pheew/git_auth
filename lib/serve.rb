require 'optparse'

module GitAuth	
  class Serve

    COMMANDS_READONLY = ['git-upload-pack']
	  COMMANDS_WRITE = ['git-receive-pack']
	  ALLOW_RE = Regexp.compile("^(git-(?:receive|upload)-pack) '[a-zA-Z][a-zA-Z0-9@._-]*(/[a-zA-Z][a-zA-Z0-9@._-]*)*'$")

	  @options = Hash.new
	
	  def self.serve
  		File.umask(0022)
		
  		# parse cmd line
  		OptionParser.new do |opts|
  			opts.banner = "Usage: 'serve.rb [OPTIONS] DIR'"
  			opts.on("--ro", "--read-only", "disable write operations") do |opt|
  				@options[:readonly] = opt  
  			end
  		end.parse!
		
	
  		# get original command
  		cmd = ENV['SSH_ORIGINAL_COMMAND'].strip if ENV['SSH_ORIGINAL_COMMAND']
  		if cmd.nil? || cmd.empty?
  			die("Need SSH_ORIGINAL_COMMAND in environment")
  		end
		
  		if cmd.include?('\n') 
  			die("No newlines allowed in command")
  		end
		
	
  		match = ALLOW_RE.match(cmd)
  		if match.nil? || !match
  			die("Command to run looks dangerous")
  		end
		
  		allowed = COMMANDS_READONLY
  		allowed += COMMANDS_WRITE if !@options[:readonly]
		
  		if( !allowed.include?(match[1]) )	
  			die("Command not allowed")
  		end

		
  		puts system("/usr/bin/git-shell","git-shell -c #{cmd}")
		
  	end
	
  	def self.die(msg)
  		$stderr << msg
  		exit 1;
  	end
  end
end
