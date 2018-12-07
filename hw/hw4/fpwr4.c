#include <stdio.h>

union UnsignedOrFloat {
	unsigned u;
	float f;
};

static float u2f(unsigned u) {
	union UnsignedOrFloat temp;
	temp.u = u;
	printf("%u\n", u);
	printf("%u\n", temp.u);
	printf("%f\n", temp.f);
	return temp.f;
}

int main() {
	int x = 1234567;
	printf("%x\n", x);
	printf("%f\n", u2f(x));
}
