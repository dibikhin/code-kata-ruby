<Query Kind="Program" />

void Main()
{
	TestDeps.TestBasic();
}

// Define other methods and classes here

class Deps { 
	public void Add(char key, char[] deps) { }
	public char[] DepsFor(char key) { return new char[] { }; }
}

class TestDeps {
	public static void TestBasic(){
		var deps = new Deps();
		deps.Add('A', new [] { 'B', 'C' } );
		deps.Add('B', new [] { 'C', 'E' } );
		deps.Add('C', new [] { 'G',     } );
		deps.Add('D', new [] { 'A', 'F' } );
		deps.Add('E', new [] { 'F'      } );
		deps.Add('F', new [] { 'H'      } );
		
		deps.DepsFor('A').SequenceEqual(new [] { 'B', 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('B').SequenceEqual(new [] { 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('C').SequenceEqual(new [] { 'G' }).Dump();
 		deps.DepsFor('D').SequenceEqual(new [] { 'A', 'B', 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('E').SequenceEqual(new [] { 'F', 'H' }).Dump();
 		deps.DepsFor('F').SequenceEqual(new [] { 'H' }).Dump();
	}
}