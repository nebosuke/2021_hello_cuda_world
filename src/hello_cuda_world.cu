#include <cinttypes>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define LOOP 10

#define BLOCK_SIZE 32

#define MAT_SIZE_X 10000
#define MAT_SIZE_Y 10000

#define CHECK(func)                   \
{                                     \
  const cudaError_t error = func;     \
  if (error != cudaSuccess) {         \
    printf("Error: %s:%d\n", __FILE__, __LINE__); \
    printf("Code: %d, Reason: %s\n", error, cudaGetErrorString(error)); \
    cudaDeviceReset();                \
    exit(EXIT_FAILURE);               \
  }                                   \
}

void calculate_gpu(float *hMat_A, float *hMat_B, float *hMat_G, uint32_t mat_size_x, uint32_t mat_size_y) {
    float *dMat_A = NULL;
    float *dMat_B = NULL;
    float *dMat_G = NULL;
    int nBytes = sizeof(float) * mat_size_x * mat_size_y;

    CHECK(cudaMalloc((float **) &dMat_A, nBytes));
    CHECK(cudaMalloc((float **) &dMat_B, nBytes));
    CHECK(cudaMalloc((float **) &dMat_G, nBytes));

    CHECK(cudaMemcpy(dMat_A, hMat_A, nBytes, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(dMat_B, hMat_B, nBytes, cudaMemcpyHostToDevice));

    dim3 block(BLOCK_SIZE, BLOCK_SIZE);
    dim3 grid((mat_size_x + block.x - 1) / block.x, (mat_size_y + block.y - 1) / block.y);
    printf("Grid=(%d, %d), Block=(%d,%d)\n", grid.x, grid.y, block.x, block.y);
	
    // TODO

    CHECK(cudaMemcpy(hMat_G, dMat_G, nBytes, cudaMemcpyDeviceToHost));

    CHECK(cudaFree(dMat_A));
    CHECK(cudaFree(dMat_B));
    CHECK(cudaFree(dMat_G));
    CHECK(cudaDeviceReset());
}

void add_vector_cpu(float *hMat_A, float *hMat_B, float *hMat_G, uint32_t mat_size_x, uint32_t mat_size_y) {
    for (uint32_t y = 0; y < mat_size_y; y++) {
       for (uint32_t x = 0; x < mat_size_x; x++) {
           uint32_t index = y * mat_size_x + x;
           hMat_G[index] = hMat_A[index] + hMat_B[index];
       }
    }
}

// CPUで A+B=G を実装
void calculate_cpu(float *hMat_A, float *hMat_B, float *hMat_G, uint32_t mat_size_x, uint32_t mat_size_y) {
    for (int i = 0; i < LOOP; i++) {
        add_vector_cpu(hMat_A, hMat_B, hMat_G, mat_size_x, mat_size_y);
    }
}

int main(void) {
    uint32_t mat_size_x = MAT_SIZE_X;
    uint32_t mat_size_y = MAT_SIZE_Y;
    int nBytes = sizeof(float) * mat_size_x * mat_size_y;

    float *hMat_A;
    float *hMat_B;
    float *hMat_G;

    hMat_A = (float *) malloc(nBytes);
    hMat_B = (float *) malloc(nBytes);
    hMat_G = (float *) malloc(nBytes);

    // 乱数で行列Aと行列Bを初期化する
    time_t t;
    srand((unsigned int) time(&t));
    for (uint32_t i = 0; i < mat_size_x * mat_size_y; i++) {
        hMat_A[i] = (float)(rand() % 100000) / 10000.0f;
	hMat_B[i] = (float)(rand() % 100000) / 10000.0f;
    }

    // calculate_cpu(hMat_A, hMat_B, hMat_G, mat_size_x, mat_size_y);
    calculate_gpu(hMat_A, hMat_B, hMat_G, mat_size_x, mat_size_y);

    free(hMat_A);
    free(hMat_B);
    free(hMat_G);
}
