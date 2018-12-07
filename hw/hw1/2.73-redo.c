#include <stdio.h>
#include <limits.h>
#include <assert.h>

int saturating_add(int x, int y) {
	// check sign of x and y. 
	// if opposite sign it is safe to add without consequences 
	// otherwise have to check if sign has changed. 
	// pos to negative change to int max
	// neg to pos change to int min

	// Get number of bits.
	int w = sizeof(int)*8;

	// Get initial result.
	int result = x+y;

	// Get most significant bits and convert results to all 0s or all 1s.
	int msbX = (x & (1 << (w-1))) >> (w-1);
	int msbY = (y & (1 << (w-1))) >> (w-1);

	// Check signs and convert results to all 0s or all 1s.
	int bothPositive = ~(msbX & msbY);
	int bothDifferent = msbX ^ msbY;

	// Check for positive or negative overflow.
	int overflow = (__builtin_add_overflow_p(x,y, (int) 0) << (w-1)) >> (w-1);

	// Return result based on conditional logic.
	return (bothDifferent & result) | (~bothDifferent & (
			(bothPositive & (
					(overflow & INT_MAX) | (~overflow & result)
				)
			) | 
			(~bothPositive & (
					(overflow & INT_MIN) | (~overflow & result)
				)
			)
		)
	);
}

int main() {
	// cases
	// p + p = P
	// p + p = n overflow
	// p + n = p
	// p + n = n

	// n + n = n
	// n + n = p overflow
	// n + p = n
	// n + p = p

	// in other words
	// same sign + same sign = other sign --- overflow
	int result;
	result = saturating_add(1, 1);
	printf("saturating_add(1, 1) should equal %d. saturating_add(1, 1) = %d\n", 2, result);
	assert(result == 2);
	result = saturating_add(INT_MAX, 1);
	printf("saturating_add(INT_MAX, 1) should equal %d. saturating_add(INT_MAX, 1) = %d\n", INT_MAX, result);
	assert(result == INT_MAX);
	result = saturating_add(2, -1);
	printf("saturating_add(2, -1) should equal %d. saturating_add(2, -1) = %d\n", 1, result);
	assert(result == 1);
	result = saturating_add(1, -2);
	printf("saturating_add(1, -2) should equal %d. saturating_add(1, -2) = %d\n", -1, result);
	assert(result == -1);

	result = saturating_add(-1, -1);
	printf("saturating_add(-1, -1) should equal %d. saturating_add(-1, -1) = %d\n", -2, result);
	assert(result == -2);
	result = saturating_add(INT_MIN, -1);
	printf("saturating_add(INT_MIN, 1) should equal %d. saturating_add(INT_MIN, 1) = %d\n", INT_MIN, result);
	assert(result == INT_MIN);
	result = saturating_add(-2, 1);
	printf("saturating_add(-2, 1) should equal %d. saturating_add(-2, 1) = %d\n", -1, result);
	assert(result == -1);
	result = saturating_add(-1, 2);
	printf("saturating_add(-1, 2) should equal %d. saturating_add(-1, 2) = %d\n", 1, result);
	assert(result == 1);
	return 0;
}