require 'ArgumentManager'
require 'test/unit'

class TestSetDefaults < Test::Unit::TestCase
  
  # valid setting
  def test_set_defaults01
    assert_nothing_raised {
      ArgumentManager.set_defaults(
        {
          :type => :integer,
          :mandatory => true,
          :min => 0,
          :max => 10,
          :df_int => 0,
          :domain => [ 'foo', 'bar' ],
          :df_str => 'bar',
          :help => 'RTFM',
          :bind => 'ultracoolvariable'
        }
      )
    }
  end
  
  # invalid type  
  def test_set_defaults02
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :type => 0
        }
      )
    }
  end
  
  # invalid mandatory
  def test_set_defaults03
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :mandatory => 0
        }
      )
    }
  end

  # invalid min -- not integral
  def test_set_defaults04a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :min => 'i am an invalid min'
        }
      )
    }
  end
  
  # invalid min -- greater than default max
  def test_set_defaults04b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :min => 20
        }
      )
    }    
  end
  
  # invalid max -- not integral
  def test_set_defaults05a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :max => 'i am an invalid max'
        }
      )
    }    
  end
  
  # invalid min -- lesser than default min
  def test_set_defaults05b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :max => -10
        }
      )
    }    
  end
  
  # valid new min & max
  def test_set_defaults06
    assert_nothing_raised( Exception ) {
      ArgumentManager.set_defaults(
        {
          :min => 20,
          :max => 30
        }
      )
    }    
  end
  
  # invalid default integer -- not integral
  def test_set_defaults07a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :df_int => 'i am an invalid default integer'
        }
      )
    }    
  end

  # invalid default integer -- out of bounds
  def test_set_defaults07b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :df_int => 999
        }
      )
    }    
  end
  
  # invalid domain -- not array of strings
  def test_set_defaults08a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :domain => 'i am an invalid domain'
        }
      )
    }    
  end
  
   # invalid domain -- not array of unique strings
  def test_set_defaults08b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :domain => [ 'foo', 'foo' ]
        }
      )
    }    
  end
  
  # invalid default string -- not string
  def test_set_defaults09a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :df_str => 0
        }
      )
    }    
  end

  # invalid default string -- not from domain
  def test_set_defaults09b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :df_str => 'baz'
        }
      )
    }    
  end

  # invalid help -- not string
  def test_set_defaults10
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :help => 0
        }
      )
    }    
  end
  
  # invalid bind -- not string
  def test_set_defaults11a
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :bind => 0
        }
      )
    }    
  end
  
  # invalid bind -- not valid ruby variable name
  def test_set_defaults11b
    assert_raise ( RuntimeError ) {
      ArgumentManager.set_defaults(
        {
          :bind => 'i am an invalid ruby variable'
        }
      )
    }    
  end
end
