/*
 * Simulated Annealing Algorithm for BNN
 * 
 * author: Andrew Ross
 */

#include "anneal.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "bnn.h"
#include "xorgens.h"
#include "energy.h"

#define ANNEAL_PRINT_DEBUG

struct perturb_list* perturb_list_create() {
    struct perturb_list* new_perturb = malloc( sizeof(struct perturb_list) );
    if ( new_perturb != NULL ) {
        new_perturb->param         = PARAM_NONE;
        new_perturb->fp_step       = 0;
        new_perturb->r_node        = 0;
        new_perturb->l_node_index  = 0;
        new_perturb->l_node_offset = 0;
        new_perturb->amount        = 0.0;
        new_perturb->next          = NULL;
    }
    return new_perturb;
}

void perturb_list_free( struct perturb_list* list ) {
    struct perturb_list* temp = NULL;
    while( list != NULL ) {
        temp = list->next;
        free(list);
        list = temp;
    }
}

struct perturb_list* anneal_perturb( BNN bnn, struct anneal_state* as ) {
    struct perturb_list* list = NULL;
    struct perturb_list* p  = NULL;


    // Set these to one, later we might want to base these on temperature.
    uint32_t n_perturb_weights = 1;
    uint32_t n_perturb_biases  = 0;
    uint32_t n_perturb_total   = n_perturb_weights + n_perturb_biases;

    uint32_t rand_result;
    uint32_t matrix_size;

    for ( uint32_t i = 0; i < n_perturb_total; i++ ) {
        // Create the first element of the list if we need to, 
        // otherwise create an element and append to the end of the list.
        if ( list == NULL ) {
            list = perturb_list_create();
            p = list;
        } else {
            p->next = perturb_list_create();
            p = p->next;
        }
        
        // If malloc failed, we have to revert the peturbations we already
        // made, then free the linked list and return NULL.
        if ( p == NULL ) {
            anneal_revert(bnn, list);
            perturb_list_free(list);
            return NULL;
        }

        // Perturb weights first, then biases.
        if ( i < n_perturb_weights ) {
            p->param = PARAM_WEIGHT;


            // Select random weight
            rand_result = (xor4096i(0) % as->total_weights);
            
            // Find the forward pass step (matrix) the number refers to, and
            // make rand_result be the weight number in that matrix
            p->fp_step = 0;
            matrix_size = bnn->layer_sizes[p->fp_step] * 
                          bnn->layer_sizes[p->fp_step+1];
            while ( rand_result >= matrix_size ) {
                rand_result -= matrix_size;
                ++p->fp_step;
                matrix_size = bnn->layer_sizes[p->fp_step] 
                              * bnn->layer_sizes[p->fp_step+1];
            }

            // Decode the right node the weight connects to
            p->r_node = rand_result / bnn->layer_sizes[p->fp_step+1];

            // Decode the index and offset of the left node the weight
            // connects to
            rand_result      = rand_result % bnn->layer_sizes[p->fp_step+1];
            p->l_node_index  = rand_result / SIZE(BNN_bin);
            p->l_node_offset = rand_result % SIZE(BNN_bin);


            // Flip the weight
            BNN_bin bitmask = 1 << p->l_node_offset;
            bnn->weight[p->fp_step][p->r_node][p->l_node_index] ^= bitmask;

        } else {
            p->param = PARAM_BIAS;

            // Select random bias
            rand_result = (xor4096i(0) % as->total_biases);
            
            // Find which bias the number refers to
            p->fp_step = 0;
            while( rand_result >= bnn->layer_sizes[p->fp_step+1] ) {
                rand_result -= bnn->layer_sizes[p->fp_step+1];
                ++p->fp_step;
            }
            p->r_node = rand_result;

            // Generates either 1 or -1
            p->amount = (BNN_real)(((xor4096i(0) % 2) << 1) - 1);

            // Adjust the bias by the generated amount
            bnn->bias[p->fp_step][p->r_node] += p->amount;
        }
    }

    return list;
}

void anneal_revert( BNN bnn, struct perturb_list* p ) {
    while ( p != NULL ) {
        if ( p->param == PARAM_WEIGHT ) {
            // Flip back the weight we flipped
            BNN_bin bitmask = 1 << p->l_node_offset;
            bnn->weight[p->fp_step][p->r_node][p->l_node_index] ^= bitmask;
        } else if ( p->param == PARAM_BIAS ) {
            // Subtract the amount we added
            bnn->bias[p->fp_step][p->r_node] -= p->amount;
        }
        p = p->next;
    }
}

void anneal_init( BNN bnn, struct anneal_state* state, dataset ds ) {

    state->temperature = 0.1;

    state->energy = compute_energy(bnn, ds, 0);

    state->cooling_factor = 0.99999;
    state->end_temperature = 0.001;

    state->iteration = 1;

    // We will need to know the total number of weights and biases
    // so that we can select which parameters to perturb
    uint32_t total_biases  = 0;
    uint32_t total_weights = 0;
    for ( uint32_t i = 1; i < bnn->layers; i++ ) {
        total_biases  += bnn->layer_sizes[i];
        total_weights += bnn->layer_sizes[i]*bnn->layer_sizes[i-1];
    }
    state->total_biases     = total_biases;
    state->total_weights    = total_weights;
    state->total_parameters = total_weights + total_biases;
}

enum anneal_decision anneal_decide( struct anneal_state* state, double new_energy ) {
    double boltzmann;

    #ifdef ANNEAL_PRINT_DEBUG
        printf( "Old Energy: %f, New Energy: %f\n", state->energy, new_energy );
    #endif

    if ( new_energy <= state->energy ) {
        state->energy = new_energy;
        return DECISION_ACCEPT;
    } else {
        boltzmann = exp((state->energy - new_energy) / state->temperature);
        if ( xor4096r(0) < boltzmann ) {
            state->energy = new_energy;
            return DECISION_ACCEPT;
        }
    }

    return DECISION_REJECT;
}

void anneal_cool( struct anneal_state* state ) {
    #ifdef ANNEAL_PRINT_DEBUG
        printf("Temp %f -> ", state->temperature);
    #endif
    state->temperature *= state->cooling_factor;
    #ifdef ANNEAL_PRINT_DEBUG
        printf("%f\n", state->temperature);
    #endif
}

uint32_t anneal_end( struct anneal_state* state ) {
    if ( state->temperature < state->end_temperature ) {
        return 1;
    }

    return 0;
}

void anneal( BNN bnn, dataset ds ) {
    struct anneal_state _state;
    struct anneal_state* state = &_state;
    struct perturb_list *perturbation = NULL;
    enum anneal_decision decision = DECISION_NONE;

    double energy;

    anneal_init( bnn, state, ds );

    // TODO potentially implement annealing resets

    while ( !anneal_end(state) ) {
        #ifdef ANNEAL_PRINT_DEBUG
            printf("\n\n\nIteration: %u\n", state->iteration);
        #endif


        perturbation = anneal_perturb( bnn, state );

        // Do a forward pass
        energy = compute_energy(bnn, ds, 0);

        decision = anneal_decide( state, energy );

        #ifdef ANNEAL_PRINT_DEBUG
            printf( "New state %s\n", 
                    (decision == DECISION_ACCEPT)?"accepted":"rejected" );
        #endif
        
        if ( decision != DECISION_ACCEPT ) {
            anneal_revert( bnn, perturbation );
        }

        // Free the perturb_list allocated by anneal_perturb
        perturb_list_free(perturbation);

        anneal_cool(state);

        ++state->iteration;
    }

    energy = compute_energy(bnn, ds, 1);
}


