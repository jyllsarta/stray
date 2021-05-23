# pirikaからもらってきた代々伝わるSeededRandom
class SeededRandom
  attr_accessor :seed

  def initialize(seed)
    @x = 123456789
    @y = 362436069
    @z = 521288629
    @w = seed
    @seed = seed
    10000.times {self.next} # 初期値依存性を捨てるために最初の方の乱数値は捨てる
  end

  def next
    t = (@x ^ (@x << 11))
    t &= 0xFFFFFFFF # for emurating 32bit int
    @x = @y
    @y = @z
    @z = @w
    @w = (@w ^ (@w >> 19)) ^ (t ^ (t >> 8))
    @w
  end

  # rand_int(6) returns [0,1,2,3,4,5].example
  def rand_int(max)
    return 0 if max <= 0
    rand = self.next
    rand / (0xFFFFFFFF / max)
  end

  # select random one from array
  def sample(array)
    array[rand_int(array.length)]
  end
end
