main();

function main(){

	run("Set Measurements...", "area redirect=None decimal=3");
	measure();
	process_image();
	run("Set Measurements...", "area limit redirect=None decimal=3");
	measure();
	
	mCNV_area = getResult("Area", 0);
	vessel_area = getResult("Area", 1);
	
	selectWindow("Results");
	run("Close");
	
	skeletonize();
	measureSkeleton();
	
	branches = getResult("# Branches", 0);
	junctions = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	length = branches * avg_length;
	
	print("mCNV Area is ", mCNV_area);
	print("vessel Area is ", vessel_area);
	print("Length is ", length);
	print("No. of Junctions is  ",junctions);
	
	
	//selectWindow("Results");
	//run("Close");
	//
	//run("Close All");
	
}

function process_image(){
	run("Mexican Hat Filter", "radius=13");
	setOption("BlackBackground", false);
	run("Convert to Mask");
}
function skeletonize(){

	run("Skeletonize");
}

function measureSkeleton(){
	run("Analyze Skeleton (2D/3D)", "prune=none");
}

function measure(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
}
