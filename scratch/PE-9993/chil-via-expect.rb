#!/usr/bin/env ruby

require 'base64'

#### CHOOSE ONE OF THESE TWO IMPLEMENTATIONS OF ProcessWrapper
# require 'popen3-process-wrapper'
require 'jruby-process-wrapper'

class ExpectReproducer
  def self.chil(command, args, response_regex, action)
    p = ProcessWrapper.execute(command, args)
    output = p.output_string

    puts "EXIT CODE: #{p.exit_code}"
    # TODO: error handling

    if match = output.match(response_regex)
      header,cryptogram = match.captures
      cryptogram = Base64.decode64(cryptogram) if action == :encrypt
    else
      puts "Unable to parse output: '#{output}' \n with regex #{response_regex.to_s}"
      puts "STDERR output: #{p.error_string}"
      raise "AAAAAA"
    end
    return cryptogram
  end

  def self.go
    itr = 0

    while true
      itr = itr + 1
      puts "iteration - #{itr}"

      val = Base64.encode64("WORLD").strip
      prompt_regex = "(Password:)|(test@localhost's password:)"
      hsm_password = "test"
      command = "./expect-ssh.sh"
      args = ["echo 'HELLO #{val}'",
              "#{prompt_regex}",
              "#{hsm_password}"]
      # command = "echo 'HELLO #{val}"
      action = :encrypt

      regex = /(HELLO) (.*)$/

      rv = chil(command, args, regex, action)
      puts "CHIL RETURNED: '#{rv}'"
    end
  end
end

ExpectReproducer.go


