#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


var size = 10;
var mCNV_Areas = newArray(size);
var vessel_Areas = newArray(size);
var vessel_Junctions = newArray(size);
var vessel_Lengths = newArray(size);
var fractal_dimensions = newArray(size);


var	m_index = 0;
var	v_index = 0;
var j_index = 0;
var l_index = 0;
var f_index = 0;

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);	
	
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}

//	Make the Measurements Table!!
	table_name = "Measurements_Fractal"
	Table.create(table_name);	
	Table.setColumn("File", list);
	Table.setColumn("mCNV Area", mCNV_Areas);	
	Table.setColumn("Vessel Area", vessel_Areas);
	Table.setColumn("Vessel Junctions", vessel_Junctions);
	Table.setColumn("Vessel Length", vessel_Lengths);
	Table.setColumn("Fractal Dimension", fractal_dimensions);


	Res_out = output + File.separator + table_name + ".csv"
	saveAs(table_name, Res_out);
	
}


function processFile(input, output, file) {

	open(input + File.separator + file);
	
	// Measure Areas (Frangi)
	run("Duplicate...", "title=copy.tif");
	selectWindow("copy.tif");
	
	run("Set Measurements...", "area redirect=None decimal=3");
	gray();
	measure();
	threshold();
	run("Set Measurements...", "area limit redirect=None decimal=3");
	measure();
	
	mCNV_Areas[m_index] = getResult("Area", 0);
	vessel_Areas[v_index] = getResult("Area", 1);

	// Close Windows
	selectWindow("Results");
	run("Close");
	selectWindow("copy.tif");
	run("Close");
	selectWindow("result");
	run("Close");

	// Skeletonize
	mex_hat();
	skeletonize();

	run("Fractal Box Count...", "box=2,3,4,6,8,12,16,32,64 black");
	
	fractal_dimensions[f_index] = getResult("D", 0);

	selectWindow("Results");
	run("Close");
	selectWindow("Plot");
	run("Close");
	
	// Measure Junctions
	measureSkeleton();
	
	branches = getResult("# Branches", 0);
	vessel_Junctions[j_index] = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	vessel_Lengths[l_index] = branches * avg_length;

	// Increment Array Indices
	m_index++;
	v_index++;
	j_index++;
	l_index++;
	f_index++;
	
	//	Close Windows	
	selectWindow("Results");
	run("Close");

	run("Close All");
	
}

// Image processing Functions
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
	run("Analyze Skeleton (2D/3D)", "prune=none");
}

function measure(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
}

