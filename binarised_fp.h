#ifndef VALJEAN_NNET_BINARISED_FP_H
#define VALJEAN_NNET_BINARISED_FP_H

#include "bnn.h"

void forward_pass(BNN bnn, BNNI input[CEIL_DIV(LAYER_MAX, SIZE(BNNI))], BNNO output[LAYER_MAX]);

#endif //VALJEAN_NNET_BINARISED_FP_H
