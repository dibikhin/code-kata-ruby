<Query Kind="FSharpProgram" />

let readWordsFile filePath = System.IO.File.ReadLines(filePath)
let findAnagrams list =
	let cleanStr word = (word:string).Trim()
	let sortedChars word = (word:string).ToLower() |> Seq.sort |> String.Concat
	list
	|> Seq.map cleanStr
	|> Seq.groupBy sortedChars

Dump (findAnagrams (readWordsFile @"C:\Users\Roman\My Projects\code-kata-ruby\Kata Six\wordsEn.txt"))