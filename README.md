# valjean-nnet
Valjean Neural Network

# Instructions for MINIST

Download the minist data files:

https://www.dropbox.com/s/c1ls5dd6owgq6cw/minist-valjean.tar.gz?dl=0

Use a network with 724 inputs and 10 outputs

To train:

nnet train mynet minist/train_image_float minist/train_label_float

To test:

nnet test mynet minist/test_image_float minist/test_label_float


# Instructions For Master Branch

To compile:

gcc nnet.c nnet_math.c -lm -o nnet

To create a neural network:

nnet new filename 4 4 4

This will create a network with one hidden layer and 4 neurons in each layer
and store it in the file.

nnet train nnetfile inputfile

Trains the network against the data in inputfile

nnet test nnetfile inputfile

Tests the network against inputfile

Training set files are binary files with the format:
- number of inputs (integer)
- number of outputs (integer)
- example1
- example2
- etc.

where each example consists of the list of inputs (floats) followed by the
list of expected outputs (floats).

To generate the example training set:

make generator

./generator test_data

then test_data will contain the testing data. Use a neural network
with 2 inputs and 2 outputs to use this training set.
