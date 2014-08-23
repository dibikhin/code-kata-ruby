  def price(goods)
    co = CheckOut.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
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
	end
end