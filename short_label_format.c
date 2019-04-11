#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define OFF_VAL 0


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
        uint32_t n_inputs = 10;
        assert(fwrite( &n_inputs, sizeof(uint32_t), 1, fp_out ));

        uint8_t label; 

        // Copy the labels directly
        while( fread( &label, sizeof(uint8_t), 1, fp_in ) ) {
            fwrite( &label, sizeof(uint8_t), 1, fp_out );
        }

        fclose(fp_in);
        fclose(fp_out);
    }

    return 0;
}
