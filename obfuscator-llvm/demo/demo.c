#include <stdio.h>

__attribute__((noinline))
int add_op(int a, int b) { return a + b; }

__attribute__((noinline))
int sub_op(int a, int b) { return a - b; }

__attribute__((noinline))
int mul_op(int a, int b) { return a * b; }

__attribute__((noinline))
int xor_op(int a, int b) { return a ^ b; }

__attribute__((noinline))
int and_op(int a, int b) { return a & b; }

__attribute__((noinline))
int or_op(int a, int b) { return a | b; }

__attribute__((noinline))
void transform_array(int* input, int size) {
    printf("[*] Array Transform: Start\n");
    
    for (int i = 0; i < size; i++) {
        input[i] = add_op(input[i], 3);
        printf("[*] Add | Current Value: %i\n", input[i]);
        
        input[i] = sub_op(input[i], 3);
        printf("[*] Sub | Current Value: %i\n", input[i]);
        
        input[i] = and_op(input[i], 3);
        printf("[*] AND | Current Value: %i\n", input[i]);
        
        input[i] = or_op(input[i], 3);
        printf("[*] OR | Current Value: %i\n", input[i]);
        
        input[i] = xor_op(input[i], 3);
        printf("[*] XOR | Current Value: %i\n", input[i]);
    }
    
    printf("[*] Array Transform: End\n");
}

int main() {
    int test[5] = {1, 2, 3, 4, 5};
    transform_array(test, 5);
    
    printf("Transformed array: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", test[i]);
    }
    printf("\n");
    
    return 0;
}
