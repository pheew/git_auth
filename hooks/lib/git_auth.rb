# load git_auth
%w(config rule auth).each do |file|
  require Dir.path file
end