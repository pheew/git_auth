#!/usr/bin/env ruby
require 'pathname'
base_dir = Pathname.new(File.dirname(__FILE__)).realpath
require File.join(base_dir , 'git_auth.rb')

module GitAuth
  Log.debug("connection open")

  # Process request
  exit_code = Serve.serve

  Log.debug("signing off")

  exit exitcode
end