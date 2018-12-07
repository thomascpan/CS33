ele:
	movl	$7, %eax
	subq	%rdi, %rax
	leaq	(%rax,%rax,4), %rax
	subq	%rsi, %rax
	leaq	7(%rdx,%rax,8), %rax
	movq	A(,%rax,8), %rax
	ret
