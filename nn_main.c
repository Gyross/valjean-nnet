#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include "xorgens.h"
#include "bnn.h"
#include "error_handling.h"

#define USAGE "\n\
Usage:\n \
    nnet new <filename> <layer size>...\n\
    nnet train <nnet filename> <input file> <label file>...\n\
    nnet test <nnet filename> <input file> <label file>\
"


// GLOBAL VARIABLES
bnn_alloc _bnn;


// PROTOTYPES
static void initPRNG();


// FUNCTIONS
int main( int argc, char* argv[] ) {
    MSG("NN operation successful!");

    initPRNG();

    BNN bnn = &_bnn;

    if (argc == 2) {
        bnn_read(bnn, argv[1]);
        bnn_print(bnn);
        return EXIT_SUCCESS;
    }

    CHECK(argc < 3, "Invalid arguments." USAGE, 1);

    if ( strcmp(argv[1], "new") == 0 ) {
        // If we are at this point we are guaranteed that argc > 3, so this
        // subtraction is valid.
        BNNS layers = (BNNS)argc - 3;

        CHECK(layers < 2, "You must specify at least two layers." USAGE, 1);

        BNNS layer_sizes[LAYER_MAX];
        for ( BNNS i = 0; i < layers; i++ ) {
            // Layer input layer sizes start at argv[3], hence we use an
            // offset of 3 when indexing argv[]
            errno = 0;
            long size = strtol(argv[i+3], NULL, 0);
            CHECK(errno != 0 || size < 1 || size > NODE_MAX, "Invalid layer size!", 1);
            layer_sizes[i] = (unsigned)size;
        }

        bnn_new(bnn, layers, layer_sizes);

        PASS(bnn_write(bnn, argv[2]), 1);
    } else if
        (strcmp(argv[1], "train") == 0 || strcmp(argv[1], "test") == 0)
    {
        CHECK(argc != 5, "Incorrect number of arguments!\n" USAGE, 1);
        PASS(bnn_read(bnn, argv[2]), 1);

        int op = strcmp(argv[1], "train" ) ? TEST : TRAIN;

        FILE* fp_input = fopen(argv[3], "rb");
        CHECK(fp_input == NULL, "Input file could not be opened, aborting!", 1);

        FILE* fp_label = fopen(argv[4], "rb");
        CHECK(fp_label == NULL, "Label file could not be opened, aborting!\n", 2);

        int ret;
        if (!(ret = bnn_op(bnn, fp_input, fp_label, op))) {
            printf("%s completed.\n", op == TRAIN ? "Training" : "Testing");

            // Only save the nnet if we were training it
            if ( op == TRAIN ) {
                PASS(bnn_write(bnn, argv[2]), 3);
            }
        } else {
            PASS(ret, 3);
        }

    error3:
        fclose(fp_label);
    error2:
        fclose(fp_input);
    } else {
        CHECK(1, "Invalid arguments." USAGE, 1);
    }

error1:
    RETURN;
}

static void initPRNG() {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    xor4096i((UINT)ts.tv_nsec);
}
