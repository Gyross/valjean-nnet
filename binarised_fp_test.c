#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "binarised_fp.h"


static void compare_output(const BNN_real expected_vec[NODE_MAX], const BNN_real output_vec[NODE_MAX], BNNS n_outputs);


void forward_pass_test() {
	// BNN bnn;
	// INPT nb_input[INP_VEC_SIZE];
	// BNNO output[NODE_MAX];
	// forward_pass(bnn, nb_input[NODE_MAX], output[NODE_MAX]);
//    BNNI input[INP_VEC_SIZE] = {0};
//    binarise_input(nb_input, input, bnn->bias[0], bnn->layer_sizes[0]);

    // for ( BNNS i = 0; i < bnn->layers-1; i++ ) { // for each layer
//         BNNS inp_size = packed_ls(bnn, i);
//         BNNS out_size = bnn->layer_sizes[i+1];
//         memset(output, 0, NODE_MAX * sizeof(BNNO));
//
//         matrix_mult(
//             input, output, inp_size, out_size, bnn->weight[i],
//             bnn->layer_sizes[i] % SIZE(BNNI), bnn->bias[i]
//         );
//
//         if (i != bnn->layers-2) {
//             binarise(input, output, out_size);
//         } else {
//             clamp(output, bnn->layer_sizes[bnn->layers-1], bnn->layer_sizes[bnn->layers-2]);
//         }
//    }
}

void packed_ls_test() {
	
}

void matrix_mult_test() {
	BNN_bin input[BIN_VEC_SIZE];
	memset(input, 0, BIN_VEC_SIZE * sizeof(BNN_bin));
	BNNS in_layer_size = 4;
	input[0]=8+2;
	BNNS inp_size = CEIL_DIV(in_layer_size, SIZE(BNN_bin));
	BNNS out_size = 2;
    BNN_real output[NODE_MAX] = {0};
    BNN_bin weights[NODE_MAX][BIN_VEC_SIZE] = {0};
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

int main (int argc, char const *argv[])
{
	matrix_mult_test();
	return 0;
}


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