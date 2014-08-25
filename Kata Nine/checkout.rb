require 'yaml'

class Rule
	attr_accessor :sku, :unit_price, :set_size, :price_per_set
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
		stats = @sku_list.chars.group_by(&:chr).map { |chr, all_chars| { chr => all_chars.size } }.reduce(Hash.new, :merge)
		stats.each do |sku, count|
			rule = @rules[sku]
			if !rule.set_size.nil? && !rule.price_per_set.nil?
				total += count / rule.set_size * rule.price_per_set
				total += count % rule.set_size * rule.unit_price
			else
				total += count * rule.unit_price
			end
		end
		total
	end
	
	private
	def parse_rules(rules)
		rule_a = Rule.new
		rule_a.sku, rule_a.unit_price = 'A', 50
		set_size, price_per_set = 3, 130

		rule_b = Rule.new
		rule_b.sku, rule_b.unit_price = 'B', 30
		set_size, price_per_set = 2, 45

		rule_c = Rule.new
		rule_c.sku, rule_c.unit_price = 'C', 20

		rule_d = Rule.new
		rule_d.sku, rule_d.unit_price = 'D', 15

		a = { rule_a.sku => rule_a, rule_b.sku => rule_b, rule_c.sku => rule_c, rule_d.sku => rule_d }
		#puts a.to_yaml
		a
	end
end

# ---
# A: !ruby/object:Rule
  # sku: A
  # unit_price: 50
  # special_price: !ruby/object:SpecialPrice
    # set_size: 3
    # price_per_set: 130
# B: !ruby/object:Rule
  # sku: B
  # unit_price: 30
  # special_price: !ruby/object:SpecialPrice
    # set_size: 2
    # price_per_set: 45
# C: !ruby/object:Rule
  # sku: C
  # unit_price: 20
# D: !ruby/object:Rule
  # sku: D
  # unit_price: 15