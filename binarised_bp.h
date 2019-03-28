#ifndef VALJEAN_NNET_BINARISED_BP_H
#define VALJEAN_NNET_BINARISED_BP_H

#include "bnn.h"

void back_pass(BNN bnn, BNNI input[CEIL_DIV(LAYER_MAX, SIZE(BNNI))], BNNO output[LAYER_MAX], BNNO target[LAYER_MAX]);

#define PACKED_SIZE (sizeof(BNNI) * 8)

static BNNS packed_ls(BNN bnn, BNNS layer);
static BNNO xnor_bin_sum(BNNI i, BNNW w);
static BNNO partial_xnor_bin_sum(BNNI i, BNNW w, uint32_t bits);
static void matrix_mult(
    BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNNW weights[NODE_MAX][WGT_VEC_SIZE], BNNS last_trunc, BNNB bias[NODE_MAX]
);
static void binarise(BNNI input[INP_VEC_SIZE], const BNNO output[NODE_MAX], BNNS out_size);
static void clamp(BNNO output[NODE_MAX], BNNS n_outputs, BNNS max);

#endif //VALJEAN_NNET_BINARISED_FP_H
