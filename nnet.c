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

/*
 *  DONT CALL UNTIL num_layers AND layer_size HAVE BEEN SPECIFIED
 */
int nnet_allocate() {
    // Set all to NULL first
    int i;
    for ( i = 0; i < MAX_NUM_LAYERS - 1; i++ ) {
        weight[i] = NULL;
        bias[i] = NULL;
    }

    for ( i = 0; i < num_layers - 1; i++ ) {
        weight[i] = malloc(layer_size[i] * layer_size[i+1] * sizeof(float));
        bias[i]   = malloc(layer_size[i+1] * sizeof(float));
        if ( weight[i] == NULL || bias[i] == NULL ) {
            fprintf(stderr, "NOT ENOUGH MEMORY!\n");
            return 1;
        }
    }

    return 0;
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
        fprintf( stderr, "File incomplete!" );
        return 1;
    }

    if ( num_layers < 2 ) {
        fprintf( stderr, "File does not specify enough layers!\n" );
        return 1;
    }

    int i;
    for ( i = 0; i < num_layers; i++ ) {
        if ( fscanf( fp, "%d", (layer_size+i) ) == EOF ) {
            fprintf( stderr, "File incomplete!" );
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
                fprintf( stderr, "File incomplete!" );
                nnet_free();
                return 1;
            }
        }

        // Scan biases
        for ( i = 0; i < layer_size[m+1]; i++ ) {
            if ( fscanf( fp, "%f", (bias[m]+i) ) == EOF ) {
                fprintf( stderr, "File incomplete!" );
                nnet_free();
                return 1;
            }
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
        
        nnet_new(n, temp_layer_size);

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
