require 'ArgumentManager.rb'

ArgumentManager.set_binding( binding )

boolean_option = false

# ArgumentManager.add_option test
# boolean
ArgumentManager.add_option(
  [ 'b', 'boolean-option' ],
  :help => 'boolean option',
  :bind => 'boolean_option'
)

# optional integer with optional parameter
ArgumentManager.add_option(
  [ 'i', 'optional-integer' ],
  :type => :integer,
  :min => 0,
  :max => 9,
  :df_int => 0,
  :help => 'optional integer',
  :bind => 'optional_integer'
)

# mandatory integer with mandatory parameter
ArgumentManager.add_option(
  [ 'j', 'mandatory-integer' ],
  :type => :integer,
  :mandatory => true,
  :min => 0,
  :max => 9,
  :help => 'mandatory integer',
  :bind => 'mandatory_integer'
)

# optional string with optional parameter
ArgumentManager.add_option(
  [ 's', 'optional-string' ],
  :type => :string,
  :domain => nil,
  :df_str => 'foo',
  :help => 'optional string',
  :bind => 'optional_string'
)

# mandatory string with mandatory parameter
ArgumentManager.add_option(
  [ 't', 'mandatory-string' ],
  :type => :string,
  :mandatory => true,
  :domain => [ 'foo', 'bar' ],
  :help => 'mandatory string',
  :bind => 'mandatory_string'
)

# ArgumentManager.set_defaults test
ArgumentManager.set_defaults(
  :type => :integer,
  :df_int => 0,
  :help => 'from now on, integer options are default'
)

ArgumentManager.add_options( 'u', 'v', 'w' )

# ArgumentManager.get_help test
=begin
ArgumentManager.get_help.each { | i |
  puts i.inspect
  puts
}
=end

# ArgumentManager.parse test
puts ArgumentManager.parse.inspect

puts boolean_option
