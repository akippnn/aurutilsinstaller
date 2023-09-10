#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINES 1000
#define MAX_KEYWORD_LEN 20
#define MAX_FIRST_WORD_LEN 100
#define MAX_REST_OF_STRING_LEN 1000

typedef struct {
    char name[MAX_FIRST_WORD_LEN];
    char desc[MAX_REST_OF_STRING_LEN];
} ProductInfo;

void parse_script(const char* select, ProductInfo* product, char* lines[], int numLines);

int main() {
    char* lines[MAX_LINES];
    int numLines = 0;

    // Sample input lines (you can replace these with your own input):
    lines[numLines++] = "name ProductName";
    lines[numLines++] = "desc Product description goes here.";
    lines[numLines++] = "bool Option1 This is a boolean option.";
    lines[numLines++] = "string Option2 This is a string option.";

    ProductInfo product;
    parse_script("info", &product, lines, numLines);

    printf("Product Name: %s\n", product.name);
    printf("Product Description: %s\n", product.desc);

    return 0;
}

void parse_script(const char* select, ProductInfo* product, char* lines[], int numLines) {
    char* assoc_arr[MAX_KEYWORD_LEN];
    char* index_arr[MAX_KEYWORD_LEN];
    
    for (int i = 0; i < numLines; i++) {
        char keyword[MAX_KEYWORD_LEN];
        char first_word[MAX_FIRST_WORD_LEN];
        char rest_of_string[MAX_REST_OF_STRING_LEN];

        sscanf(lines[i], "%s %s %[^\n]", keyword, first_word, rest_of_string);

        if (strcmp(keyword, "name") == 0) {
            strcpy(product->name, first_word);
        } else if (strcmp(keyword, "desc") == 0) {
            sprintf(product->desc, "%s %s", first_word, rest_of_string);
        } else if (strcmp(keyword, "bool") == 0) {
            sprintf(index_arr[i], "bool'%s'%s", first_word, rest_of_string);
        } else if (strcmp(keyword, "string") == 0) {
            sprintf(index_arr[i], "string'%s'%s", first_word, rest_of_string);
        } else {
            printf("Invalid keyword: %s\n", keyword);
        }
    }

    if (select != NULL) {
        if (strcmp(select, "info") == 0) {
            // Already populated product info
        } else if (strcmp(select, "input") == 0) {
            // TODO: Handle 'input' selection
        } else {
            printf("Invalid selection: %s\n", select);
        }
    } else {
        printf("No selection specified.\n");
    }
}

