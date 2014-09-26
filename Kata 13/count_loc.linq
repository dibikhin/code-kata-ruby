<Query Kind="FSharpProgram" />

open System.Text.RegularExpressions

let countLoc source =
	let deleteBlockComments text = Regex.Replace(text, "\/\*(\r\n|.)*?\*\/", "")
	let isNotOneComment str = not ((str:string).Trim().StartsWith @"//")
	
	(deleteBlockComments source).Split([|"\r\n"|], StringSplitOptions.RemoveEmptyEntries)
	|> Seq.where isNotOneComment
	|> Seq.length
	
let simpleCommentsSource = 
	@" // This file contains 3 lines of code
public interface Dave {
/**
* count the number of lines in a file
*/
int countLines(File inFile); // not the real signature!
}"

let complexCommentsSource = 
	@" /*****
* This is a test program with 5 lines of code
*  \/* no nesting allowed!
//*****//***/// Slightly pathological comment ending...

public class Hello {
public static final void main(String [] args) { // gotta love Java
   // Say hello
 System./*wait*/out./*for*/println/*it*/(""Hello/*"");
}

}"

Dump (countLoc simpleCommentsSource)	// -> 3
Dump (countLoc complexCommentsSource)	// -> 5