#include <string.h>
#include <stdio.h>
#include <math.h>
#include "binarised_bp.h"
#include "nnet_math.h"

void back_pass(BNN bnn, BNNO target[NODE_MAX], BNN_real l_r) {
	
	BNN_real weight_grads[LAYER_MAX][NODE_MAX][NODE_MAX] = {0};
	BNN_real act_grads_real[LAYER_MAX][NODE_MAX] = {0};
	BNN_real act_grads_bin[LAYER_MAX][NODE_MAX] = {0};
	BNNS last_layer = bnn->layers - 1;
	
	for (BNNS j = 0; j < bnn->layer_sizes[last_layer]; j++) {
			act_grads_real[last_layer][j] = bnn->output[j] - target[j];
		}
	
	for (BNNS i = last_layer; i >= 1; i--) {		// for each layer
		if (i < last_layer) {
			for (BNNS j = 0; j < bnn->layer_sizes[i]; j++) {
				act_grads_real[i][j] = (fabsf(bnn->activations_true[i][j])<= 1) ? 1 : 0;
			}
		}
		for (BNNS j = 0; j < bnn->layer_sizes[i-1]; j++) {		// for each set of weights to a node in the layer below
			act_grads_real[i-1][j] = 0;
			for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {		// for each node in the layer above
				weight_grads[i][j][k] = act_grads_real[i][k] * bnn->activations_true[i-1][j];
			}
			bin_matrix_mult_fpvec(act_grads_real[i], act_grads_bin[i-1], bnn->layer_sizes[i], bnn->layer_sizes[i-1],
			bnn->weight[i]);
			
			//Update:
			for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {
				bnn->weight_true[i][j][k] -= l_r * weight_grads[i][j][k];
			}
			binarise( (BNNI *) bnn->weight_true[i][j], (BNNO *) bnn->weight[i][j], bnn->layer_sizes[i]);
		}
    }
	

}



void bin_matrix_mult_fpvec(
    BNN_real input[NODE_MAX], BNN_real output[NODE_MAX], BNNS inp_size, BNNS out_size,
    BNN_bin weights[NODE_MAX][WGT_VEC_SIZE]
) {
    BNNS k, j;
    for ( BNNS j = 0; j < out_size; j++ ) { // for each output node
        for ( BNNS k = 0; k < CEIL_DIV(inp_size, SIZE(BNN_bin)); k++ ) { // for each input node
            output[j] = 0;
			for (BNNS m = 0; m < SIZE(BNN_bin); m++) {
				BNNS idx = k*SIZE(BNN_bin)+m;
				if (idx < inp_size) {
					float sign = weights[j][k] & (1 << m) ? 1 : -1;
					output[j] += input[idx] * sign;
				}
			}
        }
    }
}