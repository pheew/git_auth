#!/usr/bin/env ruby
require 'syslog'
require 'pathname'

log = Syslog.open('ssh_serve')
log.debug("connection open")
Syslog.close

base_dir = Pathname.new(File.dirname(__FILE__)).realpath
require File.join(base_dir , 'git_auth.rb')

GitAuth::Serve.serve
log = Syslog.open('ssh_serve')
log.debug("signing off")
Syslog.close
