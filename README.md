This is Conway's Game of Life algorythm done in assembly made for GAS (GNU Assembler). There's also a version of it in C++ in the repo. 
Alongside this there is also a message encryptor and decryptor that works by XOR-ing the matrix with the messege inputed and converting the result into a hexadecimal number. The decryption works the same but in reverse.

To be able to run the assembly code you have to have gcc-multilib and libc6-dev-i386 (not 100% sure if you need this one)

to create the executable file use the following command for the .s files:
gcc -m32 <asm_file>.s -o <executable_name> -no-pie
and then run it:
./<executable_name>

The format for imputing values and testing the program is the following:
4 5     // (num of lines, num of colons)
2     // (num of alive pixels to start the game with)
0 0
3 4     // (coordinates for each pixel) !matrix is 4x5 but starts from 0 so only goes up to 3, 4!
3      // num of cicles the game goes through

The output will be the matrix after the 3 cycles:
0 0 0 0 0
0 0 0 0 0
0 0 0 0 0
0 0 0 0 0
(the matrix started with 2 pixels in opposing sides of the matrix that died during the first cycle)

To see the original matrix input 0 for number of cicles

For encryption/decryption the input is similar:
4 5     // (num of lines, num of colons)
2     // (num of alive pixels to start the game with)
0 0
3 4     // (coordinates for each pixel) !matrix is 4x5 but starts from 0 so only goes up to 3, 4!
3      // (num of cicles the game goes through)
0      // (0 = incryption, 1 = decryption)
message // (the message you want encrypted/decrypted)

