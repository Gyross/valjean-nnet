#ifndef VALJEAN_NNET_BINARISED_BP_H
#define VALJEAN_NNET_BINARISED_BP_H

#include "bnn.h"
#include "binarised_fp.h"

void back_pass(BNN bnn, BNNI input[CEIL_DIV(LAYER_MAX, SIZE(BNNI))], BNNO output[LAYER_MAX], BNNO target[LAYER_MAX]);

#endif //VALJEAN_NNET_BINARISED_FP_H
