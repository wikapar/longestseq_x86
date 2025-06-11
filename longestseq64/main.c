#include <stdio.h>

char *longestseq(char* string, char *pat);

int main(int argc, char* argv[]){

    for(int i=1; i + 1<argc; i+=2){
        printf("input: %s\n", argv[i]); //input string
        printf("pattern: %s\n", argv[i+1]); //pattern
        printf(" -> %s\n", longestseq(argv[i], argv[i+1]));
    }
}