# 数を実装する
# @author Kembo
module MyNum
  # @abstract 数の基礎クラス
  class Numeric
    private_class_method :new
  end

  # 自然数のクラス
  class NaturalNumber < Numeric
    # @!attribute [r] pred
    #   @return [NaturalNumber, nil] その数の前者（0 の場合は nil）
    attr_reader :pred

    # @private
    def initialize(pred: nil)
      @pred = pred
    end

    @@Zero = new
    # @return [NaturalNumber]
    def self.Zero; @@Zero end
  end

  # 整数のクラス
  class Integer < Numeric
  end

  # @!group エイリアス
  N = NaturalNumber
  Z = Integer
end
