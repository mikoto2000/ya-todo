# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task rubocop: :environment do
  desc "Run RuboCop"
  sh %(rubocop)
end

namespace :rubocop do
  task autocorrect: :environment do
    desc "Run RuboCop and autocorrect"
    sh %(rubocop --autocorrect)
  end
end

task erblint: :environment do
  sh %(erblint --lint-all)
end

task erblint_autocorrect: :environment do
  sh %(erblint --lint-all --autocorrect)
end
