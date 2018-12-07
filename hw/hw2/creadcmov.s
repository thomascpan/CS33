	.file	"creadcmov.c"
	.text
	.globl	cread_alt
	.type	cread_alt, @function
cread_alt:
.LFB11:
	.cfi_startproc
	testq	%rdi, %rdi
	movq	$-1, %rax
	cmovne	-8(%rdi), %rax
	ret
	.cfi_endproc
.LFE11:
	.size	cread_alt, .-cread_alt
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-28)"
	.section	.note.GNU-stack,"",@progbits
