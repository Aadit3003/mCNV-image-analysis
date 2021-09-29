main();

function main(){


	// Measure mCNV Area, Vessel Area  (Frangi)
	run("Duplicate...", "title=copy.tif");
	selectWindow("copy.tif");
	
	run("Set Measurements...", "area redirect=None decimal=3");
	gray();
	measure();
	threshold();
	run("Set Measurements...", "area limit redirect=None decimal=3");
	measure();
	
	mCNV_area = getResult("Area", 0);
	vessel_area = getResult("Area", 1);
	
	selectWindow("Results");
	run("Close");
	
	selectWindow("copy.tif");
	run("Close");
	
	selectWindow("result");
	run("Close");

	// Measure Junctions, Length and Fractal Dimensions(Mex Hat)
	mex_hat();
	skeletonize();

	run("Fractal Box Count...", "box=2,3,4,6,8,12,16,32,64 black");
	
	fractal_dimension = getResult("D", 0);

	selectWindow("Results");
	run("Close");
	
	selectWindow("Plot");
	run("Close");
	
	measureSkeleton();
	
	branches = getResult("# Branches", 0);
	junctions = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	length = branches * avg_length;
	selectWindow("Results");
	run("Close");
	
	Table.rename("Branch information", "Results");
	
	tort = 0;
	print("Number of results is ", nResults);
	for (i = 0; i < nResults(); i++) {
		bl = getResult("Branch length", i);
		ed = getResult("Euclidean distance",i);
		tort+= (bl/ed);
	}
	tort/= nResults;


	selectWindow("Results");
	run("Close");
	run("Close All");

	// Print Results
	print("mCNV Area is ", mCNV_area);
	print("Vessel Area is ", vessel_area);
	print("Vessel Length is ", length);
	print("Vessel Junctions are  ",junctions);
	print("Fractal Dimension is ", fractal_dimension);
	print("Tortuosity is ", tort);
	
	

	
	
	
}

// Image Processing Functions
function mex_hat(){
	run("Mexican Hat Filter", "radius=13");
	setOption("BlackBackground", false);
	run("Convert to Mask");
}
function skeletonize(){
	run("Skeletonize");
	run("Invert LUT");
}
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

// Measurement Functions
function measureSkeleton(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Analyze Skeleton (2D/3D)", "prune=none calculate show");
}

function measure(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
}
