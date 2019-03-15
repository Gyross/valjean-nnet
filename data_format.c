#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define BUF_SIZE 4096


// Specifying the output type
// Comment out all execpt the one you want
typedef float out_t;
// typedef int8_t out_t;

int main(int argc, char* argv[]) {
    uint8_t in_buf[BUF_SIZE];
    out_t  out_buf[BUF_SIZE];
    size_t amt;

    if ( argc == 3 ) {
        FILE* fp_in;
        FILE* fp_out;
        fp_in = fopen( argv[1], "rb" );
        fp_out = fopen( argv[2], "wb" );
        assert( fp_in != NULL && fp_out != NULL );

        // Seek to start of images
        fseek(fp_in, 16, SEEK_SET);

        // Put the correct header in the output file
        int n_inputs = 28*28;
        assert(fwrite( &n_inputs, sizeof(int), 1, fp_out ));

        while(1) {
            amt = fread( in_buf, sizeof(uint8_t), BUF_SIZE, fp_in );

            if ( amt == 0 ) break;

            // Convert ints in buffer
            for ( int i = 0; i < amt; i++ ) {
                out_buf[i] = (out_t)(in_buf[i] - 128);
            }

            assert( amt == fwrite( out_buf, sizeof(out_t), amt, fp_out ) );
        }

        fclose(fp_in);
        fclose(fp_out);
    }

    return 0;
}
