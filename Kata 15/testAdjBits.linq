<Query Kind="FSharpProgram" />

//[1..(3+4)] |> Dump

//0b0000001 <<< 2 |> Dump

let findAdjacentBits bitCount = [0b011; 0b110]
	//adjacentBitsNums 
	[0..(2 ** bitCount - 1)]
	|> Seq.iter (fun num -> 
		[0..(bitCount - 2)]
		|> Seq.iter (fun shift ->
			match shift with
			| num = 0b11 <<< shift
			yield num))

[0b011; 0b110] = findAdjacentBits 3 |> Dump