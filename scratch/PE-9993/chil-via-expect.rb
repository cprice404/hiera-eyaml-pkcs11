#!/usr/bin/env ruby

require 'base64'
require 'popen3-process-wrapper'

class ExpectReproducer
  def self.chil(command, response_regex, action)
    p = ProcessWrapper.execute(command)
    output = p.output_string

    puts "EXIT CODE: #{p.exit_code}"
    # TODO: error handling

    if match = output.match(response_regex)
      header,cryptogram = match.captures
      cryptogram = Base64.decode64(cryptogram) if action == :encrypt
    else
      raise "Unable to parse output:\n #{output} \n with regex #{response_regex.to_s}"
    end
    return cryptogram
  end

  def self.go
    itr = 0

    while true
      itr = itr + 1
      puts "iteration - #{itr}"

      val = Base64.encode64("WORLD")
      prompt_regex = "(Password:)|(test@localhost's password:)"
      hsm_password = "test"
      command = "./expect-ssh.sh \"echo 'HELLO #{val}'\" \"#{prompt_regex}\" \"#{hsm_password}\""
      action = :encrypt

      regex = /(HELLO) (.*)$/

      puts "CHIL RETURNED:"
      puts chil(command, regex, action)
      puts
    end
  end
end

ExpectReproducer.go


