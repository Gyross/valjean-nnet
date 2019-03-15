#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define OFF_VAL 0

// Choose the output data type
typedef float out_t;
//typedef int8_t out_t;

int main(int argc, char* argv[]) {

    if ( argc == 3 ) {
        FILE* fp_in;
        FILE* fp_out;
        fp_in = fopen( argv[1], "rb" );
        fp_out = fopen( argv[2], "wb" );
        assert( fp_in != NULL && fp_out != NULL );

        // Seek to start of labels
        fseek(fp_in, 8, SEEK_SET);

        // Put the correct header in the output file
        int n_inputs = 10;
        assert(fwrite( &n_inputs, sizeof(int), 1, fp_out ));


        uint8_t label; 
        const out_t on = (out_t)1;
        const out_t off = (out_t)OFF_VAL;

        while( fread( &label, sizeof(uint8_t), 1, fp_in ) ) {
            for ( int i = 0; i < label; i++ ) {
                fwrite( &off, sizeof(out_t), 1, fp_out );
            }

            fwrite( &on, sizeof(out_t), 1, fp_out );

            for ( int i = label+1; i < 10; i++ ) {
                fwrite( &off, sizeof(out_t), 1, fp_out );
            }
        }

        fclose(fp_in);
        fclose(fp_out);
    }

    return 0;
}
