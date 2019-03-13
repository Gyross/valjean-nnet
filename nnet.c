#include "nnet_math.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define NNET_TRAIN 1
#define NNET_TEST  0 

#define MAX_LAYER_SIZE 1000
#define MAX_NUM_LAYERS 100

unsigned int num_layers;
unsigned int layer_size[MAX_NUM_LAYERS];

/* 
 * Weights and biases indicies correspond to a forward pass step
 * not to a layer. In the literature biases would correspond to 
 * a layer, within this program, think of them as belonging to
 * the interface between layers, this way the indicies make
 * more sense.
 */
float* weight[MAX_NUM_LAYERS];
float* bias[MAX_NUM_LAYERS];

// Activations for a forward pass have to be stored so we can
// do a back propagation
float* activation[MAX_NUM_LAYERS];

float* cost_derivative[MAX_NUM_LAYERS];

float learning_rate;

void forward_pass(float* input_layer, float* output_layer) {

    int m;

    memcpy(activation[0], input_layer, sizeof(float) * layer_size[0]);

    // There are num_layers-1 forward pass steps
    for ( m = 0; m < num_layers - 1; m++ ) {
        matrix_multiply(weight[m], activation[m], activation[m+1], layer_size[m], layer_size[m+1]);
        vector_add_inplace(activation[m+1], bias[m], layer_size[m+1]);
        vector_relu(activation[m+1], layer_size[m+1]);
    }

    memcpy(output_layer, activation[num_layers-1], sizeof(float) * layer_size[num_layers-1]);
    
}

void backpropagate(float* expected_output) {
    // we use the normal cost function: sum of (ex_out - out)^2
    // NB: All derivatives are partial


    int i, j, m;

    // first we need to zero all the cost derivatives
    for ( i = 0; i < num_layers; i++ ) {
        memset(cost_derivative[i], 0, layer_size[i]*sizeof(float));
    }

    // output layer derivatives (dCost/dOut)
    for ( i = 0; i < layer_size[num_layers-1]; i++ ) {
        cost_derivative[num_layers-1][i] = activation[num_layers-1][i] - expected_output[i];
    }


    // Note on indicies
    //
    // i will refer to the layer "on the left"
    // j will refer to the layer "on the right"
    
    // compute (dCost/dNeuron) for all neurons in the network
    // don't need to compute for the input layer since we never need the cost
    // derivative of the input
    for ( m = num_layers-2; m > 0; m-- ) {
        for ( j = 0; j < layer_size[m+1]; j++ ) {

            // reLU derivative
            float relu_factor;
            if ( activation[m+1][j] > 0.0 ) {
                relu_factor = 1.0;
            } else {
                relu_factor = 0.01;
            }

            for ( i = 0; i < layer_size[m]; i++ ) {
                cost_derivative[m][i] += cost_derivative[m+1][j] * 
                    relu_factor * *(weight[m] + i + j*(layer_size[m]));
            }
        }
    }

    // Update weights and biases
    for ( m = 0; m < num_layers-1; m++ ) {
        for ( j = 0; j < layer_size[m+1]; j++ ) {


            float relu_factor;
            if ( activation[m+1][j] > 0.0 ) {
                relu_factor = 1.0;
            } else {
                relu_factor = 0.01;
            }

            // train weights
            for ( i = 0; i < layer_size[m]; i++ ) {
                *(weight[m] + i + j*(layer_size[m])) -= relu_factor *
                    learning_rate * activation[m][i] * cost_derivative[m+1][j];
            }

            // train bias
            bias[m][j] -= learning_rate * relu_factor * cost_derivative[m+1][j];
        }
    }
    
}


void nnet_free() {
    int i;
    for ( i = 0; i < num_layers - 1; i++ ) {
        if ( weight[i] != NULL ) {
            free(weight[i]);
            weight[i] = NULL;
        }
        if ( bias[i] != NULL ) {
            free(bias[i]);
            bias[i] = NULL;
        }
    }

    for ( i = 0; i < num_layers; i++ ) {
        if ( activation[i] != NULL ) {
            free(activation[i]);
            activation[i] = NULL;
        }
        if ( cost_derivative[i] != NULL ) {
            free(cost_derivative[i]);
            cost_derivative[i] = NULL;
        }
    }
}

/*
 *  DONT CALL UNTIL num_layers AND layer_size HAVE BEEN SPECIFIED
 */
int nnet_allocate() {
    int i;

    for ( i = 0; i < num_layers - 1; i++ ) {
        weight[i] = malloc(layer_size[i] * layer_size[i+1] * sizeof(float));
        bias[i]   = malloc(layer_size[i+1] * sizeof(float));
        if ( weight[i] == NULL || bias[i] == NULL ) {
            fprintf(stderr, "NOT ENOUGH MEMORY!\n");
            nnet_free();
            return 1;
        }
    }

    for ( i = 0; i < num_layers; i++ ) {
        activation[i]      = malloc(layer_size[i] * sizeof(float));
        cost_derivative[i] = malloc(layer_size[i] * sizeof(float));
        if ( activation[i] == NULL || cost_derivative[i] == NULL ) {
            fprintf(stderr, "NOT ENOUGH MEMORY!\n");
            nnet_free();
            return 1;
        }
    }

    return 0;
}


