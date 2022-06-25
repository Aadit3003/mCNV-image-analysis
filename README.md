# An ImageJ macro tool for OCTA-based Quantitative Analysis of retinal mCNV
This project was done under the guidance of Dr Sundaresan Raman, BITS Pilani, as part of the course CS F266 (Study Oriented Project) in the First Semester of AY 21-22.

## Brief Description
An ImageJ macro that allows users to automate the batch processing of retinal OCTA images of mCNV and measure nine biomarkers to characterize the lesion and vascular activity.

## Description
This ImageJ macro allows users to automate the processing of OCTA images of retinae with mCNV. The macro's image processing pipeline uses Gaussian blur filter, Frangi Vesselness filter, Local Median thresholding and the Mexican Hat filter. The macro allows users to adjust the input parameters, number of images, and the scale. Users can then measure nine biomarkers including mCNV area, vessel area, vessel density, vessel diameter, vessel junctions, junction density, fractal dimension and vessel tortuosity.

<img src="https://github.com/Aadit3003/mCNV-image-analysis/blob/d31b473560b7ad7c3ae6335809bdb7dc3e1ecea6/Assets/1_Fig%201%20What.png" width="1024"><br/>

## Installation and Use

The latest stable version is uploaded to Zenodo. Once you download the zip file, simply drag the .ijm file onto the Fiji icon. With the mCNV image open, enter the desired parameters and select the input and output directories to save the results. If you wish to save images of the intermediate processing steps, check the "Save Pipeline Stages" option.

<img src="https://github.com/Aadit3003/mCNV-image-analysis/blob/d31b473560b7ad7c3ae6335809bdb7dc3e1ecea6/Assets/User%20Interface.png"><br/>

## Documentation, links and ressources

-   To cite this software, please use the following reference: A. Deshpande and S. Raman, *An ImageJ macro tool for OCTA-based Quantitative Analysis of Myopic Choroidal Neovascularization. 2022*.
-   [Source code on github](https://github.com/Aadit3003/mCNV-image-analysis)
