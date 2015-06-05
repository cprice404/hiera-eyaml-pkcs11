#!/usr/bin/env ruby

require 'open3'

class ProcessWrapper
  def initialize(exit_code, output_string, error_string)
    @exit_code = exit_code
    @output_string = output_string
    @error_string = error_string
  end
  attr_accessor :exit_code, :output_string, :error_string

  def self.execute(command)
    exit_code = nil
    output_string = nil
    error_string = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # wait for process to exit
        exit_code = wait_thr.value
        output_string = stdout.read
        error_string = stderr.read
    end
    ProcessWrapper.new(exit_code, output_string, error_string)
  end
end