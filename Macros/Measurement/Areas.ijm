gray();
measure();
threshold();
measure();

mCNV_area = getResult("Area", 0);
vessel_area = getResult("Area", 1);

run("Close All");
selectWindow("Results");
run("Close");

print("mCNV Area is ", mCNV_area);
print("Vessel Area is ",vessel_area);


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

function measure(){
	run("Set Scale...", "distance=170 known=1 unit=mm");
	run("Measure");
}
