#include <stdlib.h>
#include <stdio.h>

/*
 * Edit the function f()
 * and the NUM_* defines to change what
 * function to train the neural network
 * on.
 *
 * Main function will handle file IO etc.
 */

#define NUM_CASES 1000

#define NUM_INPUTS 2
#define NUM_OUTPUTS 2

#define INPUT_MIN 0.0
#define INPUT_MAX 1.0


void map(float* x, float* y) {
    y[0] = 0.5*x[0] + 0.2*x[1] - 0.1;
    y[1] = 0.7*x[0] - 0.5*x[1] + 0.8;
}


// -------------------------------------------

int main(int argc, char* argv[]) {
    float write_buf[NUM_CASES*4];
    FILE* fp = fopen(argv[1], "wb");

    if ( fp != NULL ) {
        int n_inputs  = NUM_INPUTS;
        int n_outputs = NUM_OUTPUTS;

        fwrite( &n_inputs, sizeof(int), 1, fp );
        fwrite( &n_outputs, sizeof(int), 1, fp );

        float input_vec[NUM_INPUTS];
        float output_vec[NUM_OUTPUTS];
        float range = INPUT_MAX - INPUT_MIN;

        for ( int i = 0; i < NUM_CASES; i++ ) {
            for ( int j = 0; i < NUM_INPUTS; i++ ) {
                input_vec[i] = ((float)rand()/(float)(RAND_MAX))*range + INPUT_MIN;
            }

            map(input_vec, output_vec);

            fwrite(input_vec, sizeof(float), NUM_INPUTS, fp);
            fwrite(output_vec, sizeof(float), NUM_OUTPUTS, fp);
        }
    }

    fclose(fp);

    return 0;
}
