#include <stdio.h>
#include <string.h>

char *password = "n0t_saf3_4nyw4y";

int main() {

    char input[100];
    if (fgets(input, sizeof(input), stdin) == NULL)
        input[0] = '\0';
    input[strcspn(input, "\n")] = '\0';

    if (strcmp(input, password) == 0) {
        printf("Access granted!\nBye bye!\n");
    } else {
        printf("Access denied!\nNo goodbye for you!\n");
    }

    return 0;
}


