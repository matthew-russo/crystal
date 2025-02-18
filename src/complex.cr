# A complex number is a number represented in the form a + bi. In this form,
# a and b are real numbers, and i is an imaginary number such as i² = -1.
# The a is the real part of the number, and the b is the imaginary part of
# the number.
#
# ```
# require "complex"
#
# Complex.new(1, 0)   # => 1.0 + 0.0i
# Complex.new(5, -12) # => 5.0 - 12.0i
#
# 1.to_c # => 1.0 + 0.0i
# 1.i    # => 0.0 + 1.0i
# ```
struct Complex
  # Returns the real part.
  getter real : Float64

  # Returns the imaginary part.
  getter imag : Float64

  def initialize(real : Number, imag : Number = 0)
    @real = real.to_f
    @imag = imag.to_f
  end

  def self.new(c : Complex)
    c
  end

  # Determines whether `self` equals *other* or not.
  def ==(other : Complex)
    @real == other.real && @imag == other.imag
  end

  # :ditto:
  def ==(other : Number)
    self == other.to_c
  end

  # :ditto:
  def ==(other)
    false
  end

  # Returns `self`.
  def to_c
    self
  end

  # Returns the value as a `Float64` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_f64 : Float64
    unless @imag.zero?
      raise Exception.new "Complex number with non-zero imaginary part can't be converted to real number"
    end
    @real
  end

  # Returns the value as a `Float32` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_f32 : Float32
    to_f64.to_f32
  end

  # See `#to_f64`.
  def to_f
    to_f64
  end

  # Returns the value as an `Int64` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_i64 : Int64
    to_f64.to_i64
  end

  delegate to_i32, to_i16, to_i8, to: to_i64

  # Returns the value as an `UInt64` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_u64 : UInt64
    to_f64.to_u64
  end

  delegate to_u32, to_u16, to_u8, to: to_u64

  # See `#to_i32`.
  def to_i
    to_i32
  end

  # Writes this complex object to an *io*.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).to_s # => "42.0 + 2.0i"
  # ```
  def to_s(io : IO) : Nil
    io << @real
    io << (@imag >= 0 ? " + " : " - ")
    io << @imag.abs
    io << 'i'
  end

  # Writes this complex object to an *io*, surrounded by parentheses.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).inspect # => "(42.0 + 2.0i)"
  # ```
  def inspect(io : IO) : Nil
    io << '('
    to_s(io)
    io << ')'
  end

  # Returns the absolute value of this complex number in a
  # number form, using the Pythagorean theorem.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).abs  # => 42.04759208325728
  # Complex.new(-42, 2).abs # => 42.04759208325728
  # ```
  def abs : Float64
    Math.hypot(@real, @imag)
  end

  # Returns the square of absolute value in a number form.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).abs2 # => 1768
  # ```
  def abs2 : Float64
    @real * @real + @imag * @imag
  end

  def sign : Complex
    self / abs
  end

  # Returns the phase of `self`.
  def phase : Float64
    Math.atan2(@imag, @real)
  end

  # Returns a `Tuple` with the `abs` value and the `phase`.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).polar # => {42.047592083257278, 0.047583103276983396}
  # ```
  def polar : {Float64, Float64}
    {abs, phase}
  end

  # Returns the conjugate of `self`.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).conj  # => 42.0 - 2.0i
  # Complex.new(42, -2).conj # => 42.0 + 2.0i
  # ```
  def conj : Complex
    Complex.new(@real, -@imag)
  end

  # Returns the inverse of `self`.
  def inv : Complex
    conj / abs2
  end

  # Returns `self`.
  def + : Complex
    self
  end

  # Adds the value of `self` to *other*.
  def +(other : Complex) : Complex
    Complex.new(@real + other.real, @imag + other.imag)
  end

  # :ditto:
  def +(other : Number) : Complex
    Complex.new(@real + other, @imag)
  end

  # Returns the opposite of `self`.
  def - : Complex
    Complex.new(-@real, -@imag)
  end

  # Removes the value of *other* from `self`.
  def -(other : Complex) : Complex
    Complex.new(@real - other.real, @imag - other.imag)
  end

  # :ditto:
  def -(other : Number) : Complex
    Complex.new(@real - other, @imag)
  end

  # Multiplies `self` by *other*.
  def *(other : Complex) : Complex
    Complex.new(@real * other.real - @imag * other.imag, @real * other.imag + @imag * other.real)
  end

  # :ditto:
  def *(other : Number) : Complex
    Complex.new(@real * other, @imag * other)
  end

  # Divides `self` by *other*.
  def /(other : Complex) : Complex
    if other.real <= other.imag
      r = other.real / other.imag
      d = other.imag + r * other.real
      Complex.new((@real * r + @imag) / d, (@imag * r - @real) / d)
    else
      r = other.imag / other.real
      d = other.real + r * other.imag
      Complex.new((@real + @imag * r) / d, (@imag - @real * r) / d)
    end
  end

  # :ditto:
  def /(other : Number) : Complex
    Complex.new(@real / other, @imag / other)
  end

  def clone
    self
  end

  # See `Object#hash(hasher)`
  def hash(hasher)
    hasher = real.hash(hasher)
    hasher = imag.hash(hasher) unless imag.zero?
    hasher
  end

  # Returns the number `0` in complex form.
  def self.zero : Complex
    new 0, 0
  end

  # Returns `true` if the complex number is zero.
  # This means the real and imaginary are both zero.
  #
  # ```
  # require "complex"
  #
  # Complex.new(0, 0).zero? # => true
  # Complex.new(1, 0).zero? # => false
  # Complex.new(0, 1).zero? # => false
  # ````
  def zero? : Bool
    @real == 0 && @imag == 0
  end

  def self.additive_identity : self
    zero
  end

  def multiplicative_identity : self
    new 1, 0
  end

  # Rounds to the nearest *digits*.
  def round(digits = 0) : Complex
    Complex.new(@real.round(digits), @imag.round(digits))
  end
