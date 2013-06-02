require 'test/unit'

# binary chop: itarative version

class TestClass < Test::Unit::TestCase
  def chop(num, array)
    return -1 if array.empty?
   
    bottom, top, middle = 0, array.size - 1, nil
    
    while true
      return -1 if bottom > top    
      
      middle = (top + bottom) / 2
      middle_num = array[middle]
      
      return middle if middle_num == num
      bottom = middle + 1 if middle_num < num
      top = middle - 1 if num < middle_num      
    end
  end
    
  def test_chop
    assert_equal(-1, chop(3, []))
    assert_equal(-1, chop(3, [1]))
    assert_equal(-1, chop(3, [4]))
    assert_equal(0,  chop(1, [1]))
    
    assert_equal(0,  chop(1, [1, 3]))
    assert_equal(1,  chop(3, [1, 3]))
    assert_equal(-1, chop(4, [1, 3]))
    assert_equal(-1, chop(0, [1, 3]))
    
    assert_equal(0,  chop(1, [1, 3, 5]))
    assert_equal(1,  chop(3, [1, 3, 5]))
    assert_equal(2,  chop(5, [1, 3, 5]))
    assert_equal(-1, chop(0, [1, 3, 5]))
    assert_equal(-1, chop(2, [1, 3, 5]))
    assert_equal(-1, chop(4, [1, 3, 5]))
    assert_equal(-1, chop(6, [1, 3, 5]))
    
    assert_equal(0,  chop(1, [1, 3, 5, 7]))
    assert_equal(1,  chop(3, [1, 3, 5, 7]))
    assert_equal(2,  chop(5, [1, 3, 5, 7]))
    assert_equal(3,  chop(7, [1, 3, 5, 7]))
    assert_equal(-1, chop(0, [1, 3, 5, 7]))
    assert_equal(-1, chop(2, [1, 3, 5, 7]))
    assert_equal(-1, chop(4, [1, 3, 5, 7]))
    assert_equal(-1, chop(6, [1, 3, 5, 7]))
    assert_equal(-1, chop(8, [1, 3, 5, 7]))
    
    assert_equal(-1, chop(8, [1, 3, 5, 7, 9]))
    assert_equal(-1, chop(8, [1, 3, 5, 7, 9, 11]))
    assert_equal(-1, chop(10, [1, 3, 5, 7, 9, 11]))
    assert_equal(-1, chop(12, [1, 3, 5, 7, 9, 11]))
    assert_equal(-1, chop(6, [1, 3, 5, 7, 9, 11]))
    
    assert_equal(-1, chop(4, [1, 3, 5, 7, 9, 11, 13]))
#    assert_equal(-1, chop(10_000_000, (0..9999999).to_a.select { |a| a % 2 == 1 }))
  end
end
