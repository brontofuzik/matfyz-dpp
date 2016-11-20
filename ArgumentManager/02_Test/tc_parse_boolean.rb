require 'ArgumentManager'
require 'test/unit'

class TestParseBoolean < Test::Unit::TestCase
  
  # binding test
  def test_parse00
    ArgumentManager.add_option( [ 'b' ], :bind => 'b' )
    
    b = nil
    
    ArgumentManager.set_binding( binding )
    ArgumentManager.parse( [ 'b' ] )
    
    assert_equal( b, true )
  end
  
  # boolean option
  # not given
  def test_parse01a
    options = ArgumentManager.parse( [] )
    assert_equal( nil , options[ 'b' ] )
  end
  
  # boolean option
  # given
  def test_parse01b
    options = ArgumentManager.parse( [ '-b' ] )
    assert_equal( true, options[ 'b' ] )
  end
  
end