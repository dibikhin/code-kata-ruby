<Query Kind="FSharpProgram" />

let words = ["raster";"monste";"raters";"sartre";"booste";"starer";"highas"]
let findAnagrams list =
	let doFind word = word |> Seq.sort |> String.Concat
	List.map doFind list

Dump (findAnagrams words)