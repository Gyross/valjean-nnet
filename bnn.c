#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <assert.h>
#include "xorgens.h"
#include "constants.h"
#include "bnn.h"


int bnn_new(BNN bnn, unsigned layers, unsigned layer_sizes[]) {
    static_assert(sizeof(uint64_t) == sizeof(UINT));

    // Set the global num_layers and layer_size variables
    bnn->layers = layers;
    memcpy(bnn->layer_sizes, layer_sizes, layers * sizeof(unsigned));

    // prng seeding
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    xor4096i((UINT)ts.tv_nsec);

    // Generate normally distributed weights and biases for each forward pass step.
    // Remember number of forward pass steps is one less than number of layers.
    for (int i = 0; i < layers; i++) {
        for (int j = 0; j < layer_sizes[i]; j++) {
            for (int k = 0; k < CEIL_DIV(layer_sizes[i], BPF); k++) {
                bnn->weight[i][j][k] = xor4096i(0);
            }
        }
    }

    return 0;
}

int nnet_read_file(char* filename) {
    size_t amt_read;
    FILE* fp = fopen(filename, "rb");

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n");
        return 1;
    }

    amt_read = fread( &num_layers, sizeof(unsigned int), 1, fp );

    if ( num_layers < 2 ) { 
        fprintf( stderr, "Not enough layers specified!\n" );
        return 1;
    } else if ( amt_read != 1 ) { 
        fprintf( stderr, "File empty!\n" );
        return 1;
    }

    amt_read = fread( layer_size, sizeof(unsigned int), num_layers, fp );

    if ( amt_read != num_layers ) {
        fprintf( stderr, "File corrupted!\n" );
    }

    // Allocate for arrays
    // Remember to free if there is an error after this point!
    nnet_allocate();

    int m;
    for ( m = 0; m < num_layers - 1; m++ ) {

        amt_read = fread( weight[m], sizeof(float), layer_size[m]*layer_size[m+1], fp );
        if ( amt_read != layer_size[m]*layer_size[m+1] ) {
            fprintf( stderr, "File corrupted!\n" );
            nnet_free();
            return 1;
        }

        amt_read = fread( bias[m], sizeof(float), layer_size[m+1], fp );
        if ( amt_read != layer_size[m+1] ) {
            fprintf( stderr, "File corrupted!\n" );
            nnet_free();
            return 1;
        }
    }

    fclose(fp);

    return 0;
}


int nnet_write_file(char* filename) {
    FILE* fp = fopen( filename, "wb" );

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n" );
        return 1;
    }

    fwrite( &num_layers, sizeof(unsigned int), 1, fp );
    fwrite( layer_size, sizeof(unsigned int), num_layers, fp);

    int m;    
    for ( m = 0; m < num_layers-1; m++ ) {
        fwrite( weight[m], sizeof(float), layer_size[m]*layer_size[m+1], fp);
        fwrite( bias[m], sizeof(float), layer_size[m+1], fp);
    }

    fclose(fp);
    return 0;
}

int nnet_op(FILE* fp_input, FILE* fp_label, int op_type) {
    unsigned int n_inputs, n_outputs;
    size_t amt_read;
    float input_vec[MAX_LAYER_SIZE];
    float expected_vec[MAX_LAYER_SIZE];
    float output_vec[MAX_LAYER_SIZE];

    float total_cost = 0.0;
    int n_cases = 0;

    // Read number of inputs and outputs expected by file and do some checking
    if (fread( &n_inputs, sizeof(unsigned int), 1, fp_input ) != 1) {
        fprintf( stderr, "File corrupted!\n" );
        return 1;
    }
    
    if ( fread( &n_outputs, sizeof(unsigned int), 1, fp_label ) != 1 ) {
        fprintf( stderr, "File corrupted!\n" );
        return 1;
    }

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    if ( n_inputs != layer_size[0] ) {
        fprintf( stderr, "Incorrect number of inputs!\n" );
        return 1;
    }

    if ( n_outputs != layer_size[num_layers-1] ) {
        fprintf( stderr, "Incorrect number of outputs!\n" );
        return 1;
    }

    // Loop until we reach the end of the file
    while( ( amt_read = fread( input_vec, sizeof(float), n_inputs, fp_input ) ) != 0 ) {
        if ( amt_read != n_inputs) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        } 

        if ( fread( expected_vec, sizeof(float), n_outputs, fp_label ) != n_outputs ) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        }

        forward_pass(input_vec, output_vec);

        if ( op_type == NNET_TRAIN ) {
            backpropagate(expected_vec);
        } 

        // CODE FOR PRINTING OUTPUTS
        if ( op_type == NNET_TEST ) {
            int expected_category = -1;

            // First let's find which category the input
            // should lie in.
            for ( int i = 0; i < n_outputs; i++ ) {
                if ( expected_vec[i] == 1.0 ) {
                    expected_category = i;
                }
            }

            printf("Category: %d, Out: ", expected_category);
            for ( int i = 0; i < n_outputs; i++ ) {
                 printf("%0.2f ", output_vec[i] );
            }
            printf("\n");
        }

        total_cost += cost_func(output_vec, expected_vec, n_outputs);

        n_cases++;
    }

    float avg_cost = total_cost/((float)n_cases);
    float rms_err  = sqrt(avg_cost);
    printf("Average cost: %f\n", avg_cost );
    printf("RMS error:    %f\n", rms_err );

    return 0;
}



