gray();
measure();
threshold();
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
print("Length is ", length);
print("No. of Junctions is  ",junctions);


selectWindow("Results");
run("Close");

run("Close All");


function gray(){
	run("8-bit");	
}
function threshold(){
	run("Gaussian Blur...", "sigma=1");
	run("Frangi Vesselness",
    "dogauss=true spacingstring=[1, 1] scalestring=[3, 5]");
    selectWindow("result");
    run("8-bit");
    run("Auto Local Threshold",
    "method=Median radius=8 parameter_1=0 parameter_2=0 white");

}

function skeletonize(){
	run("Invert LUT");
	run("Skeletonize", "stack");
	run("Invert LUT");
}

function measureSkeleton(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Analyze Skeleton (2D/3D)", "prune=none");

}

function measure(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
}
