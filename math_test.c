#include "nnet_math.h"
#include <stdio.h>
#include <stdlib.h>

void print_float( float* input, int n ) {
    int i;
    for ( i = 0; i < n; i++ ) {
        printf("%f ", *input);
        input++;
    }

    printf("\n");
}

int main ( int argc, char* argv[] ) {
    float M[2][3] = {{ 1.0, 2.0, 3.0 },
                     { 4.0, 5.0, 6.0 }};

    print_float( (float *)M, 2*3 );
    
    float vec_a[3] = { 1.0, 2.0, 1.0 };
    float vec_b[2];

    matrix_multiply( (float *)M, vec_a, vec_b, 3, 2);

    print_float( vec_b, 2 );

    float vec_c[3] = { 5.0, 4.0, 5.0 };

    vector_add_inplace( vec_c, vec_a, 3 );

    print_float( vec_c, 3 );

    float vec_d[3] = { 9.0, -3.0, -0.01 };

    vector_relu( vec_d, 3 );

    print_float( vec_d, 3 );
    

    return 0;
}
