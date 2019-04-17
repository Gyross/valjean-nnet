#include "dataset.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "mnist_int8_input.h"
#include "bnn.h"

/* Assertion macros for the dataset file
 *
 * This saves writing the if statement over and over
 * Need to initialize so that we know which dataset to destroy 
 * on a failed assert
 */

#define DS_ASSERT_INIT(_x) dataset _ds = _x

#define DS_ASSERT(_e, _m)      \
    if(!(_e)) {                \
        fprintf(stderr, _m);   \
        fprintf(stderr, "\n"); \
        dataset_destroy(_ds);  \
        return NULL;           \
    }


struct dataset {
    FILE* fp_input;   // Should always be valid
    FILE* fp_label;   // Allowed to be NULL if dataset is unlabelled
    BNNS num_inputs;  // Should always be valid
    BNNS num_outputs; // Not valid if dataset is unlabelled
    int num_cases;    
};


dataset dataset_create(const char* input_filename, const char* label_filename) {

    dataset ds = NULL;
    size_t if_size, lf_size;

    // Initialize the DS_ASSERT macro
    DS_ASSERT_INIT(ds);

    // We require specifying an input file
    // If label_filename is null, the dataset is unlabelled
    DS_ASSERT( 
        input_filename != NULL, 
        "An input file must be specified" 
    );

    DS_ASSERT( 
        NULL != (ds = malloc(sizeof (struct dataset))), 
        "dataset malloc returned NULL" 
    );

    // Initialize dataset
    ds->fp_input = NULL;
    ds->fp_label = NULL;
    ds->num_inputs = 0;

    // Open the input file
    DS_ASSERT( 
        NULL != (ds->fp_input = fopen(input_filename, "rb")),
        "Could not open input file!" 
    );

    // Get number of inputs
    DS_ASSERT( 
        1 == fread(&(ds->num_inputs), sizeof(ds->num_inputs), 1, ds->fp_input),
        "Input file empty!"
    );

    // Get the input filesize
    fseek( ds->fp_input, 0, SEEK_END );
    if_size = ftell( ds->fp_input ); 

    // Check if the file is the correct size for the number of inputs
    DS_ASSERT(
        0 == (if_size - sizeof(ds->num_inputs)) % (ds->num_inputs * sizeof(INPT)),
        "Incorrect input file size!"
    );

    // Set num_cases
    ds->num_cases = (if_size - sizeof(ds->num_inputs))/(ds->num_inputs * sizeof(INPT));

    // If label_filename is not NULL, then the dataset labelled
    if ( label_filename != NULL ) {

        // Open label file
        DS_ASSERT( 
            NULL != (ds->fp_label = fopen(label_filename, "rb")),
            "Could not open label file!" 
        );

        // Get number of outputs
        DS_ASSERT(
            1 == fread(&(ds->num_outputs), sizeof(ds->num_outputs), 1, ds->fp_label),
            "Label file empty!"
        );

        // Get the label filesize
        fseek( ds->fp_label, 0, SEEK_END );
        lf_size = ftell( ds->fp_label );

        // Check if the file is the correct size for the number of outputs
        DS_ASSERT(
            0 == (lf_size - sizeof(ds->num_outputs)) % sizeof(LBLT),
            "Incorrect label file size!"
        );

        // Check the file sizes are compatible with each other
        // i.e. there must be as many labels as there are input cases
        DS_ASSERT(
            (if_size - sizeof(ds->num_inputs))/(ds->num_inputs * sizeof(INPT)) ==
            (lf_size - sizeof(ds->num_outputs))/sizeof(LBLT),
            "Number of inputs and number of labels do not match!"
        );
    }

    // Rewind to beginning of data files
    dataset_rewind(ds);

    return ds;
}


void dataset_destroy(dataset ds) {
    if ( ds != NULL ) {

        // Close input file
        if ( ds->fp_input != NULL ) {
            fclose(ds->fp_input);
            ds->fp_input = NULL;
        }

        // Close label file
        if ( ds->fp_label != NULL ) {
            fclose(ds->fp_label);
            ds->fp_label = NULL;
        }

        // Free malloced pointer
        free(ds);

    } else {
        fprintf(
            stderr, 
            "Function dataset_destroy was called on NULL dataset!\n"
        );
    }
}


/*
 * Returns:
 *    1 on successful read
 *    0 on EOF
 *   -1 on error
 */
int dataset_read(dataset ds, INPT* input_vec, LBLT* label_p) {
    size_t if_amt_read, lf_amt_read;
    INPT temp_input_vec[NODE_MAX];
    LBLT temp_label;

    // Read inputs into temp_input_vec
    if_amt_read = fread( temp_input_vec, sizeof(INPT), ds->num_inputs, ds->fp_input );

    // We expect to read either 0 on EOF or ds->num_inputs,
    // if we read an unexpeccted amount, error, so return -1
    if ( if_amt_read != 0 && if_amt_read != ds->num_inputs ) {
        return -1;
    }

    // If the dataset has a label file, we need to read from it too
    if ( ds->fp_label != NULL ) {
        lf_amt_read = fread( &temp_label, sizeof(LBLT), 1, ds->fp_label );

        // If we read more than 1, return error
        if ( lf_amt_read != 0 && lf_amt_read != 1 ) {
            return -1;
        }
    } else {
        // If we don't need to read a label file,
        // set lf_amt_read to pretend we did.
        lf_amt_read = (if_amt_read) ? 1 : 0;
    }

    // If both 0, EOF, so return 0
    // If one is zero and the other non-zero, error, return -1
    if ( if_amt_read == 0 && lf_amt_read == 0 ) {
        return 0;
    } else if ( if_amt_read == 0 || lf_amt_read == 0 ) {
        return -1;
    }

    // When we get here, we know the read was successful
    // Copy read values into the given addresses and return 1
    if ( input_vec != NULL ) {
        memcpy(input_vec, temp_input_vec, ds->num_inputs * sizeof(INPT)); 
    }
    if ( ds->fp_label != NULL && label_p != NULL ) {
        *label_p = temp_label;
    }

    return 1;
}


// Number of inputs specified by the input file
BNNS dataset_num_inputs(dataset ds) {
    return ds->num_inputs;
}


// Number of outputs specified by the label file
// Returns junk if data is unlabelled
BNNS dataset_num_outputs(dataset ds) {
    return ds->num_outputs;
}


// Number of cases in dataset
int dataset_num_cases(dataset ds) {
    return ds->num_cases;
}

// Returns 1 if the dataset is labelled
// i.e. it has an associated label file
// returns 0 otherwise
int dataset_is_labelled(dataset ds) {
    if ( ds->fp_label != NULL ) {
        return 1;
    } else {
        return 0;
    }
}


// Rewinds to the first case in the dataset
void dataset_rewind(dataset ds) {
    // If fp_input is null, give an error message
    if ( ds->fp_input != NULL ) {
        // Seek to just past the num_inputs field in the input file
        fseek( ds->fp_input, sizeof(ds->num_inputs), SEEK_SET );
    } else {
        fprintf( 
            stderr, 
            "Function dataset_rewind called on dataset with NULL fp_input!" 
        );
    }
    // fp_label is allowed to be null, so no error message needed
    if ( ds->fp_label != NULL ) {
        // Seek to just past the num_outputs field in the label file
        fseek( ds->fp_label, sizeof(ds->num_outputs), SEEK_SET );
    }
}
