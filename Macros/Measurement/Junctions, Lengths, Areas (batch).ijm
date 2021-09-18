#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


var size = 10;
var mCNV_Areas = newArray(size);
var vessel_Areas = newArray(size);
var vessel_Junctions = newArray(size);
var vessel_Lengths = newArray(size);


var	m_index = 0;
var	v_index = 0;
var j_index = 0;
var l_index = 0;

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
	table_name = "Measurements3"
	Table.create(table_name);	
	Table.setColumn("File", list);
	Table.setColumn("mCNV Area", mCNV_Areas);	
	Table.setColumn("Vessel Area", vessel_Areas);
	Table.setColumn("Vessel Junctions", vessel_Junctions);
	Table.setColumn("Vessel Length", vessel_Lengths);


	Res_out = output + File.separator + table_name + ".csv"
	saveAs(table_name, Res_out);
//	selectWindow("Results");
//	run("Close");

	
}


function processFile(input, output, file) {

	open(input + File.separator + file);

//	Process Images and Measure
	gray();
	measure();
	threshold();
	measure();
	
//	Add Results to Arrays!
	mCNV_Areas[m_index] = getResult("Area", 0);
	vessel_Areas[v_index] = getResult("Area", 1);
	m_index++;
	v_index++;
	
	selectWindow("Results");
	run("Close"); 
	
	skeletonize();
	measureSkeleton();
	
	branches = getResult("# Branches", 0);
	vessel_Junctions[j_index] = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	vessel_Lengths[l_index] = branches * avg_length;

	j_index++;
	l_index++;

	//	Close Windows	
	selectWindow("Results");
	run("Close");

	run("Close All");
	
}

function gray(){
	run("8-bit");	
}
function threshold(){
	run("Gaussian Blur...", "sigma=2");
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