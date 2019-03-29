#ifndef VALJEAN_NNET_BINARISED_FP_H
#define VALJEAN_NNET_BINARISED_FP_H

#include "bnn.h"
#include "mnist_int8_input.h"

void forward_pass(BNN bnn, BNNI nb_input[INP_VEC_SIZE], BNNO output[NODE_MAX]);

#define PACKED_SIZE (sizeof(BNNI) * 8)

BNNS packed_ls(BNN bnn, BNNS layer);
BNNO xnor_bin_sum(BNNI i, BNN_bin w);
BNNO partial_xnor_bin_sum(BNNI i, BNN_bin w, uint32_t bits);
void matrix_mult(
    BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][WGT_VEC_SIZE], BNNS last_trunc, BNN_real bias[NODE_MAX]
);
void binarise(BNNI input[INP_VEC_SIZE], const BNNO output[NODE_MAX], BNNS out_size);
void clamp(BNNO output[NODE_MAX], BNNS n_outputs, BNNS max);


#endif //VALJEAN_NNET_BINARISED_FP_H
