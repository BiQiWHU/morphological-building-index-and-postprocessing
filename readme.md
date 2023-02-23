Morphological Building Index，a novel building extraction method，was proposed by Xin Huang in 2011.(A multidirectional and multiscale morphological index for automatic building extraction from mutispectral GeoEye-1 imagery. PERS,2011)


The sucess of MBI lies in its high speed and simplity. The process of building extraction does not need supervised learning.
However, the drawbacks mainly lie in the confusion of vegatation and water, the confusion of roads and mountain areas.
Hence, a series of post processing strategies have been studied from then on.
(A New Building Extraction Postprocessing Framework for High-Spatial-Resolution Remote-Sensing Imagery, JSTAR, 2017)

In this project, we code MBI and its post-processing framework on Matlab.
```open_by_reconstruction/close_by_reconstruction.m``` are listed here to load some functions.

The core of this project is ```mbi.m``` and ```postprocessing.m```.
In ```mbi.m```, we implement all steps of MBI and output a MBI feature image.

In ```postprocessing.m```, we implement the major steps in the post-processing framework including area filling holes,threshold and length-width threshold, and finally output a building map in the form of bmp.
The input of this project is two images. A RGB 3-channel image and a NIR-R-G 3-channel image of the same region.

