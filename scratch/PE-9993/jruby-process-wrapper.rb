#!/usr/bin/env ruby

require 'java'
java_import java.lang.Runtime
java_import java.io.StringWriter
java_import java.io.PrintWriter
java_import java.io.BufferedReader
java_import java.io.InputStreamReader
java_import java.io.InputStream

class JRubyProcessWrapper
  def initialize(command)
    @process = Runtime.runtime.exec(command, ["TERM=VT100"].to_java(:string))

    # out_string = StringWriter.new
    # out_writer = PrintWriter.new(out_string, true)
    # out_stream = PipedInputStream.new
    @stdout_boozer = StreamBoozer.new(@process.input_stream)
    # stdout_stream = stdout_boozer.stdout_stream

    # err_string = StringWriter.new
    # stderr_boozer = StreamBoozer.new(proc.error_stream, PrintWriter.new(err_string, true))

    @stdout_boozer.start
    # stderr_boozer.start
  end

  def stdout_stream
    StringWriterInputStream.new(@stdout_boozer.string_writer)
  end

  def stdin_stream
    # proc.output_stream
    @process.output_stream.to_io
  end



  class StringWriterInputStream < InputStream
    def initialize(string_writer)
      super()
    end
  end


  class StreamBoozer < java.lang.Thread
    def initialize(input_stream)
      @input_stream = input_stream

      @string_writer = StringWriter.new
      @print_writer = PrintWriter.new(@string_writer, true)

      super()
    end
    attr_reader :string_writer

    def run
      puts "Running boozer thread!"
      begin
        reader = BufferedReader.new(InputStreamReader.new(@input_stream))
        while line = reader.read_line
          @print_writer.println(line)
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
