#include "mnist_int8_input.h"
#include "xorgens.h"

#define MIN -128
#define MAX 127

int stochastic_binarise(int val);

// TODO: handle non multiple of 32 input vector properly
void binarise_input(INPT input[NODE_MAX], BNNI output[INP_VEC_SIZE], BNNB bias[NODE_MAX], BNNS n_inputs) {
    for (size_t i = 0; i < n_inputs; i+=SIZE(BNNI)) {
        for (ssize_t k = SIZE(BNNI)-1; k >= 0; k--) {
            output[i/SIZE(BNNI)] <<= 1;
            output[i/SIZE(BNNI)] += stochastic_binarise(input[i+k]+bias[i+k]); // potentially an overflow issue
        }
    }
}

int stochastic_binarise(int val) {
    int decider = (xor4096i(0) % (MAX - MIN)) + MIN;
    int ret = val >= decider ? 1 : 0;
    return ret;
}

void convert_labels(LBLT input[NODE_MAX], BNNO output[NODE_MAX], BNNS n_outputs, BNNS max) {
    for (size_t i = 0; i < n_outputs; i++) {
        output[i] = (BNNO)input[i] == 1 ? max : -max;
    }
}
