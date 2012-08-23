#!/usr/bin/env ruby

require 'octokit'
puts Octokit.markdown(File.read(ARGV.first))
#File.open("test.html", "w"){ |f| f.write(out) }
