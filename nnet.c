#include "nnet_math.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LAYER_SIZE 1000

int num_layers;
int* layer_size;

// Weights and biases indicies correspond to a forward pass step
// not to a layer
float** weight;
float** bias;

void forward_pass(float* input_layer, float* output_layer) {
    float array1[MAX_LAYER_SIZE];
    float array2[MAX_LAYER_SIZE];

    float* prev_layer = array1;
    float* next_layer = array2;

    int m;

    memcpy(prev_layer, input_layer, sizeof(float) * layer_size[0]);

    // There are num_layers-1 forward pass steps
    for ( int m = 0; m < num_layers - 1; m++ ) {
        matrix_multiply(weight[m], prev_layer, next_layer, layer_size[m], layer_size[m+1]);
        vector_add_inplace(next_layer, bias[m], layer_size[m+1]);
        vector_relu(next_layer, layer_size[m+1]);

        // switch layers
        float* temp = prev_layer;
        prev_layer = next_layer;
        next_layer = temp;
    }

    memcpy(output_layer, prev_layer, sizeof(float) * layer_size[num_layers-1]);
    
}
