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
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	open(input + File.separator + file);
	run("8-bit");
	run("Gaussian Blur...", "sigma=1");
	run("Frangi Vesselness", "dogauss=true spacingstring=[1, 1] scalestring=[3, 5]");
	selectWindow("result");
	run("8-bit");
	run("Auto Threshold", "method=Mean white");
	run("Close-", "stack");
	run("Skeletonize", "stack");
	run("Invert LUT");
	saveAs("Tiff", output + File.separator + "ThresholdOUTPUT_" + file);
	run("Close All");
}
