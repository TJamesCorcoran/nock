# turn a string with *,/,+ etc into an array
def parse(str)

end


YES = 0
NO  = 1

def str_to_tree(str)
  arr = []
  str.scan(/\+|\=|\?|\/|\*|\[|\]|\d+/).each do |token|
    
  end
end

def max_depth(arr)
  ret = arr.is_a?(Array) ?  [max_depth(arr[0]), max_depth(arr[1])].max + 1 : 1
  puts "arr = #{arr}; #{ret}"
  ret 
end

def pp(arr)
  depth = max_depth(arr)
  space = 128
  1.up_to(8) do |depth|
    space = space / 2
    min = 2 ** (depth - 1) 
    max = (2 ** depth) - 1
    min.upto(max) { |axis| 
  end

end

# normalize with brackets grouping to right
#   6  ::    [a b c]          [a [b c]]
def norm(arr)
  return arr unless arr.is_a?(Array)
  while arr.size > 2
    size = arr.size
    arr[size - 2] = [ arr[size - 2], arr.pop ]
  end
  arr = arr.map { |x| norm(x)   } 
end

# ? operator
#   8  ::    ?[a b]           0
#   9  ::    ?a               1
def wut(arr)
  arr.is_a?(Array) ? YES : NO
end

# + operator
#   10 ::    +[a b]           +[a b]
#   11 ::    +a               1 + a
def lus(atom)
  raise "not an atom" unless atom.is_a?(Fixnum)
  atom + 1
end

# = operator
#   12 ::    =[a a]           0
#   13 ::    =[a b]           1
#   14 ::    =a               =a
def tis(arr)
  raise "not pair" unless arr.is_a?(Array) && arr.size == 2
  ( arr[0] == arr[1] ) ? YES : NO
end

# / operator
#   16 ::    /[1 a]           a
#   17 ::    /[2 a b]         a
#   18 ::    /[3 a b]         b
#   19 ::    /[(a + a) b]     /[2 /[a b]]
#   20 ::    /[(a + a + 1) b] /[3 /[a b]]
#   21 ::    /a               /a
def slot(axis, arr, allow_error = true)
  puts "slot: axis = #{axis}, arr = #{arr}" # NOTFORCHECKIN
  
  raise "axis on atom" unless arr.is_a?(Array)
  return arr if axis == 1
  return arr[0] if axis == 2
  return arr[1] if axis == 3
  return slot(2, slot(axis/2, arr))   if (axis %2) == 0
  return slot(3, slot(axis/2, arr))
end


def nock(arr)

  puts "nocking #{arr.inspect}" # NOTFORCHECKIN

  # 39 ::    *a               *a
  raise "error: nocking an atom" unless arr.is_a?(Array)

  oper = slot(4, arr)
  a    = slot(2, arr)
  b    = slot(5, arr)

  #   23 ::    *[a [b c] d]     [*[a b c] *[a d]]
  #             [a [[b c] d]]
  if oper.is_a?(Array)
    puts "rule 23"
    return  [ nock( [ a, [b, c]]), nock( [a, d]) ] 
  end


  case oper
    #  25 ::    *[a 0 b]         /[b a]
    #           *[a [0 b]]
    when 0 then
    puts "rule 25"
    slot(b,a )

    #  26 ::    *[a 1 b]         b
    #           *[a [1 b]] 
    when 1 then 
    puts "rule 26"
    b

    
    # 27 ::    *[a 2 b c]       *[*[a b] *[a c]]
    #          *[a [2  [b c]]] 
    when 2 then       
    puts "rule 27"
    b_prime = slot(2, b)
    c       = slot(3,b)
    nock( [ nock([a, b_primce]), nock([a, c]) ])
           
            
    # 28 ::    *[a 3 b]         ?*[a b]
    #
    when 3 then 
    puts "rule 28"
    wut(nock([a, b]))

    # 29 ::    *[a 4 b]         +*[a b]
    #
    when 4 then 
    puts "rule 29"
    lus(nock([a, b]))

    # 30 ::    *[a 5 b]         =*[a b]
    #
    when 5 then 
    puts "rule 30"
    tis(nock([a, b]))

    # 32 ::  *[a 6 b c d]     *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
    #        *[a [6 [b [c d]]]]
    #               ^^^^^^^^^^
    when 6 then
    puts "rule 32"
    b_prime = slot(2, b)
    c = slot(6,b)
    d = slot(7,b)
    nock( norm([a, 2, [0, 1], 2, [1, c, d], [1, 0], 2, [1, 2, 3], [1, 0], 4, 4, b]) )
      
    # 33 ::    *[a 7 b c]       *[a 2 b 1 c]
    #           [a 7 [b c]]
    when 7 then
    puts "rule 33"
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 2, b_prime, 1, c]))


    # 34 ::    *[a 8 b c]       *[a 7 [[7 [0 1] b] 0 1] c]
    #
    when 8 then
    puts "rule 34"
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 7, [[7, [0, 1], b_prime], 0, 1], c]))

    # 35 ::    *[a 9 b c]       *[a 7 c 2 [0 1] 0 b]
    #           [a [9 [b c ]]
    when 9 then
    puts "rule 35"
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 7, c, 2, [0, 1], 0, b_prime]))

    when 10 then
    if wut(slot(2,b)) == TRUE
      # 36 ::    *[a 10 [b c] d]  *[a 8 c 7 [0 3] d]
      #           [a 10 [[b c] d]]
      #

      puts "rule 36"
      b_prime = slot(4, b)
      c       = slot(5, b)
      d       = slot(3, b)
      c = slot(3,b)
      nock( norm ([a, 8, c, 7, [0, 3], d]))
    else
      # 37 ::    *[a 10 b c]      *[a c]
      #           [a 10 [b c]]
      puts "rule 37"
      b_prime = slot(2, b)
      c       = slot(3, b)
      nock( norm ([a, 10, [b, c]]))
    end
    else
      raise "error: unknown opcode #{oper.inspect}" 
    end

