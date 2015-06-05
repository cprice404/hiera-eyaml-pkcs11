#!/usr/bin/env ruby

# require 'pty'
require 'jruby-pty'
require 'base64'

class PTYReproducer
  def self.wait_for_prompt(cout)
    # This is based on the output of /opt/nfast/bin/ppmk
    # This will basically allow us to type the passphase in
    # so that the openssl command can continue to use stdin
    buffer = ""
    begin
      # loop { buffer << cout.getc.chr; break if buffer =~ /Enter pass phrase:/}
      loop { buffer << cout.getc.chr; break if buffer =~ /test@localhost's password:/}
    rescue
    end
    return buffer
  end

  def self.chil(command, password, response_regex, action)
    PTY.spawn(command) do |openssl_out,openssl_in,pid|
      self.wait_for_prompt(openssl_out)
      openssl_in.printf("#{password}\n")
      output = self.wait_for_prompt(openssl_out)
      if match = output.match(response_regex)
        header,cryptogram = match.captures
        cryptogram = Base64.decode64(cryptogram) if action == :encrypt
      else
        raise "Unable to parse output:\n #{output} \n with regex #{response_regex.to_s}"
      end
      return cryptogram
    end
  end

  def self.go
    itr = 0

    while true
      itr = itr + 1
      puts "iteration - #{itr}"
      # PTY.spawn('/bin/echo blah') do |cmd_out, cmd_in, pid|
      #   begin
      #     puts "pid - #{pid}"
      #     one_char = cmd_out.getc.chr
      #     puts "first char - #{one_char}"
      #     rest = cmd_out.gets
      #     puts "rest chars - #{rest}"
      #   ensure
      #     puts "closing cmd_out..."
      #     cmd_out.close
      #     puts "closing cmd_in..."
      #     cmd_in.close
      #     puts "wait for #{pid}"
      #     Process.wait(pid)
      #     puts "done waiting for #{pid}"
      #   end
      # end

      val = Base64.encode64("WORLD")
      command = "ssh test@localhost \"echo 'HELLO #{val}'\""
      hsm_password = "test"
      action = :encrypt

      regex = /(HELLO) (.*)$/

      puts chil(command, hsm_password, regex, action)
    end
  end
end

PTYReproducer.go


