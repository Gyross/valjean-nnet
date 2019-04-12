//
//  binarised_bp_test.c
//  


#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "binarised_bp.h"
#include "binarised_fp.h"
#include "config.h"

static void back_pass_test();
void init_bp_test_bnn(BNN bnn);

bnn_alloc _bnnBPTest;

static void back_pass_test() {
    BNN bnn = &_bnnBPTest;
    assert(bnn != NULL);
    init_bp_test_bnn(bnn);
    
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
    
    for (BNNS i = 0; i < bnn->layers; i++) {
        printf("ACTIVATIONS LAYER %u: ", i);
        printf("bin: %u, ", bnn->b_activations[i][0]);
        for (BNNS j = 0; j < bnn->layer_sizes[i]; j++) {
            printf("%f, ", bnn->activations_true[i][j]);
        }
        printf("\n");
    }
    BNN_real target[NODE_MAX] = {1, 3};
    
    back_pass(bnn, target, 0.001);
    
    bnn_print(bnn);
    
}

#ifdef TESTING_BP
int main (int argc, char const *argv[])
{
    back_pass_test();
    return 0;
}
#endif


void init_bp_test_bnn(BNN bnn) {
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
