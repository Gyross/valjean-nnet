#ifndef VALJEAN_NNET_ANNEAL_H
#define VALJEAN_NNET_ANNEAL_H

#include "types.h"

enum anneal_param {
    PARAM_NONE,
    PARAM_WEIGHT,
    PARAM_BIAS
};

enum anneal_decision {
    DECISION_NONE,
    DECISION_ACCEPT,
    DECISION_REJECT
};

// Linked list structure to keep track of the perturbations made.
struct perturb_list {
    enum anneal_param param;
    BNNS fp_step;
    BNNS r_node;
    // For weights only
    BNNS     l_node_index;
    uint32_t l_node_offset;
    // For biases only
    BNN_real amount;

    struct perturb_list* next;
};

// Perturb list helper functions
struct perturb_list* perturb_list_create(void);
void perturb_list_free( struct perturb_list* list );

struct anneal_state {
    double temperature;
    double energy;

    double cooling_factor;
    double end_temperature;

    uint32_t iteration;

    // Stored number of parameters
    // Might want to move these to the bnn struct later
    uint32_t total_weights;
    uint32_t total_biases;
    uint32_t total_parameters;
};

void anneal( BNN bnn, dataset ds );
void anneal_init( BNN bnn, struct anneal_state* state );
struct perturb_list* anneal_perturb( BNN bnn, struct anneal_state* state );
void anneal_revert( BNN bnn, struct perturb_list* p );
enum anneal_decision anneal_decide( struct anneal_state* state, double new_energy );
void anneal_cool( struct anneal_state* state );
uint32_t anneal_end( struct anneal_state* state );

#endif
