#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Results Output directory", style = "directory") table_output
#@ File (label = "Pipeline Stages directory", style = "directory") stage_output
#@ String (label = "File suffix", value = ".tif") suffix

// Customizable Parameters
#@ int (label = "Number of Images") number_of_images
#@ int (label = "Gaussian Blur Sigma") gaussian_sigma
#@ int (label = "Mexican Hat Filter Radius") mexican_hat_filter_radius
#@ int (label = "Number of Pixels per 1 mm") scale_pixels_per_1_mm
#@ int (label = "Auto Local Threshold Radius") auto_local_threshold_radius
#@ boolean (label = "Save Pipeline Stages?") checkbox

// Arrays for Measurement
var size = number_of_images;

var mCNV_Areas = newArray(size);
var vessel_Areas = newArray(size);
var vessel_Junctions = newArray(size);
var vessel_Lengths = newArray(size);
var fractal_dimensions = newArray(size);
var torts = newArray(size);
var vessel_densities = newArray(size);
var junction_densities = newArray(size);
var vessel_diameters = newArray(size);

var index = 0;

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);	
	
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, table_output, stage_output, list[i]);
	}

//	Make the Measurements Table!!
	table_name = "measurements"
	Table.create(table_name);	
	Table.setColumn("File", list);
	Table.setColumn("mCNV Area", mCNV_Areas);	
	Table.setColumn("Vessel Area", vessel_Areas);
	Table.setColumn("Vessel Junctions", vessel_Junctions);
	Table.setColumn("Vessel Length", vessel_Lengths);
	Table.setColumn("Fractal Dimension", fractal_dimensions);
	Table.setColumn("Tortuosity", torts);

	Table.setColumn("Vessel Density", vessel_densities);
	Table.setColumn("Junction Density", junction_densities);
	Table.setColumn("Vessel Dimaeter", vessel_diameters);


	Res_out = table_output + File.separator + table_name + ".csv"
	saveAs(table_name, Res_out);
	
}


function processFile(input, t_output, s_output, file) {

	open(input + File.separator + file);
	
	// Measure Areas (Frangi)
	run("Duplicate...", "title=copy.tif");
	selectWindow("copy.tif");
	
	run("Set Measurements...", "area redirect=None decimal=3");
	gray();
	measure();
	threshold(s_output, file);
	run("Set Measurements...", "area limit redirect=None decimal=3");
	measure();
	
	mCNV_Areas[index] = getResult("Area", 0);
	vessel_Areas[index] = getResult("Area", 1);
	vessel_densities[index] = vessel_Areas[index] / mCNV_Areas[index];

	// Close Windows
	selectWindow("Results");
	run("Close");
	selectWindow("copy.tif");
	run("Close");
	selectWindow("result");
	run("Close");

	// Skeletonize
	mex_hat();
	gray();
	skeletonize(s_output, file);

	run("Fractal Box Count...", "box=2,3,4,6,8,12,16,32,64 black");
	
	fractal_dimensions[index] = getResult("D", 0);

	selectWindow("Results");
	run("Close");
	selectWindow("Plot");
	run("Close");
	
	// Measure Junctions
	measureSkeleton(s_output, file);
	
	branches = getResult("# Branches", 0);
	vessel_Junctions[index] = getResult("# Junctions", 0);
	avg_length = getResult("Average Branch Length", 0);
	vessel_Lengths[index] = branches * avg_length;

	junction_densities[index] = vessel_Junctions[index] / vessel_Lengths[index];
	vessel_diameters[index] = 1000*(vessel_Areas[index] / vessel_Lengths[index]);

	selectWindow("Results");
	run("Close");
	
	Table.rename("Branch information", "Results");
	
	tort = 0.00;
	prev_tort = 0.00;
	for (i = 0; i < nResults(); i++) {
		
		bl = getResult("Branch length", i);
		ed = getResult("Euclidean distance",i);
		t = bl/ed;
		prev_tort = tort;
		tort += (t - tort)/(i+1);
		// Check for Over/Underflow conditions
		if(isNaN(tort) || tort > 1000){
			tort = prev_tort;
			break;	
		}
	}

	torts[index] = tort;

	//	Close Windows	
	selectWindow("Results");
	run("Close");
	run("Close All");

	// Increment Array Indices
	index++;
}

// Image processing Functions
function mex_hat(){
	run("Mexican Hat Filter", "radius="+mexican_hat_filter_radius);
	setOption("BlackBackground", false);
	run("Convert to Mask");
}
function skeletonize(s_output, file){
	run("Skeletonize");
	run("Invert LUT");
	// SAVE
    saveStage(s_output, file, "4_Skeleton_");
}
function gray(){
	run("8-bit");	
}
function threshold(s_output, file){
	run("Gaussian Blur...", "sigma="+gaussian_sigma);
	// SAVE
	saveStage(s_output, file, "1_Gaussian_");
	
	run("Frangi Vesselness",
    "dogauss=true spacingstring=[1, 1] scalestring=[3, 5]");
    // SAVE
    
 	saveStage(s_output, file, "2_Frangi_");
    
    
	selectWindow("Results");
    run("8-bit");
    run("Auto Local Threshold",
    "method=Median radius="+auto_local_threshold_radius+" parameter_1=0 parameter_2=0 white");
    // SAVE
//    saveStage(s_output, file, "3_Threshold_");
}

// Measurement Functions
function measureSkeleton(s_output, file){
	run("Set Scale...", "distance="+scale_pixels_per_1_mm+" known=1 unit=mm");
	run("Analyze Skeleton (2D/3D)", "prune=none calculate show");
	// SAVE

	selectWindow("Tagged skeleton");
    saveStage(s_output, file, "5_Analyze_Skeleton_"); // Tagged Skeleton
}

function measure(){
	run("Set Scale...", "distance="+scale_pixels_per_1_mm+" known=1 unit=mm");
	run("Measure");
}

// Function to Save Intermediate Stages
function saveStage(output, file, name_string){
	if (checkbox) {
		
	run("Duplicate...", "title=copy.tif");
	selectWindow("copy.tif");
	
	saveAs("Tiff", output + File.separator + name_string + file);

	
	new_name = name_string + file;
	selectWindow(new_name);
	run("Close");
	}
}

