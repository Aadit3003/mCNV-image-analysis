run("8-bit");
run("Gaussian Blur...", "sigma=2");
run("Frangi Vesselness",
    "dogauss=true spacingstring=[1, 1] scalestring=[3, 5]");
selectWindow("result");
run("8-bit");
run("Auto Local Threshold",
    "method=Median radius=8 parameter_1=0 parameter_2=0 white");

//Invert LUT before skeletonizing!
run("Invert LUT");
run("Skeletonize", "stack");
run("Invert LUT");

