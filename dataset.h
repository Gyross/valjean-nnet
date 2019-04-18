#ifndef VALJEAN_DATASET_H
#define VALJEAN_DATASET_H

#include <stdio.h>
#include "types.h"

/*
 * Creates dataset from files
 * Checks the internal consistency of files
 *
 * NB: It is up to the caller to ensure the number of inputs and
 *     outputs matches the parameters of the network. 
 * 
 * Parameters:
 *   input_filename: Name of the file containing input cases
 *                   This is mandatory
 *   label_filename: Name of the file containing labels for input cases
 *                   Can optionally be NULL if dataset is unlabelled
 * Returns:
 *   The dataset object if successful, otherwise NULL
 */
dataset dataset_create(const char* input_filename, const char* label_filename);


/*
 * Destroys the passed dataset object
 * Can be safely called on NULL
 */
void dataset_destroy(dataset ds);


/*
 * Read the next case from the dataset,
 * store the inputs into input_vec,
 * store the label at label_p, provided the dataset is labelled
 *
 * If input_vec and/or label_p is NULL, then the data will be read
 * without storing it into the NULL parameter.
 *
 * Returns:
 *    1 on successful read
 *    0 on EOF
 *   -1 on error
 */
int dataset_read(dataset ds, INPT* input_vec, LBLT* label_p);


/*
 * Go back to the start of the dataset
 * The next dataset_read call will read the first case in the dataset
 */
void dataset_rewind(dataset ds);


/*
 * Mark the start of a particular batch
 */
void dataset_batch_start(dataset ds);


/*
 * Rewind to the point marked by dataset_batch_start
 */
void dataset_batch_rewind(dataset ds);


/*
 * Returns the number of inputs specified by the input file
 */
BNNS dataset_num_inputs(dataset ds);


/*
 * Returns the number of outputs specified by the label file
 * If the dataset is unlabelled, a junk value will be returned
 */
BNNS dataset_num_outputs(dataset ds);


/*
 * Returns the number of cases in the dataset
 */
int dataset_num_cases(dataset ds);


/*
 * Returns 1 if the dataset is labelled
 * otherwise returns 0
 */
int dataset_is_labelled(dataset ds);


#endif
