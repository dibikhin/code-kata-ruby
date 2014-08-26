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
		YAML.load(rules)
	end
end