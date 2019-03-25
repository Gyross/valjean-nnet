#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "bnorm.h"

// Calculates log2 of number.  
BNNO log_2(BNNO n) {  
	return log(n) / log(2);  
}  

// In hardware this is simplified to taking the MSB of the number
BNNO AP2 (BNNO number) {

	if (number == 0) {
		return 0;
	}

	BNNO sign = 1;
	if (number < 0) {
		sign = -1;
	}

	// full number: sign * pow(2, log_2(abs(number)));
	BNNO final = log_2(abs(number));
	printf("AP2: %d\n", final);
	return final;
}


BNNO batch_mean (BNNO * batch, int size) {

	BNNO total = 0;
	for (int i = 0; i < size; i++) {
		total += batch[i];
	}

	return total/size;
}


BNNO variance (BNNO * batch, BNNO mean, int size, int nb) {

	BNNO total = 0;
	for (int i = 0; i < size; i++) {
		BNNO c =  abs(batch[i] - mean);
		total += (c << AP2(c) >> nb);
		
		//printf("shifted: %d\n", (c << AP2(c)));
	}

	return total/size;
}



BNNO * normalize_scale_shift (BNNO * batch, int size, BNNO mean, BNNO var, int e, int y, int b, int nb) {
	
	BNNO *norm = (BNNO*)malloc(size*sizeof(BNNO));

	BNNO sqrt_var = AP2(1/sqrt(var + e));
	BNNO approx_y = AP2(y);

	for(int i = 0; i < size; i++) {
		BNNO c = (batch[i] - mean);
	        
		// normalize	
		norm[i] = c << sqrt_var >> nb;

		// scale and shift
		// note: in the paper it is written as 
		// y << AP2(norm[i]) >> nb 
		// which seems wrong
		norm[i] = (norm[i] << approx_y >> nb) + b;
	}

	return norm;
}



BNNO * batch_norm (BNNO * batch, int size, int e, int y, int b, int nb) {

	BNNO m = batch_mean(batch, size);
	BNNO var = variance(batch, m, size, nb);

	BNNO *normalized = normalize_scale_shift(batch, size, m, var, e, y, b, nb);

	printf("Var: %d, mean: %d\n", var, m);
	
	for(int i = 0; i < size; i++) {
		printf("Norm: %d\n", normalized[i]);
	}

	return normalized;

}
	

// main function for testing
int main() {
	int e = 0;
	int y = 1;
	int b = 0;
	int nb = 0;
	int size = 9;
	
	BNNO batch[] = {10, 9, 8 , 7, 6, 7, 8, 9, 10};
	BNNI *final = batch_norm(batch, size, e, y, b, nb);
	return 0;
}
