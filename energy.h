#ifndef VALJEAN_ENERGY_H
#define VALJEAN_ENERGY_H

#include "types.h"

double compute_energy( BNN bnn, dataset ds, uint32_t batch_size, 
                       double* frac_correct, int print_outputs );

#endif
