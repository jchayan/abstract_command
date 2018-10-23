
# abstract_command

Shell Command Abstraction - Let's you interact with shell commands as if they were objects.


Features:


    * Let's you define a shell command with ease.
    * Will automatically generate all the methods for each variable
      that needs to be interpolated in the command.
    * Let's you interact with a command as if it were an object.








Hello world example:
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
--------------------------------------------------------------------------------








Variable interpolation example:
--------------------------------------------------------------------------------
1540264094 ~/dev/git/abstract_command $ vim variables.rb
1540264107 ~/dev/git/abstract_command $ cat variables.rb
require 'abstract_command'

class VarsCommand < AbstractCommand
  def template
    'echo %<var_1>s %<var_2>s %<var_3>s %<var_4>s %<var_5>s'
  end
end

command = VarsCommand.new
command.var_1 = 'one'
command.var_2 = 'two'
command.var_3 = 'three'
command.var_4 = 'four'
command.var_5 = 'five'
puts command.to_s
puts command.system
1540264111 ~/dev/git/abstract_command $ irb
ruby 2.1.10:001 > eval File.read 'variables.rb'
echo one two three four five
one two three four five
true
 => nil
ruby 2.1.10:002 >
--------------------------------------------------------------------------------








Namespace suggestion:
--------------------------------------------------------------------------------
1540263711 ~/dev/git/abstract_command $ vim lib/abstract_command.rb
1540263718 ~/dev/git/abstract_command $ cat namespace_suggestion.rb
require 'abstract_command'

module Command

  class Hello < AbstractCommand
    def template
      'echo Hello %<name>s'
    end
  end

  class Bye < AbstractCommand
    def template
      'echo Bye %<name>s'
    end
  end

end

command = Command::Hello.new
command.name = 'world'
puts command.to_s
puts command.system
puts command.backtick
1540263724 ~/dev/git/abstract_command $ irb
ruby 2.1.10:001 > eval File.read 'namespace_suggestion.rb'
echo Hello world
Hello world
true
Hello world
 => nil
ruby 2.1.10:002 >
--------------------------------------------------------------------------------








Ideas behind:


    * Simplifies shell command composition.
    * Avoids methods with many arguments.
    * It's simple to add new commands.
    * Confiure instead of Coding.
    * Confiure instead of Refactor.
    * Opens the door for standardization.
    * Devs could create a namespace for commands.
    * Removes pollution and resposibilities that don't belong other code
      does not need to know about how the shell command has to be built.
    * Among other things..








Enjoy.