int nnet_new(unsigned int arg_num_layers, unsigned int* arg_layer_size) {
    // Set the global num_layers and layer_size variables
    num_layers = arg_num_layers;
    memcpy(layer_size, arg_layer_size, sizeof(unsigned int) * num_layers);

    // Allocate weights and biases
    // Return 1 in event of error
    int allocate_err = nnet_allocate();
    if ( allocate_err ) {
        return allocate_err;
    }

    // Generate normally distributed weights and biases for each forward pass step.
    // Remember number of forward pass steps is one less than number of layers.
    int i;
    for ( i = 0; i < num_layers - 1; i++ ) {
        normal_rand(weight[i], layer_size[i]*layer_size[i+1]);
        normal_rand(bias[i], layer_size[i+1]);
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

int nnet_op(FILE* fp, int op_type) {
    unsigned int n_inputs, n_outputs;
    size_t amt_read;
    float input_vec[MAX_LAYER_SIZE];
    float expected_vec[MAX_LAYER_SIZE];
    float output_vec[MAX_LAYER_SIZE];

    float total_cost = 0.0;
    int n_cases = 0;

    // Read number of inputs and outputs expected by file and do some checking
    if (fread( &n_inputs, sizeof(unsigned int), 1, fp ) != 1) {
        fprintf( stderr, "File corrupted!\n" );
        return 1;
    }
    
    if ( fread( &n_outputs, sizeof(unsigned int), 1, fp ) != 1 ) {
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
    while( ( amt_read = fread( input_vec, sizeof(float), n_inputs, fp ) ) != 0 ) {
        if ( amt_read != n_inputs) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        } 

        if ( fread( expected_vec, sizeof(float), n_outputs, fp ) != n_outputs ) {
            fprintf( stderr, "Incorrect number of bytes!\n" );
            return 1;
        }

        forward_pass(input_vec, output_vec);

        /*
        printf("%f, %f -> %f, %f should be %f, %f\n",
                read_buf[buf_offset], read_buf[buf_offset+1],
                output_vec[0], output_vec[1],
                read_buf[buf_offset+2], read_buf[buf_offset+3]);
        */

        if ( op_type == NNET_TRAIN ) {
            backpropagate(expected_vec);
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



/*
 * Usage:
 *  nnet new <filename> <layer size>...
 *  nnet load <filename>
 */


int main( int argc, char* argv[] ) {

    const char usage_message[] = 
        "Usage:\n \
         nnet new <filename> <layer size>...\n \
         nnet train <nnet filename> <training set filename>...\n \
         nnet test <nnet filename> <testing set filename>\n";


    // fix the learning rate
    // TODO change this later
    learning_rate = 0.0003;


    // Initialize globals
    for ( int i = 0; i < MAX_NUM_LAYERS; i++ ) {
        layer_size[i] = 0;
        weight[i] = NULL;
        bias[i] = NULL;
        activation[i] = NULL;
        cost_derivative[i] = NULL;
    }
    num_layers = 0;



    if ( argc < 3 ) {
        printf(usage_message);
        return 1;
    }

    if ( strcmp(argv[1], "new") == 0 ) {
        // If we are at this point we are guaranteed that argc > 3, so this
        // subtraction is valid.
        unsigned int new_num_layers = argc - 3;

        if ( new_num_layers < 2 ) {
            printf("You must specify at least two layers.\n");
            printf(usage_message);
            return 1;
        }

        unsigned int new_layer_size[MAX_NUM_LAYERS];
        for ( int i = 0; i < new_num_layers; i++ ) {
            // Layer input layer sizes start at argv[3], hence we use an 
            // offset of 3 when indexing argv[]
            new_layer_size[i] = (unsigned int)strtoul(argv[i+3], NULL, 0);
        }
        
        if ( nnet_new(new_num_layers, new_layer_size) ) {
            return 1;
        }

        if ( nnet_write_file(argv[2]) ) {
            nnet_free();
            return 1;
        }

    } else if ( strcmp(argv[1], "train") == 0 ||
                strcmp(argv[1], "test") == 0 ) {
        if ( argc < 4 ) {
            fprintf(stderr, "Not enough arguments!\n");
            fprintf(stderr, usage_message);
        }
        if ( nnet_read_file(argv[2]) ) {
            return 1;
        }

        int op_type;
        if ( strcmp(argv[1], "train" )  == 0 ) {
            op_type = NNET_TRAIN;
        } else {
            op_type = NNET_TEST;
        }

        for ( int i = 3; i < argc; i++ ) {
            FILE* fp = fopen(argv[i], "rb");
            if ( fp == NULL ) {
                fprintf(stderr, "File \"%s\" could not be opened, aborting!\n", argv[i]);
                nnet_free();
                return 1;
            }

            nnet_op(fp, op_type);
            printf("%s on \"%s\" completed.\n", op_type?"Training":"Testing", argv[i]);
            fclose(fp);
        }

        // Only save the nnet if we were training it
        if ( op_type == NNET_TRAIN ) {
            if ( nnet_write_file(argv[2]) ) {
                nnet_free();
                return 1;
            }
        }

        printf("All done.\n");

    } else {
        printf(usage_message);
        return 1;
    }


    nnet_free();
    return 0;
}
