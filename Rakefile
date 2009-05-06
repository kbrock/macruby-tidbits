require 'hotcocoa/application_builder'
require 'hotcocoa/standard_rake_tasks'


#the first time they rake, let them know they need to mention which example to run
if File.exist?('lib/application.rb')
  task :default => [:run]
else
  task :default => [:usage]
end

run_task_pat = /^run(\w+)$/

desc "run a particular example"
rule run_task_pat do |task|
  num=task.name[run_task_pat,1]
  puts `cd lib ; rm -f application.rb ; ln application#{num}.rb application.rb ; cd ..`
  Rake::Task["run"].invoke
end

rule :usage do |t|
  puts
  puts "all applications are in the same directory"
  puts "rake run1 to run example 1"
  puts "all subsequent rake calls run the same example (until you rake run2 ...)"
  puts
end