end

@@errors = []
def assert_equal(gold, actual, str)
  bool = (gold == actual)
  if bool 
    print "."
  else
    print "X"
    @@errors << str + ": expected #{gold} ; got #{actual} - #{caller[0]}" 
  end
end

def test
  @@errors = []  

  # 8, 9
  assert_equal(0, wut([1, 2]), "8a")
  assert_equal(1, wut(1), "8b")
  assert_equal(0, wut(norm([1, 2, 3, 4, 5, 6, 7, 8])), "8c")

  # 10
  thrown = false
  begin
    lus([1, 2])
  rescue
    thrown = true
  end
  assert_equal(true, thrown, "10")

  # 11
  assert_equal(1, lus(0), "11a")
  assert_equal(2, lus(lus(0)), "11b")
  assert_equal(3, lus(lus(lus(0))), "11c")

  # 12, 13, 14
  assert_equal(0, tis([12, 12]), "12")
  assert_equal(1, tis([0, 666]), "13")
  thrown = false
  begin
    tis(12)
  rescue
    thrown = true
  end
  assert_equal(true, thrown, "14")
  
  # 16 - 21
  simple = [[4,5], [6,7]]
  assert_equal(simple, slot(1, simple), "16")
  assert_equal([4,5], slot(2, simple), "17")
  assert_equal([6,7], slot(3, simple), "18")
  assert_equal(4, slot(4, simple), "19a")
  assert_equal(5, slot(5, simple), "20a")
  assert_equal(6, slot(6, simple), "19b")
  assert_equal(7, slot(7, simple), "20b")

  complex =    norm([[[8, 9], [10, 11]], [12, 13], 14, 30, 31])
  [8, 9, 10, 11, 12, 13, 14, 30, 31].each do |axis|
    puts "=== #{axis}" # NOTFORCHECKIN
    assert_equal(axis, slot(axis, complex), "complex #{axis}")
  end


  thrown = false
  begin
    slot(1, 1)
  rescue
    thrown = true
  end
  assert_equal(true, thrown, "21")
  
  
  #   23 ::    *[a [b c] d]     [*[a b c] *[a d]]
  #             [a [[b c] d]]
  
  # NOTFORCHECKIN
  input = norm([[19, 42], [0, 3], 0, 2])
  pp(input)
  ret = nock()
  puts "ret = #{ret.inspect}" 

  puts "\n\n\n\n#{@@errors.size} errors"
  puts "------"
  @@errors.each { |e| puts e }
  puts "n/a" if @@errors.empty?
end
