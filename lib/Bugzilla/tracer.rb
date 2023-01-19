# frozen_string_literal: true

class Tracer

  attr_accessor :trace_info, :parent_blind

  def initialize(trace_info, bind = nil)
    raise "Must provide a Thread::Backtrace_info::Location" unless trace_info.is_a?(Thread::Backtrace::Location)

    @parent_bind = bind
    @trace_info = trace_info
  end

  def view_source(width = 5)
    lines = File.readlines(trace_info.path)

    @res = []
    (lineno - width).upto(lineno + width) do |i|
      @res << lines[i]
    end

    puts "Location: #{trace_info.path.to_s}".green

    ap @res, index: false, ruby19_syntax: true
  end

  def bind_generic
    system 'clear'

    puts "Starting Pry Session: BindGeneric".green
    Pry.start(self.__binding__)
  end

  def bind_source
    system 'clear'

    puts "Starting Pry Session: BindSource".green
    Pry.start(trace_info.__binding__)
  end

  def bind_parent_bind
    system 'clear'
    puts "Starting Pry Session: ParentBlind".green
    Pry.start(@parent_bind)
  end

  def view_variables
    system 'clear'
    puts "Instance Variables: ".white + "#{trace_info.__binding__.instance_variables.map {|var| "#{var.to_s}: #{var.instance_variable_get(var)}"}}".yellow

    puts "Local Variables: ".white + "#{trace_info.__binding__.local_variables.map {|var| "#{var.to_s}: #{var.__binding__.local_variable_get(var)}"}}".yellow
  end

  private

  def lineno
    trace_info.lineno
  end
end
