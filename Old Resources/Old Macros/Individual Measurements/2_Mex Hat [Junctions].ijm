main();

function main(){
	
	process_image();
	skeletonize();
	measureSkeleton();
	
	branches = getResult("# Branches", 0);
	junctions = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	length = branches * avg_length;

	print("Length is ", length);
	print("No. of Junctions is  ",junctions);
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
	
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Analyze Skeleton (2D/3D)", "prune=none");
}