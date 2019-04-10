#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "xorgens.h"
#include "bnn.h"
#include "binarised_fp.h"
#include "binarised_bp.h"
#include "error_handling.h"
#include "mnist_int8_input.h"
#include "config.h"


static void print_output(
    const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs
);
static double cost_func(
    const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs, BNN_real max
);
static void print_statistics(double total_cost, unsigned n_cases);

/*
 * Creates new BNN.
 * 
 * bnn: empty BNN struct (already allocated in memory).
 * layers: number of layers, including input and output layers.
 * layer_sizes: array of number of nodes in each layer.
 *		layer_sizes[0] is the number of input nodes.
 *		layer_sizes[layers-1] is the number of output nodes.
 *
 * The function assigns these values to the bnn and generates initialised random values for the weights and biases.
 */

void bnn_new(BNN bnn, BNNS layers, BNNS layer_sizes[]) {
    static_assert(sizeof(BNN_bin) == sizeof(UINT), "UINT and weight bucket size does not match.\n");

    // Set the global num_layers and layer_size variables
    bnn->layers = layers;
    memcpy(bnn->layer_sizes, layer_sizes, layers * sizeof(BNNS));
	
    for(BNNS ii = 0; ii < LAYER_MAX-1; ii++) {
        memset(bnn->weight_true, 0, NODE_MAX * NODE_MAX * sizeof(BNN_real));
        memset(bnn->weight, 0, BIN_VEC_SIZE * NODE_MAX * sizeof(BNN_bin));
    }
    memset(bnn->bias, 0, NODE_MAX * LAYER_MAX * sizeof(BNN_real));
	memset(bnn->activations_true, 0, NODE_MAX * LAYER_MAX * sizeof(BNN_real));
	memset(bnn->b_activations, 0, BIN_VEC_SIZE * LAYER_MAX * sizeof(BNN_bin));

    // Generate uniformly distributed weights and biases for each forward pass step.
    // There are layers-1 number of weight matrices as they lie between layers
    for (BNNS i = 0; i < layers-1; i++) {
        for (BNNS j = 0; j < layer_sizes[i+1]; j++) {
            for (BNNS k = 0; k < CEIL_DIV(layer_sizes[i], SIZE(BNN_bin)); k++) {
				bnn->weight[i][j][k] = xor4096i(0);
				for (BNNS m = 0; m < SIZE(BNN_bin); m++) {
					BNN_real sign = bnn->weight[i][j][k] & (1 << m) ? 1 : -1;
					bnn->weight_true[i][j][k*SIZE(BNN_bin)+m] = sign * (BNN_real)xor4096r(0);
                    printf("%f\n", bnn->weight_true[i][j][k*SIZE(BNN_bin)+m]);
				}
            }
        }
    }
	
}

/*
 * Assigns BNN values based on input file.
 * 
 * bnn: empty BNN struct (already allocated in memory).
 * filename: file containing bnn layer sizes, weights, and biases.
 */
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
        for ( BNNS n = 0; n < bnn->layer_sizes[m+1]; n++ ) {
            amt_read = fread(bnn->weight_true[m][n], sizeof(BNN_real), bnn->layer_sizes[m], fp);
            CHECK(amt_read != bnn->layer_sizes[m], "File corrupted!", 2);
            binarise(bnn->weight[m][n], bnn->weight_true[m][n], bnn->layer_sizes[m]);
        }
    }

    for ( BNNS m = 0; m < bnn->layers; m++ ) {
        BNNS b_size = bnn->layer_sizes[m+1];
        amt_read = fread( bnn->bias[m], sizeof(BNN_real), b_size, fp );
        CHECK(amt_read != b_size, "File corrupted!", 2);
    }
    bnn_print(bnn);

error2:
    fclose(fp);

error1:
    RETURN;
}

/*
 * Writes BNN values to a file.
 * 
 * bnn: non-empty BNN struct.
 * filename: file to be written to.
 */
int bnn_write(BNN bnn, const char* filename) {
    MSG("BNN successfully saved to file.");

    size_t amt_written;
    FILE* fp = fopen( filename, "wb" );

    CHECK(fp == NULL, "Could not open file!\n", 1);

    amt_written = fwrite( &(bnn->layers), sizeof(BNNS), 1, fp );
    CHECK(amt_written != 1, "Failed to save BNN to file.", 2);

    amt_written = fwrite( bnn->layer_sizes, sizeof(BNNS), bnn->layers, fp);
    CHECK(amt_written != bnn->layers, "Failed to save BNN to file.", 2);

    for ( BNNS m = 0; m < bnn->layers-1; m++ ) {
        for ( BNNS n = 0; n < bnn->layer_sizes[m+1]; n++ ) {
            amt_written = fwrite(bnn->weight_true[m][n], sizeof(BNN_bin), bnn->layer_sizes[m], fp);
            CHECK(amt_written != bnn->layer_sizes[m], "Failed to save BNN to file.", 2);
        }
    }

    for ( BNNS m = 0; m < bnn->layers; m++ ) {
        BNNS b_size = bnn->layer_sizes[m+1];
        amt_written = fwrite( bnn->bias[m], sizeof(BNN_real), b_size, fp);
        CHECK(amt_written != b_size, "Failed to save BNN to file.", 2);
    }

error2:
    fclose(fp);

error1:
    RETURN;
}

