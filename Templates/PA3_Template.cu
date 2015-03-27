/************************************************************/
/* Programming Assignment No. :   */
/* Team Members:											*/
/*				1-											*/
/*				2-											*/
/*															*/
/************************************************************/
/* "//@@" means you should insert your own code at current  */
/*  place													*/
/************************************************************/
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
using namespace std;

#define TILE_WIDTH 16 

// Compute B = min_Element(A) , minimum in array A 
__global__ void min_Element(float * A, float * B) {
	//@@ Insert code to implement Minimum elemnt of array with reduction
	




	//
}

int main(void)
{
	int * hostA; // The A array
	int * hostB; // The B output , to store deviceB after parallel execution
	 
	int * B_check; // The output B matrix of CPU implementation) 
	int  * deviceA;
	int  * deviceB;
 
	const int width = 128;  // array width = 128 elemnts 
 
	 
	/* Allocating memory for input matrices HostA */
	hostA = new int[width];
	 

	/* Initializing input matrices with input random data */
	// Matrix A
	srand(1);
	for (int i = 0; i numARows; i++)
	{
		hostA[i] = 1 + (rand() % 100);  // genrate random between 1 and 100
	}
 
	//@@ Implement Min element of array in ordinary C++ code (serial code)
	//@@  Use it to check with the result of the parallel


	// print the result of the (Serial code) above
	printf("PUTPUT  SERAIL: %d \n", B_check);

	//@@ Allocate GPU memory here
	

	//@@ Copy memory to the GPU here
	

	//@@ Initialize the grid and block dimensions here
	

	//@@ Launch the GPU Kernel here



	cudaThreadSynchronize();
	//@@ Copy the GPU memory (deviceB) back to the CPU (hostB) here


	//@@ Free the GPU memory here


	 


	// print the result of the (Parallel code) above
	printf("PUTPUT  SERAIL: %d \n", hostB);
	
	

	return 0;
}