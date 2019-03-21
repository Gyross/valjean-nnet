cmake_minimum_required(VERSION 3.12)
project(valjean_nnet)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

file( GLOB LIB_SOURCES bnn.c )
file( GLOB LIB_HEADERS bnn.h )
add_library( bnn ${LIB_SOURCES} ${LIB_HEADERS} constants.h)

add_executable( nn_main nn_main.c constants.h)
target_link_libraries( nn_main bnn )
