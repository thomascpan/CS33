#define R 7
#define S 5
#define T 8

long A[R][S][T];

long
ele (long i, long j, long k)
{
  return A[R - i][1 - j][k - 1];
}

/*
1. 
&D[i][j] = xD + L(C * i + j)
For 2D arrays, we multiply C (the number of columns)
by i (the desired row) in order to go to the start of that row.
After, we just add by j (the desired column) to get to the correct element. 

&D[i][j][k] = xD + L((C * X * i) + (X * j) + k)
For 3D arrays, we multiply C (the number of columns)
by X (the number of depths?) and by i (the desired row)
in order to go to the start of that row. After, we multiply X
(the number of depths) by j ( the desired colunn) to get to 
the start of that column. We add this to the previous expression
to get to the start of the column of the desired row. Lastly, we add by 
k (the desired depth) to get to the correct element.

2. 
ele:
    movl    $7, %eax                    # %rax = 7
    subq    %rdi, %rax                  # %rax = 7 - i
    leaq    (%rax,%rax,4), %rax         # %rax = (7 - i) + (7 - i) * 4
                                               = 5(7 - i)
    subq    %rsi, %rax                  # %rax = 5(7 - i) - j
    leaq    7(%rdx,%rax,8), %rax        # %rax = 7 + k + (5(7 - i) - j) * 8
                                               = 7 + k + 8(5(7 - i) - j)
                                               = 5(8)(7 - i) + 8(-j) + k + 8(1) - 1 
                                               = 5(8)(7 - 1) + 8(1 - j) + (k - 1)
    movq    A(,%rax,8), %rax
    ret

The expression of %rax matches the expanded formula.
Thus, we can identify the value of the constants.
Normally we could not idetify R, but in this case, "%rax = 7 - i"
gives us the value of R. 
*/
