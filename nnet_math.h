#ifndef NNET_MATH_H
#define NNET_MATH_H

/*
 * Performs the matrix multiplication:
 *  matrix * in_vec
 * and stores the result in out_vec.
 *
 * matrix MUST be an out_size x in_size matrix, otherwise
 * things will break, probably horribly. No funny stuff.
 *
 * also you have to typecast the input matrix using (float *).
 */
void matrix_multiply(float* matrix, float* in_vec, float* out_vec, int in_size, int out_size);

/*
 * performs vec_a = vec_a + vec_b
 * both vectors should of length vec_size
 */
void vector_add_inplace(float* vec_a, float* vec_b, int vec_size);

/*
 * performs a reLU on all the elements in the input vector
 */
void vector_relu(float* vec, int vec_size);

/*
 * generates normally distributed random numbers
 */
void normal_rand(float* values, int n);

#endif
