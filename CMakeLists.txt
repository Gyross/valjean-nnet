cmake_minimum_required(VERSION 3.12)
project(valjean_nnet)

set(CMAKE_CXX_STANDARD 14)

add_compile_options("-Wl,--stack,8388608" "-fstack-usage")
#add_compile_definitions("DEBUG")

include_directories(.)

file( GLOB BNN_SOURCES bnn.c xorgens.c binarised_fp.c )
file( GLOB BNN_HEADERS bnn.h xorgens.h binarised_fp.h )
add_library( bnn ${BNN_SOURCES} ${BNN_HEADERS} )
target_link_libraries( bnn m )

add_executable( nn_main nn_main.c xorgens.c )
target_link_libraries( nn_main bnn )
