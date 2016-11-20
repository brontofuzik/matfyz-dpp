# == ArgumentManager.rb -- command line argument manager
#
# Bøeèka Jakub & Kúdela Lukáš, 2008
#
# = Option specifications (specs)
#
# Note: All the default values can be adjusted using ArgumentManager#set_defaults.
# 
# * <b><tt>:type</tt></b>
#   _description_:: type of option
#   _domain_::      <tt>:boolean</tt>, <tt>:integer</tt>, <tt>:string</tt>
#   _default_::     <tt>:boolean</tt>
#   _note_::        option types "range" and "enum" are registered through <tt>:integer</tt> and <tt>:string</tt> respectively
# ---
# * <b><tt>:mandatory</tt></b>
#   _description_:: boolean flag whether option is mandatory
#   _domain_::      { <tt>false</tt>, <tt>true</tt> }
#   _default_::     <tt>false</tt>
#   _note_::        <tt>:boolean</tt> is obviously not mandatory by default, since its possible absence is exactly what makes it an option
#                   however, it makes perfect sense for <tt>:integer</tt> or <tt>:string</tt> to be mandatory
# ---
# * <b><tt>:min</tt></b>
#   _description_:: lower bound
#   _domain_::      <tt>nil</tt> (no upper bound), integer (smaller or equal to upper bound)
#   _default_::     <tt>nil</tt>
#   _note_::        lower bound is included in the interval of allowed values
# ---
# * <b><tt>:max</tt></b>
#   _description_:: upper bound
#   _domain_::      <tt>nil</tt> (no upper bound), integer (greater or equal to lower bound)
#   _default_::     <tt>nil</tt>
#   _note_::        upper bound is included in the interval of allowed values
# ---
# * <b><tt>:df_int</tt></b>
#   _description_:: default integer value
#   _domain_::      <tt>nil</tt> (option argument is mandatory), integer (from interval [ min, max ])
#   _default_::     <tt>nil</tt>
# ---
# * <b><tt>:domain</tt></b>
#   _description_:: domain of allowed string values
#   _domain_::      <tt>nil</tt> (argument can be any string), array of strings
#   _default_::     <tt>nil</tt>
# ---
# * <b><tt>:df_str</tt></b>
#   _description_:: default string value
#   _domain_::      <tt>nil</tt> (option argument is mandatory), string (from domain { <tt>domain</tt> })
#   _default_::     <tt>nil</tt>
# ---
# * <b><tt>:help</tt></b>
#   _description_:: option help or commentary
#   _domain_::      <tt>nil</tt> (no help provided), string
#   _default_::     <tt>nil</tt>
# ---
# * <b><tt>:bind</tt></b>
#   _description_:: name of variable to which option (its value) is bound
#   _domain_::      <tt>nil</tt> (no bind to variable provided), string (legal variable name in Ruby)
#   _default_::     <tt>nil</tt>
#
# = Examples of use
#
# * <tt>ArgumentManager.add_option( [ 'a', 'boolean-option' ] )</tt>
#   - registers option with 2 names ( 'a', 'boolean-option' ) using default specifications since none were provided
# ---
# * <tt>ArgumentManager.add_option( 'a', :help => 'one lonely boolean option' )</tt>
#   - if option has only one name (which is true in many use cases), array is not necessary to pass it
# ---
# * <tt>ArgumentManager.add_option( [ 'i', 'integer-option' ], { :type => :integer, :min => 0, :max => 9, :df_int => 0 } )</tt>
#   - registers integer option with lower bound being set to 0, upper bound to 9 and default integer value to 0 (this means option argument is not mandatory )
# ---
# * <tt>ArgumentManager.add_option( [ 's', 'string-option' ], { :type => :string, :domain => [ 'foo', 'bar' ], :df_str => 'foo' } )</tt>
#   - registers string option with domain [ 'foo', 'bar' ] (enabling enum option)and default string value 'foo' (this means option argument is not mandatory )
# ---
# * <tt>ArgumentManager.add_options( 'a', 'b', 'c')</tt>
#   - registers three options with names 'a', 'b' and 'c' using default specifications (specifications can not be passed here)
# ---
# * <tt>ArgumentManager.set_defaults( :type => :integer, :df_int => 0, :help => 'from now on, integer options are default' )</tt>
#   - changes mentioned default specifications to values provided
# ---
# * <tt>ArgumentManager.add_options( 'i', 'j', 'k' )</tt>
#   - since default specifications have been changed, this registers three integer option with names 'i', 'j' and 'k' with default integer value 0 ()

