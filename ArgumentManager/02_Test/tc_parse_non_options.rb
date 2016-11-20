require 'ArgumentManager'
require 'test/unit'

class TestParseNonOptions < Test::Unit::TestCase

# neither options nor non-options given
  def test_parse01
    options = ArgumentManager.parse( [] )
    non_options = ArgumentManager.get_non_options
    
    assert_equal( options, {} )
    assert_equal( non_options, [] )
  end
  
  # only non-options given
  def test_parse02
    options = ArgumentManager.parse( [ 'i', 'am', 'a', 'non option' ] )
    non_options = ArgumentManager.get_non_options
    
    assert_equal( options, {} )
    assert_equal( [ 'i', 'am', 'a', 'non option' ], non_options )
  end
  
  # invalid non-option
  def test_parse03
    assert_raise ( RuntimeError ) {
      options = ArgumentManager.parse( [ '--opsn',  'i', 'am', 'a', 'non option' ] )
    }
  end
  
end