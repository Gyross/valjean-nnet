//
// Created by wmpmiles on 19/03/19.
//

#ifndef VALJEAN_NNET_BNN_H
#define VALJEAN_NNET_BNN_H

#include <stdint.h>
#include <stdio.h>

#define CEIL_DIV(x, y) ((x + y - 1) / y)
#define SIZE(x) (sizeof(x) * 8)

#define LAYER_MAX 50
#define NODE_MAX 1000

#define INP_VEC_SIZE CEIL_DIV(NODE_MAX, SIZE(BNNI))
#define WGT_VEC_SIZE INP_VEC_SIZE

typedef enum op_t {
    TEST,
    TRAIN
} op_t;

typedef uint32_t BNNW;
typedef int32_t BNNB;
typedef uint32_t BNNS;
typedef uint32_t BNNI;
typedef int32_t BNNO;

struct bnn {
    BNNS layers;
    BNNS layer_sizes[LAYER_MAX];
    BNNW weight[LAYER_MAX][NODE_MAX][WGT_VEC_SIZE];
    BNNB bias[LAYER_MAX][NODE_MAX];
};

typedef struct bnn *BNN;
typedef struct bnn bnn_alloc;

void bnn_new(BNN bnn, BNNS layers, BNNS layer_sizes[]);
int bnn_write(BNN bnn, const char *filename);
int bnn_read(BNN bnn, const char *filename);
int bnn_op(BNN bnn, FILE *fp_input, FILE *fp_label, op_t op);

#endif //VALJEAN_NNET_BNN_H
