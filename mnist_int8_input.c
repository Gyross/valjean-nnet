#include "mnist_int8_input.h"
#include "xorgens.h"

#define MIN -128
#define MAX 127

int stochastic_binarise(int val);

// handles non-multiples of 32 by generating garbage in the upper bits, which is fine as
// those bits won't be accessed by anything relevant
void binarise_input(INPT input[NODE_MAX], BNN_bin output[BIN_VEC_SIZE], BNN_real bias[NODE_MAX], BNNS n_inputs) {
    for (size_t i = 0; i < n_inputs; i+=SIZE(BNN_bin)) {
        for (ssize_t k = SIZE(BNN_bin)-1; k >= 0; k--) {
            output[i/SIZE(BNN_bin)] <<= 1;
            output[i/SIZE(BNN_bin)] += stochastic_binarise((signed)input[i+k]+(signed)bias[i+k]);
        }
    }
}

int stochastic_binarise(int val) {
    int decider = (xor4096i(0) % (MAX - MIN)) + MIN;
    int ret = val >= decider ? 1 : 0;
    return ret;
}

void convert_labels(LBLT input[NODE_MAX], BNN_real output[NODE_MAX], BNNS n_outputs, BNNS max) {
    for (size_t i = 0; i < n_outputs; i++) {
        output[i] = (BNN_real)input[i] == 1 ? max : -max;
    }
}
