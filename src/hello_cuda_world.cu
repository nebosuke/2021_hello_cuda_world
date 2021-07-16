#include <cinttypes>
#include <stdio.h>

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

    // TODO

    free(hMat_A);
    free(hMat_B);
    free(hMat_G);
}
