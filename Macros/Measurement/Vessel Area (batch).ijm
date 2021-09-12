/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

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
	
	run("Close All");

	Res_out = output + File.separator + "Vessel_Area.csv"
	saveAs("Results", Res_out);
	selectWindow("Results");
	run("Close");
	
}

function processFile(input, output, file) {

	open(input + File.separator + file);
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
	
}
