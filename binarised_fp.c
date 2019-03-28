#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "binarised_fp.h"

void forward_pass(BNN bnn, INPT nb_input[NODE_MAX], BNNO output[NODE_MAX]) {
    BNNI input[INP_VEC_SIZE] = {0};
    binarise_input(nb_input, input, bnn->bias[0], bnn->layer_sizes[0]);

    for ( BNNS i = 0; i < bnn->layers-1; i++ ) { // for each layer
        BNNS inp_size = packed_ls(bnn, i);
        BNNS out_size = bnn->layer_sizes[i+1];
        memset(output, 0, NODE_MAX * sizeof(BNNO));

        matrix_mult(
            input, output, inp_size, out_size, bnn->weight[i],
            bnn->layer_sizes[i] % SIZE(BNNI), bnn->bias[i]
        );
		
		memcpy(bnn->activations_true[i], (BNNA_S) output, NODE_MAX * sizeof(BNNA_S));

#ifdef DEBUG
        for (int j = 0; j < out_size; j++) {
            printf("%d ", output[j]);
        }
        printf("\n");
#endif

        if (i != bnn->layers-2) {
            binarise(input, output, out_size);
			memcpy(bnn->b_activations[i], (BNNA_U) input, INP_VEC_SIZE * sizeof(BNNA_U));
        } else {
            clamp(output, bnn->layer_sizes[bnn->layers-1], bnn->layer_sizes[bnn->layers-2]);
        }

#ifdef DEBUG
        for (int j = 0; j < CEIL_DIV(out_size, SIZE(BNNI)); j++) {
            printf("%x ", input[j]);
        }
        printf("\n");
#endif
    }
}

BNNS packed_ls(BNN bnn, BNNS layer) {
    return CEIL_DIV(bnn->layer_sizes[layer], SIZE(BNNI));
}

void matrix_mult(
    BNNI input[INP_VEC_SIZE], BNNO output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNNW weights[NODE_MAX][WGT_VEC_SIZE], BNNS last_trunc, BNNB bias[NODE_MAX]
) {
    BNNS k, j;
    for ( j = 0; j < out_size; j++ ) { // for each output node
        for ( k = 0; k < inp_size-1; k++ ) { // for each input node
            output[j] += xnor_bin_sum(input[k], weights[j][k]);
        }
        if (last_trunc == 0) {
            output[j] += xnor_bin_sum(input[k], weights[j][k]);
        }
        else {
            output[j] += partial_xnor_bin_sum(input[k], weights[j][k], last_trunc);
        }
        output[j] += bias[j];
    }
}

BNNO xnor_bin_sum(BNNI i, BNN_bin w) {
    return __builtin_popcount(~(i^w)) - (PACKED_SIZE / 2);
}

BNNO partial_xnor_bin_sum(BNNI i, BNNW w, BNNS bits) {
    BNNO xnored = ~(i^w);
    BNNO mask = (BNNO)((1 << bits) - 1);
    return 2 * __builtin_popcount(xnored & mask) - bits;
}

void binarise(BNNI input[INP_VEC_SIZE], const BNNO output[NODE_MAX], BNNS out_size) {
    for (BNNS j = 0; j < out_size; j += PACKED_SIZE) { // for each output value
        for (int k = PACKED_SIZE - 1; k >= 0; k--) { // high to low bits for efficient shifting
            input[j / PACKED_SIZE] <<= 1;
            input[j / PACKED_SIZE] += output[j + k] >= 0 ? 1 : 0;
        }
    }
}

void clamp(BNNO output[NODE_MAX], BNNS n_outputs, BNNS max) {
    for (size_t i = 0; i < n_outputs; i++) {
        output[i] = abs(output[i]) > max ? (max * (output[i] >= 0 ? 1 : -1)) : output[i];
    }
}
