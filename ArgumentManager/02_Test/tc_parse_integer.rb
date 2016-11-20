require 'ArgumentManager'
require 'test/unit'

class TestParseInteger < Test::Unit::TestCase
  
  # binding test
  def test_parse00
    ArgumentManager.add_option( [ 'i' ], :type => :integer, :min => 0, :max => 10, :df_int => 0, :bind => 'i' )
    
    i = nil
  
    ArgumentManager.set_binding( binding )
    ArgumentManager.parse( [ '-i', '5' ] )
    
    assert_equal( 5, i )
  end
  
  # valid parameter
  def test_parse01a
    assert_nothing_raised {
      ArgumentManager.parse( [ '-i', '0' ] )
    }
  end
  
  # invalid parameter -- out of bounds
  def test_parse01b
    assert_raise( RuntimeError ) {
      ArgumentManager.parse( [ '-i', '999' ] )
    }
  end
  
  # optional integer option with optional parameter
  # neither option nor parameter given
  def test_parse02a
    options = ArgumentManager.parse( [] )
    assert_equal( nil, options[ 'i' ] )
  end
  
  # optional integer option with optional parameter
  # only option given  
  def test_parse02b
    options = ArgumentManager.parse( [ '-i' ] )
    assert_equal( 0, options[ 'i' ] )
  end
  
  # optional integer option with optional parameter
  # both option and it's parameter given 
  def test_parse02c
    options = ArgumentManager.parse( [ '-i', '1' ] )
    assert_equal( 1, options[ 'i' ] )
  end
  
  # optional integer option with mandatory parameter
  # neither option nor parameter given 
  def test_parse03a    
    ArgumentManager.add_option( [ 'j' ], :type => :integer )
    
    options = ArgumentManager.parse( [] )
    assert_equal( nil, options[ 'j' ] )
  end
  
  # optional integer option with mandatory parameter
  # only option given
  def test_parse03b
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '-j' ] )
    }
  end
  
  # optional integer option with mandatory parameter
  # both option and it's parameter given
  def test_parse03c
    options = ArgumentManager.parse( [ '-j', '9' ] )
    assert_equal( 9, options[ 'j' ])
  end
  
  # mandatory integer option with optional parameter
  # neither option nor parameter given
  def test_parse04a
    ArgumentManager.add_option([ 'k' ], :type => :integer, :mandatory => true, :df_int => 0 )
    
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [] )
    }
  end
  
  # mandatory integer option with optional parameter
  # only option given
  def test_parse04b
    options = ArgumentManager.parse( [ '-k' ] )
    assert_equal( 0, options[ 'k' ] )
  end
  
  # mandatory integer option with optional parameter
  # both option and it's parameter given
  def test_parse04c
    options = ArgumentManager.parse( [ '-k', '3' ] )
    assert_equal( 3, options[ 'k' ] )
  end
  
  # mandatory integer option with mandatory parameter
  # neither option nor parameter given (previous mandatory options given)
  def test_parse05a
    ArgumentManager.add_option( [ 'l' ], :type => :integer, :mandatory => true )
    
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '-k', '3' ] )
    }
  end
  
  # mandatory integer option with mandatory parameter
  # only option given (previous mandatory options given)
  def test_parse05b
    assert_raise( RuntimeError ) {
      options = ArgumentManager.parse( [ '-k', '3', '-l' ] )
    }
  end
  
  # mandatory integer option with mandatory parameter
  # both option and it's parameter given (previous mandatory options given)
  def test_parse05c
    options = ArgumentManager.parse( [ '-k', '3', '-l', '7' ] )
    assert_equal( 7, options[ 'l' ] )
  end

end