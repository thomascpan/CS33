#include <stdio.h>
#include <assert.h>

unsigned long srl(unsigned long x, int k) {
        // Performs shift arithmetically.
        unsigned long xsra = (long) x >> k;
        // Get number of bits.
        int w = sizeof(unsigned long)*8;
        // Get offset for mask.
        unsigned long offset = w-k;
        // See if k exist. Set all bits to 1 if present, otherwise set all bits to 0.
        unsigned long isKPresent = ~(!!k - 1);
        // If k is not present, set offset to 0.
        offset = (isKPresent & offset) | (~isKPresent & 0);
        // Create mask for added bits.
        unsigned long mask = (1lu << offset) - 1;
        // if k is present, do not shift. 
        mask = (isKPresent & mask) | (~isKPresent & -1);
        // AND mask with xsra
        xsra = xsra & mask; // this part looks wrong
        return xsra;
}

long sra(long x, int k) {
        // Performs shift logically.
        long xsrl = (unsigned long) x >> k;
        // Get number of bits.
        int w = sizeof(unsigned long)*8;
        // Get offset for mask.
        long offset = w-k;
        // See if k exist. Set all bits to 1 if present, otherwise set all bits to 0.
        long isKPresent = ~(!!k - 1);
        // If k is not present, set offset to 0.
        offset = (isKPresent & offset) | (~isKPresent & 0);
        // Get most significant bit of x.
        long msb = (1l << (w-1)) & x;
        // Create mask for added bits.
        unsigned long mask = ((-1l + !msb) << offset);
        // OR mask with xsrl
        xsrl = xsrl | mask;
        return xsrl;
}

int main() {
        unsigned long uResult;
        uResult = srl(1, 4);
        printf("srl(1, 4) should equal %lu. srl(1, 4) = %lu\n", 0lu, uResult);
        assert(uResult == 0lu);
        uResult = srl(1, 0);
        printf("srl(1, 0) should equal %lu. srl(1, 0) = %lu\n", 1lu, uResult);
        assert(uResult == 1lu);
        uResult = srl(-1, 4);
        printf("srl(-1, 4) should equal %lu. srl(-1, 4) = %lu\n", (-1lu >> 4), uResult);
        assert(uResult == (-1lu >> 4));
        uResult = srl(-1, 0);
        printf("srl(-1, 0) should equal %lu. srl(-1, 0) = %lu\n", -1lu, uResult);
        assert(uResult == -1lu);

        long result;
        result = sra(1, 4);
        printf("sra(1, 4) should equal %ld. sra(1, 4) = %ld\n", 0l, result);
        assert(result == 0l);
        result = sra(1, 0);
        printf("sra(1, 0) should equal %ld. sra(1, 0) = %ld\n", 1l, result);
        assert(result == 1l);
        result = sra(-1, 4);
        printf("sra(-1, 4) should equal %ld. sra(-1, 4) = %ld\n", (-1l >> 4), result);
        assert(result == (-1l >> 4));
        result = sra(-1, 0);
        printf("sra(-1, 0) should equal %ld. sra(-1, 0) = %ld\n", -1l, result);
        assert(result == -1l);

        return 0;
}