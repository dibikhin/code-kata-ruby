require 'minitest/autorun'
require 'pp'
require 'ruby-prof'
require 'set'

class Dependencies
	def initialize
		@all_deps = {}
	end
		
	def add_direct(key, deps)
		@all_deps[key] = deps
	end

	def dependencies_for(key)
		deps_chain = recur_deps_for(key, Hash.new)
		deps_chain.keys.select { |dep| dep != key }
	end

	def recur_deps_for(key, deps_chain)
		key_deps = @all_deps[key]
		return deps_chain if deps_chain.include?(key)
		deps_chain[key] = nil # using Hash like Set
		return deps_chain if key_deps.nil?
		key_deps.each do |dep|
			deps_chain.merge(recur_deps_for(dep, deps_chain))#.keys.each { |key_dep| deps_chain[key_dep] = nil }
		end
		deps_chain
	end
	
	def self.get_rand_deps(deps_range, limit)
		deps = Hash.new
		random = Random.new
		deps_range_arr = deps_range.to_a
		random_ix = random.rand(deps_range_arr.size)
		random.rand(limit).times { deps[deps_range_arr[random_ix]] = nil }
		deps
	end

	def self.generate_deps(keys_range, deps_range, deps_limit)
		dep = Dependencies.new
		keys_range.each { |key| dep.add_direct(key, get_rand_deps(deps_range, deps_limit)) }
		dep
	end
end

class TestRack < Minitest::Test
	def test_basic
		dep = Dependencies.new

		dep.add_direct('A', %w{ B C } )
		dep.add_direct('B', %w{ C E } )
		dep.add_direct('C', %w{ G   } )
		dep.add_direct('D', %w{ A F } )
		dep.add_direct('E', %w{ F   } )
		dep.add_direct('F', %w{ H   } )

		assert_equal( %w{ B C E F G H },   dep.dependencies_for('A').sort)
		assert_equal( %w{ C E F G H },     dep.dependencies_for('B').sort)
		assert_equal( %w{ G },             dep.dependencies_for('C').sort)
		assert_equal( %w{ A B C E F G H }, dep.dependencies_for('D').sort)
		assert_equal( %w{ F H },           dep.dependencies_for('E').sort)
		assert_equal( %w{ H },             dep.dependencies_for('F').sort)
	end

	def test_simple_loop
		dep = Dependencies.new

		dep.add_direct('A', %w{ B } )
		dep.add_direct('B', %w{ X } )
		dep.add_direct('X', %w{ A } )
		
		assert_equal( %w{ B X }, dep.dependencies_for('A').sort)
		assert_equal( %w{ A X }, dep.dependencies_for('B').sort)
		assert_equal( %w{ A B }, dep.dependencies_for('X').sort)
	end

	def test_simple_loops_multi_deps
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X   } )
		dep.add_direct('X', %w{ A   } )
		dep.add_direct('D', %w{ E   } )
		
		assert_equal( %w{ B D E X }, dep.dependencies_for('A').sort)
		assert_equal( %w{ A D E X }, dep.dependencies_for('B').sort)
		assert_equal( %w{ A B D E }, dep.dependencies_for('X').sort)
	end

	def test_simple_loops_multi_deps_2
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X 	} )
		dep.add_direct('X', %w{ W B } )
		dep.add_direct('D', %w{ E 	} )
		
		assert_equal( %w{ B D E W X }, dep.dependencies_for('A').sort)
		assert_equal( %w{ W X       }, dep.dependencies_for('B').sort)
		assert_equal( %w{ B W       }, dep.dependencies_for('X').sort)
	end

	def test_simple_loops_multi_deps_3
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X 	} )
		dep.add_direct('X', %w{ A B } )
		dep.add_direct('D', %w{ E 	} )
		
		assert_equal( %w{ B D E X }, dep.dependencies_for('A').sort)
		assert_equal( %w{ A D E X }, dep.dependencies_for('B').sort)
		assert_equal( %w{ A B D E }, dep.dependencies_for('X').sort)
	end

	# def test_generator_for_chars
		# dep = Dependencies.generate_deps('A'..'M', 'A'..'Z', 7)
		# ('A'..'D').each { |key| p key, dep.dependencies_for(key) }
	# end

	def test_generator_for_fixnums
		dep = Dependencies.generate_deps(0..10000, 0..20000, 7)
		RubyProf.start
		(0..10000).each { |key| dep.dependencies_for(key) }
		puts RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT)
	end
end

	# def dependencies_for(key)
		# deps_chain = recur_deps_for(key, Set.new)
		# (deps_chain - [key]).to_a.sort
	# end

	# def recur_deps_for(key, deps_chain)
		# key_deps = @all_deps[key]
		# return deps_chain if deps_chain.include?(key)
		# deps_chain.add(key)
		# return deps_chain if key_deps.nil?
		# key_deps.each do |dep|
		# #	deps_chain += recur_deps_for(dep, deps_chain)
			# recur_deps_for(dep, deps_chain).each { |key_dep| deps_chain.add(key_dep) unless deps_chain.include?(key_dep) }
		# end
		# deps_chain
	# end