# An ImageJ macro for Quantitative Analysis of OCTA images.

## Description
This ImageJ macro allows users to automate the processing of OCTA images of retinae with mCNV. The macro's image processing pipeline uses Gaussian blur filter, Frangi Vesselness filter, Local Median thresholding and the Mexican Hat filter. The macro allows users to adjust the input parameters, number of images, and the scale. Users can then measure nine biomarkers including mCNV area, vessel area, vessel density, vessel diameter, vessel junctions, junction density, fractal dimension and vessel tortuosity.

<img src="https://github.com/Aadit3003/mCNV-image-analysis/blob/d31b473560b7ad7c3ae6335809bdb7dc3e1ecea6/Assets/1_Fig%201%20What.png" width="1024"><br/>

## Installation and Use

The latest stable version is uploaded to Zenodo at <Insert Site Here>. Once you download the zip file, simply drag the .ijm file onto the Fiji icon. With the mCNV image open, enter the desired parameters and select the input and output directories to save the results. If you wish to save images of the intermediate processing steps, check the "Save Pipeline Stages" option.

<img src="https://github.com/Aadit3003/mCNV-image-analysis/blob/d31b473560b7ad7c3ae6335809bdb7dc3e1ecea6/Assets/User%20Interface.png"><br/>

## Documentation, links and ressources

<!-- -   Ask questions on the [pendent drop topic page of the ImageJ forum](http://forum.imagej.net/t/pendent-drop-plugin-how-to-use/290) -->
<!-- -   To cite this software, please use the following reference: A. Daerr and A. Mogne, *Pendent\_Drop: An ImageJ Plugin to Measure the Surface Tension from an Image of a Pendent Drop*. Journal of Open Research Software, 4: e3 (2016), [DOI: 10.5334/jors.97](http://dx.doi.org/10.5334/jors.97) -->
-   [source code on github](https://github.com/Aadit3003/mCNV-image-analysis)
-   [PDF document descripting the underlying mCNV analysis techniques and macro in more detail]()
