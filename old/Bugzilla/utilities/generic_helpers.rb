module Bugzilla
  module GenericHelpers

    def project_dir
      File.expand_path(File.join(File.dirname(__FILE__), "..")).split("/").last + "/"
    end

  end
end