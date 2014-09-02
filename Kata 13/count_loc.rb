def delete_block_comments(str)
	str.gsub(/\/\*(\n|.)*?\*\//, '')	# '?' is ungreedy quantifier and does all work 
end

def count_loc(str)
	loc_count = 0
	str_wo_block_comments = delete_block_comments(str)
	str_wo_block_comments.lines.each do |line| 
		loc_count += 1 if !line.strip.start_with?("//") && line.strip != ''
	end
	loc_count
end

simple_comments = ' // This file contains 3 lines of code
 public interface Dave {
  /**
   * count the number of lines in a file
   */
  int countLines(File inFile); // not the real signature!
}'

complex_comments = ' /*****
  * This is a test program with 5 lines of code
  *  \/* no nesting allowed!
  //*****//***/// Slightly pathological comment ending...

 public class Hello {
    public static final void main(String [] args) { // gotta love Java
        // Say hello
      System./*wait*/out./*for*/println/*it*/("Hello/*");
    }

}'

puts count_loc(simple_comments)		# => 3
puts count_loc(complex_comments)	# => 5