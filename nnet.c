#include "nnet_math.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LAYER_SIZE 1000
#define MAX_NUM_LAYERS 100

int num_layers;
int layer_size[MAX_NUM_LAYERS];

/* 
 * Weights and biases indicies correspond to a forward pass step
 * not to a layer. In the literature biases would correspond to 
 * a layer, within this program, think of them as belonging to
 * the interface between layers, this way the indicies make
 * more sense.
 */
float* weight[MAX_NUM_LAYERS - 1];
float* bias[MAX_NUM_LAYERS - 1];

// Activations for a forward pass have to be stored so we can
// do a back propagation
float* activation[MAX_NUM_LAYERS];

float* cost_derivative[MAX_NUM_LAYERS];

float learning_rate;

void forward_pass(float* input_layer, float* output_layer) {

    int m;

    memcpy(activation[0], input_layer, sizeof(float) * layer_size[0]);

    // There are num_layers-1 forward pass steps
    for ( int m = 0; m < num_layers - 1; m++ ) {
        matrix_multiply(weight[m], activation[m], activation[m+1], layer_size[m], layer_size[m+1]);
        vector_add_inplace(activation[m+1], bias[m], layer_size[m+1]);
        vector_relu(activation[m+1], layer_size[m+1]);
    }

    memcpy(output_layer, activation[num_layers-1], sizeof(float) * layer_size[num_layers-1]);
    
}

