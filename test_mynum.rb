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

  @@nums = (1..4).inject({0 => @@Zero}){|h, i| h[i] = h[i-1].succ; h }
  @@nums[100] = (5..100).inject(@@nums[4]){|n, i| n.succ }
  data('1 + 0 = 1' => [@@nums[1], @@nums[0], @@nums[1]],
       '0 + 1 = 1' => [@@nums[0], @@nums[1], @@nums[1]],
       '1 + 2 = 3' => [@@nums[1], @@nums[2], @@nums[3]],
       '100 + 2 = 102' => [@@nums[100], @@nums[2], @@nums[100].succ.succ],
       '2 + 100 = 102' => [@@nums[2], @@nums[100], @@nums[100].succ.succ] )
  def test_add(data)
    assert_equal(data[2], data[0] + data[1])
  end
end
