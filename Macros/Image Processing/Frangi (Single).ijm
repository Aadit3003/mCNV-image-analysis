run("8-bit");
run("Gaussian Blur...", "sigma=1");
run("Frangi Vesselness", "dogauss=true spacingstring=[1, 1] scalestring=[3, 5]");
selectWindow("result");
run("8-bit");
