#include <string.h>
#include <stdio.h>
#include "binarised_fp.h"

#define PACKED_SIZE (sizeof(BNNI) * 8)

static BNNS packed_ls(BNN bnn, BNNS layer);
static BNNO bin_sum(BNNI i, BNNW w);

void forward_pass(BNN bnn, BNNI input[INP_VEC_SIZE], BNNO output[LAYER_MAX]) {

    for ( BNNS i = 0; i < bnn->layers-1; i++ ) { // for each layer
        BNNS inp_size = packed_ls(bnn, i);
        BNNS out_size = bnn->layer_sizes[i+1];
        memset(output, 0, out_size * sizeof(BNNO));

        for ( BNNS j = 0; j < out_size; j++ ) { // for each output node
            for ( BNNS k = 0; k < inp_size; k++ ) { // for each input node
                output[j] += bin_sum(input[k], bnn->weight[i][j][k]);
            }
        }

        // binarise
        if (i != bnn->layers-1) {
            for (BNNS j = 0; j < out_size; j += PACKED_SIZE) { // for each output value
                for (int k = PACKED_SIZE - 1; k >= 0; k--) { // for each bit in reverse
                    input[j / PACKED_SIZE] <<= 1;
                    input[j / PACKED_SIZE] += output[j + k] >= 0 ? 1 : 0;
                }
            }
        }
#ifdef DEBUG
        else {
            for ( BNNS j = 0; j < out_size; j++ ) {
                printf("%d\n", output[j]);
            }
        }
#endif
    }
}

BNNS packed_ls(BNN bnn, BNNS layer) {
    return CEIL_DIV(bnn->layer_sizes[layer], SIZE(BNNI));
}

static BNNO bin_sum(BNNI i, BNNW w) {
    return __builtin_popcount(~(i^w)) - (PACKED_SIZE / 2);
}
