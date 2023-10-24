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
#
class AbstractCommand
  attr_accessor :req_vars
  attr_accessor :opt_vars

  # '%<name>s'.scan(/(%<)(\w+)(>)/)
  # => [["%<", "name", ">"]]
  VARIABLE_REGEX = /(%<)(\w+)(>)/

  def template
    raise 'must implement'
  end

  def setget(variable, value)
    singleton_class.class_eval { attr_accessor variable.to_sym }
    instance_variable_set("@#{variable}", value.shellescape)
  end

  def initialize(properties)
    @req_vars = properties[:required]
    @opt_vars = properties[:optional]

    req_vars.each { |variable, value| setget(variable, value) }
    opt_vars.each { |variable, value| setget(variable, value) }
  end

  def variables
    req_vars.keys + opt_vars.keys
  end

  def to_s
    bindings = {}
    variables.each do |variable|
      value = instance_variable_get("@#{variable}")
      bindings[variable.to_sym] = "#{value}"
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
