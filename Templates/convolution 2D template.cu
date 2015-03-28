#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
using namespace std;


#define Mask_width  5  // convolution kernel 
#define Mask_radius Mask_width/2  

//@@ INSERT CODE HERE
#define TILE_WIDTH 16

// CLAMP() In computer terms, to clamp a value is to make sure that it lies between some maximum and minimum values.
// If it’s greater than the max value, then it’s replaced by the max,
#define CLAMP(val, start, end) (min(max(val, start), end))

__global__ void conv2D(float *I, float *P, const float *__restrict__ M, int ImagW, int ImagH, int ImagC)
{
	 
	int tx = threadIdx.x;
	int ty = threadIdx.y;
	int tz = threadIdx.z;
	int bx = blockIdx.x;
	int by = blockIdx.y;
	int row = by * TILE_WIDTH + ty;  // use of TILE_WIDTH instead of blockDim 
	int col = bx * TILE_WIDTH + tx;


	//@@ implement  your kernel here 
	 
    //@@ pixels are in the range of 0 to 1 , use CLAMP here at the end and before storing the data to M
		 
	}

	 


}

int main(int argc, char* argv[]) {
	 
	int maskRows;
	int maskColumns;
	int imageChannels;
	int imageWidth;
	int imageHeight;
	char * inputImageFile;
	char * inputMaskFile; 
	float * hostInputImageData;
	float * hostOutputImageData;
	float * hostMaskData;
	float * deviceInputImageData;
	float * deviceOutputImageData;
	float * deviceMaskData;

	 
    //@@ initialize your variables here

	 
	 
	//@@ INSERT CODE HERE
	dim3 dimGrid((imageWidth + TILE_WIDTH - 1) / TILE_WIDTH, (imageHeight + TILE_WIDTH - 1) / TILE_WIDTH, 1);
	dim3 dimBlock(TILE_WIDTH, TILE_WIDTH, imageChannels);

	conv2D << <dimGrid, dimBlock >> >(deviceInputImageData, deviceOutputImageData, deviceMaskData, imageWidth, imageHeight, imageChannels);
	cudaDeviceSynchronize();

	 


	 

	cudaFree(deviceInputImageData);
	cudaFree(deviceOutputImageData);
	cudaFree(deviceMaskData);

	free(hostMaskData);
	 
	return 0;
}
