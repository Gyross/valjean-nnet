#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "mnist_int8_input.h"
#include "dataset.h"

int main( int argc, char* argv[] ) {
    dataset ds = NULL;
    INPT image[784];
    char gscale[] = " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$";

    int gscale_len = strlen(gscale);

    assert(argc == 2);
    ds = dataset_create( argv[1], NULL );


    while ( 1 == dataset_read(ds, image, NULL) ) {
        for ( int i = 0; i < 784; i++ ) {
            if ( i % 28 == 0 ) {
                printf("\n");
            }

            printf("%c", gscale[(gscale_len * (image[i] + 128))/256]);
        }
    }
    
    dataset_destroy(ds);

    return 0;
}
