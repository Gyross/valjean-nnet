#ifndef VALJEAN_NNET_BINARISED_FP_H
#define VALJEAN_NNET_BINARISED_FP_H

#include "bnn.h"
#include "mnist_int8_input.h"

void forward_pass(BNN bnn);

void fp_wrapper(BNN bnn, INPT* input_vec, BNN_real* output_vec);

#define PACKED_SIZE (sizeof(BNN_bin) * 8)

BNNS packed_ls(BNN bnn, BNNS layer);
BNN_real xnor_bin_sum(BNN_bin i, BNN_bin w);
BNN_real partial_xnor_bin_sum(BNN_bin i, BNN_bin w, uint32_t bits);
void matrix_mult(
    BNN_bin input[BIN_VEC_SIZE], BNN_real output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][BIN_VEC_SIZE], BNNS last_trunc, BNN_real bias[NODE_MAX]
);

//binarises OUTPUT to be INPUT for next layer (very confusing terminology)
void binarise(BNN_bin input[BIN_VEC_SIZE], const BNN_real output[NODE_MAX], BNNS out_size);
void clamp(BNN_real output[NODE_MAX], BNNS n_outputs, BNNS max);


#endif //VALJEAN_NNET_BINARISED_FP_H
