#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "binarised_bp.h"
#include "config.h"

void back_pass(BNN bnn, BNN_real target[NODE_MAX], BNN_real l_r) {
	
	BNN_real ***weight_grads;
	BNN_real act_grads_real[LAYER_MAX][NODE_MAX];
	BNN_real act_grads_bin[LAYER_MAX][NODE_MAX];
	BNNS last_layer = bnn->layers - 1;
	
    
    weight_grads = calloc(LAYER_MAX-1, sizeof(BNN_real **));
    assert(weight_grads != NULL);
	for (BNNS i = 0; i < LAYER_MAX - 1; i++) {
        weight_grads[i] = calloc(NODE_MAX, sizeof(BNN_real *));
        assert(weight_grads[i] != NULL);
        for (BNNS j = 0; j < NODE_MAX; j++) {
            weight_grads[i][j] = calloc(NODE_MAX, sizeof(BNN_real));
            assert(weight_grads[i][j] != NULL);
        }
	}
	memset(act_grads_real, 0, LAYER_MAX * NODE_MAX *  sizeof(BNN_real));
	memset(act_grads_bin, 0, LAYER_MAX * NODE_MAX * sizeof(BNN_real));
	
    BNN_real exponents[NODE_MAX];
    BNN_real exp_sum = 0;
	
    for (BNNS j = 0; j < bnn->layer_sizes[last_layer]; j++) {
        exponents[j] = exp(bnn->activations_true[last_layer][j]);
        exp_sum += exponents[j];
    }
    
	for (BNNS j = 0; j < bnn->layer_sizes[last_layer]; j++) {
        act_grads_real[last_layer][j] = exponents[j]/exp_sum - target[j];
    }
	
	for (int i = last_layer-1; i >= 0; i--) {		// for each layer
		if (i < last_layer-1) {
			for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
                act_grads_real[i+1][j] = act_grads_bin[i+1][j]; //* ((fabsf(bnn->activations_true[i][j])<= 1) ? 1 : 0);
			}
		}
		for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {		// for each set of weights to a node in the layer below
			act_grads_real[i][k] = 0;
			for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {		// for each node in the layer above
				weight_grads[i][j][k] = act_grads_real[i+1][j] * bnn->activations_true[i][k];
			}
			
			//Update:
			for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
				bnn->weight_true[i][j][k] -= l_r * weight_grads[i][j][k];
			}
        }
        bin_matrix_mult_fpvec(act_grads_real[i+1], act_grads_bin[i], bnn->layer_sizes[i+1], bnn->layer_sizes[i], bnn->weight[i]);
        
		for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
			binarise( bnn->weight[i][j],  bnn->weight_true[i][j], bnn->layer_sizes[i]);
		}
        
        #ifdef TESTING_BP
        printf("BACKPASS OUTPUTS\n");
        for (BNNS i = 0; i < bnn->layers; i++) {
            printf("LAYER %u\n", i);
            for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {
                printf("OUTPUT NODE %u\n", k);
                printf("act grad real: %f\n", act_grads_real[i][k]);
                printf("act grad bin: %f\n", act_grads_bin[i][k]);
                printf("WEIGHT GRADS:\n");
                for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
                    printf("%f, ", weight_grads[i][j][k]);
                }
                printf("\n");
            }
        }
        #endif
    }
    
    
    for (BNNS i = 0; i < LAYER_MAX - 1; i++) {
        for (BNNS j = 0; j < NODE_MAX; j++) {
            free(weight_grads[i][j]);
        }
        free(weight_grads[i]);
    }
    free(weight_grads);
	

}



void bin_matrix_mult_fpvec(
    BNN_real input[NODE_MAX], BNN_real output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][BIN_VEC_SIZE]
) {
    for ( BNNS j = 0; j < out_size; j++) {
        output[j] = 0;
    }
    for ( BNNS k = 0; k < inp_size; k++) { // for each input node
        for (BNNS m = 0; m < CEIL_DIV(out_size, SIZE(BNN_bin)); m++) {
            for (BNNS j = 0; j < SIZE(BNN_bin); j++) {
                BNNS idx = m*SIZE(BNN_bin) + j;
                if (idx < out_size) {
                    float sign = weights[k][m] & (1 << j) ? 1 : -1;
                    output[idx] += input[k] * sign;
                }
            }
        }
    }
}
