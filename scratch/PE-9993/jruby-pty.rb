#!/usr/bin/env ruby

require 'jruby-process-wrapper'

# public static ExecutionStubResult executeCommand(String command)
# throws InterruptedException, IOException {
#
#                              ProcessWrapper wrapper = new ProcessWrapper(Runtime.getRuntime().exec(command));
#
#                              String stdErr = wrapper.getErrorString();
#                              if ( ! stdErr.isEmpty() ) {
#                                  log.warn("Executed an external process which logged to STDERR: " + stdErr);
#                              }
#
#                              return new ExecutionStubResult(wrapper.getOutputString(), wrapper.getExitCode());
#                              }

class PTY
  def self.spawn(command)
    process = JRubyProcessWrapper.new(command)

    yield process.stdout_stream, process.stdin_stream, nil #process.in, process.pid
  end
end