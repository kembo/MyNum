require 'test/unit'
require_relative 'mynum'

class TestMyNaturalNaumber < Test::Unit::TestCase
  def test_cant_new; assert_raise { MyNum::NaturalNumber.new } end
  def test_zero
    assert_kind_of(MyNum::NaturalNumber, MyNum::NaturalNumber.Zero)
    assert_nil(MyNum::NaturalNumber.Zero.pred)
  end
end