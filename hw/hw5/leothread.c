#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void perform_work(int k, int t);

void *thread(void *vargp);

int leonardo_number(int n);

struct Arguments {
    int *k;
    int *t;
};

int main(int argc, char **argv) {
    int n = argc == 2 ? atoi( argv[1] ) : 0;

    if (argc != 2) {
        fprintf(stderr, "usage: %d <Nth Leonardo number>\n", n);
        exit(0);
    }

    int k = n;
    int t = 0;
    
    perform_work(k, t);
    return 0;
}

void perform_work(int k, int t) {
    if (k > 1) {
        pthread_t left_tid;
        pthread_t right_tid;
        struct Arguments *left_args = malloc(sizeof(struct Arguments *));
        left_args->k = malloc(sizeof(int *));
        *left_args->k = k-1;
        left_args->t = malloc(sizeof(int *));
        *left_args->t = t+1;
        struct Arguments *right_args = malloc(sizeof(struct Arguments *));
        right_args->k = malloc(sizeof(int *));
        *right_args->k = k-2;
        right_args->t = malloc(sizeof(int *));
        *right_args->t = t+1+leonardo_number(k-1);

        printf("(%d\n", t);
        pthread_create(&left_tid, NULL, thread, left_args);
        pthread_join(left_tid, NULL);
        pthread_create(&right_tid, NULL, thread, right_args);
        pthread_join(right_tid, NULL);
        free(left_args->k);
        free(left_args->t);
        free(left_args);
        free(right_args->k);
        free(right_args->t);
        free(right_args);

        printf("%d)\n", t);
    } else {
        printf("[%d]\n", t);
    }
}

void *thread(void *vargp) {
    struct Arguments* args = (struct Arguments*) vargp;
    int k = *args->k;
    int t = *args->t;

    perform_work(k, t);
    return NULL;
}

int leonardo_number(int n) {
    int result;

    if (n == 0 || n == 1) {
        result = 1;
    } else {
        int i;
        int a = 1;
        int b = 1;
        for (i = 1; i < n; i++) {
            result = a + b + 1;
            a = b;
            b = result;
        }
    }
    return result;
}
