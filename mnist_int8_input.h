//
// Created by wmpmiles on 25/03/19.
//

#ifndef VALJEAN_NNET_MNIST_INT8_INPUT_H
#define VALJEAN_NNET_MNIST_INT8_INPUT_H

#include <stdint.h>
#include "types.h"
#include "bnn.h"

void binarise_input(INPT input[NODE_MAX], BNN_bin output[BIN_VEC_SIZE], BNN_real bias[NODE_MAX], BNNS n_inputs);
void convert_label( LBLT label, BNN_real expected[NODE_MAX], BNNS n_outputs );

#endif //VALJEAN_NNET_MNIST_INT8_INPUT_H
