<Query Kind="FSharpProgram" />

open System.Text.RegularExpressions

let countLoc source =
	let deleteBlockComments text =
		Regex.Replace(text, "\/\*(\r\n|.)*?\*\/", "")
	let isNotOneComment str = 
		not ((str:string).Trim().StartsWith @"//")
	
	(deleteBlockComments source).Split [|'\n'|]
	|> Seq.where isNotOneComment
	//|> Seq.length
	
let simpleCommentsSource = 
	@" // This file contains 3 lines of code
	public interface Dave {
	/**
	* count the number of lines in a file
	*/
	int countLines(File inFile); // not the real signature!
	}"

Dump (countLoc simpleCommentsSource)