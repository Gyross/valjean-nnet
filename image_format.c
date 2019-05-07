#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include "config.h"

#define BUF_SIZE 4096


#define OUTPUT_FLOAT

#ifdef OUTPUT_FLOAT
    typedef float out_t;
#else
    typedef int8_t out_t;
#endif

#ifdef DATA_FORMAT
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
        uint32_t n_inputs = 28*28;
        assert(fwrite( &n_inputs, sizeof(uint32_t), 1, fp_out ));

        while(1) {
            amt = fread( in_buf, sizeof(uint8_t), BUF_SIZE, fp_in );

            if ( amt == 0 ) break;

            // Convert ints in buffer
            for ( int i = 0; i < amt; i++ ) {
                out_buf[i] = (out_t)(in_buf[i] - 128);

                #ifdef OUTPUT_FLOAT
                    out_buf[i] = out_buf[i] / 128.0;
                #endif
            }

            assert( amt == fwrite( out_buf, sizeof(out_t), amt, fp_out ) );
        }

        fclose(fp_in);
        fclose(fp_out);
    }

    return 0;
}
#endif
