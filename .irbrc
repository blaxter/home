# It requires:
#   * rubygem
#   * gems install wirble duration

IRB_START_TIME = Time.now

require 'pp'
require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'
require 'wirble'
require 'duration'

ARGV.concat [ "--readline" ]

IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"
IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT]  = true

Wirble.init( :skip_history => true )
Wirble.colorize

# v methods for being used in irb session -----------------

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# enable tracing
def enable_trace( event_regex = /^(call|return)/, class_regex = /IRB|Wirble|RubyLex|RubyToken/ )
  puts "Enabling method tracing with event regex #{event_regex.inspect} and class exclusion regex #{class_regex.inspect}"

  set_trace_func Proc.new{|event, file, line, id, binding, classname|
    printf "[%8s] %30s %30s (%s:%-2d)\n", event, id, classname, file, line if
      event          =~ event_regex and
      classname.to_s !~ class_regex
  }
  return
end

# disable tracing
def disable_trace
  puts "Disabling method tracing"

  set_trace_func nil
end

# Catch all log output from active record
def log_to(stream, colorize=true)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
  ActiveRecord::Base.colorize_logging = colorize
end

# clear the screen.. with some self destruction ;-)
def clear
  eval "def clear; print #{`clear`.inspect} end"
  clear
end
private :clear

# ^ methods for being used in irb session ------------------

alias q exit

at_exit do
  puts Duration.new( Time.now - IRB_START_TIME )
end
