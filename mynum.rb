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
    @@Zero = new
    # @return [MyNum::NaturalNumber]
    def self.Zero; @@Zero end

    # @private
    def initialize(pred: nil)
      @pred = pred
      @succ = nil
    end
    # @!attribute [r] pred
    #   @return [MyNum::NaturalNumber, nil] その数の前者（0 の場合は nil）
    attr_reader :pred
    # @return [MyNum::NaturalNumber] その数の後者
    def succ
      @succ = NaturalNumber._new(pred: self) if @succ.nil?
      @succ
    end

    # @param [MyNum::NaturalNumber] other
    # @return [true, false] other より大きいかどうか
    def >(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      return false if self == other or self == @@Zero
      return true if other == @@Zero
      self.pred > other.pred
    end
    # @param [MyNum::NaturalNumber] other
    # @return [true, false] other 以上かどうか
    def >=(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      if self == other then true
      else (self > other)
      end
    end
    # @param [MyNum::NaturalNumber] other
    # @return [true, false] other より小さいかどうか
    def <(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      other > self
    end
    # @param [MyNum::NaturalNumber] other
    # @return [true, false] other 以下かどうか
    def <=(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      if self == other then true
      else (other > self)
      end
    end

    # @param [MyNum::NaturalNumber] other
    # @return [MyNum::NaturalNumber] 和
    def +(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      return self if other == @@Zero
      (self + other.pred).succ
    end
    # @param [MyNum::NaturalNumber] other
    # @return [MyNum::NaturalNumber] 差
    def -(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      return self if other == @@Zero
      raise ArgumentError if self == @@Zero
      self.pred - other.pred
    end
    # @param [MyNum::NaturalNumber] other
    # @return [MyNum::NaturalNumber] 積
    def *(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      return @@Zero if other == @@Zero
      (self * other.pred) + self
    end
    # @param [MyNum::NaturalNumber] other
    # @return [Array<MyNum::NaturalNumber>] 商と余りの配列
    def divmod(other)
      raise TypeError unless other.kind_of?(NaturalNumber)
      raise ZeroDivisionError if other == @@Zero
      quo = @@Zero
      rem = self
      until rem < other
        quo  = quo.succ
        rem -= other
      end
      [quo, rem]
    end
    # @param [MyNum::NaturalNumber] other
    # @return [Array<MyNum::NaturalNumber>] 商
    def /(other); divmod(other).first end
    # @param [MyNum::NaturalNumber] other
    # @return [Array<MyNum::NaturalNumber>] 余り
    def %(other); divmod(other).last end
  end

  # 整数のクラス
  class Integer < Numeric
  end

  # @!group エイリアス
  N = NaturalNumber
  Z = Integer
end
