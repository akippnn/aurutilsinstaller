#ifndef PARSE_H
#define PARSE_H

#define MAX_FIRST_WORD_LEN 100
#define MAX_REST_OF_STRING_LEN 1000

typedef struct {
    char name[MAX_FIRST_WORD_LEN];
    char desc[MAX_REST_OF_STRING_LEN];
} ProductInfo;

void parse_script(const char* select, ProductInfo* product, char* lines[], int numLines);

#endif // PARSE_H
