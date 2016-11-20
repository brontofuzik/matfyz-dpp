require 'ArgumentManager'
require 'test/unit'

class TestParseString < Test::Unit::TestCase
  
  # binding test
  def test_parse00
    ArgumentManager.add_option( [ 's-opt' ], :type => :string, :domain => [ 'foo', 'bar' ], :df_str => 'foo', :bind => 's_opt' )
    
    s_opt = nil
  
    ArgumentManager.set_binding( binding )
    ArgumentManager.parse( [ '--s-opt=foo' ] )
    
    assert_equal( 'foo', s_opt )
  end
  
  # valid parameter
  def test_parse01a
    assert_nothing_raised {
      ArgumentManager.parse( [ '--s-opt=foo' ] )
    }
  end
  
  # invalid parameter -- out of bounds
  def test_parse01b
    assert_raise( RuntimeError ) {
      ArgumentManager.parse( [ '--s-opt=baz' ] )
    }
  end
  
  # optional string option with optional parameter 
  # neither option nor parameter given (previous mandatory options given)
  def test_parse02a
    options = ArgumentManager.parse( [] )
    assert_equal( nil, options[ 's-opt' ] )
  end
  
  # optional string option with optional parameter 
  # only option given (previous mandatory options given)
  def test_parse02b
    options = ArgumentManager.parse( [ '--s-opt' ] )
    assert_equal( 'foo', options[ 's-opt' ] )
  end
  
  # optional string option with optional parameter
  # both option and it's parameter given (previous mandatory options given)
  def test_parse02c
    options = ArgumentManager.parse( [ '--s-opt=foo' ] )
    assert_equal( 'foo', options[ 's-opt' ] )
  end
  
  # optional string option with mandatory parameter
  # neither option nor parameter given
  def test_parse03a
    ArgumentManager.add_option( [ 't-opt' ], :type => :string )
    
    options = ArgumentManager.parse( [] )
    assert_equal( nil, options[ 't-opt' ] )
  end
  
  # optional string option with mandatory parameter
  # only option given
  def test_parse03b
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '--t-opt' ] )
    }
  end
  
  # optional string option with mandatory parameter
  # both option and it's parameter given
  def test_parse03c
    options = ArgumentManager.parse( [ '--t-opt=foo' ] )
    assert_equal( 'foo', options[ 't-opt' ] )
  end
  
  # mandatory string option with optional parameter
  # neither option nor parameter given
  def test_parse04a
    ArgumentManager.add_option([ 'u-opt' ], :type => :string, :mandatory => true, :df_str => 'foo' )
    
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [] )
    }
  end
  
  # mandatory string option with optional parameter
  # only option given
  def test_parse04b
    options = ArgumentManager.parse( [ '--u-opt' ] )
    assert_equal( 'foo', options[ 'u-opt' ] )
  end
  
  # mandatory string option with optional parameter
  # both option and it's parameter given
  def test_parse04c
    options = ArgumentManager.parse( [ '--u-opt', 'foo' ] )
    assert_equal( 'foo', options[ 'u-opt' ] )
  end
  
  # mandatory string option with mandatory parameter
  # neither option nor parameter given (previous mandatory options given)
  def test_parse05a
    ArgumentManager.add_option( [ 'v-opt' ], :type => :string, :mandatory => true )
    
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '--u-opt=foo' ] )
    }
  end
  
  # mandatory string option with mandatory parameter
  # only option given (previous mandatory options given)
  def test_parse05b
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '--u-opt=foo', '--v-opt' ] )
    }
  end
  
  # mandatory string option with mandatory parameter
  # both option and it's parameter given (previous mandatory options given)
  def test_parse05c
    options = ArgumentManager.parse( [ '--u-opt=foo', '--v-opt=bar' ] )
    assert_equal( 'bar', options[ 'v-opt' ] )
  end
  
end