end

struct Number
  def to_c : Complex
    Complex.new(self, 0)
  end

  def i : Complex
    Complex.new(0, self)
  end

  def ==(other : Complex)
    to_c == other
  end

  def cis : Complex
    Complex.new(Math.cos(self), Math.sin(self))
  end

  def +(other : Complex) : Complex
    Complex.new(self + other.real, other.imag)
  end

  def -(other : Complex) : Complex
    Complex.new(self - other.real, -other.imag)
  end

  def *(other : Complex) : Complex
    Complex.new(self * other.real, self * other.imag)
  end

  def /(other : Complex) : Complex
    self * other.inv
  end
end

module Math
  # Calculates the exponential of *value*.
  #
  # ```
  # require "complex"
  #
  # Math.exp(4 + 2.i) # => -22.720847417619233 + 49.645957334580565i
  # ```
  def exp(value : Complex) : Complex
    r = exp(value.real)
    Complex.new(r * cos(value.imag), r * sin(value.imag))
  end

  # Calculates the natural logarithm of *value*.
  #
  # ```
  # require "complex"
  #
  # Math.log(4 + 2.i) # => 1.4978661367769956 + 0.4636476090008061i
  # ```
  def log(value : Complex) : Complex
    Complex.new(Math.log(value.abs), value.phase)
  end

  # Calculates the logarithm of *value* to base 2.
  #
  # ```
  # require "complex"
  #
  # Math.log2(4 + 2.i) # => 2.1609640474436813 + 0.6689021062254881i
  # ```
  def log2(value : Complex) : Complex
    log(value) / LOG2
  end

  # Calculates the logarithm of *value* to base 10.
  #
  # ```
  # require "complex"
  #
  # Math.log10(4 + 2.i) # => 0.6505149978319906 + 0.20135959813668655i
  # ```
  def log10(value : Complex) : Complex
    log(value) / LOG10
  end

  # Calculates the square root of *value*.
  # Inspired by the [following blog post](https://pavpanchekha.com/blog/casio-mathjs.html) of Pavel Panchekha on floating point precision.
  #
  # ```
  # require "complex"
  #
  # Math.sqrt(4 + 2.i) # => 2.0581710272714924 + 0.48586827175664565i
  # ```
  #
  # Although the imaginary number is defined as i = sqrt(-1),
  # calling `Math.sqrt` with a negative number will return `-NaN`.
  # To obtain the result in the complex plane, `Math.sqrt` must
  # be called with a complex number.
  #
  # ```
  # Math.sqrt(-1.0)         # => -NaN
  # Math.sqrt(-1.0 + 0.0.i) # => 0.0 + 1.0i
  # ```
  def sqrt(value : Complex) : Complex
    r = value.abs

    re = if value.real >= 0
           0.5 * sqrt(2.0 * (r + value.real))
         else
           value.imag.abs / sqrt(2.0 * (r - value.real))
         end

    im = if value.real <= 0
           0.5 * sqrt(2.0 * (r - value.real))
         else
           value.imag.abs / sqrt(2.0 * (r + value.real))
         end

    Complex.new(re, value.imag >= 0 ? im : -im)
  end
end
