# valjean-nnet
A binarised neural network with hardware acceleration support for Zedboard.

## Downloading instructions

Clone the repository, then download the MNIST data files and extract so that the `mnist/` folder is in the top level project directory:

https://www.dropbox.com/s/ed90pf5v3mzzhb3/valjean-mnist.tar.gz?dl=0

Testing and training datasets & labels for the binarised network:

  * `mnist/train_image_int8`
  * `mnist/train_label_int8`
  * `mnist/test_image_int8`
  * `mnist/test_label_int8`

Testing and training datasets & labels for the floating point network:

  * `mnist/train_image_float`
  * `mnist/train_label_float`
  * `mnist/test_image_float`
  * `mnist/test_label_float`

You can view the images used for training and testing by running:

`./view_train_images.sh`

`./view_test_images.sh`

## Compilation Instructions

To compile, run the following commands:

`mkdir build`

`(cd build; cmake ..; make)`

If cmake gives an error like:

`CMake 3.14 or higher is required.  You are running version 3.6`

Simply change the version number in the top line of `CMakeLists.txt` to your cmake version.

To enable harware acceleration on the Zedboard, open `CMakeLists.txt` and uncomment the line:

`add_compile_definitions("HW_ACCELERATE")`

To enable stochastic binarisation, open `CMakeLists.txt` and uncomment the line:

`add_compile_definitions("STOCHASTIC_BINARISE")`

## Creating a New Network

To create a network with arbitrary sizes, type:

`build/nn_main new <network name> <input size> <hidden layer sizes>... <output size>`

MNIST requires a network with 784 input nodes and 10 output nodes, so use:

`build/nn_main new <network name> 784 <hidden layer sizes>... 10`

Hardware acceleration requires a network with layer sizes (784, 32, 32, 10), so use:

`build/nn_main new <network name> 784 32 32 10`

## Forward pass on a network

Use the command:

`build/nn_main test <network name> <input data file> <data label file>`

For MNIST, use:

`build/nn_main test <network name> mnist/test_image_int8 mnist/test_label_int8`

## Using the Pre-Trained Network

With `python3` and `numpy` installed, use the command:

`python3 translate.py`

Then the pre-trained network will be stored in `python_bnn`, compatible with MNIST and hardware acceleration.
Test the network with:

`build/nn_main test python_bnn mnist/test_image_int8 mnist/test_label_int8`

## Training a Network

Use either:

`build/nn_main train <network name> <input data file> <data label file>`

`build/nn_main anneal <network name> <input data file> <data label file>`

For MNIST use:

`build/nn_main train <network name> mnist/train_image_int8 mnist/train_label_int8`

`build/nn_main anneal <network name> mnist/train_image_int8 mnist/train_label_int8`


## Compiling and Using the Floating Point Network

A version of the software for floating point networks is also provided in `floatsrc/`.
To compile, use:

`(cd floatsrc; make)`

Creating, training and testing networks is done in a similar way to the binarised version,
but with `floatsrc/nnet` instead of `build/nn_main`:

`floatsrc/nnet new <network name> 784 32 32 10`

`floatsrc/nnet train <network name> mnist/train_image_float mnist/train_label_float`

`floatsrc/nnet test <network name> mnist/test_image_float mnist/test_label_float`
