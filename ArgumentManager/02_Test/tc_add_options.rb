require 'ArgumentManager'
require 'test/unit'

class TestAddOptions < Test::Unit::TestCase
  
  # default boolean options
  def test_add_option01
    ArgumentManager.add_options( 'u', 'v', 'w' )
    
    options = ArgumentManager.parse( [ '-u' ] )
    
    assert_equal( true, options[ 'u' ] )
    assert_equal( nil, options[ 'v' ] )
    assert_equal( nil, options[ 'w' ] )
  end
  
  # changed to default integer options
  def test_add_option02
    ArgumentManager.set_defaults( :type => :integer, :df_int => 0 )
    ArgumentManager.add_options( 'i', 'j', 'k' )
    
    options = ArgumentManager.parse( [ '-i', '3', '-v', '-k', '4' ] )
    
    assert_equal( 3, options[ 'i' ] );
    assert_equal( true, options[ 'v' ] );
    assert_equal( 4, options[ 'k' ] );
    assert_equal( nil, options[ 'j' ] );
  end
  
end
