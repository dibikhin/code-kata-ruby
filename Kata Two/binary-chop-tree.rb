require 'test/unit'

class Node
  attr_accessor :left, :item, :right
	
  def initialize(left, item, right)
    @left, @item, @right = left, item, right
  end

  def self.print(tree, indent)
    if not tree.nil?
      puts indent + tree.item[:value].to_s
      print tree.left, indent + "\\--"    
      print tree.right, indent + "\\--"
    end
  end
end

class Array
  def index
    i = -1
    self.map do |n| 
      i += 1
      { :index => i, :value => n }
    end
  end

  def to_tree
   if self.empty?
     nil
   else
     to_tree_iter(self, 0, self.count - 1) 
   end
  end
  
  private
  def to_tree_iter(array, buttom, top)
   if buttom > top
     nil
   else
     middle = (buttom + top) / 2
     item = array[middle]
     Node.new(
       to_tree_iter(array, buttom, middle -1), 
       item,
       to_tree_iter(array, middle + 1, top))
   end
  end
end

# binary chop tree 
class TestClass < Test::Unit::TestCase
  def chop(num, array)
    return -1 if array.empty?
    return chop_tree(num, array.index.to_tree)
  end    
  
  def chop_tree(num, tree)
    return -1 if tree.nil?
    
    middle = tree.item[:index]
    middle_num = tree.item[:value]

    case
    when middle_num == num
      middle
    when middle_num < num
      chop_tree(num, tree.right)
    when num < middle_num
      chop_tree(num, tree.left)
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
  end
end
