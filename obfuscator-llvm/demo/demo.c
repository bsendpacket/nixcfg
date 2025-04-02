#include <stdio.h>

static inline int modify(int input) {
    int val_1 = input * 2;
    int val_2 = input + 2;

    return (val_1 ^ val_2);
}

int main() {
    int data[0x10];

    for (int i = 0; i < 0x10; i++) {
        data[i] = modify(i);
    }

    for (int i = 0; i < 0x10; i++) {
        if (data[i] % 2 == 0) {
            printf("%i is even\n", data[i]);
        } else {
            printf("%i is odd\n", data[i]);
        }
    }

    return 0;
}