void bnn_print(BNN bnn) {
    printf("LAYERS: %d\n", bnn->layers);
    for (BNNS i = 0; i < bnn->layers; i++) {
        printf("%d ", bnn->layer_sizes[i]);
    }
    printf("\n");
    printf("WEIGHTS\n");
    for (BNNS i = 0; i < bnn->layers-1; i++) {
        printf("LAYER: %d\n", i);
        for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
            printf("OUTPUTNODE: %d\n", j);
            for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {
                printf("%f ", bnn->weight_true[i][j][k]);
            }
            printf("%u\n", bnn->weight[i][j][0]);
            printf("\n");
        }
    }
    printf("DONE PRINTING\n");
    printf("DONE PRINTING\n");
    printf("DONE PRINTING\n");
    /*
    printf("BIASES\n");
    for (BNNS i = 0; i < bnn->layers; i++) {
        for (BNNS j = 0; j < bnn->layer_sizes[i]; j++) {
            printf("%d ", bnn->bias[i][j]);
        }
    }
    */
}

/*
 * Performs operation - training or testing.
 *
 * bnn: initialised bnn struct.
 * fp_input: input data for operation.
 * fp_label: data labels i.e. output data.
 * op_type: either training or testing.
 */
int bnn_op(BNN bnn, FILE* fp_input, FILE* fp_label, op_t op_type) {
    MSG("Successfully completed operation.");

    BNNS n_inputs, n_outputs;
    size_t amt_read;
    INPT nb_input[NODE_MAX];
    LBLT _expected_vec[NODE_MAX];
    BNN_real expected_vec[NODE_MAX];

    double total_cost = 0;
    unsigned n_cases = 0;

    // Read number of inputs and outputs expected by file and do some checking
    CHECK(fread( &n_inputs, sizeof(BNNS), 1, fp_input ) != 1, "File corrupted!", 1);
    CHECK(fread( &n_outputs, sizeof(BNNS), 1, fp_label ) != 1, "File corrupted!", 1);

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    printf("%d\n", n_inputs);
    CHECK(n_inputs != bnn->layer_sizes[0], "Incorrect number of inputs!", 1);
    CHECK(n_outputs != bnn->layer_sizes[bnn->layers-1], "Incorrect number of outputs!", 1);

    // Loop until we reach the end of the file
    uint32_t total_read = 0;
    while( ( amt_read = fread( nb_input, sizeof(INPT), n_inputs, fp_input ) ) != 0 ) {
        CHECK(amt_read != n_inputs, "Incorrect number of bytes!", 1);
        total_read += amt_read;
        printf("Total:%d\n", total_read);

        CHECK(
            fread( _expected_vec, sizeof(LBLT), n_outputs, fp_label ) != n_outputs,
            "Incorrect number of bytes!", 1
        );

        BNN_real maxsize = (bnn->layer_sizes[bnn->layers-2]);
        convert_labels(_expected_vec, expected_vec, n_outputs,maxsize);
        
#ifdef DEBUG_OPT
        printf("PRINTING EXPECTED OUTPUT\n");
        for (BNNS i = 0; i < n_outputs; i++) {
            printf("%d\n", _expected_vec[i]);
            printf("%f\n", expected_vec[i]);
        }
#endif
        
		BNN_bin b_input[BIN_VEC_SIZE];
		memset(b_input, 0, BIN_VEC_SIZE * sizeof(BNN_bin));
	    binarise_input(nb_input, b_input, bnn->bias[0], bnn->layer_sizes[0]);
		
		memcpy(bnn->b_activations[0], (BNN_bin *) b_input, BIN_VEC_SIZE * sizeof(BNN_bin));
        for(BNNS i = 0; i < bnn->layer_sizes[0]; i++) {
            bnn->activations_true[0][i] = (BNN_real)nb_input[i];
        }
        
#ifdef DEBUG_IPT
        printf("nbinput:\n");
        for (BNNS i = 0; i < n_inputs; i++) {
            printf("%d\n", nb_input[i]);
            printf("%f\n", (BNN_real)nb_input[i]);
        }
        printf("binput:\n");
        for (BNNS i = 0; i < n_inputs; i++) {
            printf("%u\n", (BNN_bin)b_input[i]);
        }
#endif
        printf("");
        forward_pass(bnn);

        if ( op_type == TRAIN ) {
			// hard code learning rate to 0.001
            back_pass(bnn, expected_vec, 0.0001);
            print_output(expected_vec, bnn->activations_true[bnn->layers-1], n_outputs);
        }
        else if ( op_type == TEST ) {
            print_output(expected_vec, bnn->activations_true[bnn->layers-1], n_outputs);
        }

        total_cost += cost_func(bnn->activations_true[bnn->layers-1], expected_vec, n_outputs, bnn->layer_sizes[bnn->layers-2]);

        n_cases++;
    }

    print_statistics(total_cost, n_cases);

error1:
    RETURN;
}

static void print_output(
    const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs
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
        printf("%f ", output_vec[i] );
    }
    printf("\n");

}
static double cost_func(
    const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs, BNN_real max
) {
    double cost = 0.0;

    for (BNNS i = 0; i < n_outputs; i++) {
        double diff = (double)((output_vec[i] - expected_vec[i])) / (2 * max);
        cost += diff * diff;
    }

    return cost / 2.0;
}

static void print_statistics(double total_cost, unsigned n_cases) {
    double avg_cost = total_cost / n_cases;
    double rms_err  = sqrt(avg_cost);
    printf("Average cost: %lf\n", avg_cost );
    printf("RMS error:    %lf\n", rms_err );
}