void backpropagate(float* expected_output) {
    // we use the normal cost function: sum of 1/2 * (ex_out - out)^2
    // NB: All derivatives are partial

    // output layer derivatives (dCost/dOut)
    int i, j, m;
    for ( i = 0; i < layer_size[num_layers-1]; i++ ) {
        cost_derivative[num_layers-1][i] = activation[num_layers-1][i] - expected_output[i];
    }


    // Note on indicies
    //
    // i will refer to the previous layer
    // j will refer to the next layer
    
    // compute (dCost/dNeuron) for all neurons in the network
    // don't need to compute for the input layer since we never need the cost
    // derivative of the input
    for ( m = num_layers-2; m > 0; m-- ) {
        for ( j = 0; j < layer_size[m+1]; j++ ) {
            for ( i = 0; i < layer_size[m]; i++ ) {

                // reLU derivative
                if ( activation[m+1][j] > 0 ) {
                    cost_derivative[m][i] += 
                        cost_derivative[m+1][j] * *(weight[m] + i + j*(layer_size[m+1]));
                }
            }
        }
    }

    // Update weights and biases
    for ( m = 0; m < num_layers-1; m++ ) {
        for ( j = 0; j < layer_size[m+1]; j++ ) {

            // the if statement encodes the derivative of
            // the reLU function. If the activation is
            // less than zero there is no training to do
            // for this neuron
            if ( activation[m+1][j] > 0 ) {

                // train weights
                for ( i = 0; i < layer_size[m]; i++ ) {
                    *(weight[m] + i + j*(layer_size[m+1])) -= 
                        learning_rate * activation[m][i] * cost_derivative[m+1][j];
                }

                // train bias
                bias[m][j] -= learning_rate * cost_derivative[m+1][j];
            }
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
        if ( activation[i] != NULL ) {
            free(activation[i]);
            activation[i] = NULL;
        }
    }

    if ( activation[num_layers - 1] != NULL ) {
        free(activation[num_layers - 1]);
        activation[num_layers - 1] = NULL;
    }
}

/*
 *  DONT CALL UNTIL num_layers AND layer_size HAVE BEEN SPECIFIED
 */
int nnet_allocate() {
    // Set all to NULL first
    int i;
    for ( i = 0; i < MAX_NUM_LAYERS - 1; i++ ) {
        weight[i] = NULL;
        bias[i] = NULL;
        activation[i] = NULL;
        cost_derivative[i] = NULL;
    }

    activation[MAX_NUM_LAYERS - 1] = NULL;
    cost_derivative[MAX_NUM_LAYERS - 1] = NULL;

    for ( i = 0; i < num_layers - 1; i++ ) {
        weight[i]          = malloc(layer_size[i] * layer_size[i+1] * sizeof(float));
        bias[i]            = malloc(layer_size[i+1] * sizeof(float));
        activation[i]      = malloc(layer_size[i] * sizeof(float));
        cost_derivative[i] = malloc(layer_size[i] * sizeof(float));
        if ( weight[i] == NULL || bias[i] == NULL || 
             activation[i] == NULL || cost_derivative[i] == NULL ) {
            fprintf(stderr, "NOT ENOUGH MEMORY!\n");
            nnet_free();
            return 1;
        }
    }

    // Activation stores for every layer, so we need an extra one
    activation[num_layers - 1] = malloc(layer_size[num_layers - 1] * sizeof(float));
    cost_derivative[num_layers - 1] = malloc(layer_size[num_layers - 1] * sizeof(float));

    if ( activation[num_layers - 1] == NULL || cost_derivative[num_layers - 1] == NULL ) {
        fprintf(stderr, "NOT ENOUGH MEMORY!\n");
        nnet_free();
        return 1;
    }

    return 0;
}


int nnet_new(int arg_num_layers, int* arg_layer_size) {
    // Set the global num_layers and layer_size variables
    num_layers = arg_num_layers;
    memcpy(layer_size, arg_layer_size, sizeof(int) * num_layers);

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

/*
 * File format:
 * num_layers
 * layer_size
 * weight[0] ( in row major order )
 * bias[0]
 * weight[1]
 * bias[1]
 * etc.
 *
 * It doesn't matter at this stage where line breaks are as long as the
 * data is stored in this order. So you can write input files that
 * have matricies stored like:
 *
 * 1.0 1.0
 * 2.0 3.0
 *
 * for example.
 */

int nnet_read_file(char* filename) {
    FILE* fp = fopen(filename, "r");

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n");
        return 1;
    }

    if ( fscanf( fp, "%d", &num_layers ) == EOF ) {
        fprintf( stderr, "File incomplete!\n" );
        return 1;
    }

    if ( num_layers < 2 ) {
        fprintf( stderr, "File does not specify enough layers!\n" );
        return 1;
    }

    int i;
    for ( i = 0; i < num_layers; i++ ) {
        if ( fscanf( fp, "%d", (layer_size+i) ) == EOF ) {
            fprintf( stderr, "File incomplete!\n" );
            return 1;
        }
        
        if ( layer_size[i] < 1 ) {
            fprintf( stderr, "Layers must all have at least one neuron!\n" );
            return 1;
        }
    }

    // Allocate for arrays
    // Remember to free if there is an error after this point!
    nnet_allocate();

    int m;
    for ( m = 0; m < num_layers - 1; m++ ) {

        // Scan weights
        for ( i = 0; i < layer_size[m]*layer_size[m+1]; i++ ) {
            if ( fscanf( fp, "%f", (weight[m]+i) ) == EOF ) {
                fprintf( stderr, "File incomplete!\n" );
                nnet_free();
                return 1;
            }
        }

        // Scan biases
        for ( i = 0; i < layer_size[m+1]; i++ ) {
            if ( fscanf( fp, "%f", (bias[m]+i) ) == EOF ) {
                fprintf( stderr, "File incomplete!\n" );
                nnet_free();
                return 1;
            }
        }
    }

    fclose(fp);

    return 0;
}


int nnet_write_file(char* filename) {
    FILE* fp = fopen( filename, "w" );

    if ( fp == NULL ) {
        fprintf( stderr, "Could not open file!\n" );
        return 1;
    }

    fprintf( fp, "%d\n\n", num_layers );

    int m,i,j;

    for ( i = 0; i < num_layers; i++ ) {
        fprintf( fp, "%d ", layer_size[i] );
    }

    for ( m = 0; m < num_layers-1; m++ ) {
        fprintf( fp, "\n\n");

        for ( i = 0; i < layer_size[m+1]; i++ ) {
            for ( j = 0; j < layer_size[m]; j++ ) {
                fprintf( fp, "%f ", *(weight[m]+(i*layer_size[m+1])+j) );
            }
            fprintf( fp, "\n" );
        }
        fprintf( fp, "\n" );

        for ( i = 0; i < layer_size[m+1]; i++ ) {
            fprintf( fp, "%f ", *(bias[m]+i) );
        }
    }

    fclose(fp);
    return 0;
}



/*
 * Usage:
 *  nnet new <filename> <layer size>...
 *  nnet load <filename>
 */

int main( int argc, char* argv[] ) {
    const char usage_message[] = 
        "Usage:\n nnet new <filename> <layer size>...\n nnet load <filename>\n";

    if ( argc < 3 ) {
        printf(usage_message);
        return 1;
    }

    if ( strcmp(argv[1], "new") == 0 ) {
        int n = argc - 3;
        if ( n < 2 ) {
            printf("You must specify at least two layers.\n");
            printf(usage_message);
            return 1;
        }

        int i;
        int temp_layer_size[MAX_NUM_LAYERS];
        for ( i = 3; i < argc; i++ ) {
            temp_layer_size[i-3] = atoi(argv[i]);
        }
        
        if ( nnet_new(n, temp_layer_size) ) {
            return 1;
        }

        if ( nnet_write_file(argv[2]) ) {
            return 1;
        }

    } else if ( strcmp(argv[1], "load") == 0 ) {
        if ( nnet_read_file(argv[2]) ) {
            return 1;
        }
    } else {
        printf(usage_message);
        return 1;
    }

    char *command_str = NULL;
    char *command_old = NULL;
    char *command_tok = NULL;
    size_t command_len;
    int loop_flag = 1;

    while(loop_flag) {
        printf("> ");

        // get a line from console
        getline(&command_str, &command_len, stdin);
        // store the original string pointer so we can free it later
        command_old = command_str;
        // trim the '\n' at the end of the string
        command_str = strsep(&command_str, "\n");
        // Seperate by spaces
        command_tok = strsep(&command_str, " ");

        if ( strcmp(command_tok, "fp") == 0 ) {

            // Forward Pass
            float input_vec[MAX_LAYER_SIZE];
            float output_vec[MAX_LAYER_SIZE];

            int i;
            for ( i = 0; i < layer_size[0]; i++ ) {
                command_tok = strsep(&command_str, " ");
                while ( command_tok != NULL && strcmp(command_tok, "") == 0 ) {
                    command_tok = strsep(&command_str, " ");
                }

                if ( command_tok == NULL ) {
                    printf("Too few inputs\n");
                }

                sscanf(command_tok, "%f", input_vec+i);
            }

            forward_pass(input_vec, output_vec);
            for ( i = 0; i < layer_size[num_layers-1]; i++ ) {
                printf("%f ", output_vec[i]);
            }
            printf("\n");

        } 
        else if ( strcmp(command_tok, "slr" ) == 0 ) {
            command_tok = strsep(&command_str, " " );
            while ( command_tok != NULL && strcmp(command_tok, "") == 0 ) {
                command_tok = strsep(&command_str, " ");
            }

            if ( command_tok == NULL ) {
                printf("Too few inputs\n");
            }

            sscanf(command_tok, "%f", &learning_rate);
        }
        else if ( strcmp(command_tok, "bp" ) == 0 ) {
            float expected_vec[MAX_LAYER_SIZE];

            int i;
            for ( i = 0; i < layer_size[0]; i++ ) {
                command_tok = strsep(&command_str, " ");
                while ( command_tok != NULL && strcmp(command_tok, "") == 0 ) {
                    command_tok = strsep(&command_str, " ");
                }

                if ( command_tok == NULL ) {
                    printf("Too few inputs\n");
                }

                sscanf(command_tok, "%f", expected_vec+i);
            }

            backpropagate(expected_vec);
        }
        else if ( strcmp(command_tok, "save") == 0 ) {
            nnet_write_file(command_str);
        }
        else if ( strcmp(command_tok, "exit") == 0 ||
                  strcmp(command_tok, "quit") == 0 ) {
            loop_flag = 0;
        }
        else {
            printf("Invalid command\n");
            printf("Forward Pass:\n");
            printf(" fp <float input>...\n");
            printf("Quit nnet:\n");
            printf(" quit\n");
        }

        free(command_old);
    }

    nnet_free();
    return 0;
}
