Matlab code for the paper:
M. Zhou, H. Chen, J. Paisley, L. Ren, L. Li, Z. Xing, D. Dunson,   
G. Sapiro and L. Carin, Nonparametric Bayesian Dictionary Learning for
Analysis of Noisy and Incomplete Images, submitted.  
Coded by: Mingyuan Zhou, ECE, Duke University, mz1@ee.duke.edu, mingyuan.zhou@duke.edu


File list:

Demo files:
Demo_Denoise_Gray.m: Running file for BPFA gray-scale image denoising.
Demo_Denoise_RGB.m: Running file for BPFA RGB image denoising.

Main programs:
BPFA_Denoise.m: The BPFA grayscale image denoising program.

Subprograms for Gibbs sampling:
SampleDZS.m: Sampling the dictionary D, the binary indicating matrix Z, and the pseudo weight matrix S. Used for no missing data case.
SamplePi.m: Sampling Pi.
Samplephi.m: Sampling the noise precision phi.
Samplealpha: Sampling alpha, the precision of si.

Subprograms for the updates in sequential learning
idexUpdate.m: Update the index of the training data in the input data matrix X.
Update_Input.m: Update the training data set in sequential learning. Used for no missing data case.
SZUpdate.m: Update the pseudo weight matrix S and binary indicating matrix Z in sequential learning.

Other subprograms:
sparsity.m: Squeeze out zero components in the sparse matrix.
DispDictionary.m: Display the dictionary elements as a image
DenoiseOutput_LowMemoryReq.m: Reconstruct the image
InitMatrix_Denoise.m: Initialization for gray-scale image denoising

house.png: the original house image. Other test images can be downloaded from http://www.cs.tut.fi/~foi/GCF-BM3D/

castle.png: the original castle image. Other test images can be found in The Berkeley Segmentation Dataset and Benchmark.

Papers and test results related to the code can be found at http://people.ee.duke.edu/~mz1/