
# Abstract Command


Shell Command Abstraction - Let's you interact with shell commands as if they were objects.


Ideas behind:


* Enforces standardization.
* Enforces separation of command definition and consumption.
* Enforces configuration over code.
* Enforces configuration over refactoring.
* Enforces simple shell command definition.
* Provides a simple Object Oriented Interface.
* Provides a scope for variables that belong to the command.
* Provides getters and setter for every interpolation in command.
* Provides a neat interface that plugs to data structures transparently.
* Avoids methods with many arguments.
* Avoids changes in the standared libarary: system, backtick, etc.



Hello world example:
--------------------------------------------------------------------------------
```ruby
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
```

```bash
$ ruby example.rb
echo Hello World.
```
--------------------------------------------------------------------------------








Dynamic variables in command:
--------------------------------------------------------------------------------
```ruby
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
```

```bash
$ ruby variables.rb
echo one two three four five
one two three four five
```
--------------------------------------------------------------------------------








Namespace suggestion:
--------------------------------------------------------------------------------
```ruby
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
```

```bash
$ ruby namespace_suggestion.rb
echo Hello world
Hello world
true
Hello world
```
--------------------------------------------------------------------------------








Fast initialization:
--------------------------------------------------------------------------------
```ruby
require 'abstract_command'

module Command
  class Hello < AbstractCommand
    def template
      'echo Hello %<name>s'
    end
  end
end

command = Command::Hello.new(:name => 'Kazu')
puts command.to_s
puts command.system
```

```bash
$ ruby constructor.rb
echo Hello Kazu
Hello Kazu
true
```
--------------------------------------------------------------------------------








Automatic Sanitization:
--------------------------------------------------------------------------------
```ruby
require 'abstract_command'

module Command
  class Hello < AbstractCommand
    def template
      'echo Hello %<name>s'
    end
  end
end

command = Command::Hello.new(:name => '; touch /tmp/x')
puts command.to_s
puts command.system
```

```bash
$ ruby sanitization.rb
echo Hello \;\ touch\ /tmp/x
Hello ; touch /tmp/x
true
```
--------------------------------------------------------------------------------









I hope it is useful to you :)

