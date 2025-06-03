#include <stdio.h>

char *longestseq(char* string, char *pat);

int main(int argc, char* argv[]){

    for(int i=1; i<argc; i++){
        for(int i=1; i<argc; i+=2){
            printf("%s", argv[i]); //input string
            printf("%s", argv[i+1]); //pattern
            printf(" -> %s\n", longestseq(argv[i], argv[i+1]));
        }
    }
}