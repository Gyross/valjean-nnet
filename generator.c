#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*
 * Edit the function map()
 * and the NUM_* defines to change what
 * function to train the neural network
 * on.
 *
 * Main will handle file IO etc.
 */

#define NUM_CASES 100000

#define NUM_INPUTS 2
#define NUM_OUTPUTS 2

#define INPUT_MIN 0.0
#define INPUT_MAX 1.0


void map(float* x, float* y) {
    y[0] = sin(x[0])*cos(x[1]);
    y[1] = cos(x[0])*sin(x[1]);
}


// -------------------------------------------

int main(int argc, char* argv[]) {
    float input_vec[NUM_INPUTS];
    float output_vec[NUM_OUTPUTS];

    FILE* fp = fopen(argv[1], "wb");

    if ( fp != NULL ) {
        unsigned int n_inputs  = NUM_INPUTS;
        unsigned int n_outputs = NUM_OUTPUTS;
        float range = INPUT_MAX - INPUT_MIN;

        fwrite( &n_inputs, sizeof(unsigned int), 1, fp );
        fwrite( &n_outputs, sizeof(unsigned int), 1, fp );

        // Generate new random seed
        unsigned int seed;
        FILE* urandom = fopen("/dev/urandom", "r");
        fread(&seed, sizeof(int), 1, urandom);
        fclose(urandom);
        srand(seed);

        for ( long int i = 0; i < NUM_CASES; i++ ) {
            for ( unsigned int j = 0; j < NUM_INPUTS; j++ ) {
                input_vec[j] = ((float)rand()/(float)(RAND_MAX))*range + INPUT_MIN;
            }

            map(input_vec, output_vec);

            fwrite(input_vec, sizeof(float), NUM_INPUTS, fp);
            fwrite(output_vec, sizeof(float), NUM_OUTPUTS, fp);
        }
    }

    fclose(fp);

    return 0;
}
