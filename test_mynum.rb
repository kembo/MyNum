require 'test/unit'
require_relative 'mynum'

class TestMyNaturalNaumber < Test::Unit::TestCase
  include MyNum

  def test_cant_new; assert_raise { NaturalNumber.new } end
end