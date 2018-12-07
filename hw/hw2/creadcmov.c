#include <stdio.h>

long cread_alt(long *xp) {
  long rval = -1;
  long eval = xp[-1];
  if (xp) {
    rval = eval;
  }
  return rval;
}

int main() {
  return 0;
}
