# abstract_command
Shell Command Abstraction - Let's you interact with shell commands as if they were objects.

Simple Example:
--------------------------------------------------------------------------------
1540262628 ~/dev/git/abstract_command $ cat example.rb 

require 'abstract_command'

# Hello World Example.
class HelloCommand < AbstractCommand
  def template
    'echo Hello %<name>s'
  end
end

command = HelloCommand.new
command.name = 'World.'

puts command.to_s

1540262630 ~/dev/git/abstract_command $ irb
ruby 2.1.10:001 > eval File.read 'example.rb'
echo Hello World.
 => nil 
ruby 2.1.10:002 > 
1540262655 ~/dev/git/abstract_command $ 
