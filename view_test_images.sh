gcc mnist_viewer.c dataset.c mnist_int8_input.c -Wall -Werror -o mnist_viewer
./mnist_viewer mnist/test_image_int8 | less
rm mnist_viewer
