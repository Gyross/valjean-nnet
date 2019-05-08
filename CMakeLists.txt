cmake_minimum_required(VERSION 3.0)
project(valjean_nnet)

set(CMAKE_CXX_STANDARD 14)

add_compile_options("-Wl,--stack,8388608" "-fstack-usage" "-Wall" "-Werror" "-O2")
# For profiling, add "-pg" to compile options and uncomment link option
#add_link_options("-g")
#add_compile_definitions("DEBUG")

# Uncomment this option to enable stochastic binarisation of inputs to the network
#add_compile_definitions("STOCHASTIC_BINARISE")

# Uncomment this option to enable hardware acceleration of forward pass on the Zedboard
# Hardware acceleration is only used in a "test" operation, it is unused for "train" and "anneal" operations
#add_compile_definitions("HW_ACCELERATE")

include_directories(.)

file( GLOB BNN_SOURCES bnn.c xorgens.c binarised_fp.c binarised_bp.c axi_fp.c dataset.c anneal.c energy.c)
file( GLOB BNN_HEADERS bnn.h xorgens.h binarised_fp.h binarised_bp.h axi_fp.h dataset.h anneal.h energy.h)
add_library( bnn ${BNN_SOURCES} ${BNN_HEADERS} config.h types.h error_handling.h mnist_int8_input.c mnist_int8_input.h)
target_link_libraries( bnn m )

add_executable( nn_main nn_main.c xorgens.c error_handling.h)
target_link_libraries( nn_main bnn )
