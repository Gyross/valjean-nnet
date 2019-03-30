#include "energy.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bnn.h"
#include "error_handling.h"
#include "binarised_fp.h"

#define ENERGY_PRINT_DEBUG


// energy for each test case
double partial_energy( BNN bnn, LBLT label, BNNO* output_vec, BNNS vec_size ) {
    double diff;
    double sum = 0.0;
    BNNO expected;

    for ( int i = 0; i < vec_size; ++i ) {

        if ( i == label ) {
            expected = bnn->layer_sizes[bnn->layers-2];
        } else {
            expected = - bnn->layer_sizes[bnn->layers-2];
        }

        diff = expected - output_vec[i];
        sum += diff*diff;
    }

    return sum;
}

LBLT find_output_label( BNNO* output_vec, BNNS vec_size ) {
    BNNO highest = output_vec[0];
    BNNS label   = 0;

    for ( LBLT i = 1; i < vec_size; i++ ) {
        if ( output_vec[i] > highest ) {
            label   = i;
            highest = output_vec[i];
        }
    }

    return label;
}


// An initial implementation is to do a full pass on the data set
// for every calculation of energy
double compute_energy( BNN bnn, FILE* fp_input, FILE* fp_label ) {
    MSG("Beginning energy computation\n");

    BNNS n_inputs, n_outputs;
    INPT input_vec[NODE_MAX];
    BNNO output_vec[NODE_MAX];
    size_t amt_read;
    LBLT label, output_label;

    size_t if_size, il_size;

    uint32_t n_cases   = 0;
    uint32_t n_correct = 0;

    double energy = 0.0;
    
    // Go to the start of the file
    fseek( fp_input, 0, SEEK_SET );
    fseek( fp_label, 0, SEEK_SET );

    // Read number of inputs and outputs expected by file and do some checking
    CHECK(fread( &n_inputs, sizeof(BNNS), 1, fp_input ) != 1, "File corrupted!", 1);
    CHECK(fread( &n_outputs, sizeof(BNNS), 1, fp_label ) != 1, "File corrupted!", 1);

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    CHECK(n_inputs != bnn->layer_sizes[0], "Incorrect number of inputs!", 1);
    CHECK(n_outputs != bnn->layer_sizes[bnn->layers-1], "Incorrect number of outputs!", 1);

    // Check the files are the correct size for the number of inputs
    fseek( fp_input, 0, SEEK_END );
    if_size = ftell(fp_input);
    CHECK((if_size - sizeof(BNNS)) % (n_inputs * sizeof(INPT)) != 0, "Incorrect input file size!", 1);
    fseek( fp_label, 0, SEEK_END );
    il_size = ftell(fp_label);
    CHECK((il_size - sizeof(BNNS)) % (sizeof(LBLT)) != 0, "Incorrect label file size!", 1);

    // Check the file sizes are compatile with each other
    CHECK((if_size - sizeof(BNNS))/(n_inputs * sizeof(INPT)) !=
          (il_size - sizeof(BNNS))/sizeof(LBLT), "Incompatible file sizes!", 1);

    // Go to the first input/label of the file
    fseek( fp_input, sizeof(uint32_t), SEEK_SET );
    fseek( fp_label, sizeof(uint32_t), SEEK_SET );

    // Loop until we reach the end of the file
    while( ( amt_read = fread( input_vec, sizeof(INPT), n_inputs, fp_input ) ) != 0 ) {

        CHECK(
            amt_read != n_inputs, 
            "Incorrect number of bytes in input read!", 1
        );

        CHECK(
            fread( &label, sizeof(LBLT), 1, fp_label ) != 1,
            "Incorrect number of bytes in label read!", 1
        );

        forward_pass(bnn, input_vec, output_vec);

        #ifdef ENERGY_PRINT_DEBUG
            ++n_cases;
            output_label = find_output_label(output_vec, n_outputs); 
            if ( output_label == label ) {
               ++n_correct;
            }
            for ( int i = 0; i < n_inputs; i++ ) {
                printf( "%d,", input_vec[i] );
            }
            printf( " -> " );
            for ( int i = 0; i < n_outputs; i++ ) {
                printf( "%d,", output_vec[i] );
            }
            printf( "\t got %d expect %d\n", output_label, label );
        #endif

        energy += partial_energy(bnn, label, output_vec, n_outputs);
    }

    #ifdef ENERGY_PRINT_DEBUG
        printf("%f%% correct\n", n_correct/(double)n_cases);
    #endif

    return energy;

error1:
    RETURN;
}

