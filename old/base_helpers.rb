# frozen_string_literal: true

class Bugzilla
  module BaseHelpers

    def silence_warnings
      old_verbose = $VERBOSE
      $VERBOSE = nil
      yield
    ensure
      $VERBOSE = old_verbose
    end
  end

  def safe_send(obj, method, *args, &block)
    (obj.is_a?(Module) ? Module : Object).instance_method(method)
                                         .bind(obj).call(*args, &block)
  end

  def not_a_real_file?(file)
    file =~ /^(\(.*\))$|^<.*>$/ || file =~ /__unknown__/ || file == "" || file == "-e"
  end
end
