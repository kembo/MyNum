# 数を実装する
# @author Kembo
module MyNum
  # @abstract 数の基礎クラス
  class Numeric
    class << self
      alias_method :_new, :new
      private :new
    end
  end

  # 自然数
  class NaturalNumber < Numeric
    # @!attribute [r] pred
    #   @return [NaturalNumber, nil] その数の前者（0 の場合は nil）
    attr_reader :pred

    # @private
    def initialize(pred: nil)
      @pred = pred
      @succ = nil
    end

    # @return [NaturalNumber] その数の後者
    def succ
      @succ = NaturalNumber._new(pred: self) if @succ.nil?
      @succ
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
