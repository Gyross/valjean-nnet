//
// Created by wmpmiles on 25/03/19.
//

#ifndef VALJEAN_NNET_MNIST_INT8_INPUT_H
#define VALJEAN_NNET_MNIST_INT8_INPUT_H

#include <stdint.h>
#include "bnn.h"

typedef int8_t  INPT;
typedef uint8_t LBLT;

void binarise_input(INPT input[NODE_MAX], BNN_bin output[BIN_VEC_SIZE], BNN_real bias[NODE_MAX], BNNS n_inputs);
void convert_labels(LBLT input[NODE_MAX], BNN_real output[NODE_MAX], BNNS n_outputs, BNNS max);

#endif //VALJEAN_NNET_MNIST_INT8_INPUT_H
