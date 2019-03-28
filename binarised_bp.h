#ifndef VALJEAN_NNET_BINARISED_BP_H
#define VALJEAN_NNET_BINARISED_BP_H

#include "bnn.h"
#include "binarised_fp.h"

void bin_matrix_mult_fpvec(
    BNN_real input[NODE_MAX], BNN_real output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][WGT_VEC_SIZE]
);
void back_pass(BNN bnn, BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNO target[NODE_MAX], BNN_real l_r);

#endif //VALJEAN_NNET_BINARISED_FP_H
