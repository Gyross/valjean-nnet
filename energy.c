#include "energy.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "bnn.h"
#include "error_handling.h"
#include "binarised_fp.h"

#define ENERGY_PRINT_DEBUG

void soft_max( BNN_real* raw_vec, double* sm_vec, BNNS vec_size ) {
    double exp_vec[vec_size];
    double exp_sum = 0;

    // Compute expoentials of outputs & their sum
    for ( int i = 0; i < vec_size; i++ ) {
        exp_vec[i] = exp(raw_vec[i]);
        exp_sum += exp_vec[i];
    }

    // Normalise exponentials
    for ( int i = 0; i < vec_size; i++ ) {
        sm_vec[i] = exp_vec[i] / exp_sum;
    }
}



double _pe_square_error( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    double diff;
    double sum = 0.0;
    BNN_real expected;

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

double _pe_square_error_weighted( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    double diff;
    double sum = 0.0;
    BNN_real expected;

    // Increased weighting of pushing up the correct value
    for ( int i = 0; i < vec_size; ++i ) {
        if ( i == label ) {
            expected = bnn->layer_sizes[bnn->layers-2];
            diff = expected - output_vec[i];
            sum += (vec_size - 1)*diff*diff;
        } else {
            expected = - bnn->layer_sizes[bnn->layers-2];
            diff = expected - output_vec[i];
            sum += diff*diff;
        }

    }

    return sum;
}

double _pe_square_error_normalized( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    double diff;
    double sum = 0.0;
    double scaling = 0.0;
    BNN_real expected;

    for ( int i = 0; i < vec_size; ++i ) {
        if ( i == label ) {
            expected = bnn->layer_sizes[bnn->layers-2];
            diff = expected - output_vec[i];
            sum += (vec_size - 1)*diff*diff;
        } else {
            expected = - bnn->layer_sizes[bnn->layers-2];
            diff = expected - output_vec[i];
            sum += diff*diff;
        }

        scaling += abs(output_vec[i]);
    }

    return sum / scaling;
}


double _pe_exponential_difference( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    double diff;
    double sum = 0.0;

    for ( int i = 0; i < vec_size; ++i ) {
        if ( i != label ) {
            diff = output_vec[i] - output_vec[label];
            sum += exp(diff);
        }
    }
    
    return sum;
}

double _pe_cross_entropy( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    // Cross Entropy "energy" function
    double sum = 0.0;
    double sm_vec[vec_size];

    soft_max(output_vec, sm_vec, vec_size);

    for ( int i = 0; i < vec_size; ++i ) {
        if ( i == label ) {
            sum = -log(sm_vec[i]);
            break;
        }
    }

    return sum;
}


// energy for each test case
double partial_energy( BNN bnn, LBLT label, BNN_real* output_vec, BNNS vec_size ) {
    // return _pe_square_error( bnn, label, output_vec, vec_size );
    // return _pe_square_error_weighted( bnn, label, output_vec, vec_size );
    // return _pe_square_error_normalized( bnn, label, output_vec, vec_size );
    // return _pe_exponential_difference( bnn, label, output_vec, vec_size );
    return _pe_cross_entropy( bnn, label, output_vec, vec_size );
}


LBLT find_output_label( BNN_real* output_vec, BNNS vec_size ) {
    BNN_real highest = output_vec[0];
    BNNS label = 0;

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
double compute_energy( BNN bnn, dataset ds, uint32_t batch_size, 
                       double* frac_correct, int print_outputs ) {
    MSG("Beginning energy computation\n");

    INPT input_vec[NODE_MAX];
    BNN_real output_vec[NODE_MAX];
    LBLT label, output_label;

    int read_code;

    BNNS n_inputs  = bnn->layer_sizes[0];
    BNNS n_outputs = bnn->layer_sizes[bnn->layers-1];

    uint32_t n_cases   = 0;
    uint32_t n_correct = 0;

    double energy_sum = 0.0;

    // n_inputs and n_outpus have to be the same as the number of input and
    // output layers in the network, otherwise the data is
    // incompatible with the network.
    CHECK(dataset_num_inputs(ds)  != n_inputs, "Incorrect number of inputs!", 1);
    CHECK(dataset_num_outputs(ds) != n_outputs, "Incorrect number of outputs!", 1);

    // Loop until we reach the end of the batch
    while(n_cases < batch_size) {

        read_code = dataset_read(ds, input_vec, &label);

        if ( read_code == 0 ) {
            // EOF, go to start of dataset and read again
            dataset_rewind(ds);
            read_code = dataset_read(ds, input_vec, &label);
        } 

        CHECK((-1 == read_code), "Dataset read error!", 1);

        fp_wrapper(bnn, input_vec, output_vec);

        ++n_cases;

        output_label = find_output_label(output_vec, n_outputs); 

        energy_sum += partial_energy(bnn, label, output_vec, n_outputs);

        #ifdef ENERGY_PRINT_DEBUG
            if ( output_label == label ) {
               ++n_correct;
            }
            if ( print_outputs ) {
                for ( int i = 0; i < n_inputs; i++ ) {
                    printf( "%5d,", input_vec[i] );
                }
                printf( " -> " );
                for ( int i = 0; i < n_outputs; i++ ) {
                    printf( "%5.0f,", output_vec[i] );
                }
                printf( "\t got %d expect %d\n", output_label, label );
            }
        #endif
    }

    if ( frac_correct != NULL ) {
        *frac_correct = n_correct/(double)n_cases;
    }

    return energy_sum/n_cases;

error1:
    RETURN;
}

