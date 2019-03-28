#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

/*
 * Edit the function map()
 * and the NUM_* defines to change what
 * function to train the neural network
 * on.
 *
 * Main will handle file IO etc.
 */

#define NUM_CASES 16

#define NUM_INPUTS 4
#define NUM_OUTPUTS 5

int main(int argc, char* argv[]) {
    int8_t input[NUM_INPUTS];
    uint8_t label;

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
            label = 0;

            for ( unsigned int j = 0; j < NUM_INPUTS; j++ ) {
                if ( rand() % 2 ) {
                    input[j] = 127;
                    ++label;
                } else {
                    input[j] = -128;
                }
            }

            fwrite(input, sizeof(int8_t), NUM_INPUTS, fp_input);
            fwrite(&label, sizeof(uint8_t), 1, fp_label);
        }
    }

    fclose(fp_input);
    fclose(fp_label);

    return 0;
}
