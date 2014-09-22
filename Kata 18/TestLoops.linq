<Query Kind="Program" />

void Main()
{
//	TestDeps.TestBasic();
	//TestDeps.TestCharGen();
	TestDeps.TestIntGen();
}

// Define other methods and classes here

class Deps <T> where T : IComparable<T> {
	Dictionary<T, List<T>> _allDeps = new Dictionary<T, List<T>>();
	
	public Dictionary<T, List<T>> AllDeps {
		get { return _allDeps; }
	}
	
	public void Add(T key, List<T> deps) {
		_allDeps.Add(key, deps);
	}
	
	public List<T> DepsFor(T key) {
		var depsForKey = RecurDepsFor(key, new HashSet<T>()).Where(d => d.CompareTo(key) < 0 || d.CompareTo(key) > 0);
		return depsForKey.Distinct().OrderBy(d => d).ToList();
	}
	
	private IEnumerable<T> RecurDepsFor(T key, HashSet<T> depsChain) {
		List<T> keyDeps;
		IEnumerable<T> ienum = null;
		_allDeps.TryGetValue(key, out keyDeps);
		if(depsChain.Contains(key)) return depsChain;
		depsChain.Add(key);
		if(keyDeps == null) return depsChain;
		foreach(var kd in keyDeps)
			ienum = depsChain.Union(RecurDepsFor(kd, depsChain));
		return ienum == null ? depsChain : ienum;
	}
	
	private static List<T> GenRandDeps(Random rand, T[] depsRangeArr) {
		var deps = new HashSet<T>();
		int randIx;
		rand.Next(1, depsRangeArr.Length / 2).Times(() => { 
			randIx = rand.Next(1, depsRangeArr.Length); 
			deps.Add(depsRangeArr[randIx]);
		});
		return deps.ToList();
	}
	
	public static Deps<T> GenDeps(T[] keySet, T[] depSet) {
		var deps = new Deps<T>();
		var rand = new Random();
		keySet.ToList().ForEach(key => { 
			var randDeps = GenRandDeps(rand, depSet);
			randDeps.RemoveAll(d => d.CompareTo(key) == 0);
			deps.Add(key, randDeps);
		});
		return deps;
	}
}

class TestDeps {
	public static void TestBasic() {
		var deps = new Deps<char>();
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
	
	public static void TestCharGen() {
		var deps = Deps<char>.GenDeps("POIUYTREWQ".ToCharArray(), "POIUYTREWQ".ToCharArray());
		deps.DepsFor('P').Dump();
		deps.AllDeps.Dump();
	}
	
	public static void TestIntGen() {
		var deps = Deps<int>.GenDeps(Enumerable.Range(1, 5000).ToArray(), Enumerable.Range(1, 10000).ToArray());
		deps.DepsFor(2);//.Dump();
		//deps.AllDeps.Dump();
	}
}

// thanx to Jon Skeet
public static class Extensions {
    public static void Times(this int count, Action action) {
        for (int i=0; i < count; i++) action();        
    }
}