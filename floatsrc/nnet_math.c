#include "nnet_math.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>

/*
 * Performs the matrix multiplication:
 *  matrix * in_vec
 * and stores the result in out_vec.
 *
 * matrix MUST be an out_size x in_size matrix, otherwise
 * things will break, probably horribly. No funny stuff.
 */
void matrix_multiply(float* matrix, float* in_vec, float* out_vec,
                     int in_size, int out_size) {

    // TODO probably remove these
    assert(matrix != NULL);
    assert(in_vec != NULL);
    assert(out_vec != NULL);
    assert(in_size != 0);
    assert(out_size != 0);

    int i, j;
    for ( i = 0; i < out_size; i++ ) {
        float accumulator = 0.0;

        for ( j = 0; j < in_size; j++ ) {

            accumulator += (*(matrix+j+i*in_size)) * in_vec[j];

        }

        out_vec[i] = accumulator;
    }
}

/*
 * performs vec_a = vec_a + vec_b
 * both vectors should of length vec_size
 * otherwise bad things might happen
 */
void vector_add_inplace(float* vec_a, float* vec_b, int vec_size) {

    // TODO probably remove these
    assert(vec_a != NULL);
    assert(vec_b != NULL);
    assert(vec_size != 0);

    int i;
    for ( i = 0; i < vec_size; i++ ) {
        vec_a[i] = vec_a[i] + vec_b[i];
    }
}

/*
 * performs a reLU on all the elements in the input vector
 */
void vector_relu(float* vec, int vec_size) {

    // TODO probably remove these
    assert(vec != NULL);
    assert(vec_size != 0);

    int i;
    for ( i = 0; i < vec_size; i++ ) {
        if ( vec[i] < 0.0 ) {
            vec[i] = 0.01*vec[i];
        }
    }
}


float cost_func(float* output_vec, float* expected_vec, int vec_size) {
    float cost = 0;
    int i; 
    for ( i = 0; i < vec_size; i++ ) {
        float output = output_vec[i];

        // If outputs are less than 0 or greater than 1,
        // treat them the same as 0 or 1 respectively
        if ( output > 1.0 ) {
            output = 1.0;
        } else if ( output < 0.0 ) {
            output = 0.0;
        }

        float diff = expected_vec[i] - output;
        cost += diff*diff;
    }

    return cost;
}


/*
 * Generates n floats ~ N(0,1)
 *
 */
void normal_rand(float* values, int n)
{
    const int nsum = 25;

    assert(values != NULL);
    assert(n != 0);


    // Get a new random seed (probably won't be able to do this on zedboard)
    unsigned int seed;
    FILE* urandom = fopen("/dev/urandom", "r");
    fread(&seed, sizeof(int), 1, urandom);
    fclose(urandom);
    srand(seed);

    int i;
    for ( i = 0; i < n; i++ ) {
	float x = 0;
	int j;
        for(j = 0; j < nsum; j++) {
            x += (double)rand() / RAND_MAX;
        }

	x -= nsum / 2.0;
	x /= sqrt(nsum / 12.0);

        values[i] = x;
    }

}