#--
# ******************************************************************************
# ArgumentManager
# ******************************************************************************
#++
class ArgumentManager
  
  @@options = []
  
  @@non_options = []
  
  @@binding = nil
  
  # default option specifications
  @@df_specs = {
    :type => :boolean,    # { :boolean, :integer, :string }
    :mandatory => false,  # { false, true }
    :min => nil,          # { nil, integer }
    :max => nil,          # { nil, integer }
    :df_int => nil,       # { nil, integer }
    :domain => nil,       # { nil, array of strings }
    :df_str => nil,       # { nil, string }
    :help => nil,         # { nil, string }
    :bind => nil          # { nil, string }
  }
  
  # adds option with given names and specification
  # ---
  # _names_:: option name (string) or array of option names
  # _specs_:: hash containing option specifications (see section "Option specifications" for details)
  def ArgumentManager.add_option( names = [], specs = {} )
    
    # convert to array if necessary
    names = names.to_a
    
    # default option specifications are overriden when given
    specs = @@df_specs.merge( specs )
    
    # new option is created according to specifications
    case specs[ :type ]
      when :boolean
        new_option = BooleanOption.new( names, specs )
      when :integer
        new_option = IntegerOption.new( names, specs )
      when :string
        new_option = StringOption.new( names, specs )
      else
        raise "invalid type specified: #{ specs[ :type ].to_s }"
    end
    
    # new option is stored 
    @@options.push( new_option )  
  end
  
  # adds arbitrary number of options using default specification
  # ---
  # _names_:: any number of option names (strings) to be added
  def ArgumentManager.add_options( *names )
    names.each { | x |
      ArgumentManager.add_option( x )
    }
  end

  # gets options
  # ---
  # *returns*:: array containing all options
  def ArgumentManager.get_options
    @@options
  end
  
  # gets non-options
  # ---
  # *returns*:: array containing all non-options
  def ArgumentManager.get_non_options
    @@non_options
  end
  
  # sets default option specifications (these are used when particular specifications are not provided)
  # ---
  # _specs_:: hash containing option specifications to be set as default
  def ArgumentManager.set_defaults( specs = {} )
    specs.each { | spec |
      case spec[ 0 ]
        when :type
          if Option.type_ok?( spec[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end  
        when :mandatory
          if Option.mandatory_ok?( spec[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :min
          if IntegerOption.bounds_ok?( specs[ 1 ], @@df_specs[ :max ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :max
          if IntegerOption.bounds_ok?( @@df_specs[ :min ], specs[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :df_int
          if IntegerOption.default_ok?( specs[ 1 ], @@df_specs[ :min ], @@df_specs[ :max ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :domain
          if StringOption.domain_ok?( specs[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :df_str
          if StringOption.default_ok?( specs[ 1 ], @@df_specs[ :domain ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :help
          if Option.help_ok?( spec[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        when :bind
          if Option.bind_ok?( spec[ 1 ] )
            @@df_specs[ spec[ 0 ] ] = spec[ 1 ]
          end
        else
          raise "invalid option specification keyword: #{ spec[ 0 ].to_s }"
      end
    }
  end
  
  # parses the command line arguments and checks whether they correspond to given specification 
  # ---
  # *returns*:: hash containing option names and their values
  def ArgumentManager.parse( argv )
    
    argv = ArgumentManager.expand_short_option_clusters( argv )
    
    # parse options
    options = []
    while !argv.empty?
      option_obj = ArgumentManager.parse_option( argv )
      if option_obj != nil
        # option has been found
        options.push( option_obj )
      else
        # no further options, only following non-options
        break
      end
    end
    
    # parse following non-options
    non_options = []
    argv.each { | non_option |
      non_options.push( non_option )
    }
    
    @@non_options = non_options
    
    # check for mandatory
    @@options.each { | option |
      # option is mandatory and value was not found
      if (option.get_mandatory) and (option.value == nil)
          raise "mandatory option not given: #{ option.names[ 0 ] }"
      end
    }
    
    # get values
    values = {}
    options.each { | option |
      option.get_names.each { | name |
        values[ name ] = option.get_value
      }
    }

    # get bindings
    options.each { | option |
      if (option.get_bind != nil) and (option.get_value != nil)
        if option.is_a?(StringOption)
          code = "#{ option.get_bind } = '#{ option.get_value }'"
        elsif option.is_a?(IntegerOption)
          code = "#{ option.get_bind } = #{ option.get_value }"
        elsif option.is_a?(BooleanOption)
          code = "#{ option.get_bind } = #{ option.get_value }"
        end
        eval( code, @@binding )
      end
    }
    
    return values
  end
  
  # exapnds every cluster of multiple short options (-abc) to single short options (-a -b -c)
  # ---
  # _argv_::    array of command line arguments passed to program
  # ---
  # *returns*:: new argv with expanded multiples of short options (-abc) to single (-a -b -c)
  def ArgumentManager.expand_short_option_clusters( argv )
    new_argv = []
    argv.each { | x |
      if ArgumentManager.match_short_option_cluster( x )
        # need to expand
        ArgumentManager.expand_short_option_cluster( x ).each { | x |
          new_argv.push( x )
        }
      else
        # no need to expand
        new_argv.push(x)
      end
    }
    return new_argv
  end
  
  # ArgumentManager.expand_short_option_cluster
  # ---
  # _option_::  single argument from command line
  # *returns*:: converts a string of short arguments (-abc) to an array of individual ones
  def ArgumentManager.expand_short_option_cluster( short_option_cluster )
    
    # split option string to option array of single characters
    short_option_array = short_option_cluster.split( // )
    
    # remove leading '-'
    short_option_array.shift
    
    expanded_short_options = []
    while ! short_option_array.empty?
      if short_option_array[ 0 ].match( /[A-Za-z0-9_]/ )
        expanded_short_options.push( '-' + short_option_array[ 0 ] )
        short_option_array.shift
      else
        break
      end
    end
    return expanded_short_options
  
    #while /^-[A-Za-z0-9_][A-Za-z0-9_]/.match( option )
    #  options.push( "-" + option[1, 1] )
    #  option = "-" + option[2, option.length]
    #end
    #
    #options.push( option )
  end
  
  # ArgumentManager.parse_option
  # ---
  # _argv_::    array of command line arguments passed to program
  # *returns*:: string containing the option name plus associated arguments
  def ArgumentManager.parse_option( argv )
    # option name is guaranteed to be at the beginning of the array
    option = argv.shift
    
    # extract option name
    match_data = ArgumentManager.match_option( option )
    if match_data == nil
      argv.unshift option
      return nil
    end

    option_obj = process_option( match_data )

    if option_obj == nil
      raise "unknown option given: #{ option.to_s }"
    end
    
    # mark the presence of option
    option_obj.set_present
    
    # if option must have value, we:
    # 1. try to extract it from the long option
    # 2. take the following command line argument (if exists) for it
    # otherwise an exception is raised
    if option_obj.must_have_value?
      match_data = ArgumentManager.match_long_option( option )
      # matched against long option with argument
      if (match_data != nil) and (match_data[ 3 ] != nil)
        argument = match_data[ 3 ]
        option_obj.set_value( argument )
      elsif (! argv.empty?) and (! ArgumentManager.match_option( argv[ 0 ] ))
        option_obj.set_value( argv.shift )
      else
        raise "mandatory option argument not given: #{ option.to_s }"
      end
      return option_obj
    end
    
    # if option must have value, we:
    # 1. try to extract it from the long option
    # 2. take the following command line argument (if exists) for it
    if option_obj.can_have_value?
      match_data = ArgumentManager.match_long_option( option )
      # matched against long option with argument
      if (match_data != nil) and (match_data[ 3 ] != nil)
        argument = match_data[ 3 ]
        option_obj.set_value( argument )
      elsif (! argv.empty?) and (! ArgumentManager.match_option( argv[ 0 ] ))
        option_obj.set_value( argv.shift )
      end
      return option_obj
    end
    
    return option_obj
  end
  
  # ArgumentManager.process_option
  # ---
  # _option_:: option to be processed
  def ArgumentManager.process_option( match_data )
    option_name = match_data[ 1 ]
    
    # fetch option using extracted name 
    option_obj = ArgumentManager.fetch_option_by_name( option_name )

    return option_obj
  end
  
  # fetches option using its name
  # ---
  # _name_::    name of option to be fetched
  # *returns*:: option if found, nil otherwise
  def ArgumentManager.fetch_option_by_name( option_name )
    
    # search all options and all their respective names for name match
    @@options.each { | option |
      if option.get_names.include?( option_name )
        return option
      end
    }
    
    # no option with given name found
    return nil
  end
  
  # ArgumentManager.match_short_option_cluster
  # ---
  # _argument_:: command line argument (string)
  # *returns*:: match data object in case of match, nil otherwise
  def ArgumentManager.match_short_option_cluster( argument )
    return argument.match( /\A-([A-Za-z0-9_]{2,})(.*)\z/ )
  end
  
  # ArgumentManager.match_option_name
  # ---
  # _option_::  option to be processed
  # *returns*:: the name of the argument
  def ArgumentManager.match_option( option )
    # short option
    match_data = ArgumentManager.match_short_option( option )
    if match_data
      return match_data
    end
    # long option
    match_data = ArgumentManager.match_long_option( option )
    if match_data
      return match_data
    end
    # no match (non-option)
    return nil
  end
  
  # short option
  def ArgumentManager.match_short_option( option )
    return option.match( /\A-([A-Za-z0-9_])\z/ )
  end
  
  # long option
  def ArgumentManager.match_long_option( option )
    return option.match( /\A--([A-Za-z0-9_][-A-Za-z0-9_]*)(=(.*))?\z/ )
  end
  
  
  # ArgumentManager.get_help
  # ---
  # *returns*:: array containing info (names, mandatory, constraints, default, help) for each registered option
  def ArgumentManager.get_help
    help = @@options.collect { | option |
      # select short option names first
      short_names = option.get_names.select { | name |
        name.length == 1
      }

      # select long option names
      long_names = option.get_names.select { | name |
        name.length > 1
      }
      
      # combine short names and long names to create string of names
      names = short_names + long_names
    
      # mandatory
      if option.get_mandatory
        mandatory = 'option is mandatory'
      else
        mandaotry = nil
      end

      # constraints and default
      case option.class.to_s
        
        when 'BooleanOption'
          names.collect! { | name |
            if name.length == 1
              '-' + name  
            else
              '--' + name
            end
          }
          constraints = nil
          
        when 'IntegerOption'
          names.collect! { | name |
            if name.length == 1
              '-' + name     
            else
              '--' + name + '=INT'
            end
          }
          # either bound is specified
          if option.get_min or option.get_max
            # min
            if option.get_min
              min = option.get_min
            else
              min = '-inf'
            end
            # max
            if option.get_max
              max = option.get_max
            else
              max = '+inf'
            end
            constraints = "INT is from interval [ #{ option.get_min }, #{ option.get_max } ]"
          end
          if option.get_default
            default = "INT is not mandatory -- default value is #{ option.get_default }"
          else
            default = 'INT is mandatory'
          end
          
        when 'StringOption'
          names.collect! { | name |
            if name.length == 1
              '-' + name     
            else
              '--' + name + '=STR'
            end
          }
          if option.get_domain
            constraints = "STR is from domain { #{ option.get_domain.join( ', ' ) } }"
          end
          if option.get_default
            default = "STR is not mandatory -- default value is #{ option.get_default }"
          else
            default = 'STR is mandatory'
          end
          
        else
          constraints = nil
      end
    
      # help
      help = option.get_help
      
      [ names.join( ', ' ), mandatory, constraints, default, help ].compact
    }
    return help
  end
  
  # ArgumentManager.set_binding
  # _binding_:: binding to be set
  def ArgumentManager.set_binding( binding )
    @@binding = binding
  end
end

#--
# ******************************************************************************
# Option
# ******************************************************************************
#++
# Class Option implements interface that all derived option classed have in common,
# namely menipulation routines for common attributes like names, mandatory flag,
# help and binding to variable.
class Option
  
  #--
  # Instance variables
  #++
  
  # _description_:: all registered option names (both short and long)
  # _domain_::      non-empty array of unique valid option names
  # _default_::     -
  attr_reader :names
    
  # _description_:: boolean flag whether option is mandatory
  # _domain_::      { false, true }
  # _default_::     false
  attr_reader :mandatory 
    
  # _description_:: option help or commentary
  # _domain_::      string
  # _default_::     nil
  attr_reader :help
  
  # _description_:: option value (determined by calling Option#parse)
  # _domain_::      { { false, true }, integer, string }
  # _default_::     nil
  attr_reader :value
  
  # _description_:: name of variable to which option (its value) is bound
  # _domain_::      string (legal variable name in Ruby)
  # _default_::     nil
  attr_reader :bind
  
  #--
  # Class methods
  #++
  
  # creates an instance of class Option given its names and specifications
  # _names_:: array containing all option names (see example of use)
  # _specs_:: hash containing all option specifications (see example of use)
  # ---
  # *returns*:: instance of class Option
  def initialize( names, specs )
    set_names( names )
    set_mandatory( specs[ :mandatory ] )
    set_help( specs[ :help ] )
    set_bind( specs[ :bind ] )
  end
  
  # checks whether option names are ok
  # ---
  # option names are ok if (and only if):
  # * they are all ok (see Option#name_ok?)
  # * they are all unique
  # ---
  # _names_:: array containing all option names to be checked
  # ---
  # *returns*:: true if all option names are ok, false otherwise
  def Option.names_ok?( names )
    
    # detect if all names are ok
    ok_names_only = names.select { | name |
      Option.name_ok?( name )
    }
    if ok_names_only.size < names.size
      # at least one name was not ok
      return false
    end
    
    # detect if all names are unique
    if ok_names_only.sort.uniq.size < names.size
      # at least one duplicity
      return false
    end
    # all names are ok and unique
    return true
  end
  
  # checks whether option name is ok
  # ---
  # option name is ok if (and only if) it is:
  # * one (upper-case or lower-case) letter
  # * seqence of (upper-case or lower-case) letters that may contain minus sign
  #   but has to begin and end with a letter
  # ---
  # _name_:: option name to be checked
  # ---
  # *returns*:: true if option name is ok, false otherwise
  def Option.name_ok?( name )
    if ! name.is_a?(String)
      return false
    end
    
    if name.match( /\A[A-Za-z](\z|[-A-Za-z]*[A-Za-z]\z)/ )
      return true
    else
      return false
    end
  end
  
  # checks whether option type is ok
  # ---
  # option type is ok if (and only if):
  # * it is one of allowed option types (boolean, integer or string)
  # ---
  # _type_:: option type to be checked
  # ---
  # *returns*:: true if option type is ok, false otherwise
  def Option.type_ok?( type )
    if [ :boolean, :integer, :string ].include?( type )
      return true
    else
      return false
    end
  end
  
  # checks whether option mandatory flag is ok
  # ---
  # option mandatory flag is ok if (and only if):
  # * it is one of allowed option mandatory flags (false or true)
  # ---
  # _mandatory_:: option mandatory flag to be checked
  # ---
  # *returns*:: true if option mandatory flag is ok, false otherwise
  def Option.mandatory_ok?( mandatory )
    if [ false, true ].include?( mandatory )
      return true
    else
      return false
    end
  end
  
  # checks whether option help is ok
  # ---
  # option help is ok if (and only if):
  # * it is nil (no help provided)
  # * it is an (arbitrary) string 
  # ---
  # _help_:: option help to be checked
  # ---
  # *returns*:: true if option help is ok, false otherwise
  def Option.help_ok?( help )
    if (help == nil) or (help.is_a?( String ))
      return true
    else
      return false
    end
  end
  
  # checks whether option bind is ok
  # ---
  # option bind is the name of the variable the option is bound to,
  # ergo the varible that will be assigned the option argument by Option#parse
  # ---
  # option bind is ok if (and only if):
  # * it is nil (no bind provided)
  # * it is an (arbitrary) string (note: option names in Ruby can not be arbitrary!)
  # ---
  # _bind_:: option bind to be checked
  # ---
  # *returns*:: true if option bind is ok, false otherwise
  def Option.bind_ok?( bind )
     if (bind == nil) or (bind.is_a?( String ))
      return true
    else
      return false
    end
  end
  
  #--
  # Instance Methods
  #++
  
  # sets all option names (after checking if they are all ok)
  # ---
  # _names_:: array containing string option names to be set
  def set_names( names )
    if Option.names_ok?( names )
      @names = names
    else
      raise "invalid names: #{ names.to_s }"
    end
  end
  
  # gets all option names
  # ---
  # *returns*:: array containing all option names
  def get_names
    @names
  end

  # adds name to already existing option names (after checking if it is ok)
  # ---
  # _name_:: string option name to be added
  def add_name( name )
    if Option.name_ok?( name )
      if ! @names.include?( name )
        @names.push( name )
      end
    end
  end
  
  # sets option mandatory flag (after checking if it is ok)
  # ---
  # _madatory_:: booolean option mandatory flag to be set
  def set_mandatory( mandatory )
    if Option.mandatory_ok?( mandatory )
      @mandatory = mandatory
    else
      raise "invalid mandatory value: #{ mandatory.to_s }"
    end
  end
  
  # gets option mandatory flag
  # ---
  # *returns*:: boolean option mandatory flag
  def get_mandatory
    @mandatory
  end
  
  # sets option help
  # ---
  # _help_:: string option help to be set
  def set_help( help )
    if Option.help_ok?( help )
      @help = help
    else
      raise 'invalid help'
    end
  end
  
  # gets option help
  # ---
  # *returns*:: string option help
  def get_help
    @help
  end
  
  # sets option bind
  # ---
  # _bind_:: string option bind (name of variable the optin is bound to) to be set
  def set_bind( bind )
    if Option.bind_ok?( bind )
      @bind = bind
    else
      raise "invalid bind variable name: #{ bind.to_s }"
    end
  end
  
  # gets option bind
  # ---
  # *returns*:: string option bind (name of variable the optin is bound to)
  def get_bind
    @bind
  end
  
  # checks whether this argument can have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument can have an assigned value
  def can_have_value?
    return false
  end
  
  # checks whether this argument must have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument must have an assigned value
  def must_have_value?
    return false
  end
  
  # sets option argument value
  # ---
  # _value_:: option argument value to be set
  def set_value( value )
    @value = value  
  end
  
  # gets option argument value
  # ---
  # *returns*:: option argument vaulue
  def get_value
    @value  
  end
  
  # informes the object, that the argument is present on the command-line (for bool arguments)
  # ---
  # *returns*:: nil
  def set_present
    nil
  end
end

#--
# ******************************************************************************
# BooleanOption
# ******************************************************************************
#++
class BooleanOption < Option

  # creates an instance of class BooleanOption given its names and specifications
  # _names_:: array containing all option names (see example of use)
  # _specs_:: hash containing all option specifications (see example of use)
  # ---
  # *returns*:: instance of class BooleanOption
  def initialize( names, specs )
    super( names, specs )
  end
  
  # checks whether this argument must have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument must have an assigned value
  def set_present
    set_value( true )
  end
end

#--
# ******************************************************************************
# IntegerOption (also implements "RangeOption")
# ******************************************************************************
#++
class IntegerOption < Option
  
  #--
  # Instance variables
  #++

  # _description_:: lower bound
  # _domain_::      integer, smaller or equal to upper bound
  # _default_::     nil (=> no lower bound)
  attr_reader :min

  # _description_:: upper bound
  # _domain_::      integer, greater or equal to lower bound
  # _default_::     nil (=> no upper bound)
  attr_reader :max
   
  # _description_:: default integer value
  # _domain_::      [ lower bound, upper bound ]
  # _default_::     nil (=> option argument mandatory)
  attr_reader :df_int
  
  #--
  # Class methods
  #++
  
  # creates an instance of class IntegerOption given its names and specifications
  # ---
  # _names_:: array containing all option names (see example of use)
  # _specs_:: hash containing all option specifications (see example of use)
  # ---
  # *returns*:: instance of class IntegerOption
  def initialize( names, specs )
    super( names, specs )
    set_bounds( specs[ :min ], specs[ :max ] )
    set_default( specs[ :df_int ] )
  end
  
  # checks whether integer option bounds are ok
  # ---
  # bounds are ok if (and only if):
  # * both are nil
  # * either one of them is nil and the other one is an integer
  # * both are integers and the following condition is satisfied
  #   the lower bound is less than or equal to the upper bound
  # ---
  # _min_:: lower bound to be checked (nil or integer)
  # _max_:: upper bound to be checked (nil or integer)
  # ---
  # *returns*:: true if integer option bounds are ok, false otherwise
  def IntegerOption.bounds_ok?( min, max )
    if (min == nil) and (max == nil)
      return true
    elsif ((min == nil) and (max.is_a?( Fixnum ))) or 
          ((max == nil) and (min.is_a?( Fixnum )))
      return true
    elsif (min.is_a?( Fixnum )) and (max.is_a?( Fixnum )) and (min <= max)
      return true
    else
      return false
    end
  end
  
  # checks whether integer option default integer value is ok
  # ---
  # default integer value is ok if (and only if):
  # * it is nil
  # * (bounds not specified) it is any integer 
  # * (bounds specified) it is integer within bounds
  # ---
  # _df_int_:: default integer value to be checked (nil or integer)
  # _min_:: lower bound to be checked (nil or integer)
  # _max_:: upper bound to be checked (nil or integer)
  # ---
  # *returns*:: true if integer option default integer value is ok, false otherwise
  def IntegerOption.default_ok?( df_int, min, max )
    # nil as a default vaule is ok
    if df_int == nil
      return true
    end
    
    # check whether the default value satisfies the lower bound
    if min != nil
      if df_int < min
        return false
      end
    end
    
    # check whether the default value satisfies the upper bound
    if max != nil
      if max < df_int
        return false
      end
    end
    
    # the default value satisifes both (lower and upper) bounds
    return true
  end
  
  #--
  # Instance methods
  #++
  
  # sets the integer option bounds
  # ---
  # _min_:: integer option lower bound to be set (nil or integer)
  # _max_:: integer option upper bound to be set (nil or integer)
  def set_bounds( min, max )
    set_min( min )
    set_max( max )
  end
  
  # gets integer option bounds
  # ---
  # *returns*:: array (size two) of nils (bounds not specified) or integers
  def get_bounds
    [ @min, @max ]
  end
  
  # sets integer optin lower bound
  # ---
  # _min_:: integer option lower bound to be set (nil or integer)
  def set_min( min )
    if IntegerOption.bounds_ok?( min, @max )
      @min = min
    else
      @min = nil
      raise "invalid lower bound: #{ min.to_s }"
    end
  end
  
  # gets integer option lower bound
  # ---
  # *returns*:: integer option lower bound (nil or integer)
  def get_min
    @min
  end
  
  # sets integer option upper bound
  # ---
  # _max_:: integer option upper bound (nil or integer) to be set
  def set_max( max )
    if IntegerOption.bounds_ok?( @min, max )
      @max = max
    else
      @max = nil
      raise "invalid upper bound: #{ max.to_s }"
    end
  end
  
  # gets integer option upper bound
  # ---
  # *returns*:: integer option upper bound (nil or integer)
  def get_max
    @max
  end
  
  # sets integer option default integer value
  # ---
  # _df_int_:: integer option default integer value to be set (nil or integer)
  def set_default( df_int )
    if IntegerOption.default_ok?( df_int, @min, @max )
      @df_int = df_int
    else
      @df_int = nil
      raise "invalid default integer value: #{ df_int.to_s }"
    end
  end
  
  # gets integer option default integer value
  # ---
  # *returns*:: integer option default integer value (nil or integer)
  def get_default
    @df_int
  end
  
  # checks whether this argument can have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument can have an assigned value
  def can_have_value?()
    return true
  end
  
  # checks whether this argument must have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument must have an assigned value
  def must_have_value?()
    return @df_int == nil
  end
  
  # sets integer value
  # ---
  # _value_:: integer option value to be set
  def set_value( value )
    if value == nil
      return
    end
    
    value = value.to_i
    
    satisfying_min = ((get_min == nil) or ((get_min != nil) and (get_min <= value)))
    satisfying_max = ((get_max == nil) or ((get_max != nil) and (value <= get_max)))
    
    if satisfying_min and satisfying_max
      @value = value
    else
      raise "integer value out of range: #{ value.to_s }"
    end
  end
  
  # get integer value
  # ---
  # *returns*:: integer option value
  def get_value
    if @value != nil
      return @value
    else
      return @df_int
    end
  end
end

#--
# ******************************************************************************
# StringOption (also implements "EnumOption")
# ******************************************************************************
#++
class StringOption < Option
  
  #--
  # Instance variables
  #++
  
  # _description_:: domain of allowed string values
  # _domain_::      array of strings
  # _default_::     nil (=> any string)
  attr_reader :domain

  # _description_:: default string value
  # _domain_::      { domain }
  # _default_::     nil (=> option argument mandatory)
  attr_reader :df_str
  
  #--
  # Class methods
  #++
  
  # creates an instance of class StringOption given its names and specifications
  # ---
  # _names_:: array containing all option names (see example of use)
  # _specs_:: hash containing all option specifications (see example of use)
  # ---
  # *returns*:: instance of class StringOption
  def initialize( names, specs )
    super( names, specs )
    set_domain( specs[ :domain ] )
    set_default( specs[ :df_str ] )
  end
  
  # checks whether string option domain is ok
  # ---
  # domain is ok if (and only if):
  # * it is nil
  # * it is array of unique strings
  # ---
  # _domain_:: string option domain to be checked (array of strings)
  # ---
  # *returns*:: true if string option domain is ok, false otherwise
  def StringOption.domain_ok?( domain )
    # nil
    if domain == nil
      return true
    end
    
    if ! domain.is_a?(Array)
      return false
    end
    
    # array of unique strings
    if domain.sort.uniq.length == domain.length
      return true
    else
      return false
    end
  end
  
  # checks whether string option default string value is ok
  # ---
  # string option default string value is ok if (and only if):
  # * it is nil
  # * (domain not specified) any string
  # * (domain specified) string from the domain
  # ---
  # _df_str_:: string option default value to be checked (nil or string)
  # _domain_:: srring option domain against which to check (nil or array of strings)
  # ---
  # *returns*:: true if string option default string value is ok, false otherwise
  def StringOption.default_ok?( df_str, domain )
    if df_str == nil
      # nil
      return true
    elsif df_str.is_a?( String )
      if domain == nil
        # (domain not specified) any string
        return true
      else
        # (domain specified) a string from the domain
        if domain.include?( df_str )
          return true
        else
          return false
        end
      end
    else
      # default not nil or a string
      return false
    end
  end
  
  #--
  # Instance methods
  #++
  
  # sets string option domain
  # ---
  # _domain_:: string option domain to be set (array of strings)
  def set_domain( domain )
    if StringOption.domain_ok?( domain )
      @domain = domain
    else
      @domain = nil
      raise "invalid domain: #{ domain.to_s }"
    end 
  end
  
  # gets string option domain
  # ---
  # *returns*:: string option domain (array of strings)
  def get_domain
    @domain
  end
  
  # sets string option default string value
  # ---
  # _df_str_:: string option default string value to be set (nil or string)
  def set_default( df_str )
    if StringOption.default_ok?( df_str, @domain )
      @df_str = df_str
    else
      @df_str = nil
      raise "invalid default string value: #{ df_str.to_s }"
    end 
  end
  
  # gets string option default string value
  # ---
  # *returns*:: string option default string value (nil or string)
  def get_default
    @df_str
  end
  
  # checks whether this argument can have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument can have an assigned value
  def can_have_value?
    return true
  end
  
  # checks whether this argument must have an assigned value
  # ---
  # *returns*:: bool specifying whether this argument must have an assigned value
  def must_have_value?
    return @df_str == nil
  end
  
  # sets string value
  # ---
  # _value_:: string option value to be set
  def set_value( value )
    if value == nil
      return
    end
    
    # convert to string if necessary
    value = value.to_s
    
    if (get_domain == nil) or (get_domain.include?( value ))
      @value = value
    else
      raise "string value not from domain: #{ value.to_s }"
    end
    
  end
  
  # gets string option value
  # ---
  # *returns*:: string option value
  def get_value
    if @value != nil
      return @value
    else
      return @df_str
    end
  end
end
