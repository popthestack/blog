require 'nanoc3/tasks'

task :default => [:compile]
task :rebuild => [:fullclean, :compile]

task :fullclean => :clean do
  #system('git', 'clean', '-qdf')
  system('rm', '-r', 'output', 'tmp')
end

task :compile do
  system('nanoc3', 'compile')
end

