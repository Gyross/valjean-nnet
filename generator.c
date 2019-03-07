#include <stdlib.h>
#include <stdio.h>

#define NUM_CASES 1000
#define NUM_INPUTS 1
#define NUM_OUTPUTS 1

int main(int argc, char* argv[]) {
    float write_buf[NUM_CASES*2];
    FILE* fp = fopen(argv[1], "wb");

    if ( fp != NULL ) {
        int n_inputs  = NUM_INPUTS;
        int n_outputs = NUM_OUTPUTS;

        fwrite( &n_inputs, sizeof(int), 1, fp );
        fwrite( &n_outputs, sizeof(int), 1, fp );

        int i;
        for ( i = 0; i < NUM_CASES; i++ ) {
            float x = (float)rand()/(float)(RAND_MAX/100);
            float y = 2.0*x + 3.0;
            write_buf[2*i] = x;
            write_buf[2*i + 1] = y;
        }

        fwrite(write_buf, sizeof(float), NUM_CASES*2, fp);
    }

    fclose(fp);

    return 0;
}
