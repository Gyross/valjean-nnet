#!/usr/bin/python3

import numpy as np
import ctypes

def main():
    weights = np.load('weights.p', allow_pickle=True)

    layers = ctypes.c_uint32(len(weights) + 1)
    sizes = (ctypes.c_uint32 * (len(weights) + 1))()
    sizes[0] = len(weights[0][0])
    for i, arr in enumerate(weights):
        sizes[i+1] = len(arr)

    with open ('python_bnn', 'wb') as f:
        f.write(memoryview(layers))
        f.write(memoryview(sizes))
        for arr in weights:
            for vec in arr:
                c_vec = (ctypes.c_float * len(vec))(*vec)
                f.write(memoryview(c_vec))
        for size in (784, 32, 32, 10):
            c_vec = (ctypes.c_float * size)()
            f.write(memoryview(c_vec))


if __name__ == '__main__':
    main()

