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
		@total = 0
		@sku_list = ''
	end
	
	def scan(sku)
		@sku_list += sku
		@total = compute_total(@rules, @sku_list)
	end
	
	def compute_total(rules, sku_list)
		total = 0
		stats = @sku_list.chars.group_by(&:chr).map { |chr, all_chars| { chr => all_chars.size } }
		stats.each do |stat|
			stat.each do |sku, count|
				rule = @rules[sku]
				if !rule.special_price.nil?
					total += count / rule.special_price.set_size * rule.special_price.price_per_set
					total += count % rule.special_price.set_size * rule.unit_price
				else
					total += count * rule.unit_price
				end
			end
		end
		total
	end
	
	private
	def parse_rules(rules)
		rule_a, rule_a_spec_price = Rule.new, SpecialPrice.new
		rule_a_spec_price.set_size, rule_a_spec_price.price_per_set = 3, 130
		rule_a.sku, rule_a.unit_price, rule_a.special_price = 'A', 50, rule_a_spec_price

		rule_b, rule_b_spec_price = Rule.new, SpecialPrice.new
		rule_b_spec_price.set_size, rule_b_spec_price.price_per_set = 2, 45
		rule_b.sku, rule_b.unit_price, rule_b.special_price = 'B', 30, rule_b_spec_price

		rule_c = Rule.new
		rule_c.sku, rule_c.unit_price = 'C', 20

		rule_d = Rule.new
		rule_d.sku, rule_d.unit_price = 'D', 15

		{ rule_a.sku => rule_a, rule_b.sku => rule_b, rule_c.sku => rule_c, rule_d.sku => rule_d }
	end
end

# Item  Unit      Special
# 		Price     Price
# --------------------------
# A     50       3 for 130
# B     30       2 for 45
# C     20
# D     15