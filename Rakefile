require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new('test:units') do |t|
  t.libs << 'test'
  t.description = 'Run unit tests'
  t.test_files = FileList['test/units/**/test_*.rb']
  t.warning = false
end

Rake::TestTask.new('test:integration') do |t|
  t.libs << 'test'
  t.description = 'Run integration tests'
  t.test_files = FileList['test/integration/**/test_*.rb']
  t.warning = false
end

desc 'Run all tests'
task test: ['test:units', 'test:integration']

RuboCop::RakeTask.new(:rubocop)

task default: %i[test rubocop]
