module Bugzilla
  class Tracer
    module OutputHelper

      def trace(*args)
        traces.each do |t|
          puts build_line(t, *args)
        end
        show_trace_count
        show_ignored_trace_count
        nil
      end
      def source_trace(*args)
        i = 0
        source_trace = traces.map do |t|
          i += 1

          case t.event
          when :call
            log_lineno(i) + build_line(t, *args) + t.source_code
          when :return
            log_lineno(i, header: "[Return] Trace", colour: :green) + build_line(t, *args) + "Return".white + " #{t.return_value}\n".cyanish + "    from #{t.method_id}"
          when :raise
            log_lineno(i, header: "[Raise] Trace", colour: :red) + build_line(t, *args) + "Exception: #{t.exception}\n".red
          end
        end

        puts source_trace.join("\n")
        show_trace_count
        show_ignored_trace_count
      end

      def build_line(trace, *args)
        line = [
          colourise(trace.event, :event), colourise(gsub_filter!(trace.path), :path),
          colourise(trace.lineno, :lineno), colourise(trace.method_id, :method_id)
        ].join(' ')

        return line unless args
        line + "\n" + args.map do |arg|
          header = "#{arg.to_s.capitalize.gsub("_", " ").white}   "

          info = "#{trace.send(arg)}\n"
          info = CodeRay.scan(info.gsub("#<", "<"), :ruby).term
          header + info
        end.join(' ')
      end

      def colourise(text, arg)
        arg = arg.to_sym if arg.is_a?(String)
        return "\e[#{colour_opts[arg]}m#{text}\e[0m" if colour_opts.key?(arg)
        text
      end


      protected

      def show_trace_count
        puts "\nShown Traces: #{traces.count}".white
      end

      def show_ignored_trace_count
        puts "Filtered Traces: #{ignored_traces_count}".gray
      end

      def log_lineno(i, header: "[Call] Trace", colour: :gray)
        "---------- #{header}: #{i} ----------\n".send(colour)
      end
    end
  end
end
