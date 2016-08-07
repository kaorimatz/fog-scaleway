require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.name = 'test:integration'
  t.description = 'Run integration tests'
  t.test_files = FileList['test/integration/**/test_*.rb']
  t.warning = false
end

RuboCop::RakeTask.new
