<Query Kind="FSharpProgram" />

let findAdjacentBits bitCount =
	let ( ** ) x y = pown x y
	seq {
		for num in 0..(2 ** bitCount - 1) do
			for shift in 0..(bitCount - 2) do
				if num = (0b11 <<< shift) then yield num }
			
findAdjacentBits 3 |> Dump // -> 3 6