#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "binarised_fp.h"
#include "bnn.h"
#include "config.h"

//GOBAL VAR:
bnn_alloc _bnnTest;

static void compare_output(const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs);
void matrix_mult_test(void);
void init_test_bnn(BNN bnn);

void forward_pass_test() {
    BNN bnn = &_bnnTest;
    assert(bnn != NULL);
    init_test_bnn(bnn);
    
    INPT nb_input[NODE_MAX] = {0};
    BNN_bin b_input[BIN_VEC_SIZE] = {0};
    nb_input[0] = (INPT)128;
    nb_input[3] = (INPT)-128;
    nb_input[4] = (INPT)40;
    binarise_input(nb_input, b_input, bnn->bias[0], bnn->layer_sizes[0]);

    memcpy(bnn->b_activations[0], (BNN_bin *) b_input, BIN_VEC_SIZE * sizeof(BNN_bin));
    for(BNNS i = 0; i < bnn->layer_sizes[0]; i++) {
        bnn->activations_true[0][i] = (BNN_real)nb_input[i];
    }
    
    forward_pass(bnn);
    
    //PRINT OUTPUT
    
    for (BNNS i = 0; i < bnn->layers; i++) {
        printf("ACTIVATIONS LAYER %u: ", i);
        printf("bin: %u, ", bnn->b_activations[i][0]);
        for (BNNS j = 0; j < bnn->layer_sizes[i]; j++) {
            printf("%f, ", bnn->activations_true[i][j]);
        }
        printf("\n");
    }
    
    
}

//void packed_ls_test() {	
//}

void matrix_mult_test() {
	printf("mat_mult_test\n");
	BNN_bin input[BIN_VEC_SIZE];
	memset(input, 0, BIN_VEC_SIZE * sizeof(BNN_bin));
	BNNS in_layer_size = 4;
	input[0]=8+2;
	BNNS inp_size = CEIL_DIV(in_layer_size, SIZE(BNN_bin));
	BNNS out_size = 2;
    BNN_real output[NODE_MAX] = {0};
    
    BNN_bin  weights[NODE_MAX][BIN_VEC_SIZE];
    memset(weights, 0, sizeof(BNN_bin) * BIN_VEC_SIZE * NODE_MAX);
    
    BNNS last_trunc = in_layer_size % SIZE(BNN_bin);
	BNN_real bias[NODE_MAX] = {0};
	BNN_real expected_output[NODE_MAX] = {0};
	
	matrix_mult(input, output, inp_size, out_size, weights, last_trunc, bias);
	compare_output(expected_output, output, out_size);
	
	BNN_real output_new[NODE_MAX] = {0};
	weights[0][0] = 2 + 4 + 8;
	weights[1][0] = 1 + 2;
	
	bias[0] = 1;
	
	bias[1] = 0;
	
	expected_output[0] = 3;
	expected_output[1] = 0;
	matrix_mult(input, output_new, inp_size, out_size, weights, last_trunc, bias);
	compare_output(expected_output, output_new, out_size);

}
#ifdef TESTING
int main (int argc, char const *argv[])
{
    forward_pass_test();
	matrix_mult_test();
	return 0;
}
#endif


static void compare_output(const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs) {
    int correctness = 1;

	printf("Output:   ");
    for ( BNNS i = 0; i < n_outputs; i++ ) {
		if ( expected_vec[i] != output_vec[i] ) {
			correctness = 0;
		}
        printf("%f ", output_vec[i] );
    }
    printf("\nExpected: ");
    for ( BNNS i = 0; i < n_outputs; i++ ) {
        printf("%f ", expected_vec[i] );
    }
	
	if (correctness == 1) {
		printf("\nCorrect: True \n");
	} else {
		printf("\nCorrect: False \n");
	}
}


void init_test_bnn(BNN bnn) {
    // Set the global num_layers and layer_size variables
    BNNS num_layers = 3;
    bnn->layers = 3;
    for(BNNS i = 0; i < LAYER_MAX; i++) {
        bnn->layer_sizes[i] = 0;
    }
    bnn->layer_sizes[0] = 5;
    bnn->layer_sizes[1] = 5;
    bnn->layer_sizes[2] = 2;
    for(BNNS ii = 0; ii < LAYER_MAX-1; ii++) {
        memset(bnn->weight_true, 0, NODE_MAX * NODE_MAX * sizeof(BNN_real));
        memset(bnn->weight, 0, BIN_VEC_SIZE * NODE_MAX * sizeof(BNN_bin));
    }
    memset(bnn->bias, 0, NODE_MAX * LAYER_MAX * sizeof(BNN_real));
    memset(bnn->activations_true, 0, NODE_MAX * LAYER_MAX * sizeof(BNN_real));
    memset(bnn->b_activations, 0, BIN_VEC_SIZE * LAYER_MAX * sizeof(BNN_bin));
    
    // Generate uniformly distributed weights and biases for each forward pass step.
    // There are layers-1 number of weight matrices as they lie between layers
    
    for (BNNS i = 0; i < num_layers-1; i++) {
        for (BNNS j = 0; j < bnn->layer_sizes[i+1]; j++) {
            for (BNNS k = 0; k < bnn->layer_sizes[i]; k++) {
                if (i == 0 && j == 2 && k == 1) {
                    bnn->weight_true[i][j][k] = -0.4;
                } else if (i == 0 && j == 2 && k == 4) {
                    bnn->weight_true[i][j][k] = 1.3;
                } else if (i == 0 && j == 4 && k == 0) {
                    bnn->weight_true[i][j][k] = -0.01;
                } else if (i == 1 && j == 1 && k == 4) {
                    bnn->weight_true[i][j][k] = 0.8;
                } else if (i == 1 && j == 1 && k == 2) {
                    bnn->weight_true[i][j][k] = -0.2;
                } else{
                    bnn->weight_true[i][j][k] = 0;
                }
                
            }
            binarise(bnn->weight[i][j], bnn->weight_true[i][j], bnn->layer_sizes[i+1]);
        }
    }
    bnn_print(bnn);
}
