#include "energy.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bnn.h"
#include "error_handling.h"
#include "binarised_fp.h"


// energy for each test case
double partial_energy( BNN bnn, uint8_t label, BNNO* output_vec, BNNS vec_size ) {
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


// An initial implementation is to do a full pass on the data set
// for every calculation of energy
double compute_energy( BNN bnn, FILE* fp_input, FILE* fp_label ) {
    MSG("Beginning energy computation\n");

    BNNS n_inputs, n_outputs;
    INPT input_vec[NODE_MAX];
    BNNO output_vec[NODE_MAX];
    size_t amt_read;
    uint8_t label;

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
    CHECK((ftell(fp_input) - sizeof(BNNS)) % (n_inputs * sizeof(BNNI)) == 0, "Incorrect input file size!", 1);
    fseek( fp_label, 0, SEEK_END );
    CHECK((ftell(fp_label) - sizeof(BNNS)) % (n_outputs * sizeof(LBLT)) == 0, "Incorrect label file size!", 1);

    // Go back to the start of the file (again)
    fseek( fp_input, 0, SEEK_SET );
    fseek( fp_label, 0, SEEK_SET );

    // Loop until we reach the end of the file
    while( ( amt_read = fread( input_vec, sizeof(INPT), n_inputs, fp_input ) ) != 0 ) {

        CHECK(
            amt_read != n_inputs, 
            "Incorrect number of bytes in input read!", 1
        );

        CHECK(
            fread( &label, sizeof(uint8_t), 1, fp_label ) != 1,
            "Incorrect number of bytes in label read!", 1
        );

        forward_pass(bnn, input_vec, output_vec);

        energy += partial_energy(bnn, label, output_vec, n_outputs);
    }

    return energy;

error1:
    RETURN;
}

