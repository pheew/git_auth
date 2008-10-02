# load git_auth
%w(config group rule default auth).each do |file|
  require Dir.pwd + "/lib/" + file
end