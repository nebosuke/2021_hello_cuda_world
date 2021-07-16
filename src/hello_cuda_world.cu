#include <cinttypes>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

#define MAT_SIZE_X 10000
#define MAT_SIZE_Y 10000

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

    // TODO

    free(hMat_A);
    free(hMat_B);
    free(hMat_G);
}
