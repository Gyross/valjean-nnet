#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include "mnist_int8_input.h"
#include "dataset.h"

int main( int argc, char* argv[] ) {
    INPT image[784];
    dataset ds = NULL;
    assert(argc == 2);
    ds = dataset_create( argv[1], NULL );


    while ( 1 == dataset_read(ds, image, NULL) ) {
        for ( int i = 0; i < 784; i++ ) {
            if ( i % 28 == 0 ) {
                printf("\n");
            }
            
            if ( image[i] >= 100 ) {
                printf("#");
            } else if ( image[i] >= 0 ) {
                printf("x");
            } else if ( image[i] >= -100 ) {
                printf("~");
            } else {
                printf(" ");
            }
        }
    }
    
    dataset_destroy(ds);

    return 0;
}
