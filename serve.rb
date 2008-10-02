#!/usr/bin/env ruby
require 'pathname'
base_dir = Pathname.new(File.dirname(__FILE__)).realpath
require File.join(base_dir , 'git_auth.rb')

#GitAuth::Serve.serve
exit 1
