#!/usr/bin/env ruby

require 'java'
java_import java.lang.Runtime
java_import java.io.StringWriter
java_import java.io.PrintWriter
java_import java.io.BufferedReader
java_import java.io.InputStreamReader
java_import java.io.InputStream

class ProcessWrapper
  def initialize(exit_code, output_string, error_string)
    @exit_code = exit_code
    @output_string = output_string
    @error_string = error_string
  end
  attr_accessor :exit_code, :output_string, :error_string

  def self.execute(command, args)
    process = Runtime.runtime.exec([command].concat(args).to_java(:string))

    out_string = StringWriter.new
    stdout_pump = StreamPump.new(process.input_stream, PrintWriter.new(out_string, true))

    err_string = StringWriter.new
    stderr_pump = StreamPump.new(process.error_stream, PrintWriter.new(err_string, true))

    stdout_pump.start
    stderr_pump.start
    exit_code = process.wait_for
    stdout_pump.join
    stderr_pump.join

    ProcessWrapper.new(exit_code, out_string.to_string, err_string.to_string)
  end

  # def stdout_stream
  #   StringWriterInputStream.new(@stdout_boozer.string_writer)
  # end
  #
  # def stdin_stream
  #   # proc.output_stream
  #   @process.output_stream.to_io
  # end
  #
  #
  #
  # class StringWriterInputStream < InputStream
  #   def initialize(string_writer)
  #     super()
  #   end
  # end


  class StreamPump < java.lang.Thread
    def initialize(input_stream, writer)
      @input_stream = input_stream
      @writer = writer

      super()
    end
    attr_reader :string_writer

    def run
      begin
        reader = BufferedReader.new(InputStreamReader.new(@input_stream))
        while line = reader.read_line
          @writer.println(line)
        end
      ensure
        if reader
          reader.close
        end
      end
      # BufferedReader reader = null;
      #                      try {
      #                        reader = new BufferedReader(new InputStreamReader(in));
      #                        String line;
      #                        while ((line = reader.readLine()) != null) {
      #                            pw.println(line);
      #                        }
      #                        } catch (IOException e) {
      #                          log.error("Failed to read stream", e);
      #                        } finally {
      #                          try {
      #                            if (reader != null) {
      #                                reader.close();
      #                            }
      #                            } catch (IOException e) {
      #                              log.warn("Attempt to close stream failed", e);
      #                            }
      #                            }
      #                            }
      #                            }
    end
  end
end

# public class ProcessWrapper {
#
#          private final StringWriter outputString;
#          private final StringWriter errorString;
#          private final int exitCode;
#
#          private static final Logger log = LoggerFactory.getLogger(ProcessWrapper.class);
#
#          public ProcessWrapper(Process process) throws InterruptedException
#          {
#              outputString = new StringWriter();
#          errorString = new StringWriter();
#          StreamBoozer seInfo = new StreamBoozer(process.getInputStream(), new PrintWriter(outputString, true));
#          StreamBoozer seError = new StreamBoozer(process.getErrorStream(), new PrintWriter(errorString, true));
#          seInfo.start();
#          seError.start();
#          exitCode = process.waitFor();
#          seInfo.join();
#          seError.join();
#        }
#
#        public String getErrorString() {
#                        return errorString.toString();
#                      }
#
#        public String getOutputString() {
#                        return outputString.toString();
#                      }
#
#        public int getExitCode() {
#                     return exitCode;
#                   }
#
#
#        class StreamBoozer extends Thread {
#                                     private final InputStream in;
#                                     private final PrintWriter pw;
#
#                                     StreamBoozer(InputStream in, PrintWriter pw) {
#                                         this.in = in;
#                                     this.pw = pw;
#                                   }
#
#        @Override
#        public void run() {
#                      BufferedReader reader = null;
#                      try {
#                        reader = new BufferedReader(new InputStreamReader(in));
#                        String line;
#                        while ((line = reader.readLine()) != null) {
#                            pw.println(line);
#                        }
#                        } catch (IOException e) {
#                          log.error("Failed to read stream", e);
#                        } finally {
#                          try {
#                            if (reader != null) {
#                                reader.close();
#                            }
#                            } catch (IOException e) {
#                              log.warn("Attempt to close stream failed", e);
#                            }
#                            }
#                            }
#                            }
