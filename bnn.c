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
#include "anneal.h"

static int print_output(
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
    //bnn_print(bnn);

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
 * dataset: exisitng dataset to operate on
 * op_type: either training or testing.
 */
int bnn_op(BNN bnn, dataset ds, op_t op_type) {

    // Skip operation and go straight to annealing
    // TODO clean up te implementation of this
    if ( op_type == ANNEAL ) {
        anneal(bnn, ds);
        return 0;
    }

    MSG("Successfully completed operation.");

    int read_code;
    LBLT label = 0;
    BNN_real expected_vec[NODE_MAX];

    // Input & output vectors
    INPT nb_input[NODE_MAX];
    BNN_real out_activations[NODE_MAX];

    BNNS n_inputs  = bnn->layer_sizes[0];
    BNNS n_outputs = bnn->layer_sizes[bnn->layers-1];

    double total_cost = 0;
    unsigned n_cases = 0;

    // Initialize vectors
    memset( nb_input, 0, sizeof(nb_input));
    memset( out_activations, 0, sizeof(out_activations));

    // inputs and outputs specified by dataset must be the same as number
    // of neurons in input and output layers in the network, otherwise the 
    // dataset is incompatible with the network.
    CHECK( dataset_num_inputs(ds)  != n_inputs, 
           "Incorrect number of inputs!", 1);
    CHECK( dataset_num_outputs(ds) != n_outputs, 
           "Incorrect number of outputs!", 1);

    uint32_t total_correct = 0;

    // While there are input cases left in the dataset
    while( 1 == (read_code = dataset_read( ds, nb_input, &label )) ) {

        convert_label(label, expected_vec, n_outputs);
        
#ifdef DEBUG_OPT
        printf("PRINTING EXPECTED OUTPUT\n");
        for (BNNS i = 0; i < n_outputs; i++) {
            printf("%f\n", expected_vec[i]);
        }
#endif
        fp_wrapper( bnn, nb_input, out_activations );

        if ( op_type == TRAIN ) {
			// hard code learning rate to 0.001
            back_pass(bnn, expected_vec, 0.001);
            total_correct += print_output(expected_vec, out_activations, n_outputs);
        }
        else if ( op_type == TEST ) {
            total_correct += print_output(expected_vec, out_activations, n_outputs);
        }

        total_cost += cost_func( out_activations, 
                                 expected_vec, 
                                 n_outputs, 
                                 bnn->layer_sizes[bnn->layers-2] );

        n_cases++;
    }

    CHECK(read_code == -1, "Incorrect number of bytes!", 1);
    
    printf("NUM CORRECT: %d %d\n", total_correct, n_cases);

    print_statistics(total_cost, n_cases);

error1:
    RETURN;
}

static int print_output(
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
    int predicted_cat = 0;
    for ( BNNS i = 0; i < n_outputs; i++ ) {
        printf("%f ", output_vec[i] );
        if (output_vec[i] > output_vec[predicted_cat]) {
            predicted_cat = i;
        }
    }
    printf("PREDICT: %d\n", predicted_cat);
    printf("%d\n", predicted_cat==expected_category ? 1 : 0);
    return (predicted_cat==expected_category ? 1 : 0);

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
