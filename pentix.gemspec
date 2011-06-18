Gem::Specification.new do |s|
  s.name    = 'pentix'
  s.version = '1.0.1'
  s.date    = '2011-06-18'

  s.summary     = "An advanced tetris like game"
  s.description = %Q{A simple demo project for the Gosu gem}

  s.authors  = ['Nikolay Nemshilov']
  s.email    = 'nemshilov@gmail.com'
  s.homepage = 'http://github.com/MadRabbit/pentix.rb'
  s.add_dependency 'gosu'

  s.files = Dir['bin/**/*'] + Dir['lib/**/*'] + Dir['media/**/*'] + Dir['spec/**/*']
  s.files+= %w(
    README.md
    pentix.rb
  )

  s.executables = ['pentix']
end