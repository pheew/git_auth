# load git_auth
require 'pathname'

dir = Pathname.new(File.dirname(__FILE__)).realpath

puts dir

%w(config group rule default auth).each do |file|
  
  require  File.join(dir, 'lib/' ,file)
  
end


