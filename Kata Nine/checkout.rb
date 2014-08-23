class SpecialPrice
	attr_accessor :set_size, :price_per_set
end

class Rule
	attr_accessor :sku, :unit_price, :special_price
end

class CheckOut
	attr_reader :total

	def initialize(rules)
		@rules = parse_rules(rules)
	end
	
	def scan(sku)
		@sku_list << sku
		@total = compute_total(@rules, @sku_list)
	end
	
	private
	def parse_rules(rules)
		rule_a, rule_a_spec_price = Rule.new, SpecialPrice.new
		rule_a_spec_price.set_size, rule_a_spec_price.price_per_set = 3, 130
		rule_a.sku, rule_a.unit_price, rule_a.special_price = 'A', 50, rule_a_spec_price

		rule_b, rule_b_spec_price = Rule.new, SpecialPrice.new
		rule_b_spec_price.set_size, rule_b_spec_price.price_per_set = 2, 45
		rule_b.sku, rule_b.unit_price, rule_b.special_price = 'B', 30, rule_b_spec_price

		rule_с = Rule.new
		rule_с.sku, rule_с.unit_price = 'C', 20

		rule_d = Rule.new
		rule_d.sku, rule_d.unit_price = 'D', 15

		[rule_a, rule_b, rule_c, rule_d]
	end
end

# Item  Unit      Special
# 		Price     Price
# --------------------------
# A     50       3 for 130
# B     30       2 for 45
# C     20
# D     15