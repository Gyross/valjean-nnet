#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "binarised_fp.h"
#include "config.h"
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define MAX_SEG 32
#define NUM_SEG 4
#define FINAL_OUT_LAYER 10

void forward_pass(BNN bnn) {

	// Initialize AXI-lite communication
	volatile uint32_t* a;
	int fd;
	fd = open("/dev/mem", O_RDWR);
	a = mmap(NULL, 0x1000, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x43C00000);
	

	send_weights(a, bnn);

	send_inputs(a, bnn->b_activations[0], packed_ls(bnn, 0));

	read_outputs(a, bnn->activations_true[bnn->layers-1], bnn->layer_sizes[bnn->layers-1]);

}

void fp_wrapper( BNN bnn, INPT* input_vec, BNN_real* output_vec ) { 

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
}

void send_weights(volatile uint32_t* a, BNN bnn) {

	int segments[NUM_SEG] = {0, 8, 16, 24};
	int data_sent = 0;


	while (data_sent != 1) {
		
		for (int i = 0; i < bnn->layers-1; i++) {	
			
			BNNS input_size = packed_ls(bnn, i);
			BNNS output_size = bnn->layer_sizes[i+1];

			// For each segment
			for (int seg = 0; seg < NUM_SEG; seg++) {
				
				if (segments[seg] <= output_size) {	
				
					// send row of inputs at location 'seg'
					for (int in = 0; in < input_size; in++) {
						a[0] = bnn->weight[i][seg][in] && 0xFF;
						a[0] = bnn->weight[i][seg][in] && 0xFF00;
					}
				
				// In the case of this being the final output layer (size 10)
				// We need to pad with 0 for the second segment
				} else if (segments[seg] >= output_size && seg == 1 && output_size == FINAL_OUT_LAYER) {
					a[0] = 0;
					a[0] = 0;
				} 
			}
		}

		for (int i = 0; i < NUM_SEG; i++) {
			segments[i] += 1;
			
			if (segments[i] >= MAX_SEG) {
				data_sent = 1;
			}
		} 
	}	
		
}


void send_inputs(volatile uint32_t* a, BNN_bin input[BIN_VEC_SIZE], BNNS input_size) {

	for (int i = 0; i < input_size; i++) {
		a[1] = input[i] && 0xFF;	
		a[1] = input[i] && 0xFF00;	
	}
}


void read_outputs(volatile uint32_t* a, BNN_real output[NODE_MAX], BNNS output_size) {
	
	for (int i = 0; i < output_size; i++) {
		output[i] = a[2];		
	}
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
