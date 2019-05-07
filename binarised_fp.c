#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "binarised_fp.h"
#include "config.h"
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define NUM_SEG 10
#define NUM_UNIT 8
#define FINAL_OUT_LAYER 10

#define MMAP_LENGTH 0x1000

volatile uint32_t* a;
volatile int fd;

void forward_pass_setup(BNN bnn) {
    // Initialize AXI-lite communication
    fd = open("/dev/mem", O_RDWR);
    a = mmap(NULL, MMAP_LENGTH, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x43C00000);

    send_weights(a, bnn);
}

void forward_pass_cleanup(void) {
    munmap(a, MMAP_LENGTH);
    close(fd);
}

void forward_pass(BNN bnn) {

    //clock_t begin = clock();

    send_inputs(a, bnn->b_activations[0], packed_ls(bnn, 0));

    read_outputs(a, bnn->activations_true[bnn->layers-1], bnn->layer_sizes[bnn->layers-1]);

    //clock_t end = clock();
    //double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    //printf("Time: %lf\n", time_spent);

}

void fp_wrapper( BNN bnn, INPT* input_vec, BNN_real* output_vec ) { 

    // Binarize inputs & put in b_activations
    binarise_input(input_vec, bnn->b_activations[0], bnn->bias[0], bnn->layer_sizes[0]);
    
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
    int count = 0;

    int segments[NUM_SEG] = {0, 8, 16, 24, 0, 8, 16, 24, 0, 8};
    int layers[NUM_SEG]   = {0, 0,  0,  0, 1, 1,  1,  1, 2, 2};

    for (int unit = 0; unit < NUM_UNIT; unit++) {
	for (int seg = 0; seg < NUM_SEG; seg++) {    
    
            BNNS input_size = packed_ls(bnn, layers[seg]);
	    
	    // send row of inputs at location 'seg'
	    for (int in = 0; in < input_size; in++) {
		BNN_bin weight;
		if (layers[seg] == 2 && segments[seg]+unit >= FINAL_OUT_LAYER) {
		    weight = 0;
		} else {
		    weight = bnn->weight[layers[seg]][segments[seg]+unit][in];
		}

		a[0] = weight & 0xFFFF;
	        count++;
		if (in != 24) {
		    a[0] = (weight >> 16) & 0xFFFF;
		    count++;
		}
	    }
	}
    }    
    //printf("weight_count=%d\n", count);        
}


void send_inputs(volatile uint32_t* a, BNN_bin input[BIN_VEC_SIZE], BNNS input_size) {

    for (int i = 0; i < input_size; i++) {
        a[1] = input[i] & 0xFFFF;    
        if (i < input_size-1)
            a[1] = (input[i] >> 16) & 0xFFFF;    
    }
}


void read_outputs(volatile uint32_t* a, BNN_real output[NODE_MAX], BNNS output_size) {
        
    for (int i = 0; i < output_size; i++) {
        uint32_t out = a[2];        
        if (out & 0x8000) out = out | 0xFFFF0000;
        output[i] = *((int32_t *)(&out));
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
