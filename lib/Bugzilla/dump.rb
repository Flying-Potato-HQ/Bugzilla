# require 'tty-prompt'
# require_relative "./my_tools/bugzilla"
# require_relative "./my_tools/utilities"
require_relative "./my_tools/my_helpers"

module MyTools

  extend ActiveSupport::Concern

  included do

  end

  def self.include(base)
    base.extend MyTools
  end

  def diff_trace(base: nil)
    self.diff_trace(base: base)
  end

  def stack
    stack = clean_trace(caller)
    stack.map do |string|
      string = string.gsub("/home/ruby/core/repo", "")
      puts string.yellow
    end
    nil
  end

  def self.diff_trace(base, verbose: true, vars: :none)
    raise "Must provide base, usually (self)".red unless base
    manual_load(base)

    trace1 = trace(verbose: true, output: false) { proc1.call }
    trace2 = trace(verbose: true, output: false) { proc2.call }

    trace1.each_with_index do |trace, index|
      @first = clean_path(trace[:File])
      first_caller = clean_path(trace[:Caller])

      @second = clean_path(trace2.dig(index, :File))
      second_caller = clean_path(trace2.dig(index, :Caller))

      if vars == :diff
        first_vars = trace[:Variables][:local_vars].keys + trace[:Variables][:instance_vars].keys.map(&:to_s)
        second_vars = trace2.dig(index, :Variables)[:local_vars].keys + trace2.dig(index, :Variables)[:instance_vars].keys.map(&:to_s)
        combined_vars = first_vars + second_vars

        different_vars = first_vars - second_vars - [":_", ":e"]
        common_vars = combined_vars - different_vars
      end

      color = @first != @second ? :red : :green
      puts "- - - - - - - - - -        ".send(color) + "#{index}".white + "          - - - - - - - - - - ".send(color)

      if verbose
        puts "\n Expected".white + "     Caller:   #{first_caller}".gray
        puts "   Path:".gray + " #{@first}".send(color)
        puts "\n Actual".white + "       Caller: #{second_caller}".gray
        puts "   Path:".gray + " #{@second} \n".send(color)
      else
        length = 50 - @first.length
        empty = " " * length
        puts " Expected".white + " #{@first}".send(color) + "    " +
               empty + "Actual".white + " #{@second} ".send(color)
        puts " Different Vars: ".white + " #{different_vars} ".gray if vars == :diff
        puts " Common Vars: ".white + " #{common_vars} ".gray if vars == :diff
      end

    end

    puts "Trace 1: #{trace1.count}".white
    puts "Trace 2: #{trace2.count}".white
  end

  def self.manual_load(base)
    @proc1 = Proc.new { base.current_user.can?(:update, base.send(:current_user)) }
    @proc2 = Proc.new { base.current_user.can?(:update, base.instance_variable_get(:@contract)) }

    return true if @proc1 && @proc2
    false
  end

  def self.trace(verbose: false, output: true, &block)
    trace = []
    set_trace_func proc { |event, file, line, id, binding, classname|
      file_path = file.gsub("/home/ruby/core/repo", "")

      if event == 'call'

        variables = { local_vars: {}, instance_vars: {} }
        binding.local_variables.each {|var| variables[:local_vars][var] = binding.local_variable_get(var)}
        binding.instance_variables.each {|var| variables[:instance_vars][var] = binding.instance_variable_get(var)}

        trace << {
          Source: "#{classname}##{id}",
          Info: {
            Method: id,
            Class: classname,
          },
          File: "#{file_path}:#{line}",
          Binding: binding,
          Variables: variables,
          Caller: binding.__binding__.caller_loc
        }
      end
    }
    if block_given?
      block.call
    else
      puts "No block given, calling on self".blue
    end
    set_trace_func nil

    trace = clean_trace(trace)
    output_trace(trace) if output

    return nil if verbose == false
    trace
  end

  def self.clean_trace(trace)
    trace = trace.reject { |string| string.to_s =~ /\/(gems|rubies|middleware|)\// }
    trace = trace.reject do |loc|
      loc.to_s.include?("goldiloader") ||
        loc.to_s.include?("application_controller") ||
        loc.to_s.include?("prosopite") ||
        loc.to_s.include?("pry") ||
        loc.to_s.include?("backend/platform") ||
        loc.to_s.include?("irb") ||
        loc.to_s.include?("/bin/rails")
      loc.to_s.include?("permissions/defaults/klass_base") ||
        loc.to_s.include?("ar_timezones.rb") ||
        loc.to_s.include?("/my_tools.rb") ||
        loc.to_s.include?("/01_pre_config_patches/array.rb") ||
        loc.to_s.include?("irb_binding") ||
        loc.to_s.include?("/bin/rails:5") ||
        loc.to_s.include?("-e:1")
    end

    trace
  end

  private

  def self.calling_method(caller)
    caller[0][/`([^']*)'/, 1]
  end

  def self.calling_method(caller)
    caller[0].split("/").last
  end

  def get_caller_logs(caller)
    if caller.is_a?(Array)
      caller
    elsif caller.is_a?(Binding)
    end
  end

  def self.clean_caller_paths(caller_array)
    caller_array.map do |string|
      clean_path(string)
    end
  end



  def self.output_trace(trace)
    puts "\n ------- Trace ------- \n".green

    trace.each_with_index do |loc, i|
      puts " - - - - - - - - - -         #{i + 1}          - - - - - - - - - - ".white
      puts "    #{loc[:Source].yellow}"
      puts "    #{loc[:File].blue}"

      puts "        Instance Variables".cyanish if loc[:Variables][:instance_vars].present?
      puts "           " + loc[:Caller].white
      puts "           " + loc[:Variables][:instance_vars].reject {|e| e.blank? }.map { |k,v| { "#{k}": v.to_s} }.join(" ").white
      puts "        Local Variables".cyanish if loc[:Variables][:local_vars].present?
      puts "           " + loc[:Variables][:local_vars].reject {|e| e.blank? }.map { |k,v| { "#{k}": v.to_s} }.join(" ").white
    end
  end

  def self.proc1
    @proc1
  end

  def self.proc2
    @proc2
  end

  module DebugHelper
    def pp_path(path)
      path_finished = false

      path = path.split(/[\/:`]/).reject(&:blank?)
      puts "\n"
      path.each_with_index do |section, i|
        raise "#{section} is not a string".red unless section.is_a?(String)
        print f(section) unless section.include?(".rb") || path_finished

        path_finished = true if section.include?(".rb")
        print "/#{section.white}" if section.include?(".rb")
        print section.yellow if ":#{section}" =~ /\d/ && path_finished
        print "       #{section.cyan} \n" if path.length == i + 1
      end
      nil
    end

    def clean_path(path)
      path = path.to_s.gsub("/home/ruby/core/repo", "")
      path = path.to_s.gsub("/config", "")
      path = path.to_s.gsub("/initializers", "")
      path.to_s.gsub("/app", "")
    end

    private

    def f(folder)
      slash + folder.blue
    end

    def slash
      '/'.white
    end
  end

  extend DebugHelper

  module BindingHelper
    include DebugHelper

    def called_by_method
      pp_path(caller_locations(2, 1)[0].label)
    end

    def caller_loc
      # caller[1][/`([^']*)'/, 1]
      caller.reject {|l| l.include?("(pry)") || l.include?( "my_tools") }[0]
    end

    def binding_of_caller
      puts "Not implemented yet".red
    end

    def caller
      caller = super
      MyTools.clean_trace(caller)
    end
  end

  extend BindingHelper

  module ArrayHelper
    def clean
      MyTools.clean_trace(self)
    end
  end

  Binding.include BindingHelper unless Binding.include?(BindingHelper)
  Pry.include BindingHelper unless Pry.include?(BindingHelper)
  Array.include ArrayHelper unless Array.include?(ArrayHelper)
end