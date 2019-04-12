#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "binarised_fp.h"
#include "config.h"

void forward_pass(BNN bnn) {

    for ( BNNS i = 0; i < bnn->layers-1; i++ ) { // for each layer
        BNNS inp_size = packed_ls(bnn, i);
        BNNS out_size = bnn->layer_sizes[i+1];

        matrix_mult(
            bnn->b_activations[i], bnn->activations_true[i+1], inp_size, out_size, bnn->weight[i],
            bnn->layer_sizes[i] % SIZE(BNN_bin), bnn->bias[i]
        );

#ifdef DEBUG_FP
        for (int j = 0; j < out_size; j++) {
            printf("%f ", bnn->activations_true[i+1][j]);
        }
        printf("DONE\n");
#endif

        if (i != bnn->layers-2) {
            binarise(bnn->b_activations[i+1], bnn->activations_true[i+1], out_size);
        } else {
            /*for(BNNS j = 0; j < bnn->layer_sizes[bnn->layers-2]; j++) {
                printf("%f\n", bnn->activations_true[i+1][j]);
            }*/
            //clamp(bnn->activations_true[i+1], bnn->layer_sizes[bnn->layers-1], bnn->layer_sizes[bnn->layers-2]);
        }

#ifdef DEBUG_FP
        printf("POST CLAMP/BINARISATION\n");
        for (int j = 0; j < CEIL_DIV(out_size, SIZE(BNN_bin)); j++) {
            printf("%f ", bnn->bias[i-1][j]);
        }
        printf("\n");
#endif
    }
}

void fp_wrapper( BNN bnn, INPT* input_vec, BNN_real* output_vec ) { 

    fprintf(stderr, "Enetered fp_wrapper\n");
    // Clear activations fields
    memset(bnn->activations_true, 0, NODE_MAX * LAYER_MAX * sizeof(BNN_real));
    memset(bnn->b_activations, 0, BIN_VEC_SIZE * LAYER_MAX * sizeof(BNN_bin));
    
    // Binarize inputs & put in b_activations
    binarise_input(input_vec, bnn->b_activations[0], bnn->bias[0], bnn->layer_sizes[0]);
    
    // Copy raw inputs into activations_true
    for(BNNS i = 0; i < bnn->layer_sizes[0]; i++) {
        bnn->activations_true[0][i] = (BNN_real)(input_vec[i]);
    }

    #ifdef DEBUG_IPT
        printf("nbinput:\n");
        for (BNNS i = 0; i < bnn->layer_sizes[0]; i++) {
            printf("%d\n", input_vec[i]);
            printf("%f\n", (BNN_real)input_vec[i]);
        }
        printf("binput:\n");
        for (BNNS i = 0; i < bnn->layer_sizes[0]; i++) {
            printf("%u\n", bnn->b_activations[0][i]);
        }
    #endif

    // Perform the forward pass
    forward_pass(bnn);

    // Copy outputs into output_vec
    memcpy(output_vec, bnn->activations_true[bnn->layers-1], 
           sizeof(BNN_real) * bnn->layer_sizes[bnn->layers-1]);

    fprintf(stderr, "Left fp_wrapper\n");
}

BNNS packed_ls(BNN bnn, BNNS layer) {
    return CEIL_DIV(bnn->layer_sizes[layer], SIZE(BNN_bin));
}

void matrix_mult(
    BNN_bin input[BIN_VEC_SIZE], BNN_real output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][BIN_VEC_SIZE], BNNS last_trunc, BNN_real bias[NODE_MAX]
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

BNN_real xnor_bin_sum(BNN_bin i, BNN_bin w) {
    return (BNN_real) __builtin_popcount(~(i^w)) - (PACKED_SIZE / 2);
}

BNN_real partial_xnor_bin_sum(BNN_bin i, BNN_bin w, BNNS bits) {
    BNN_bin xnored =  (BNN_bin) ~(i^w);
    BNN_bin mask = (BNN_bin)((1 << bits) - 1);
    int out = (2 * __builtin_popcount(xnored & mask) - bits);
    return (BNN_real) out;
}

void binarise(BNN_bin input[BIN_VEC_SIZE], const BNN_real output[NODE_MAX], BNNS out_size) {
    for (BNNS j = 0; j < out_size; j += PACKED_SIZE) { // for each output value
        int input_index = j / PACKED_SIZE;
        for (int k = PACKED_SIZE - 1; k >= 0; k--) { // high to low bits for efficient shifting
            input[input_index] <<= 1;
            input[input_index] += output[j + k] >= 0 ? 1 : 0;
        }
    }
}

void clamp(BNN_real output[NODE_MAX], BNNS n_outputs, BNNS max) {
    for (size_t i = 0; i < n_outputs; i++) {
        output[i] = fabsf(output[i]) > max ? ((BNN_real)max * (output[i] >= 0 ? 1 : -1)) : output[i];
    }
}
