run("Analyze Skeleton (2D/3D)", "prune=none calculate show");

selectWindow("Results");
run("Close");
Table.rename("Branch information", "Results");

tort = 0.00;
prev_tort = 0.00;
print("Number of results is ", nResults);
for (i = 0; i < nResults(); i++) {
	
	bl = getResult("Branch length", i);
	ed = getResult("Euclidean distance",i);
	t = bl/ed;
	prev_tort = tort;
	tort += (t - tort)/(i+1);
	// Check for Over/Underflow conditions
	if(isNaN(tort) || tort > 1000){
		
		print("breaking");
		tort = prev_tort;
		break;	
	}
}
print("Tort is ", tort);

//run("Close All");
//selectWindow("Results");
//run("Close");