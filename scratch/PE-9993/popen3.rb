#!/usr/bin/env ruby

require 'open3'

Open3.popen3("ls -l /tmp") do |stdin, stdout, stderr, wait_thr|
   puts "stdin: #{stdin}" 
   puts "stdout: #{stdout}" 
   puts "stderr: #{stderr}" 
   puts "wait_thr: #{wait_thr}" 
end
