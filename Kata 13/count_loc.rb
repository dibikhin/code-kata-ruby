str = "// This file contains 3 lines of code
public interface Dave {
  /**
   * count the number of lines in a file
   */
  int countLines(File inFile); // not the real signature!
}"

loc_count = 0
#str.chars.each { |chr| loc_count += 1 if chr == "\n" }
str.lines.each { |line| loc_count += 1 if !line.strip.start_with?("//", "*/", "/*") }
puts loc_count

#.gsub(/\/\*(\n|.)*\*\//, '').strip