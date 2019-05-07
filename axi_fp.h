#ifndef VALJEAN_NNET_AXI_FP_H
#define VALJEAN_NNET_AXI_FP_H

#include "bnn.h"
#include "mnist_int8_input.h"

void axi_fp_setup(BNN bnn);
void axi_fp_cleanup(void);

void axi_fp(BNN bnn);

void axi_fp_wrapper(BNN bnn, INPT* input_vec, BNN_real* output_vec);

void send_weights(volatile uint32_t* a, BNN bnn);
void send_inputs(volatile uint32_t* a, BNN_bin input[BIN_VEC_SIZE], BNNS input_size);
void read_outputs(volatile uint32_t* a, BNN_real output[NODE_MAX], BNNS output_size);

#endif //VALJEAN_NNET_AXI_FP_H
