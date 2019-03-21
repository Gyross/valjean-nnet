#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "xorgens.h"
#include "bnn.h"
#include "binarised_fp.h"


void bnn_new(BNN bnn, unsigned layers, unsigned layer_sizes[]) {
    static_assert(sizeof(BNNW) == sizeof(UINT), "UINT and weight bucket size does not match.\n");

    // Set the global num_layers and layer_size variables
    bnn->layers = layers;
    memcpy(bnn->layer_sizes, layer_sizes, layers * sizeof(BNNS));

    // Generate normally distributed weights and biases for each forward pass step.
    // Remember number of forward pass steps is one less than number of layers.
    for (BNNS i = 0; i < layers; i++) {
        for (BNNS j = 0; j < layer_sizes[i]; j++) {
            for (BNNS k = 0; k < CEIL_DIV(layer_sizes[i], SIZE(BNNW)); k++) {
                bnn->weight[i][j][k] = xor4096i(0);
            }
        }
    }
}

int bnn_read(BNN bnn, const char* filename) {
    size_t amt_read;
    FILE* fp = fopen(filename, "rb");

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n");
        return 1;
    }

    amt_read = fread( &(bnn->layers), sizeof(unsigned), 1, fp );

    if ( amt_read != 1 ) {
        fprintf( stderr, "File empty!\n" );
        return 1;
    } else if ( bnn->layers < 2 ) {
        fprintf( stderr, "Not enough layers specified!\n" );
        return 1;
    }

    amt_read = fread( bnn->layer_sizes, sizeof(unsigned), bnn->layers, fp );

    if ( amt_read != bnn->layers ) {
        fprintf( stderr, "File corrupted!\n" );
    }

    for ( BNNS m = 0; m < bnn->layers-1; m++ ) {
        BNNS wm_size = CEIL_DIV(bnn->layer_sizes[m] * bnn->layer_sizes[m+1], SIZE(BNNW));
        amt_read = fread( bnn->weight[m], sizeof(BNNW), wm_size, fp );
        if ( amt_read != wm_size ) {
            fprintf( stderr, "File corrupted!\n" );
            return 1;
        }

        BNNS bv_size = bnn->layer_sizes[m+1];
        amt_read = fread( bnn->bias[m], sizeof(BNNB), bv_size, fp );
        if ( amt_read != bv_size ) {
            fprintf( stderr, "File corrupted!\n" );
            return 1;
        }
    }

    fclose(fp);

    return 0;
}


int bnn_write(BNN bnn, const char* filename) {
    FILE* fp = fopen( filename, "wb" );

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n" );
        return 1;
    }

    fwrite( &(bnn->layers), sizeof(BNNS), 1, fp );
    fwrite( bnn->layer_sizes, sizeof(BNNS), bnn->layers, fp);

    for ( BNNS m = 0; m < bnn->layers-1; m++ ) {
        BNNS wm_size = CEIL_DIV(bnn->layer_sizes[m] * bnn->layer_sizes[m+1], SIZE(BNNW));
        BNNS bv_size = bnn->layer_sizes[m+1];
        fwrite( bnn->weight[m], sizeof(BNNW), wm_size, fp);
        fwrite( bnn->bias[m], sizeof(BNNB), bv_size, fp);
    }

    fclose(fp);
    return 0;
}

int bnn_op(BNN bnn, FILE* fp_input, FILE* fp_label, int op_type) {
    BNNS n_inputs, n_outputs;
    size_t amt_read;
    BNNI input_vec[INP_VEC_SIZE];
    BNNO expected_vec[NODE_MAX];
    BNNO output_vec[NODE_MAX];

    BNNO total_cost = 0;
    int n_cases = 0;

    // Read number of inputs and outputs expected by file and do some checking
    if (fread( &n_inputs, sizeof(BNNS), 1, fp_input ) != 1) {
        fprintf( stderr, "File corrupted!\n" );
        return 1;
    }
    
    if ( fread( &n_outputs, sizeof(BNNS), 1, fp_label ) != 1 ) {
        fprintf( stderr, "File corrupted!\n" );
        return 1;
    }

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    if ( n_inputs != bnn->layer_sizes[0] ) {
        fprintf( stderr, "Incorrect number of inputs!\n" );
        return 1;
    }

    if ( n_outputs != bnn->layer_sizes[bnn->layers-1] ) {
        fprintf( stderr, "Incorrect number of outputs!\n" );
        return 1;
    }

    // Loop until we reach the end of the file
    size_t n_input_blocks = CEIL_DIV(n_inputs, SIZE(BNNI));
    while( ( amt_read = fread( input_vec, sizeof(BNNI), n_input_blocks, fp_input ) ) != 0 ) {
        if ( amt_read != n_input_blocks ) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        } 

        if ( fread( expected_vec, sizeof(BNNO), n_outputs, fp_label ) != n_outputs ) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        }

        forward_pass(bnn, input_vec, output_vec);

        if ( op_type == OP_TRAIN ) {
            //backpropagate(expected_vec);
        } 

        // CODE FOR PRINTING OUTPUTS
        if ( op_type == OP_TEST ) {
            int expected_category = -1;

            // First let's find which category the input
            // should lie in.
            for ( BNNS i = 0; i < n_outputs; i++ ) {
                if ( expected_vec[i] > 0 ) {
                    expected_category = i;
                    break;
                }
            }

            printf("Category: %d, Out: ", expected_category);
            for ( BNNS i = 0; i < n_outputs; i++ ) {
                 printf("%d ", output_vec[i] );
            }
            printf("\n");
        }

        //total_cost += cost_func(output_vec, expected_vec, n_outputs);

        n_cases++;
    }

    double avg_cost = total_cost/((float)n_cases);
    double rms_err  = sqrt(avg_cost);
    printf("Average cost: %lf\n", avg_cost );
    printf("RMS error:    %lf\n", rms_err );

    return 0;
}



