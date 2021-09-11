run("8-bit");
run("Gaussian Blur...", "sigma=2");
run("Frangi Vesselness",
    "dogauss=true spacingstring=[1, 1] scalestring=[2, 4]");
selectWindow("result");
run("8-bit");
run("Auto Threshold", "method=Mean white");

run("Close-", "stack");

run("Skeletonize", "stack");
run("Invert LUT");

