#ifndef VALJEAN_NNET_ERROR_HANDLING_H
#define VALJEAN_NNET_ERROR_HANDLING_H

// error handling setup
#define MSG(x) const char *__msg = x; int __ret = 0; int __pass = 0
#define CHECK(x, y, z) if (x) { __msg = y; __ret = z; goto error##z; }
#define PASS(x, y) if (x) { __pass = 1; __ret = x; goto error##y; }
#define RETURN if (!__pass) fprintf(stderr, __ret ? "ERROR: %s\n" : "%s\n", __msg); return __ret

#endif //VALJEAN_NNET_ERROR_HANDLING_H
