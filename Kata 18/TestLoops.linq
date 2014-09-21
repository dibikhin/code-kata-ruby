<Query Kind="Program" />

void Main()
{
	TestDeps.TestBasic();
	TestDeps.TestGen();
}

// Define other methods and classes here

class Deps {
	Dictionary<char, List<char>> _allDeps = new Dictionary<char, List<char>>();
	
	public Dictionary<char, List<char>> AllDeps {
		get { return _allDeps; }
	}
	
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
	
	private static List<char> GenRandDeps() {
		var deps = new HashSet<char>();
		var rand = new Random();
		var randIx = rand.Next(10);
		var depsRangeArr = "POIUYTREWQ".ToCharArray();
		rand.Next(5).Times(() => deps.Add(depsRangeArr[randIx]));
		return deps.ToList();
	}
	
	public static Deps GenDeps() {
		var deps = new Deps();
		"POIUYTREWQ".ToCharArray().ToList().ForEach(key => deps.Add(key, GenRandDeps()));
		return deps;
	}
}

class TestDeps {
	public static void TestBasic() {
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
	
	public static void TestGen() {
		Deps.GenDeps().AllDeps.Dump();
	}
}

// thanx to Jon Skeet
public static class Extensions {
    public static void Times(this int count, Action action) {
        for (int i=0; i < count; i++) action();        
    }
}