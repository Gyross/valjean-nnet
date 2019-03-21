//
// Created by wmpmiles on 19/03/19.
//

#ifndef VALJEAN_NNET_BNN_H
#define VALJEAN_NNET_BNN_H

#include <stdint.h>

struct bnn {
    unsigned layers;
    unsigned layer_sizes[LAYER_MAX];
    uint64_t weight[LAYER_MAX][NODE_MAX][CEIL_DIV(NODE_MAX, BPF)];
    int bias[LAYER_MAX][NODE_MAX];
};

typedef struct bnn *BNN;
typedef struct bnn bnn_alloc;

int bnn_new(BNN bnn, unsigned layers, unsigned layer_sizes[]);
int bnn_write(BNN bnn, const char *filename);
int bnn_read(BNN bnn, const char *filename);
void bnn_op(BNN bnn, FILE *fp_input, FILE *fp_label, int op);

#endif //VALJEAN_NNET_BNN_H
