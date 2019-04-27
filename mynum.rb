# 数を実装する
# @author Kembo
module MyNum
  # @abstract 数の基礎クラス
  class Numeric
    private_class_method :new
  end

  # 自然数のクラス
  class NaturalNumber < Numeric
  end

  # 整数のクラス
  class Integer < Numeric
  end

  # @!group エイリアス
  N = NaturalNumber
  Z = Integer
end
