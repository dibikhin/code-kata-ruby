<Query Kind="FSharpProgram" />

let words = ["raster ";"monste";" raters	";"Sartre";"booste";"starer";"highas"]
let findAnagrams list =
	let sortedChars word = 
		(word:string).Trim().ToLower() |> Seq.sort |> String.Concat
	list
	|> Seq.groupBy sortedChars
	|> Map.ofSeq

Dump (findAnagrams words)