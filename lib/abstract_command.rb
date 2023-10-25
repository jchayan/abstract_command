require 'open3'
require 'shellwords'

# Shell Command Abstraction.
#
# Hides away all the details to generate a command.
# And provides an easy interface to interact with shell commands as if
# they were objects.
#
# This is good for the following reasons:
#
# - Enforces standardization.
# - Enforces separation of command definition and consumption.
# - Enforces configuration over code.
# - Enforces configuration over refactoring.
# - Enforces simple shell-command definition.
# - Enforces automatic sanitization of variables that get interpolated.
# - Provides a simple Object Oriented Interface.
# - Provides a scope for variables that belong to the command.
# - Provides getters and setter for every interpolation in command.
# - Provides a neat interface that plugs to data structures transparently.
# - Avoids methods with many arguments.
# - Avoids changes in the standared libarary: system, backtick, etc.

class CommandArgument
  attr_accessor :name
  attr_accessor :value

  def initialize(name, value)
    @name  = name
    @value = value
  end
end

class AbstractCommand
  private

  # We would only allow changing the value of an argument.
  #
  # This method defines a setter/getter for an argument, making
  # this library fulfill its promise of abstracting commands as objects:
  # all the instance variables of a command are CommandArguments

  def create_accessor_mutator(argument)
    singleton_class.send(:define_method, "#{argument.name}") do
      command_arg = instance_variable_get("@#{argument.name}")
      command_arg.value
    end

    singleton_class.send(:define_method, "#{argument.name}=") do |value|
      command_arg = self.instance_variable_get("@#{argument.name}")
      command_arg.value = value
    end

    instance_variable_set("@#{argument.name}", argument)
  end

  def create_command_arg(property, value)
    CommandArgument.new(property, value)
  end

  public

  def template
    raise 'must implement'
  end

  def initialize(properties = {})
    properties
      .map(&method(:create_command_arg))
      .each(&method(:create_accessor_mutator))
  end

  # Command arguments can be retrieved to build the command's template
  # in the way that the user of this library finds more convenient

  def command_arguments
    instance_variables.map(&method(:instance_variable_get))
  end

  # Shell sanitization is still ensured as in the original implementation
  # So that the command is cleaned up even if the arguments values change

  def to_s
    bindings = {}
    command_arguments.each do |argument|
      bindings[argument.name.to_sym] = "#{argument.value.shellescape}"
    end
    format(template, bindings)
  end

  def system
    super(to_s)
  end

  def backtick
    `#{to_s}`
  end

  def execute
    begin
      stdout, stderr, status = Open3.capture3(to_s)
      status = status.exitstatus
    rescue StandardError => error
      stdout = ""
      if(error.message)
        stderr = error.message
      end
      status = 1
    end
    return stdout, stderr, status
  end

end
