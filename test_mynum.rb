require 'test/unit'
require_relative 'mynum'

class TestNaturalNumber < Test::Unit::TestCase
  def test_cant_new; assert_raise { MyNum::N.new } end
  def test_zero
    assert_kind_of(MyNum::N, MyNum::N.Zero)
    assert_nil(MyNum::N.Zero.pred)
  end

  @@Zero = MyNum::N.Zero
  def test_succ_and_pred
    assert_kind_of(MyNum::N, @@Zero.succ)
    assert_equal(@@Zero.succ, @@Zero.succ)
    assert_equal(@@Zero, @@Zero.succ.pred)
  end
end
