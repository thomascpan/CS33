#include "func.h"
#include "util.h"

void func0(double *weights, double *arrayX, double *arrayY, int xr, int yr, int n)
{
	int i;
	double weight = 1/((double)(n));

	omp_set_num_threads(30);
	#pragma omp parallel for
	for(i = 0; i < n; i++){
		weights[i] = weight;
		arrayX[i] = xr;
		arrayY[i] = yr;
	}
}

void func1(int *seed, int *array, double *arrayX, double *arrayY,
			double *probability, double *objxy, int *index,
			int Ones, int iter, int X, int Y, int Z, int n)
{
	int i, j;
   	int index_X, index_Y;
	int max_size = X*Y*Z;
	double d_Ones = (double) Ones;

	omp_set_num_threads(30);
	#pragma omp parallel for private(j, index_X, index_Y)
	for(i = 0; i < n; i++){
		double aX = arrayX[i] + 1 + 5*rand2(seed, i);
		double aY = arrayY[i] + -2 + 2*rand2(seed, i);
		double prob = 0;

		int i_mult_Ones = i*Ones;
		for(j = 0; j < Ones; j++){
			int idx = i_mult_Ones + j;
			index_X = round(aX + objxy[j*2 + 1]);
			index_Y = round(aY + objxy[j*2]);
			index[idx] = fabs(index_X*Y*Z + index_Y*Z + iter);
			if(index[idx] >= max_size)
				index[idx] = 0;

			int e = array[index[idx]];
			prob += (pow(e - 100,2) - pow(e-228,2))/50.0;
		}
		probability[i] = prob/d_Ones;
		arrayX[i] = aX;
		arrayY[i] = aY;
	}
	
}


void func2(double *weights, double *probability, int n)
{
	int i;
	double sumWeights=0;

	omp_set_num_threads(30);
	#pragma omp parallel for reduction(+:sumWeights)
	for(i = 0; i < n; i++) {
   		weights[i] = weights[i] * exp(probability[i]);
   		sumWeights += weights[i];
	}

	omp_set_num_threads(30);
	#pragma omp parallel for
	for(i = 0; i < n; i++) {
   		weights[i] = weights[i] / sumWeights;
	}
}

void func3(double *arrayX, double *arrayY, double *weights, double *x_e, double *y_e, int n)
{
	double estimate_x=0.0;
	double estimate_y=0.0;
    	int i;
	
	omp_set_num_threads(30);
	#pragma omp parallel for reduction(+:estimate_x,estimate_y)
	for(i = 0; i < n; i++){
		double weight = weights[i];
   		estimate_x += arrayX[i] * weight;
   		estimate_y += arrayY[i] * weight;
   	}

	*x_e = estimate_x;
	*y_e = estimate_y;

}

void func4(double *u, double u1, int n)
{
	int i;
	double d_n = (double) n;

	omp_set_num_threads(30);
	#pragma omp parallel for
	for(i = 0; i < n; i++){
   		u[i] = u1 + i/d_n;
   	}
}

void func5(double *x_j, double *y_j, double *arrayX, double *arrayY, double *weights, double *cfd, double *u, int n)
{
	int i, j;
	double weight = 1/(double) n;

	omp_set_num_threads(30);
	#pragma omp parallel for
	for(j = 0; j < n; j++){
   		//i = findIndex(cfd, n, u[j]);
   		i = findIndexBin(cfd, 0, n, u[j]);
		int ii = n-1;
   		if(i == -1)
   			i = ii;
   		x_j[j] = arrayX[i];
   		y_j[j] = arrayY[i];

   	}

	omp_set_num_threads(30);
	#pragma omp parallel for
	for(i = 0; i < n; i++){
		arrayX[i] = x_j[i];
		arrayY[i] = y_j[i];
		weights[i] = weight;
	}
}
