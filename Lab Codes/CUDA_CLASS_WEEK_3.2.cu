
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdlib.h>  // srand() , rand()
#include <stdio.h>
#include <math.h>


__global__ void global_reduce(int *input_d, int *output_d)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int tid = threadIdx.x;

	// sdata is allocated in the kernel call: 3rd arg to <<<b, t, shmem>>>
	extern __shared__ int sdata[];
	sdata[tid] = input_d[i];
	for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1)
	{
		if (tid < s)
		{
			sdata[tid] += sdata[s + tid];
		}
		__syncthreads();
	}
	// only thread 0 writes result for this block back to global mem
	if (tid == 0){
		output_d[blockIdx.x] = sdata[0];
	}
}

int main()
{
	const int ARRAY_SIZE = 1 << 20;   
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);
	const int maxThreadPerBlock = 1024;
	int threads = maxThreadPerBlock;
	int blocks = (ARRAY_SIZE / maxThreadPerBlock);


	int *input_h;
	input_h = (int*)malloc(ARRAY_BYTES);
	int sum = 0;
	srand(1);
	for (int i = 0; i < ARRAY_SIZE; i++)
	{
		input_h[i] = (int)(rand() % 100);  // random number betwen 0 and 100
		sum += input_h[i];
	}
	printf("output SERAIL: %d \n", sum);
	// declare GPU memory pointers
	int *in_d, *intermediate_d, *out_d;

	// allocate GPU memory
	cudaMalloc((void**)&in_d, ARRAY_BYTES);
	cudaMalloc((void**)&intermediate_d, ARRAY_BYTES);
	cudaMalloc((void**)&out_d, sizeof(int)); // only 1 element

	cudaMemcpy(in_d, input_h, ARRAY_BYTES, cudaMemcpyHostToDevice);

	global_reduce << <blocks, threads, threads * sizeof(int) >> >(in_d, intermediate_d);


	// now we're down to one block left, so reduce it
	threads = blocks; // launch one thread for each block in prev step
	blocks = 1;
	global_reduce << <blocks, threads, threads * sizeof(int) >> >(intermediate_d, out_d);

	int out_h;
	cudaMemcpy(&out_h, out_d, sizeof(int), cudaMemcpyDeviceToHost);

	printf("output parallel: %d \n", out_h);
	// cudaDeviceReset must be called before exiting in order for profiling and
	// tracing tools such as Nsight and Visual Profiler to show complete traces.
	int cudaStatus = cudaDeviceReset();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceReset failed!");
		return 1;
	}

	cudaFree(in_d);
	cudaFree(out_d);
	cudaFree(intermediate_d);

	return 0;
}
