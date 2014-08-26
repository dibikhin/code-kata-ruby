require 'minitest/autorun'
require './checkout'

class TestPrice < Minitest::Test

	# Item  Unit      Special
	# 		Price     Price
	# --------------------------
	# A     50       3 for 130
	# B     30       2 for 45
	# C     20
	# D     15

  RULES =
"---
A: !ruby/object:Rule
  sku: A
  unit_price: 50
  set_size: 3
  price_per_set: 130
B: !ruby/object:Rule
  sku: B
  unit_price: 30
  set_size: 2
  price_per_set: 45
C: !ruby/object:Rule
  sku: C
  unit_price: 20
D: !ruby/object:Rule
  sku: D
  unit_price: 15"
	
  def price(goods)
    co = CheckOut.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end