#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include "constants.h"
#include "bnn.h"

/*
 * Usage:
 *  nnet new <filename> <layer size>...
 *  nnet load <filename>
 */


int main( int argc, char* argv[] ) {

    const char usage_message[] =
        "Usage:\n \
         nnet new <filename> <layer size>...\n \
         nnet train <nnet filename> <input file> <label file>...\n \
         nnet test <nnet filename> <input file> <label file>\n";

    if ( argc < 3 ) {
        printf(usage_message);
        return 1;
    }

    bnn_alloc _bnn;
    BNN bnn = &_bnn;
    if ( strcmp(argv[1], "new") == 0 ) {
        // If we are at this point we are guaranteed that argc > 3, so this
        // subtraction is valid.
        unsigned layers = (unsigned)argc - 3;

        if ( layers < 2 ) {
            printf("You must specify at least two layers.\n");
            printf(usage_message);
            return EXIT_FAILURE;
        }

        unsigned layer_sizes[LAYER_MAX];
        for ( int i = 0; i < layers; i++ ) {
            // Layer input layer sizes start at argv[3], hence we use an
            // offset of 3 when indexing argv[]
            errno = 0;
            long size = strtol(argv[i+3], NULL, 0);
            if (errno != 0 || size < 1 || size > NODE_MAX) {
                printf("Invalid layer size: %s\n", argv[i+3]);
                return EXIT_FAILURE;
            }
            layer_sizes[i] = (unsigned)size;
        }

        bnn = bnn_new(layers, layer_sizes);

        if ( bnn_write(bnn, argv[2]) ) {
            return 1;
        }

    } else if
        (strcmp(argv[1], "train") == 0 || strcmp(argv[1], "test") == 0)
    {
        if ( argc != 5 ) {
            fprintf(stderr, "Incorrect number of arguments!\n");
            fprintf(stderr, usage_message);
        }

        if ( bnn_read(bnn, argv[2]) ) {
            return 1;
        }

        int op = strcmp(argv[1], "train" ) ? OP_TEST : OP_TRAIN;

        FILE* fp_input = fopen(argv[3], "rb");
        if ( fp_input == NULL ) {
            fprintf(stderr, "File \"%s\" could not be opened, aborting!\n", argv[3]);
            return 1;
        }

        FILE* fp_label = fopen(argv[4], "rb");
        if ( fp_label == NULL ) {
            fprintf(stderr, "File \"%s\" could not be opened, aborting!\n", argv[4]);
            fclose(fp_input);
            return 1;
        }

        bnn_op(bnn, fp_input, fp_label, op);

        printf("%s completed.\n", op == OP_TRAIN ? "Training" : "Testing");

        fclose(fp_input);
        fclose(fp_label);

        // Only save the nnet if we were training it
        if ( op == OP_TRAIN ) {
            if ( bnn_write(bnn, argv[2]) ) {
                return 1;
            }
        }

        printf("All done.\n");

    } else {
        printf(usage_message);
        return 1;
    }

    return 0;
}
