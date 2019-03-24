#ifndef VALJEAN_NNET_BINARISED_FP_H
#define VALJEAN_NNET_BINARISED_FP_H

#include "bnn.h"

void forward_pass(BNN bnn, BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX]);

#endif //VALJEAN_NNET_BINARISED_FP_H
