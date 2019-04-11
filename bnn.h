//
// Created by wmpmiles on 19/03/19.
//

#ifndef VALJEAN_NNET_BNN_H
#define VALJEAN_NNET_BNN_H

#include <stdint.h>
#include <stdio.h>

#define CEIL_DIV(x, y) ((x + y - 1) / y)
#define SIZE(x) (sizeof(x) * 8)

#define LAYER_MAX 5
#define NODE_MAX 800

#define BIN_VEC_SIZE CEIL_DIV(NODE_MAX, SIZE(BNN_bin))

typedef enum op_t {
    TEST,
    TRAIN,
    ANNEAL
} op_t;

typedef float BNN_real; //bnn real number type
typedef uint32_t BNNS; // bnn size type
typedef uint32_t BNN_bin; //bnn binarised type

/*
 * BNN struct.
 * layers: number of layers.
 * layer_sizes[]: number of nodes in each layer.
 * weight: array of weight matrices in each layer.
 * bias: array of bias vectors in each layer.
 */
struct bnn {
    BNNS layers;
    BNNS layer_sizes[LAYER_MAX];
    BNN_bin weight[LAYER_MAX-1][NODE_MAX][BIN_VEC_SIZE];
	BNN_real weight_true[LAYER_MAX-1][NODE_MAX][NODE_MAX];
    BNN_real bias[LAYER_MAX-1][NODE_MAX];
	BNN_real activations_true[LAYER_MAX][NODE_MAX];
	BNN_bin b_activations[LAYER_MAX][NODE_MAX];
};



typedef struct bnn *BNN;
typedef struct bnn bnn_alloc;

/*
 * Function to create new BNN.
 * 
 * bnn: empty BNN struct (already allocated in memory).
 * layers: number of layers, including input and output layers.
 * layer_sizes: array of number of nodes in each layer.
 *		layer_sizes[0] is the number of input nodes.
 *		layer_sizes[layers-1] is the number of output nodes.
 *
 * The function assigns these values to the bnn and generates initialised random values for the weights and biases.
 */
void bnn_new(BNN bnn, BNNS layers, BNNS layer_sizes[]);

/*
 * Writes BNN values to a file.
 * 
 * bnn: non-empty BNN struct.
 * filename: file to be written to.
 */
int bnn_write(BNN bnn, const char *filename);

/*
 * Assigns BNN values based on input file.
 * 
 * bnn: empty BNN struct (already allocated in memory).
 * filename: file containing bnn layer sizes, weights, and biases.
 */
int bnn_read(BNN bnn, const char *filename);

void bnn_print(BNN bnn);

/*
 * Performs operation - training or testing.
 *
 * bnn: initialised bnn struct.
 * fp_input: input data for operation.
 * fp_label: data labels i.e. output data.
 * op_type: either training or testing.
 */
int bnn_op(BNN bnn, FILE *fp_input, FILE *fp_label, op_t op);

#endif //VALJEAN_NNET_BNN_H
