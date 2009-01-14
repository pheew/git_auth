require 'optparse'

module GitAuth	
  class Serve

	  COMMANDS_READONLY = ['git-upload-pack']
	  COMMANDS_WRITE = ['git-receive-pack']
	  ALLOW_RE = Regexp.compile("^(git-(?:receive|upload)-pack) '([a-zA-Z][a-zA-Z0-9@._-]*(/[a-zA-Z][a-zA-Z0-9@._-]*)*)'$")
	  
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
  			Log.tell_user("Need SSH_ORIGINAL_COMMAND in environment")
  			return 1
  		end
	    
	    Log.debug("Original command : " + cmd)

  		if cmd.include?('\n')
  		  Log.debug("Newlines found in command")
  			Log.tell_user("No newlines allowed in command")
  			return 1
  		end
		

  		match = ALLOW_RE.match(cmd)
  		if match.nil? || !match
  			Log.tell_user("Command to run looks dangerous")
  			return 1
  		end
		
  		allowed = COMMANDS_READONLY
  		allowed += COMMANDS_WRITE if !@options[:readonly]
  		
  		Log.debug("Allowed : " + allowed.inspect)
      	Log.debug("New command : " + cmd)
      	Log.debug("Repository : " + match[2])

  		if( !allowed.include?(match[1]) )	
  			Log.tell_user("Command not allowed")
  			return 1
  		end

Log.debug("Current dir : " + Dir.pwd)
      # Check rights of user
      if COMMANDS_WRITE.include? match[1]
        # Let the pre-receive hook authorize so we can match the refs from the parameters
        ENV["GIT_USERNAME"] = ARGV[0]
        ENV["GIT_REPO"] = match[2]
        ENV["GITAUTH_DIR"] = "/storage/apps/git_auth/"

        system("git-shell -c \"#{cmd}\"")
      else
        if Auth.can_read?(ARGV[0].strip, match[2])
          Log.debug "User \"#{ARGV[0]}\" was granted read acces to repository"
          system("git-shell -c \"#{cmd}\"")

        else
          Log.tell_user "You are not allowed to access this repository"
          Log.debug "User \"#{ARGV[0]}\" was denied read acces to repository"
          return 1
        end
      end 
      
  	end
  end
end
