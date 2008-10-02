# load git_auth
require 'pathname'

dir = Pathname.new(File.dirname(__FILE__)).realpath

%w(config group rule default auth serve log).each do |file|
  
  require  File.join(dir, 'lib/' ,file)
  
end


