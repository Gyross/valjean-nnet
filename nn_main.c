#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include "xorgens.h"
#include "bnn.h"
#include "error_handling.h"
#include "config.h"
#include "dataset.h"

#define USAGE "\n\
Usage:\n \
    nnet new <filename> <layer size>...\n\
    nnet {test, train, anneal} <nnet filename> <input file> <label file>\
"


// GLOBAL VARIABLES
bnn_alloc _bnn;


// PROTOTYPES
static void initPRNG(void);


// FUNCTIONS
#ifdef RUN
int main( int argc, char* argv[] ) {
    MSG("NN operation successful!");

    initPRNG();

    BNN bnn = &_bnn;
    dataset ds = NULL;

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
    } else if ( strcmp(argv[1], "test")   == 0 || 
                strcmp(argv[1], "train")  == 0 ||
                strcmp(argv[1], "anneal") == 0 )
    {
        CHECK(argc != 5, "Incorrect number of arguments!\n" USAGE, 1);
        PASS(bnn_read(bnn, argv[2]), 1);

        int op;
        if ( strcmp( argv[1], "test" ) == 0 ) {
            op = TEST;
        } else if ( strcmp( argv[1], "train" ) == 0 ) {
            op = TRAIN;
        } else {
            op = ANNEAL;
        }

        CHECK(NULL == (ds = dataset_create(argv[3],argv[4])), "Error creating dataset!\n", 1);
        
        int ret;
        if (!(ret = bnn_op(bnn, ds, op))) {
            printf("%s completed.\n", 
                    op == TEST ? "Testing" : 
                    op == TRAIN ? "Training" : "Annealing" );

            // Only save the nnet if we were training or annealing
            if ( op == TRAIN || op == ANNEAL ) {
                PASS(bnn_write(bnn, argv[2]), 1);
            }
        } else {
            PASS(ret, 1);
        }

    } else {
        CHECK(1, "Invalid arguments." USAGE, 1);
    }

error1:
    dataset_destroy(ds);
    RETURN;
}
#endif

static void initPRNG() {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    xor4096i((UINT)ts.tv_nsec);
}
