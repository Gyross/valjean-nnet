# valjean-nnet
Valjean Neural Network

Basic instructions

To compile:

gcc nnet.c nnet_math.c -lm -o nnet

To create a neural network:

nnet new filename 4 4 4

This will create a network with one hidden layer and 4 neurons in each layer.

To forward pass in the terminal interface:

> fp 2.0 1.0 -2.0 1.5

This will pass the listed values into the input layer of the network.
