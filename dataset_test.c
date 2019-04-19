#include <stdio.h>
#include <assert.h>
#include "dataset.h"
#include "bnn.h"
#include "mnist_int8_input.h"
#include "config.h"

#ifdef DATASET_TEST
int main( int argc, char* argv[]) {
    
    INPT input_vec[NODE_MAX];
    LBLT label;

    assert(argc == 3);
    dataset ds = dataset_create(argv[1], argv[2]);
    printf("\nInputs: %d, Outputs: %d\n", dataset_num_inputs(ds), dataset_num_outputs(ds));
    printf("Num Cases: %d\n\n", dataset_num_cases(ds));
    
    int count = 0;
    while ( dataset_read(ds, input_vec, &label) ) {
        ++count;
        for ( int i = 0; i < dataset_num_inputs(ds); i++ ) {
            printf("%5d ", input_vec[i]);
        }

        printf(" --> %3d\n", label);
    }

    assert(count == dataset_num_cases(ds));
    return 0;
}
#endif
