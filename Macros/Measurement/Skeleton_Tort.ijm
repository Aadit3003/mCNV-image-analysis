run("Analyze Skeleton (2D/3D)", "prune=none calculate show");

selectWindow("Results");
run("Close");
Table.rename("Branch information", "Results");

tort = 0;
print("Number of results is ", nResults);
for (i = 0; i < nResults()-30; i++) {
	
	bl = getResult("Branch length", i);
//	print("BL is ",bl);
	ed = getResult("Euclidean distance",i);
//	print("ED is ",ed);
	t = bl/ed;
//	print(t);
	tort = tort+t;
//	print(tort);
	// Shows Infinity after 339.9045
}
print("Sum is ", tort);
tort = tort/nResults;

print("Tortuosity is ", tort);

//run("Close All");
//selectWindow("Results");
//run("Close");