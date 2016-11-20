require 'ArgumentManager'
require 'test/unit'

class TestAddOption < Test::Unit::TestCase
  
  # invalid option names -- not strings
  def test_add_option01a
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option( [ 0, 1, 2 ] )
    }
  end
  
  # invalid option names -- not unique strings
  def test_add_option01b
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option( [ 'a', 'a' ] )
    }
  end
  
  # invalid option names -- not unique among all registered options
  def test_add_option01c
    assert_nothing_raised { 
      ArgumentManager.add_option( 'a' );
    }
    
    assert_raise ( RuntimeError ) { 
      ArgumentManager.add_option( 'a' );
    }
  end
  
  # valid boolean
  def test_add_option02a
    assert_nothing_raised { 
      ArgumentManager.add_option(
        [ 'b', 'b-boolean' ],
        :help => 'boolean opt',
        :bind => 'boolean_opt'
      )
    }
  end
  
  # invalid help -- not string
  def test_add_option02b
    assert_raise( RuntimeError ) { 
      ArgumentManager.add_option(
        [ 'd' ],
        :help => 0
      )
    }
  end
  
  # invalid bind -- not string
  def test_add_option02c
    assert_raise( RuntimeError ) { 
      ArgumentManager.add_option(
        [ 'e' ],
        :bind => :bind
      )
    }
  end
  
  # invalid bind -- not valid ruby variable name
  def test_add_option02d
    assert_raise( RuntimeError ) { 
      ArgumentManager.add_option(
        [ 'f' ],
        :bind => 'boolean opt'
      )
    }
  end
  
  # valid optional integer with optional parameter
  def test_add_option03a
    assert_nothing_raised( Exception ) { 
      ArgumentManager.add_option(
        [ 'i' ],
        :type => :integer,
        :df_int => 0
      )
    }
  end
  
  # valid optional integer with mandatory parameter
  def test_add_option03b
    assert_nothing_raised( Exception ) { 
      ArgumentManager.add_option(
        [ 'j' ],
        :type => :integer
      )
    }
  end
  
  # valid mandatory integer with optional parameter
  def test_add_option03c
    assert_nothing_raised( Exception ) {
      ArgumentManager.add_option(
        [ 'k' ],
        :type => :integer,
        :mandatory => true,
        :df_int => 0
      )
    }
  end
  
  # valid mandatory integer with mandatory parameter
  def test_add_option03d
    assert_nothing_raised( Exception ) {
      ArgumentManager.add_option(
        [ 'l' ],
        :type => :integer,
        :mandatory => true
      )
    }
  end
  
  # valid bounds
  def test_add_option03e
    assert_nothing_raised( Exception ) { 
      ArgumentManager.add_option(
        [ 'm' ],
        :type => :integer,
        :min => -1,
        :max => +1
      )
    }    
  end
  
  
  # invalid bounds -- min > max
  def test_add_option03f
    assert_raise( RuntimeError ) { 
      ArgumentManager.add_option(
        [ 'n' ],
        :type => :integer,
        :min => +1,
        :max => -1
      )
    }    
  end
  
  # valid default integer
  def test_add_option03g
    assert_nothing_raised { 
      ArgumentManager.add_option(
        [ 'o' ],
        :type => :integer,
        :max => 5,
        :df_int => 5
      )
    }
  end
  
  # invalid default integer -- out of bounds
  def test_add_option03h
    assert_raise( RuntimeError ) { 
      ArgumentManager.add_option(
        [ 'p' ],
        :type => :integer,
        :min => -1,
        :max => +1,
        :df_int => 5
      )
    }
  end
  
  # valid optional string with optional parameter
  def test_add_option04a
    assert_nothing_raised {
      ArgumentManager.add_option(
        [ 's' ],
        :type => :string,
        :df_str => 'foo'
      )
    }
  end
  
  # valid optional string with mandatory parameter
  def test_add_option04b
    assert_nothing_raised {
      ArgumentManager.add_option(
        [ 't' ],
        :type => :string
      )
    }
  end
  
  # valid mandatory string with optional parameter
  def test_add_option04c
    assert_nothing_raised {
      ArgumentManager.add_option(
        [ 'u' ],
        :type => :string,
        :mandatory => true,
        :df_str => 'foo'
      )
    }
  end
  
  # valid mandatory string with mandatory parameter
  def test_add_option04d
    assert_nothing_raised {
      ArgumentManager.add_option(
        [ 'v' ],
        :type => :string,
        :mandatory => true
      )
    }
  end
  
  # valid domain
  def test_add_option04e
    assert_nothing_raised {
      ArgumentManager.add_option(
        [ 'w' ],
        :type => :string,
        :domain => ['foo', 'bar']
      )
    }
  end
  
  # invalid domain -- not strings
  def test_add_option04f
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
        [ 'x' ],
        :type => :string,
        :domain => 0
      )
    }
  end
  
  # invalid domain -- not unique strings
  def test_add_option04g
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
        [ 'y' ],
        :type => :string,
        :domain => ['foo', 'foo']
      )
    }
  end
  
  # invalid default -- not string
  def test_add_option04h
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
        [ 'z' ],
        :type => :string,
        :df_str => 0
      )
    }
  end
  
   # invalid default -- not from domain
  def test_add_option04i
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
        [ 'sa' ],
        :type => :string,
        :domain => ['foo', 'bar'],
        :df_str => 'baz'
      )
    }
  end

  # invalid type
  def test_add_option05
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
          [ 'hello_world' ],
          :type => 'hello world'
        )
    }
  end
  
  # invalid mandatory
  def test_add_option06
    assert_raise ( RuntimeError ) {
      ArgumentManager.add_option(
          [ 'hello_world' ],
          :mandatory => 'hello world'
        )
    }
  end
end
