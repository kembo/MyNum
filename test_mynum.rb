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

  @@Nums = (1..4).inject({0 => @@Zero}){|h, i| h[i] = h[i-1].succ; h }
  @@Nums[100] = (5..100).inject(@@Nums[4]){|n, i| n.succ }
  @@Nums[101] = @@Nums[100].succ
  @@Nums[102] = @@Nums[101].succ

  sub_test_case('comparison') do
    data(  '1 is gather than 0'   => [@@Nums[1], @@Nums[0], true],
           '4 is gather than 2'   => [@@Nums[4], @@Nums[2], true],
         '102 is gather than 100' => [@@Nums[102], @@Nums[100], true],
           '0 is not gather than 1'   => [@@Nums[0], @@Nums[1], false],
           '4 is not gather than 4'   => [@@Nums[4], @@Nums[4], false],
         '100 is not gather than 100' => [@@Nums[100], @@Nums[100], false],
         '100 is not gather than 102' => [@@Nums[100], @@Nums[102], false] )
    def test_gather(data)
      arg1, arg2, result = data
      assert_equal(result, arg1 > arg2)
    end

    data(  '0 is less than 1'   => [@@Nums[0], @@Nums[1], true],
           '2 is less than 4'   => [@@Nums[2], @@Nums[4], true],
         '100 is less than 102' => [@@Nums[100], @@Nums[102], true],
           '1 is not less than 0'   => [@@Nums[1], @@Nums[0], false],
           '4 is not less than 4'   => [@@Nums[4], @@Nums[4], false],
         '100 is not less than 100' => [@@Nums[100], @@Nums[100], false],
         '102 is not less than 100' => [@@Nums[102], @@Nums[100], false] )
    def test_less(data)
      arg1, arg2, result = data
      assert_equal(result, arg1 < arg2)
    end

    data(  '0 is 0'   => [@@Nums[0], @@Nums[0], true],
           '4 is 4'   => [@@Nums[4], @@Nums[4], true],
         '100 is 100' => [@@Nums[100], @@Nums[100], true],
           '0 is not 4'   => [@@Nums[0], @@Nums[4], false],
           '4 is not 100' => [@@Nums[4], @@Nums[100], false],
         '100 is not 4'   => [@@Nums[100], @@Nums[4], false] )
    def test_equal(data)
      arg1, arg2, result = data
      assert_equal(result, arg1 == arg2)
    end
  end

  sub_test_case('calculation') do
    data('1 + 0 = 1' => [@@Nums[1], @@Nums[0], @@Nums[1]],
         '0 + 1 = 1' => [@@Nums[0], @@Nums[1], @@Nums[1]],
         '1 + 2 = 3' => [@@Nums[1], @@Nums[2], @@Nums[3]],
         '100 + 2 = 102' => [@@Nums[100], @@Nums[2], @@Nums[102]],
         '2 + 100 = 102' => [@@Nums[2], @@Nums[100], @@Nums[102]] )
    def test_add(data)
      arg1, arg2, result = data
      assert_equal(result, arg1 + arg2)
    end

    data(  '1 - 0 = 1'   => [@@Nums[1], @@Nums[0], @@Nums[1]],
           '4 - 4 = 0'   => [@@Nums[4], @@Nums[4], @@Nums[0]],
         '102 - 2 = 100' => [@@Nums[102], @@Nums[2], @@Nums[100]] )
    def test_sub(data)
      arg1, arg2, result = data
      assert_equal(result, arg1 - arg2)
    end

    data(  '"0 - 1" is error' => [@@Nums[0], @@Nums[1]],
           '"3 - 4" is error' => [@@Nums[3], @@Nums[4]],
         '"2 - 100" is error' => [@@Nums[2], @@Nums[100]] )
    def test_sub_error(data)
      arg1, arg2 = data
      assert_raise { arg1 - arg2 }
    end
  end

end
