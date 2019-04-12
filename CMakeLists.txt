cmake_minimum_required(VERSION 3.12)
project(valjean_nnet)

set(CMAKE_CXX_STANDARD 14)

add_compile_options("-Wl,--stack,8388608" "-fstack-usage" "-Wall" "-Werror" "-g")
# For profiling, add "-pg" to compile options and uncomment link option
add_link_options("-g")
#add_compile_definitions("DEBUG")

include_directories(.)

file( GLOB BNN_SOURCES bnn.c xorgens.c binarised_fp.c binarised_bp.c dataset.c )
file( GLOB BNN_HEADERS bnn.h xorgens.h binarised_fp.h binarised_bp.h dataset.h )
add_library( bnn ${BNN_SOURCES} ${BNN_HEADERS} types.h error_handling.h mnist_int8_input.c mnist_int8_input.h)
target_link_libraries( bnn m )

add_executable( nn_main nn_main.c xorgens.c error_handling.h)
target_link_libraries( nn_main bnn )
