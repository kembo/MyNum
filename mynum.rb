# 数を実装する
# @author Kembo
module MyNum
  # @abstract 数の基礎クラス
  class Numeric
    private_class_method :new
  end

  # 自然数
  # @!attribute [r] pred
  #   @return [MyNum::NaturalNumber, nil] その数の前者（0 の場合は nil）
  class NaturalNumber < Numeric
    attr_reader :pred
    class << self
      alias_method :_new, :new
      public :_new

      # 普通の Integer から MyNum::NaturalNumber に変換する
      # @param [::Integer] num 0以上の整数
      # @return [MyNum::NaturalNumber] num と対応する自然数
      # @raise [ArgumentError] 負の数が代入されたときの例外
      def [](num)
        raise TypeError.new("num(#{num.class})") unless num.kind_of?(::Integer)
        raise ArgumentError.new('num is negative.') if num < 0
        (0...num).inject(@@Zero){|n,_| n.succ }
      end
    end

    # @private
    def initialize(pred: nil)
      @pred = pred
      @succ = nil
    end
    # @return [MyNum::NaturalNumber] その数の後者
    def succ
      @succ = NaturalNumber._new(pred: self) if @succ.nil?
      @succ
    end
    @@Zero = new
    # @return [MyNum::NaturalNumber]
    def self.Zero; @@Zero end
    @@One = @@Zero.succ
    # @return [MyNum::NaturalNumber]
    def self.One; @@One end

    DECA = self[10]
    # 文字列への変換
    # @param [MyNum::NaturalNumber] base 基数
    # @return [String] 数値の文字列表現
    def to_s(base=DECA)
      digits = [self]
      until digits.first < base
        n = digits.shift
        digits = n.divmod(base) + digits
      end
      digits.map(&:to_char).join('')
    end
    # アンダーバーで囲った通常の Numeric と差別化した文字列を返す
    # @return [String] 数値の文字列表現
    def inspect; '_'+to_s+'_' end
    # @private
    # 一桁前提で文字への変換
    # @raise [RangeError] 0-9, a-z で間に合わなかった場合
    def to_char
      return @char if instance_variable_defined?(:@char)
      @char = case self
        when @@Zero
          '0'
        when DECA
          'a'
        else
          self.pred.to_char.succ
        end
      raise RangeError unless ('0'..'9').include?(@char) or ('a'..'z').include?(@char)
      @char
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
  N = NaturalNumber

  # 整数のクラス
  # @!attribute [r] minuend
  #   @return [MyNum::NaturalNumber] 引かれる数
  # @!attribute [r] subtrahend
  #   @return [MyNum::NaturalNumber] 引く数
  class Integer < Numeric
    attr_reader :minuend, :subtrahend
    # @type [{Symbol=>{MyNum::NaturalNumber=>MyNum::Integer}}]
    @@instances = {pos: {}, neg: {}}
    class << self
      # @overload [](minuend, subtrahend)
      #   整数のインスタンスを返す
      #   @param [MyNum::NaturalNumber] minuend 引かれる数
      #   @param [MyNum::NaturalNumber] subtrahend 引く数
      #   @return [MyNum::Integer]
      # @overload [](value)
      #   普通の Integer から MyNum::Integer に変換する
      #   @param [::Integer] value
      #   @return [MyNum::Integer]
      def [](m, s=nil)
        if s.nil?
          raise TypeError.new("value: #{m.class}") unless m.kind_of?(::Integer)
        elsif !(m.kind_of?(NaturalNumber) and s.kind_of?(NaturalNumber))
          raise TypeError.new("(m: #{m.class}, s: #{s.class})")
        end
        if s.pred.nil?
          @@instances[:pos][m] = new(m,s) unless @@instances[:pos].has_key?(m)
          return @@instances[:pos][m]
        elsif m.pred.nil?
          @@instances[:neg][s] = new(m,s) unless @@instances[:neg].has_key?(s)
          return @@instances[:neg][s]
        end
        self[m.pred, s.pred]
      end
      # @private
      def conv(val)
        if val >= 0
          self[ N[val], N.Zero ]
        else
          self[ N.Zero, N[val] ]
        end
      end
    end
    # @private
    def initialize(m, s)
      @minuend = m
      @subtrahend = s
    end
    @@Zero = self[N.Zero, N.Zero]
    # @return [MyNum::Integer]
    def self.Zero; @@Zero end
    @@One  = self[N.One, N.Zero]
    # @return [MyNum::Integer]
    def self.One; @@One end
  end
  Z = Integer
end
