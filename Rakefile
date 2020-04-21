# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("config/application", __dir__)

Rails.application.load_tasks

unless Rails.env.production?
  require "rubocop/rake_task"
  require "scss_lint/rake_task"

  RuboCop::RakeTask.new(:rubocop) do |t|
    t.patterns = %w(app config lib spec)
  end

  SCSSLint::RakeTask.new do |t|
    t.files = Dir.glob(["app/assets/stylesheets"])
  end

  task default: [:spec, "jasmine:ci", :rubocop, :scss_lint]

  desc "Lint Ruby and SASS files"
  task lint: %i[rubocop scss_lint]
end
