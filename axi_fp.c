#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "binarised_fp.h"
#include "axi_fp.h"
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

void axi_fp_setup(BNN bnn) {
    // Initialize AXI-lite communication
    fd = open("/dev/mem", O_RDWR);
    a = mmap(NULL, MMAP_LENGTH, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x43C00000);

    send_weights(a, bnn);
}

void axi_fp_cleanup(void) {
    //munmap((void *)a, MMAP_LENGTH);
    close(fd);
}

void axi_fp_wrapper( BNN bnn, INPT* input_vec, BNN_real* output_vec ) { 

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
    axi_fp(bnn);

    // Copy outputs into output_vec
    memcpy(output_vec, bnn->activations_true[bnn->layers-1], 
           sizeof(BNN_real) * bnn->layer_sizes[bnn->layers-1]);
}


void axi_fp(BNN bnn) {
    //clock_t begin = clock();

    send_inputs(a, bnn->b_activations[0], packed_ls(bnn, 0));

    read_outputs(a, bnn->activations_true[bnn->layers-1], bnn->layer_sizes[bnn->layers-1]);

    //clock_t end = clock();
    //double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    //printf("Time: %lf\n", time_spent);

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

                a[0] = weight & 0x0000FFFF;
                count++;

                if (in != 24) {
                    a[0] = (weight >> 16) & 0x0000FFFF;
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
