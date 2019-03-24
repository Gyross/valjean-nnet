#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "xorgens.h"
#include "bnn.h"
#include "binarised_fp.h"
#include "error_handling.h"


static void print_output(
    const BNNO expected_vec[NODE_MAX], const BNNO output_vec[NODE_MAX], BNNS n_outputs
);
static BNNO cost_func(
    const BNNO expected_vec[NODE_MAX], const BNNO output_vec[NODE_MAX], BNNS n_outputs
);
static void print_statistics(BNNO total_cost, unsigned n_cases);


void bnn_new(BNN bnn, unsigned layers, unsigned layer_sizes[]) {
    static_assert(sizeof(BNNW) == sizeof(UINT), "UINT and weight bucket size does not match.\n");

    // Set the global num_layers and layer_size variables
    bnn->layers = layers;
    memcpy(bnn->layer_sizes, layer_sizes, layers * sizeof(BNNS));

    // Generate uniformly distributed weights and biases for each forward pass step.
    // There are layers-1 number of weight matrices as they lie between layers
    for (BNNS i = 0; i < layers-1; i++) {
        for (BNNS j = 0; j < layer_sizes[i+1]; j++) {
            for (BNNS k = 0; k < CEIL_DIV(layer_sizes[i], SIZE(BNNW)); k++) {
                bnn->weight[i][j][k] = xor4096i(0);
            }
        }
    }
}

int bnn_read(BNN bnn, const char* filename) {
    MSG("BNN file successfully parsed.");

    size_t amt_read;
    FILE* fp = fopen(filename, "rb");

    CHECK(fp == NULL, "Could not open file!", 1);

    amt_read = fread( &(bnn->layers), sizeof(unsigned), 1, fp );

    CHECK(amt_read != 1, "File empty!\n", 2);
    CHECK(bnn->layers < 2, "Not enough layers specified!", 2);

    amt_read = fread( bnn->layer_sizes, sizeof(unsigned), bnn->layers, fp );

    CHECK(amt_read != bnn->layers, "File corrupted!", 2);

    for ( BNNS m = 0; m < bnn->layers-1; m++ ) {
        BNNS wm_size = CEIL_DIV(bnn->layer_sizes[m] * bnn->layer_sizes[m+1], SIZE(BNNW));
        amt_read = fread( bnn->weight[m], sizeof(BNNW), wm_size, fp );
        CHECK(amt_read != wm_size, "File corrupted!", 2);
    }

    for ( BNNS m = 0; m < bnn->layers; m++ ) {
        BNNS b_size = bnn->layer_sizes[m];
        amt_read = fread( bnn->bias[m], sizeof(BNNB), b_size, fp );
        CHECK(amt_read != b_size, "File corrupted!", 2);
    }

error2:
    fclose(fp);

error1:
    RETURN;
}


int bnn_write(BNN bnn, const char* filename) {
    MSG("BNN successfully saved to file.");

    size_t amt_written;
    FILE* fp = fopen( filename, "wb" );

    CHECK(fp == NULL, "Could not open file!\n", 1);

    amt_written = fwrite( &(bnn->layers), sizeof(BNNS), 1, fp );
    CHECK(amt_written == 1, "Failed to save BNN to file.", 2);

    amt_written = fwrite( bnn->layer_sizes, sizeof(BNNS), bnn->layers, fp);
    CHECK(amt_written == bnn->layers, "Failed to save BNN to file.", 2);

    for ( BNNS m = 0; m < bnn->layers-1; m++ ) {
        BNNS wm_size = CEIL_DIV(bnn->layer_sizes[m] * bnn->layer_sizes[m+1], SIZE(BNNW));
        amt_written = fwrite( bnn->weight[m], sizeof(BNNW), wm_size, fp);
        CHECK(amt_written == wm_size, "Failed to save BNN to file.", 2);
    }

    for ( BNNS m = 0; m < bnn->layers; m++ ) {
        BNNS b_size = bnn->layer_sizes[m];
        amt_written = fwrite( bnn->bias[m], sizeof(BNNB), b_size, fp);
        CHECK(amt_written == b_size, "Failed to save BNN to file.", 2);
    }

error2:
    fclose(fp);

error1:
    RETURN;
}

int bnn_op(BNN bnn, FILE* fp_input, FILE* fp_label, op_t op_type) {
    MSG("Successfully completed operation.");

    BNNS n_inputs, n_outputs;
    size_t amt_read;
    BNNI input_vec[INP_VEC_SIZE];
    BNNO expected_vec[NODE_MAX];
    BNNO output_vec[NODE_MAX];

    BNNO total_cost = 0;
    unsigned n_cases = 0;

    // Read number of inputs and outputs expected by file and do some checking
    CHECK(fread( &n_inputs, sizeof(BNNS), 1, fp_input ) != 1, "File corrupted!", 1);
    CHECK(fread( &n_outputs, sizeof(BNNS), 1, fp_label ) != 1, "File corrupted!", 1);

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    CHECK(n_inputs != bnn->layer_sizes[0], "Incorrect number of inputs!", 1);
    CHECK(n_outputs != bnn->layer_sizes[bnn->layers-1], "Incorrect number of outputs!", 1);

    // Loop until we reach the end of the file
    size_t n_input_blocks = CEIL_DIV(n_inputs, SIZE(BNNI));
    while( ( amt_read = fread( input_vec, sizeof(BNNI), n_input_blocks, fp_input ) ) != 0 ) {
        CHECK(amt_read != n_input_blocks, "Incorrect number of bytes!", 1);

        CHECK(
            fread( expected_vec, sizeof(BNNO), n_outputs, fp_label ) != n_outputs,
            "Incorrect number of bytes!", 1
        );

        forward_pass(bnn, input_vec, output_vec);

        if ( op_type == TRAIN ) {
            //backpropagate(expected_vec);
        }
        else if ( op_type == TEST ) {
            print_output(expected_vec, output_vec, n_outputs);
        }

        total_cost += cost_func(output_vec, expected_vec, n_outputs);

        n_cases++;
    }

    print_statistics(total_cost, n_cases);

error1:
    RETURN;
}

static void print_output(
    const BNNO expected_vec[NODE_MAX], const BNNO output_vec[NODE_MAX], BNNS n_outputs
) {
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

static BNNO cost_func(
    const BNNO expected_vec[NODE_MAX], const BNNO output_vec[NODE_MAX], BNNS n_outputs
) {
    BNNO cost = 0;

    for (BNNS i = 0; i < n_outputs; i++) {
        int diff = output_vec[i] - expected_vec[i];
        cost += diff * diff;
    }

    return cost / 2;
}

static void print_statistics(BNNO total_cost, unsigned n_cases) {
    double avg_cost = total_cost/((float)n_cases);
    double rms_err  = sqrt(avg_cost);
    printf("Average cost: %lf\n", avg_cost );
    printf("RMS error:    %lf\n", rms_err );
}
