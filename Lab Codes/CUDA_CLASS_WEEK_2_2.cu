
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <iostream>
#define HEIGHT 5
#define WIDTH 5
#define ARRAY_SIZE_X 32
#define ARRAY_SIZE_Y 16
#define ARRAY_SIZE_IN_BYTES ((ARRAY_SIZE_X) * (ARRAY_SIZE_Y) * (sizeof(unsigned int)))
using namespace std;

__global__ void what_is_my_id_2d_A(unsigned int * const X, unsigned int * const Y, unsigned int * const thread)
{
	/*
	gridDim.x–  The size in blocks of the X dimension of the grid.
	gridDim.y–  The size in blocks of the Y dimension of the grid.
	blockDim.x– The size in threads of the X dimension of a single block.
	blockDim.y– The size in threads of the Y dimension of a single block.
	theadIdx.x– The offset within a block of the X thread index.
	theadIdx.y– The offset within a block of the Y thread index.
	*/
	const unsigned int idx_x  = (blockIdx.x * blockDim.x)  +  threadIdx.x;
	const unsigned int idx_y = (blockIdx.y * blockDim.y)  +  threadIdx.y;
	const unsigned int thread_idx =((gridDim.x * blockDim.x) * idx_y) + idx_x;
	X[thread_idx] = idx_x;

}

int main()
{



	int jimmy [HEIGHT][WIDTH];
	int n,m;


	for (n=0; n<HEIGHT; n++)
	{
		for (m=0; m<WIDTH; m++)
		{
			jimmy[n][m]=(n+1)*(m+1);
			cout <<  jimmy[n][m] << "  ";
		}
		cout << endl;
	}
	/**-------------------------------------------*/
	unsigned int cpu_calc_thread[ARRAY_SIZE_Y][ARRAY_SIZE_X];
	unsigned int cpu_xthread[ARRAY_SIZE_Y][ARRAY_SIZE_X];
	unsigned int cpu_ythread[ARRAY_SIZE_Y][ARRAY_SIZE_X];
	/* Total thread count ¼ 32 * 4 = 128 */
	const dim3 threads_rect(32, 4); /* 32 * 4 */
	const dim3 blocks_rect(1,4);

	/* Total thread count ¼ 16 * 8 = 128 */
	const dim3 threads_square(16, 8); /* 16 * 8 */
	const dim3 blocks_square(2,2);

	unsigned int * gpu_calc_thread;
	unsigned int * gpu_xthread;
	unsigned int * gpu_ythread;

	cudaMalloc((void **)&gpu_calc_thread, ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpu_xthread, ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpu_ythread, ARRAY_SIZE_IN_BYTES);

	for (int kernel=0; kernel < 2; kernel++)
	{
		switch (kernel)
		{
		case 0:
			{
				/* Execute our kernel */
				what_is_my_id_2d_A<<<blocks_rect, threads_rect>>>(gpu_xthread, gpu_ythread,
					gpu_calc_thread);
			} break;
		case 1:
			{
				/*Executeour kernel */
				what_is_my_id_2d_A<<<blocks_square, threads_square>>>(gpu_xthread, gpu_ythread,
					 gpu_calc_thread);
			} break;
		default: exit(1); break;
		}

		printf("\nKernel %d\n", kernel);
		/* Iterate through the arrays and print */
		for (int y=0; y < ARRAY_SIZE_Y; y++)
		{
			for (int x=0; x < ARRAY_SIZE_X; x++)
			{
				printf("CT:  %d TID: %d YTID: %d XTID: \n", cpu_calc_thread[y][x],  cpu_ythread[y][x], cpu_xthread[y][x]);  

			}
		}/* Wait for any key so we can see the console window */

		return 0;
	}
}

