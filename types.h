#ifndef VALJEAN_NNET_TYPES_H
#define VALJEAN_NNET_TYPES_H

#include <stdint.h>

/*
 * typedefs and forward declarations of the core
 * BNN types and structs
 */

// Data file types
typedef int8_t  INPT;
typedef uint8_t LBLT;

typedef float BNN_real; //bnn real number type
typedef uint32_t BNNS; // bnn size type
typedef uint32_t BNN_bin; //bnn binarised type

// BNN struct typedefs
struct bnn;
typedef struct bnn *BNN;
typedef struct bnn bnn_alloc;

// Datasets
struct dataset;
typedef struct dataset* dataset;

#endif
