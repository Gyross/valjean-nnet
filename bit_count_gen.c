#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define NUM_CASES 128

#define NUM_INPUTS 6
#define NUM_OUTPUTS 7

int get_smallest_index( int* array, int len ) {
    int smallest = array[0];
    int index    = 0;
    for ( int i = 1; i < len; i++ ) {
        if ( array[i] < smallest ) {
            index    = i;
            smallest = array[i];
        }
    }
    return index;
}

int main(int argc, char* argv[]) {
    int8_t input[NUM_INPUTS];
    uint8_t label;

    int hist[NUM_OUTPUTS];
    memset( hist, 0, sizeof(hist) );

    FILE* fp_input = fopen(argv[1], "wb");
    FILE* fp_label = fopen(argv[2], "wb");

    if ( fp_input != NULL && fp_label != NULL ) {
        unsigned int n_inputs  = NUM_INPUTS;
        unsigned int n_outputs = NUM_OUTPUTS;

        fwrite( &n_inputs, sizeof(unsigned int), 1, fp_input );
        fwrite( &n_outputs, sizeof(unsigned int), 1, fp_label );

        // Generate new random seed
        unsigned int seed;
        FILE* urandom = fopen("/dev/urandom", "r");
        fread(&seed, sizeof(int), 1, urandom);
        fclose(urandom);
        srand(seed);

        for ( long int i = 0; i < NUM_CASES; i++ ) {

            int req_label = get_smallest_index( hist, NUM_OUTPUTS );
            do {
                label = 0;
                for ( unsigned int j = 0; j < NUM_INPUTS; j++ ) {
                    if ( rand() % 2 ) {
                        input[j] = 127;
                        ++label;
                    } else {
                        input[j] = -128;
                    }
                }
            } while ( label != req_label );

            ++hist[label];

            fwrite(input, sizeof(int8_t), NUM_INPUTS, fp_input);
            fwrite(&label, sizeof(uint8_t), 1, fp_label);
        }
    }

    fclose(fp_input);
    fclose(fp_label);

    return 0;
}
