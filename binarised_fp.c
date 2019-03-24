#include <string.h>
#include <stdio.h>
#include "binarised_fp.h"

#define PACKED_SIZE (sizeof(BNNI) * 8)

static BNNS packed_ls(BNN bnn, BNNS layer);
static BNNO xnor_bin_sum(BNNI i, BNNW w);
static BNNO partial_xnor_bin_sum(BNNI i, BNNW w, uint32_t bits);
static void matrix_mult(
    BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNNW weights[NODE_MAX][WGT_VEC_SIZE], BNNS last_trunc, BNNB bias[NODE_MAX]
);
static void binarise(BNNI input[INP_VEC_SIZE], const BNNO output[NODE_MAX], BNNS out_size);

void forward_pass(BNN bnn, BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX]) {

    for ( BNNS i = 0; i < bnn->layers-1; i++ ) { // for each layer
        BNNS inp_size = packed_ls(bnn, i);
        BNNS out_size = bnn->layer_sizes[i+1];
        memset(output, 0, out_size * sizeof(BNNO));

        matrix_mult(input, output, inp_size, out_size, bnn->weight[i], bnn->layer_sizes[i] % SIZE(BNNI));

        // binarise
        if (i != bnn->layers-2) {
            binarise(input, output, out_size);
        }
    }
}

BNNS packed_ls(BNN bnn, BNNS layer) {
    return CEIL_DIV(bnn->layer_sizes[layer], SIZE(BNNI));
}

static void matrix_mult(
    BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNNW weights[NODE_MAX][WGT_VEC_SIZE], BNNS last_trunc, BNNB bias[NODE_MAX]
) {
    BNNS k, j;
    for ( j = 0; j < out_size; j++ ) { // for each output node
        for ( k = 0; k < inp_size-1; k++ ) { // for each input node
            output[j] += xnor_bin_sum(input[k], weights[j][k]);
        }
        output[j] += partial_xnor_bin_sum(input[k], weights[j][k], last_trunc);
        output[j] += bias[j];
    }
}

static BNNO xnor_bin_sum(BNNI i, BNNW w) {
    return __builtin_popcount(~(i^w)) - (PACKED_SIZE / 2);
}

static BNNO partial_xnor_bin_sum(BNNI i, BNNW w, BNNS bits) {
    BNNO xnored = ~(i^w);
    BNNO mask = (BNNO)((1 << bits) - 1);
    return 2 * __builtin_popcount(xnored & mask) - bits;
}

static void binarise(BNNI input[INP_VEC_SIZE], const BNNO output[NODE_MAX], BNNS out_size) {
    for (BNNS j = 0; j < out_size; j += PACKED_SIZE) { // for each output value
        for (int k = PACKED_SIZE - 1; k >= 0; k--) { // high to low bits for efficient shifting
            input[j / PACKED_SIZE] <<= 1;
            input[j / PACKED_SIZE] += output[j + k] >= 0 ? 1 : 0;
        }
    }
}
