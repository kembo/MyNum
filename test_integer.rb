require 'test/unit'
require_relative 'mynum'

class TestInteger < Test::Unit::TestCase
  def test_cant_new; assert_raise { MyNum::Z.new } end

  N = MyNum::N
  Z = MyNum::Z
  def test_zero
    zero = MyNum::Integer.Zero
    assert_equal(N[0], zero.minuend)
    assert_equal(N[0], zero.subtrahend)
  end
  def test_one
    one = MyNum::Integer.One
    assert_equal(N[1], one.minuend)
    assert_equal(N[0], one.subtrahend)
  end
  data('<2,2> => <0,0>' => [[N[2], N[2]], [N[0], N[0]]],
       '<4,1> => <3,0>' => [[N[4], N[1]], [N[3], N[0]]],
       '<1,4> => <0,3>' => [[N[1], N[4]], [N[0], N[3]]],
       '<100,102> => <0,2>' => [[N[100], N[102]], [N[0], N[2]]] )
  def test_create(data)
    act, exp = data
    act = MyNum::Integer[*act]
    assert_equal(exp[0], act.minuend)
    assert_equal(exp[1], act.subtrahend)
  end
  def test_create_dup
    n1 = MyNum::Integer[N[1], N[3]]
    n2 = MyNum::Integer[N[2], N[4]]
    assert_equal(n1.object_id, n2.object_id)
  end
  data('10 => <10,0>' => [10, [N[10], N[0]]],
       '-100 => <0,100>' => [-100, [N[0], N[100]]] )
  def test_convert(data)
    act, exp = data
    act = MyNum::Integer[act]
    assert_equal(exp[0], act.minuend)
    assert_equal(exp[1], act.subtrahend)
  end
  data('float' => [-3.4, TypeError])
  def test_convert_error(data)
    act, err = data
    assert_raise(err){ MyNum::Integer[act] }
  end
end
