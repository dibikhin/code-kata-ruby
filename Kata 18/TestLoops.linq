<Query Kind="Program" />

void Main()
{
	TestDeps.TestBasic();
}

// Define other methods and classes here

class Deps {
	Dictionary<char, List<char>> _allDeps = new Dictionary<char, List<char>>();
	
	public void Add(char key, List<char> deps) {
		_allDeps.Add(key, deps);
	}
	
	public List<char> DepsFor(char key) {
		var asdf = RecurDepsFor(key, new HashSet<char>()).Where(d => d != key).ToList();
		asdf.Sort();
		return asdf;
	}
	
	private HashSet<char> RecurDepsFor(char key, HashSet<char> depsChain) {
		List<char> keyDeps;
		_allDeps.TryGetValue(key, out keyDeps);
		if(depsChain.Contains(key)) return depsChain;
		depsChain.Add(key);
		if(keyDeps == null) return depsChain;
		foreach(var kd in keyDeps)
			depsChain.UnionWith(RecurDepsFor(kd, depsChain));
		return depsChain;
	}
}

class TestDeps {
	public static void TestBasic(){
		var deps = new Deps();
		deps.Add('A', new List<char> { 'B', 'C' } );
		deps.Add('B', new List<char> { 'C', 'E' } );
		deps.Add('C', new List<char> { 'G',     } );
		deps.Add('D', new List<char> { 'A', 'F' } );
		deps.Add('E', new List<char> { 'F'      } );
		deps.Add('F', new List<char> { 'H'      } );
		
		deps.DepsFor('A').SequenceEqual(new List<char> { 'B', 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('B').SequenceEqual(new List<char> { 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('C').SequenceEqual(new List<char> { 'G' }).Dump();
 		deps.DepsFor('D').SequenceEqual(new List<char> { 'A', 'B', 'C', 'E', 'F', 'G', 'H' }).Dump();
 		deps.DepsFor('E').SequenceEqual(new List<char> { 'F', 'H' }).Dump();
 		deps.DepsFor('F').SequenceEqual(new List<char> { 'H' }).Dump();
	}
}