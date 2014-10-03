<Query Kind="FSharpProgram" />

let chop num lst =
	let chopIter n ls bottom top =
		123
	match lst with
	| [] -> -1
	| _	 -> chopIter num lst 0 List.length - 1
	
chop 3 [] |> Dump