#include <stdlib.h>
#include <stdio.h>

#define NUM_CASES 100000
#define NUM_INPUTS 2
#define NUM_OUTPUTS 2

int main(int argc, char* argv[]) {
    float write_buf[NUM_CASES*4];
    FILE* fp = fopen(argv[1], "wb");

    if ( fp != NULL ) {
        int n_inputs  = NUM_INPUTS;
        int n_outputs = NUM_OUTPUTS;

        fwrite( &n_inputs, sizeof(int), 1, fp );
        fwrite( &n_outputs, sizeof(int), 1, fp );

        int i;
        for ( i = 0; i < NUM_CASES; i++ ) {
            float x1 = (float)rand()/(float)(RAND_MAX/1);
            float x2 = (float)rand()/(float)(RAND_MAX/1);
            float y1 = x1 + x2 + 0.1;
            float y2 = x1 - x2 + 0.6;
            write_buf[4*i] = x1;
            write_buf[4*i + 1] = x2;
            write_buf[4*i + 2] = y1;
            write_buf[4*i + 3] = y2;
        }

        fwrite(write_buf, sizeof(float), NUM_CASES*2, fp);
    }

    fclose(fp);

    return 0;
}
