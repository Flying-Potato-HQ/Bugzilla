# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]


# frozen_string_literal: true

# require "bundler/gem_tasks"
#
# FileList['tasks/**/*.rake'].each(&method(:import))
#
# desc 'Run all specs'
# task ci: %w[ spec ]