	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LASANPC4:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC35:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L4
	movq	stats_bytes(%rip), %r8
	pxor	%xmm2, %xmm2
	pxor	%xmm1, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdi, %xmm2
	movl	$.LC0, %esi
	movl	$6, %edi
	movq	stats_connections(%rip), %rdx
	cvtsi2ssq	%r8, %xmm1
	movl	stats_simultaneous(%rip), %ecx
	movl	$2, %eax
	movl	httpd_conn_count(%rip), %r9d
	cvtsi2ssq	%rdx, %xmm0
	divss	%xmm2, %xmm1
	divss	%xmm2, %xmm0
	cvtss2sd	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm0
	call	syslog
.L4:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LASANPC25:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r11d
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movabsq	$6148914691236517206, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	testl	%r11d, %r11d
	jg	.L7
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L109:
	movq	%rcx, %rsi
	leaq	(%r9,%r9), %rdx
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L100
	movq	(%rcx), %rcx
	cmpq	%rdx, %r8
	jle	.L17
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC1, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%r9
	.cfi_def_cfa_offset 40
	popq	%r10
	.cfi_def_cfa_offset 32
	addq	%rbp, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L101
.L19:
	movq	24(%rcx), %r8
.L13:
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L102
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L21
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L22
	cmpb	$3, %al
	jle	.L103
.L22:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L104
.L21:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L24
.L7:
	movq	throttles(%rip), %rcx
	addq	%rbp, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L105
	leaq	32(%rcx), %rdi
	movq	24(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	%rax, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L106
	movq	32(%rcx), %rdx
	leaq	8(%rcx), %rdi
	movq	$0, 32(%rcx)
	movq	%rdx, %rsi
	shrq	$63, %rsi
	addq	%rdx, %rsi
	sarq	%rsi
	addq	%rax, %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	%rsi, %rdx
	cmpb	$0, 2147450880(%rax)
	movq	%rdx, %r8
	movq	%rdx, 24(%rcx)
	jne	.L107
	movq	8(%rcx), %r9
	cmpq	%r9, %rdx
	jle	.L13
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L14
	cmpb	$3, %al
	jle	.L108
.L14:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L109
	addq	$16, %rcx
	movq	%rcx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L21
	movq	%rcx, %rdi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L104:
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L110
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	movl	$.LC3, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$5, %edi
	xorl	%eax, %eax
	addl	$1, %ebx
	addq	$48, %rbp
	call	syslog
	cmpl	%ebx, numthrottles(%rip)
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	jg	.L7
	.p2align 4,,10
	.p2align 3
.L24:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %r8
	movq	throttles(%rip), %r11
	movq	$-1, %rbp
	leaq	(%rax,%rax,8), %rax
	salq	$4, %rax
	leaq	144(%r8,%rax), %rbx
	jmp	.L37
	.p2align 4,,10
	.p2align 3
.L27:
	addq	$144, %r8
	cmpq	%rbx, %r8
	je	.L6
.L37:
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L25
	cmpb	$3, %al
	jle	.L111
.L25:
	movl	(%r8), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L27
	leaq	64(%r8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L112
	leaq	56(%r8), %rdi
	movq	%rbp, 64(%r8)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L29
	cmpb	$3, %al
	jle	.L113
.L29:
	movl	56(%r8), %r10d
	testl	%r10d, %r10d
	jle	.L27
	leaq	16(%r8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L38
	cmpb	$3, %al
	jle	.L114
.L38:
	movslq	16(%r8), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r11, %rcx
	leaq	8(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L115
	leaq	40(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L40
	cmpb	$3, %dl
	jle	.L116
.L40:
	movslq	40(%rcx), %rcx
	cqto
	leaq	20(%r8), %rsi
	idivq	%rcx
	movq	%rax, %r9
	leal	-1(%r10), %eax
	leaq	(%rsi,%rax,4), %r10
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L121:
	cmpq	%rax, %r9
	cmovg	%rax, %r9
.L35:
	addq	$4, %rsi
.L41:
	cmpq	%r10, %rsi
	je	.L117
	movq	%rsi, %rax
	movq	%rsi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	addl	$3, %ecx
	cmpb	%al, %cl
	jl	.L32
	testb	%al, %al
	jne	.L118
.L32:
	movslq	(%rsi), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r11, %rcx
	leaq	8(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L119
	leaq	40(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L34
	cmpb	$3, %dl
	jle	.L120
.L34:
	movslq	40(%rcx), %rcx
	cqto
	idivq	%rcx
	cmpq	$-1, %r9
	jne	.L121
	movq	%rax, %r9
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L17:
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$.LC2, %esi
	movl	$6, %edi
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%r8
	.cfi_def_cfa_offset 32
	addq	%rbp, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L19
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L117:
	movq	%r9, 64(%r8)
	addq	$144, %r8
	cmpq	%rbx, %r8
	jne	.L37
.L6:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L120:
	.cfi_restore_state
	call	__asan_report_load4
.L119:
	call	__asan_report_load8
.L118:
	movq	%rsi, %rdi
	call	__asan_report_load4
.L105:
	call	__asan_report_load8
.L107:
	call	__asan_report_load8
.L106:
	call	__asan_report_load8
.L111:
	movq	%r8, %rdi
	call	__asan_report_load4
.L102:
	call	__asan_report_load8
.L100:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L108:
	call	__asan_report_load4
.L103:
	call	__asan_report_load4
.L112:
	call	__asan_report_store8
.L113:
	call	__asan_report_load4
.L101:
	call	__asan_report_load8
.L110:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L116:
	call	__asan_report_load4
.L115:
	call	__asan_report_load8
.L114:
	call	__asan_report_load4
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC4:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LASANPC14:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L128
	ret
.L128:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$stderr, %eax
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L129
	movq	stderr(%rip), %rdi
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L129:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LASANPC13:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L136
	ret
.L136:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$stderr, %eax
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L137
	movq	stderr(%rip), %rdi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L137:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T 
charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.text
	.p2align 4,,15
	.type	usage, @function
usage:
.LASANPC11:
.LFB11:
	.cfi_startproc
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L141
	movq	stderr(%rip), %rdi
	movl	$.LC6, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L141:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"1 32 8 11 client_data "
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC30:
.LFB30:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %rsi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$112, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	movq	%rbx, %r12
	testl	%eax, %eax
	jne	.L165
.L142:
	leaq	32(%rbx), %rdi
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rbp
	movq	$.LC7, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC30, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-218959360, 2147450884(%rbp)
	movl	$-202116109, 2147450888(%rbp)
	cmpb	$0, 2147450880(%rax)
	movq	%rsi, 32(%rbx)
	jne	.L166
	leaq	96(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L167
	movq	%rsi, %rax
	movq	$0, 96(%rsi)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L148
	cmpb	$3, %al
	jle	.L168
.L148:
	cmpl	$3, (%rsi)
	je	.L169
.L145:
	cmpq	%rbx, %r12
	jne	.L170
	movq	$0, 2147450880(%rbp)
	movl	$0, 2147450888(%rbp)
.L144:
	addq	$112, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L169:
	.cfi_restore_state
	leaq	8(%rsi), %rdi
	movl	$2, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L171
	movq	8(%rsi), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L151
	cmpb	$3, %dl
	jle	.L172
.L151:
	movl	704(%rax), %edi
	movl	$1, %edx
	call	fdwatch_add_fd
	jmp	.L145
.L168:
	movq	%rsi, %rdi
	call	__asan_report_load4
.L172:
	call	__asan_report_load4
.L167:
	call	__asan_report_store8
.L170:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%rbp)
	movl	$-168430091, 2147450888(%rbp)
	jmp	.L144
.L166:
	call	__asan_report_load8
.L165:
	movq	%rdi, 8(%rsp)
	movl	$96, %edi
	call	__asan_stack_malloc_1
	movq	8(%rsp), %rsi
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L142
.L171:
	call	__asan_report_load8
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.1
.LC8:
	.string	"1 32 16 2 tv "
	.section	.rodata
	.align 32
.LC9:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LASANPC34:
.LFB34:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$104, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbp
	movq	%rbp, %r13
	testl	%eax, %eax
	jne	.L181
.L173:
	movq	%rbp, %r12
	movq	$1102416563, 0(%rbp)
	shrq	$3, %r12
	movq	$.LC8, 8(%rbp)
	movq	$.LASANPC34, 16(%rbp)
	movl	$-235802127, 2147450880(%r12)
	movl	$-219021312, 2147450884(%r12)
	movl	$-202116109, 2147450888(%r12)
	testq	%rbx, %rbx
	je	.L182
.L177:
	movq	%rbx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L183
	movq	(%rbx), %rax
	movl	$1, %ecx
	movl	$.LC9, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbx
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbx
	cmove	%rcx, %rbx
	movq	%rax, stats_time(%rip)
	xorl	%eax, %eax
	movq	%rbx, %rcx
	call	syslog
	movq	%rbx, %rdi
	call	thttpd_logstats
	movq	%rbx, %rdi
	call	httpd_logstats
	movq	%rbx, %rdi
	call	mmc_logstats
	movq	%rbx, %rdi
	call	fdwatch_logstats
	movq	%rbx, %rdi
	call	tmr_logstats
	cmpq	%rbp, %r13
	jne	.L184
	movq	$0, 2147450880(%r12)
	movl	$0, 2147450888(%r12)
.L175:
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L182:
	.cfi_restore_state
	leaq	32(%rbp), %rbx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	call	gettimeofday
	jmp	.L177
.L183:
	movq	%rbx, %rdi
	call	__asan_report_load8
.L181:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L173
.L184:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movq	%rax, 2147450880(%r12)
	movl	$-168430091, 2147450888(%r12)
	jmp	.L175
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LASANPC6:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L187
	testb	%dl, %dl
	jne	.L202
.L187:
	xorl	%edi, %edi
	movl	(%rbx), %ebp
	call	logstats
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L188
	testb	%dl, %dl
	jne	.L203
.L188:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L203:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L202:
	movq	%rbx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LASANPC32:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC10:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LASANPC7:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L207
	testb	%dl, %dl
	jne	.L223
.L207:
	movl	watchdog_flag(%rip), %eax
	movl	(%rbx), %ebp
	testl	%eax, %eax
	je	.L224
	movl	$0, watchdog_flag(%rip)
	movl	$360, %edi
	call	alarm
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L209
	testb	%dl, %dl
	jne	.L225
.L209:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L225:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L223:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L224:
	movl	$.LC10, %edi
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC11:
	.string	"1 32 4 6 status "
	.section	.rodata
	.align 32
.LC12:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LASANPC3:
.LFB3:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	testl	%eax, %eax
	jne	.L275
.L226:
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	leaq	96(%rbx), %r12
	shrq	$3, %rbp
	movq	$.LC11, 8(%rbx)
	movq	$.LASANPC3, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-218959356, 2147450884(%rbp)
	movl	$-202116109, 2147450888(%rbp)
	call	__errno_location
	movq	%rax, %r15
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L230
	testb	%dl, %dl
	jne	.L276
.L230:
	movl	(%r15), %eax
	movq	%r15, %r14
	subq	$64, %r12
	xorl	%r13d, %r13d
	shrq	$3, %r14
	movl	%eax, 12(%rsp)
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%rsp)
.L231:
	movl	$1, %edx
	movq	%r12, %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L236
	js	.L277
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L231
	leaq	36(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L237
	testb	%sil, %sil
	jne	.L278
.L237:
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%r13d, %eax
	movl	%eax, 36(%rdx)
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L277:
	movzbl	2147450880(%r14), %eax
	cmpb	%al, 11(%rsp)
	jl	.L234
	testb	%al, %al
	jne	.L279
.L234:
	movl	(%r15), %eax
	cmpl	$4, %eax
	je	.L231
	cmpl	$11, %eax
	je	.L231
	cmpl	$10, %eax
	jne	.L280
.L236:
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L240
	testb	%dl, %dl
	jne	.L281
.L240:
	movl	12(%rsp), %eax
	movl	%eax, (%r15)
	leaq	16(%rsp), %rax
	cmpq	%rbx, %rax
	jne	.L282
	movq	$0, 2147450880(%rbp)
	movl	$0, 2147450888(%rbp)
.L228:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L280:
	.cfi_restore_state
	movl	$.LC12, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L236
.L276:
	movq	%r15, %rdi
	call	__asan_report_load4
.L281:
	movq	%r15, %rdi
	call	__asan_report_store4
.L282:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%rbp)
	movl	$-168430091, 2147450888(%rbp)
	jmp	.L228
.L278:
	call	__asan_report_load4
.L279:
	movq	%r15, %rdi
	call	__asan_report_load4
.L275:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L226
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC13:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC14:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LASANPC15:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L287
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L287:
	.cfi_restore_state
	movl	$.LC13, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L288
	movq	stderr(%rip), %rdi
	movl	$.LC14, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L288:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC15:
	.string	"1 32 100 4 line "
	.section	.rodata
	.align 32
.LC16:
	.string	"r"
	.zero	62
	.align 32
.LC17:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC18:
	.string	"debug"
	.zero	58
	.align 32
.LC19:
	.string	"port"
	.zero	59
	.align 32
.LC20:
	.string	"dir"
	.zero	60
	.align 32
.LC21:
	.string	"chroot"
	.zero	57
	.align 32
.LC22:
	.string	"nochroot"
	.zero	55
	.align 32
.LC23:
	.string	"data_dir"
	.zero	55
	.align 32
.LC24:
	.string	"symlink"
	.zero	56
	.align 32
.LC25:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC26:
	.string	"symlinks"
	.zero	55
	.align 32
.LC27:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC28:
	.string	"user"
	.zero	59
	.align 32
.LC29:
	.string	"cgipat"
	.zero	57
	.align 32
.LC30:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC31:
	.string	"urlpat"
	.zero	57
	.align 32
.LC32:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC33:
	.string	"localpat"
	.zero	55
	.align 32
.LC34:
	.string	"throttles"
	.zero	54
	.align 32
.LC35:
	.string	"host"
	.zero	59
	.align 32
.LC36:
	.string	"logfile"
	.zero	56
	.align 32
.LC37:
	.string	"vhost"
	.zero	58
	.align 32
.LC38:
	.string	"novhost"
	.zero	56
	.align 32
.LC39:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC40:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC41:
	.string	"pidfile"
	.zero	56
	.align 32
.LC42:
	.string	"charset"
	.zero	56
	.align 32
.LC43:
	.string	"p3p"
	.zero	60
	.align 32
.LC44:
	.string	"max_age"
	.zero	56
	.align 32
.LC45:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LASANPC12:
.LFB12:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %r13
	testl	%eax, %eax
	jne	.L392
.L289:
	movq	%r13, %r15
	movl	$.LC16, %esi
	movq	%rbx, %rdi
	movq	$1102416563, 0(%r13)
	shrq	$3, %r15
	movq	$.LC15, 8(%r13)
	movq	$.LASANPC12, 16(%r13)
	movl	$-235802127, 2147450880(%r15)
	movl	$-218959356, 2147450896(%r15)
	movl	$-202116109, 2147450900(%r15)
	call	fopen
	movq	%rax, 8(%rsp)
	testq	%rax, %rax
	je	.L388
	movabsq	$4294977024, %rbp
	leaq	32(%r13), %rax
	movq	%rax, (%rsp)
.L293:
	movq	8(%rsp), %rdx
	movq	(%rsp), %rdi
	movl	$1000, %esi
	call	fgets
	testq	%rax, %rax
	je	.L393
	movq	(%rsp), %rdi
	movl	$35, %esi
	call	strchr
	testq	%rax, %rax
	je	.L294
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L295
	testb	%dl, %dl
	jne	.L394
.L295:
	movb	$0, (%rax)
.L294:
	movq	(%rsp), %rbx
	movl	$.LC17, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L296
	testb	%al, %al
	jne	.L395
	.p2align 4,,10
	.p2align 3
.L296:
	cmpb	$0, (%rbx)
	je	.L293
	movl	$.LC17, %esi
	movq	%rbx, %rdi
	call	strcspn
	leaq	(%rbx,%rax), %r14
	movq	%r14, %rax
	movq	%r14, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L298
	testb	%al, %al
	jne	.L396
.L298:
	movzbl	(%r14), %eax
	cmpb	$32, %al
	ja	.L299
	btq	%rax, %rbp
	jnc	.L299
	movq	%r14, %rdi
	.p2align 4,,10
	.p2align 3
.L302:
	movq	%rdi, %rax
	movq	%rdi, %rcx
	addq	$1, %r14
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L300
	testb	%al, %al
	jne	.L397
.L300:
	movq	%r14, %rax
	movb	$0, -1(%r14)
	movq	%r14, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L301
	testb	%al, %al
	jne	.L398
.L301:
	movzbl	(%r14), %eax
	cmpb	$32, %al
	jbe	.L399
.L299:
	movl	$61, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L337
	movq	%rax, %rcx
	movq	%rax, %rsi
	leaq	1(%rax), %r12
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L304
	testb	%cl, %cl
	jne	.L400
.L304:
	movb	$0, (%rax)
.L303:
	movl	$.LC18, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L401
	movl	$.LC19, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L402
	movl	$.LC20, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L403
	movl	$.LC21, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L404
	movl	$.LC22, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L405
	movl	$.LC23, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L406
	movl	$.LC24, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L390
	movl	$.LC25, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L391
	movl	$.LC26, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L390
	movl	$.LC27, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L391
	movl	$.LC28, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L407
	movl	$.LC29, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L408
	movl	$.LC30, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L409
	movl	$.LC31, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L410
	movl	$.LC32, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L411
	movl	$.LC33, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L412
	movl	$.LC34, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L413
	movl	$.LC35, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L414
	movl	$.LC36, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L415
	movl	$.LC37, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L416
	movl	$.LC38, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L417
	movl	$.LC39, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L418
	movl	$.LC40, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L419
	movl	$.LC41, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L420
	movl	$.LC42, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L421
	movl	$.LC43, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L422
	movl	$.LC44, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L332
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L306
	.p2align 4,,10
	.p2align 3
.L399:
	btq	%rax, %rbp
	movq	%r14, %rdi
	jc	.L302
	jmp	.L299
	.p2align 4,,10
	.p2align 3
.L401:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
.L306:
	movl	$.LC17, %esi
	movq	%r14, %rdi
	call	strspn
	leaq	(%r14,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L296
	testb	%al, %al
	je	.L296
	movq	%rbx, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L337:
	xorl	%r12d, %r12d
	jmp	.L303
.L402:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L306
.L403:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L306
.L404:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L306
.L405:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L306
.L406:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L306
.L390:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L306
.L391:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L306
.L398:
	movq	%r14, %rdi
	call	__asan_report_load1
.L397:
	call	__asan_report_store1
.L407:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L306
.L393:
	movq	8(%rsp), %rdi
	call	fclose
	leaq	16(%rsp), %rax
	cmpq	%r13, %rax
	jne	.L423
	movl	$0, 2147450880(%r15)
	movq	$0, 2147450896(%r15)
.L291:
	addq	$216, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L408:
	.cfi_restore_state
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L306
.L410:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L306
.L409:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L306
.L412:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L306
.L411:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L306
.L413:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L306
.L396:
	movq	%r14, %rdi
	call	__asan_report_load1
.L400:
	movq	%rax, %rdi
	call	__asan_report_store1
.L415:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L306
.L414:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L306
.L423:
	movdqa	.LC46(%rip), %xmm0
	movq	$1172321806, 0(%r13)
	movabsq	$-723401728380766731, %rax
	movq	%rax, 2147450896(%r15)
	movups	%xmm0, 2147450880(%r15)
	jmp	.L291
	.p2align 4,,10
	.p2align 3
.L418:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L306
.L332:
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L424
	movq	stderr(%rip), %rdi
	movq	%rbx, %rcx
	movl	$.LC45, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L422:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L306
.L421:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L306
.L424:
	movl	$stderr, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L420:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%r12, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L306
.L419:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L306
.L417:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L306
.L416:
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L306
.L395:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L394:
	movq	%rax, %rdi
	call	__asan_report_store1
.L388:
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L392:
	movl	$192, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %r13
	jmp	.L289
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC47:
	.string	"nobody"
	.zero	57
	.align 32
.LC48:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC49:
	.string	""
	.zero	63
	.align 32
.LC50:
	.string	"-V"
	.zero	61
	.align 32
.LC51:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC52:
	.string	"-C"
	.zero	61
	.align 32
.LC53:
	.string	"-p"
	.zero	61
	.align 32
.LC54:
	.string	"-d"
	.zero	61
	.align 32
.LC55:
	.string	"-r"
	.zero	61
	.align 32
.LC56:
	.string	"-nor"
	.zero	59
	.align 32
.LC57:
	.string	"-dd"
	.zero	60
	.align 32
.LC58:
	.string	"-s"
	.zero	61
	.align 32
.LC59:
	.string	"-nos"
	.zero	59
	.align 32
.LC60:
	.string	"-u"
	.zero	61
	.align 32
.LC61:
	.string	"-c"
	.zero	61
	.align 32
.LC62:
	.string	"-t"
	.zero	61
	.align 32
.LC63:
	.string	"-h"
	.zero	61
	.align 32
.LC64:
	.string	"-l"
	.zero	61
	.align 32
.LC65:
	.string	"-v"
	.zero	61
	.align 32
.LC66:
	.string	"-nov"
	.zero	59
	.align 32
.LC67:
	.string	"-g"
	.zero	61
	.align 32
.LC68:
	.string	"-nog"
	.zero	59
	.align 32
.LC69:
	.string	"-i"
	.zero	61
	.align 32
.LC70:
	.string	"-T"
	.zero	61
	.align 32
.LC71:
	.string	"-P"
	.zero	61
	.align 32
.LC72:
	.string	"-M"
	.zero	61
	.align 32
.LC73:
	.string	"-D"
	.zero	61
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LASANPC10:
.LFB10:
	.cfi_startproc
	movl	$80, %eax
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$0, debug(%rip)
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movw	%ax, port(%rip)
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	$0, dir(%rip)
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC47, user(%rip)
	movq	$.LC48, charset(%rip)
	movq	$.LC49, p3p(%rip)
	movl	$-1, max_age(%rip)
	cmpl	$1, %edi
	jle	.L473
	leaq	8(%rsi), %rdi
	movq	%rsi, %r13
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L501
	movq	8(%rsi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L428
	testb	%al, %al
	jne	.L502
.L428:
	movl	$1, %ebp
	.p2align 4,,10
	.p2align 3
.L500:
	cmpb	$45, (%rbx)
	jne	.L430
	movl	$.LC50, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L503
	movl	$.LC52, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L432
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jl	.L504
	movl	$.LC53, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L437
.L436:
	movl	$.LC54, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L437
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L437
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L505
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, dir(%rip)
	.p2align 4,,10
	.p2align 3
.L435:
	addl	$1, %ebp
	cmpl	%ebp, %r12d
	jle	.L426
.L508:
	movslq	%ebp, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L506
	movq	(%rdi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L500
	testb	%al, %al
	je	.L500
	movq	%rbx, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L432:
	movl	$.LC53, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L436
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jge	.L437
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L507
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	addl	$1, %ebp
	call	atoi
	movw	%ax, port(%rip)
	cmpl	%ebp, %r12d
	jg	.L508
	.p2align 4,,10
	.p2align 3
.L426:
	cmpl	%ebp, %r12d
	jne	.L430
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L437:
	.cfi_restore_state
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L440
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L440:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L441
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L504:
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L509
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	read_config
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L441:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L442
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L442
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L510
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, data_dir(%rip)
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L442:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L444
	movl	$0, no_symlink_check(%rip)
	jmp	.L435
.L444:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L445
	movl	$1, no_symlink_check(%rip)
	jmp	.L435
.L445:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L446
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L446
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L511
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, user(%rip)
	jmp	.L435
.L503:
	movl	$.LC51, %edi
	call	puts
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L446:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L448
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L448
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L512
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L435
.L448:
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L450
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L451
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L513
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, throttlefile(%rip)
	jmp	.L435
.L450:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L453
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L454
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L514
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, hostname(%rip)
	jmp	.L435
.L451:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L454
.L453:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L454
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L454
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L515
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, logfile(%rip)
	jmp	.L435
.L454:
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L516
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L458
	movl	$0, do_vhost(%rip)
	jmp	.L435
.L516:
	movl	$1, do_vhost(%rip)
	jmp	.L435
.L473:
	movl	$1, %ebp
	jmp	.L426
.L458:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L459
	movl	$1, do_global_passwd(%rip)
	jmp	.L435
.L459:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L460
	movl	$0, do_global_passwd(%rip)
	jmp	.L435
.L506:
	call	__asan_report_load8
.L460:
	movl	$.LC69, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L461
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L462
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L517
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, pidfile(%rip)
	jmp	.L435
.L461:
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L464
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L462
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L518
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, charset(%rip)
	jmp	.L435
.L462:
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L467
.L466:
	movl	$.LC72, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L467
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jge	.L467
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L519
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L435
.L464:
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L466
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L467
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L520
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, p3p(%rip)
	jmp	.L435
.L467:
	movl	$.LC73, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L430
	movl	$1, debug(%rip)
	jmp	.L435
.L507:
	call	__asan_report_load8
.L505:
	call	__asan_report_load8
.L509:
	call	__asan_report_load8
.L510:
	call	__asan_report_load8
.L513:
	call	__asan_report_load8
.L512:
	call	__asan_report_load8
.L501:
	call	__asan_report_load8
.L502:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L430:
	call	__asan_handle_no_return
	call	usage
.L511:
	call	__asan_report_load8
.L514:
	call	__asan_report_load8
.L515:
	call	__asan_report_load8
.L517:
	call	__asan_report_load8
.L518:
	call	__asan_report_load8
.L519:
	call	__asan_report_load8
.L520:
	call	__asan_report_load8
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC74:
	.string	"5 32 8 9 max_limit 96 8 9 min_limit 160 16 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC75:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC76:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC77:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC78:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC79:
	.string	"|/"
	.zero	61
	.align 32
.LC80:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC81:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.align 32
.LC82:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10392, %rsp
	.cfi_def_cfa_offset 10448
	leaq	48(%rsp), %rax
	movq	%rdi, 24(%rsp)
	movq	%rax, 32(%rsp)
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	testl	%eax, %eax
	jne	.L610
.L521:
	movq	32(%rsp), %rax
	movl	$.LC16, %esi
	movq	$1102416563, (%rax)
	leaq	10336(%rax), %r13
	movq	$.LC74, 8(%rax)
	movq	$.LASANPC17, 16(%rax)
	shrq	$3, %rax
	movq	24(%rsp), %rdi
	movq	%rax, 40(%rsp)
	movl	$-235802127, 2147450880(%rax)
	movl	$-218959360, 2147450884(%rax)
	movl	$-218959118, 2147450888(%rax)
	movl	$-218959360, 2147450892(%rax)
	movl	$-218959118, 2147450896(%rax)
	movl	$-219021312, 2147450900(%rax)
	movl	$-218959118, 2147450904(%rax)
	movl	$-218959360, 2147451532(%rax)
	movl	$-218959118, 2147451536(%rax)
	movl	$-218959360, 2147452164(%rax)
	movl	$-202116109, 2147452168(%rax)
	call	fopen
	movq	%rax, %r14
	testq	%rax, %rax
	je	.L611
	movq	32(%rsp), %rbx
	xorl	%esi, %esi
	leaq	160(%rbx), %rdi
	leaq	224(%rbx), %rbp
	call	gettimeofday
	movq	%rbx, %rax
	movabsq	$4294977024, %rbx
	addq	$223, %rax
	movq	%rax, (%rsp)
	.p2align 4,,10
	.p2align 3
.L530:
	movq	%r14, %rdx
	movl	$5000, %esi
	movq	%rbp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L612
	movl	$35, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L527
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L528
	testb	%dl, %dl
	jne	.L613
.L528:
	movb	$0, (%rax)
.L527:
	movq	%rbp, %rdi
	call	strlen
	testq	%rax, %rax
	je	.L530
	leal	-1(%rax), %edx
	movslq	%edx, %rdi
	leaq	0(%rbp,%rdi), %rcx
	movq	%rcx, %rsi
	movq	%rcx, %r8
	shrq	$3, %rsi
	andl	$7, %r8d
	movzbl	2147450880(%rsi), %esi
	cmpb	%r8b, %sil
	jg	.L531
	testb	%sil, %sil
	jne	.L614
.L531:
	movzbl	-10112(%r13,%rdi), %ecx
	cmpb	$32, %cl
	jbe	.L615
	.p2align 4,,10
	.p2align 3
.L532:
	leaq	-10240(%r13), %rax
	leaq	-10304(%r13), %r15
	movl	$.LC82, %esi
	movq	%rbp, %rdi
	leaq	-5056(%r13), %r12
	movq	%rax, 8(%rsp)
	movq	%rax, %rcx
	movq	%r15, %r8
	xorl	%eax, %eax
	movq	%r12, %rdx
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L539
	xorl	%eax, %eax
	movq	%r15, %rcx
	movq	%r12, %rdx
	movl	$.LC76, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L616
	movq	24(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rbp, %rcx
	movl	$.LC77, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L617
	movq	24(%rsp), %rcx
	movq	%rbp, %r8
	movl	$.LC78, %esi
	xorl	%eax, %eax
	movq	stderr(%rip), %rdi
	call	fprintf
	jmp	.L530
	.p2align 4,,10
	.p2align 3
.L615:
	btq	%rcx, %rbx
	jnc	.L532
	movslq	%eax, %rsi
	movl	%edx, %edx
	addq	(%rsp), %rsi
	addq	%rbp, %rdi
	subq	%rdx, %rsi
	.p2align 4,,10
	.p2align 3
.L536:
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L533
	testb	%al, %al
	jne	.L618
.L533:
	movb	$0, (%rdi)
	cmpq	%rsi, %rdi
	je	.L530
	leaq	-1(%rdi), %rax
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L535
	testb	%dl, %dl
	jne	.L619
.L535:
	movzbl	-1(%rdi), %edx
	cmpb	$32, %dl
	ja	.L532
	btq	%rdx, %rbx
	movq	%rax, %rdi
	jc	.L536
	jmp	.L532
	.p2align 4,,10
	.p2align 3
.L616:
	movq	8(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L620
	movq	$0, -10240(%r13)
.L539:
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L542
	jle	.L621
.L542:
	cmpb	$47, -5056(%r13)
	jne	.L544
	jmp	.L622
	.p2align 4,,10
	.p2align 3
.L545:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L544:
	movl	$.LC79, %esi
	movq	%r12, %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L545
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L546
	testl	%eax, %eax
	jne	.L547
	movl	$100, maxthrottles(%rip)
	movl	$4800, %edi
	call	malloc
	movq	%rax, throttles(%rip)
.L548:
	testq	%rax, %rax
	je	.L549
	movslq	numthrottles(%rip), %rdx
.L550:
	leaq	(%rdx,%rdx,2), %rdx
	movq	%r12, %rdi
	salq	$4, %rdx
	addq	%rax, %rdx
	movq	%rdx, 16(%rsp)
	call	e_strdup
	movq	16(%rsp), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L623
	movq	%rax, (%rdx)
	movslq	numthrottles(%rip), %rax
	movq	%r15, %rcx
	shrq	$3, %rcx
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	cmpb	$0, 2147450880(%rcx)
	jne	.L624
	leaq	8(%rax), %rdi
	movq	-10304(%r13), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L625
	movq	%rcx, 8(%rax)
	movq	8(%rsp), %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L626
	leaq	16(%rax), %rdi
	movq	-10240(%r13), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L627
	leaq	24(%rax), %rdi
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L628
	leaq	32(%rax), %rdi
	movq	$0, 24(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L629
	leaq	40(%rax), %rdi
	movq	$0, 32(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L559
	cmpb	$3, %cl
	jle	.L630
.L559:
	movl	$0, 40(%rax)
	leal	1(%rdx), %eax
	movl	%eax, numthrottles(%rip)
	jmp	.L530
.L547:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L548
.L546:
	movq	throttles(%rip), %rax
	jmp	.L550
.L622:
	leaq	1(%r12), %rsi
	movq	%r12, %rdi
	call	strcpy
	jmp	.L544
.L612:
	movq	%r14, %rdi
	call	fclose
	leaq	48(%rsp), %rax
	cmpq	32(%rsp), %rax
	jne	.L631
	movq	40(%rsp), %rax
	pxor	%xmm0, %xmm0
	movq	$0, 2147450896(%rax)
	movl	$0, 2147450904(%rax)
	movq	$0, 2147451532(%rax)
	movq	$0, 2147452164(%rax)
	movups	%xmm0, 2147450880(%rax)
.L523:
	addq	$10392, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L618:
	.cfi_restore_state
	call	__asan_report_store1
.L619:
	movq	%rax, %rdi
	call	__asan_report_load1
.L621:
	movq	%r12, %rdi
	call	__asan_report_load1
.L625:
	call	__asan_report_store8
.L624:
	movq	%r15, %rdi
	call	__asan_report_load8
.L613:
	movq	%rax, %rdi
	call	__asan_report_store1
.L611:
	movq	24(%rsp), %rbx
	movl	$.LC75, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	movq	%rbx, %rdx
	call	syslog
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L610:
	movl	$10336, %edi
	call	__asan_stack_malloc_8
	testq	%rax, %rax
	cmove	32(%rsp), %rax
	movq	%rax, 32(%rsp)
	jmp	.L521
.L631:
	movq	32(%rsp), %rax
	leaq	48(%rsp), %rdx
	movl	$10336, %esi
	movq	$1172321806, (%rax)
	movq	%rax, %rdi
	call	__asan_stack_free_8
	jmp	.L523
.L620:
	movq	8(%rsp), %rdi
	call	__asan_report_store8
.L630:
	call	__asan_report_store4
.L623:
	movq	%rdx, %rdi
	call	__asan_report_store8
.L549:
	xorl	%eax, %eax
	movl	$.LC80, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L632
	movq	stderr(%rip), %rdi
	movl	$.LC81, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L627:
	call	__asan_report_store8
.L626:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L632:
	movl	$stderr, %edi
	call	__asan_report_load8
.L617:
	movl	$stderr, %edi
	call	__asan_report_load8
.L614:
	movq	%rcx, %rdi
	call	__asan_report_load1
.L629:
	call	__asan_report_store8
.L628:
	call	__asan_report_store8
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC83:
	.string	"-"
	.zero	62
	.align 32
.LC84:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC85:
	.string	"a"
	.zero	62
	.align 32
.LC86:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC8:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L645
	cmpq	$0, hs(%rip)
	je	.L645
	movq	logfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L645
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$.LC83, %esi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	strcmp
	testl	%eax, %eax
	jne	.L648
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L645:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.p2align 4,,10
	.p2align 3
.L648:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC84, %esi
	movl	$5, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC85, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	chmod
	testq	%rbx, %rbx
	je	.L637
	testl	%eax, %eax
	jne	.L637
	movq	%rbx, %rdi
	call	fileno
	movl	$2, %esi
	movl	$1, %edx
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L637:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC86, %esi
	xorl	%eax, %eax
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	movl	$2, %edi
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC87:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC88:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC89:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	shrq	$3, %r13
	movl	%esi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L673:
	cmpl	%eax, max_connects(%rip)
	jle	.L724
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L652
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L653
	cmpb	$3, %al
	jle	.L725
.L653:
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L652
	leaq	8(%rbx), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L726
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L727
.L656:
	movq	hs(%rip), %rdi
	movl	%r12d, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L659
	cmpl	$2, %eax
	je	.L675
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L661
	cmpb	$3, %al
	jle	.L728
.L661:
	leaq	4(%rbx), %rdi
	movl	$1, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L662
	testb	%dl, %dl
	jne	.L729
.L662:
	movl	4(%rbx), %eax
	addl	$1, num_connects(%rip)
	cmpb	$0, 2147450880(%r13)
	movl	$-1, 4(%rbx)
	movl	%eax, first_free_connect(%rip)
	jne	.L730
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L731
	leaq	96(%rbx), %rdi
	movq	%rax, 88(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L732
	leaq	104(%rbx), %rdi
	movq	$0, 96(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L733
	leaq	136(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L734
	movq	$0, 136(%rbx)
	leaq	56(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L668
	cmpb	$3, %al
	jle	.L735
.L668:
	movq	%r14, %rax
	movl	$0, 56(%rbx)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L736
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L670
	cmpb	$3, %dl
	jle	.L737
.L670:
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L738
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L672
	cmpb	$3, %dl
	jle	.L739
.L672:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L673
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L673
	.p2align 4,,10
	.p2align 3
.L675:
	movl	$1, %eax
.L649:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L659:
	.cfi_restore_state
	movq	%rbp, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L727:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	movq	%rax, %rdx
	movq	%rax, 8(%rbx)
	testq	%rax, %rax
	je	.L740
	movq	%rax, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L658
	cmpb	$3, %cl
	jle	.L741
.L658:
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	jmp	.L656
.L728:
	movq	%rbx, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L724:
	xorl	%eax, %eax
	movl	$.LC87, %esi
	movl	$4, %edi
	call	syslog
	movq	%rbp, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L649
.L652:
	movl	$2, %edi
	movl	$.LC88, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L726:
	movq	%r14, %rdi
	call	__asan_report_load8
.L725:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L729:
	call	__asan_report_load4
.L738:
	movq	%r14, %rdi
	call	__asan_report_load8
.L739:
	call	__asan_report_load4
.L730:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L731:
	call	__asan_report_store8
.L732:
	call	__asan_report_store8
.L733:
	call	__asan_report_store8
.L734:
	call	__asan_report_store8
.L735:
	call	__asan_report_store4
.L736:
	movq	%r14, %rdi
	call	__asan_report_load8
.L737:
	call	__asan_report_load4
.L741:
	movq	%rax, %rdi
	call	__asan_report_store4
.L740:
	movl	$2, %edi
	movl	$.LC89, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC90:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	leaq	56(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%r13, %rax
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	shrq	$3, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L743
	cmpb	$3, %al
	jle	.L826
.L743:
	leaq	72(%rbx), %rax
	movl	$0, 56(%rbx)
	movq	%rax, 16(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L827
	leaq	64(%rbx), %rcx
	movq	$-1, %rax
	movq	%rcx, %rdx
	movq	%rax, 72(%rbx)
	shrq	$3, %rdx
	movq	%rcx, 8(%rsp)
	cmpb	$0, 2147450880(%rdx)
	jne	.L828
	movq	%rax, 64(%rbx)
	leaq	8(%rbx), %rax
	xorl	%ebp, %ebp
	movq	%rax, 24(%rsp)
	shrq	$3, %rax
	movq	%rax, (%rsp)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jg	.L746
	jmp	.L768
	.p2align 4,,10
	.p2align 3
.L842:
	addl	$1, %r8d
	cqto
	movslq	%r8d, %rsi
	idivq	%rsi
.L757:
	movq	%r13, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L761
	cmpb	$3, %dl
	jle	.L829
.L761:
	movslq	56(%rbx), %rsi
	leal	1(%rsi), %edx
	movl	%edx, 56(%rbx)
	leaq	16(%rbx,%rsi,4), %rdx
	movq	%rdx, %r9
	shrq	$3, %r9
	movzbl	2147450880(%r9), %r11d
	movq	%rdx, %r9
	andl	$7, %r9d
	addl	$3, %r9d
	cmpb	%r11b, %r9b
	jl	.L762
	testb	%r11b, %r11b
	jne	.L830
.L762:
	movq	%rdi, %rdx
	movl	%r14d, 16(%rbx,%rsi,4)
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L763
	cmpb	$3, %dl
	jle	.L831
.L763:
	movq	8(%rsp), %rdx
	movl	%r8d, 40(%rcx)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L832
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L765
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L765:
	movq	%rax, 64(%rbx)
	movq	16(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L833
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L825
	cmpq	%r10, %rax
	cmovge	%rax, %r10
.L825:
	movq	%r10, 72(%rbx)
.L751:
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	jle	.L768
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L769
	cmpb	$3, %al
	jle	.L834
.L769:
	addq	$1, %rbp
	cmpl	$9, 56(%rbx)
	jg	.L768
.L746:
	movq	(%rsp), %rax
	movl	%ebp, %r12d
	movl	%ebp, %r14d
	cmpb	$0, 2147450880(%rax)
	jne	.L835
	movq	8(%rbx), %rax
	leaq	240(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L836
	leaq	0(%rbp,%rbp,2), %r9
	movq	throttles(%rip), %rdi
	movq	240(%rax), %rsi
	movq	%r9, %r15
	salq	$4, %r15
	addq	%r15, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L837
	movq	(%rdi), %rdi
	call	match
	testl	%eax, %eax
	je	.L751
	movq	throttles(%rip), %rcx
	addq	%r15, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L838
	leaq	8(%rcx), %rdi
	movq	24(%rcx), %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L839
	movq	8(%rcx), %rax
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L772
	leaq	16(%rcx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L840
	movq	16(%rcx), %r10
	cmpq	%r10, %rdx
	jl	.L772
	leaq	40(%rcx), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L755
	cmpb	$3, %dl
	jle	.L841
.L755:
	movl	40(%rcx), %r8d
	testl	%r8d, %r8d
	jns	.L842
	movl	$3, %edi
	xorl	%eax, %eax
	movl	$.LC90, %esi
	call	syslog
	movq	throttles(%rip), %rcx
	addq	%r15, %rcx
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L758
	cmpb	$3, %al
	jle	.L843
.L758:
	leaq	8(%rcx), %rax
	movl	$0, 40(%rcx)
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L844
	leaq	16(%rcx), %rdx
	movq	8(%rcx), %rax
	movq	%rdx, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L845
	movq	16(%rcx), %r10
	movl	$1, %r8d
	jmp	.L757
	.p2align 4,,10
	.p2align 3
.L768:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L772:
	.cfi_restore_state
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L837:
	.cfi_restore_state
	call	__asan_report_load8
.L836:
	call	__asan_report_load8
.L835:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L834:
	movq	%r13, %rdi
	call	__asan_report_load4
.L833:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L832:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L831:
	call	__asan_report_store4
.L830:
	movq	%rdx, %rdi
	call	__asan_report_store4
.L829:
	movq	%r13, %rdi
	call	__asan_report_load4
.L841:
	call	__asan_report_load4
.L840:
	call	__asan_report_load8
.L839:
	call	__asan_report_load8
.L838:
	call	__asan_report_load8
.L845:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L844:
	movq	%rax, %rdi
	call	__asan_report_load8
.L843:
	call	__asan_report_store4
.L826:
	movq	%r13, %rdi
	call	__asan_report_store4
.L828:
	movq	%rcx, %rdi
	call	__asan_report_store8
.L827:
	movq	16(%rsp), %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %edx
	leaq	16(%rsp), %rbp
	testl	%edx, %edx
	jne	.L903
.L846:
	movq	%rbp, %rax
	movq	$1102416563, 0(%rbp)
	xorl	%esi, %esi
	xorl	%r15d, %r15d
	shrq	$3, %rax
	movq	$.LC8, 8(%rbp)
	leaq	32(%rbp), %rbx
	movq	$.LASANPC18, 16(%rbp)
	movq	%rbx, %rdi
	movq	%rax, 8(%rsp)
	movl	$-235802127, 2147450880(%rax)
	movl	$-219021312, 2147450884(%rax)
	movl	$-202116109, 2147450888(%rax)
	call	gettimeofday
	movq	%rbx, %rdi
	xorl	%ebx, %ebx
	call	logstats
	leaq	32(%rbp), %rax
	movq	%rax, (%rsp)
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jg	.L850
	jmp	.L860
	.p2align 4,,10
	.p2align 3
.L855:
	testq	%rdi, %rdi
	je	.L857
	call	httpd_destroy_conn
	movq	connects(%rip), %r13
	addq	%r15, %r13
	leaq	8(%r13), %r14
	movq	%r14, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L904
	movq	8(%r13), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	cmpb	$0, 2147450880(%r12)
	jne	.L905
	movq	$0, 8(%r13)
.L857:
	addl	$1, %ebx
	addq	$144, %r15
	cmpl	%ebx, max_connects(%rip)
	jle	.L860
.L850:
	movq	connects(%rip), %rdi
	addq	%r15, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L853
	cmpb	$3, %al
	jle	.L906
.L853:
	leaq	8(%rdi), %rax
	movl	(%rdi), %edx
	movq	%rax, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L907
	movq	8(%rdi), %rdi
	testl	%edx, %edx
	je	.L855
	movq	(%rsp), %rsi
	call	httpd_close_conn
	movq	connects(%rip), %rax
	addq	%r15, %rax
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L908
	movq	8(%rax), %rdi
	jmp	.L855
	.p2align 4,,10
	.p2align 3
.L860:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L852
	movq	$0, hs(%rip)
	leaq	72(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L861
	cmpb	$3, %al
	jle	.L909
.L861:
	movl	72(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L910
.L862:
	leaq	76(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L863
	testb	%dl, %dl
	jne	.L911
.L863:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L912
.L864:
	movq	%rbx, %rdi
	call	httpd_terminate
.L852:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L849
	call	free
.L849:
	leaq	16(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L913
	movq	8(%rsp), %rax
	movq	$0, 2147450880(%rax)
	movl	$0, 2147450888(%rax)
.L848:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L910:
	.cfi_restore_state
	call	fdwatch_del_fd
	jmp	.L862
	.p2align 4,,10
	.p2align 3
.L912:
	call	fdwatch_del_fd
	jmp	.L864
.L906:
	call	__asan_report_load4
.L907:
	movq	%rax, %rdi
	call	__asan_report_load8
.L904:
	movq	%r14, %rdi
	call	__asan_report_load8
.L905:
	movq	%r14, %rdi
	call	__asan_report_store8
.L908:
	call	__asan_report_load8
.L913:
	movq	$1172321806, 0(%rbp)
	movq	8(%rsp), %rax
	movabsq	$-723401728380766731, %rsi
	movq	%rsi, 2147450880(%rax)
	movl	$-168430091, 2147450888(%rax)
	jmp	.L848
.L903:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L846
.L911:
	call	__asan_report_load4
.L909:
	call	__asan_report_load4
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC91:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LASANPC5:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L919
	movl	$1, got_usr1(%rip)
	ret
	.p2align 4,,10
	.p2align 3
.L919:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC91, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC92:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LASANPC2:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	shut_down
	movl	$5, %edi
	movl	%ebx, %edx
	xorl	%eax, %eax
	movl	$.LC92, %esi
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC36:
.LFB36:
	.cfi_startproc
	leaq	56(%rdi), %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L923
	cmpb	$3, %al
	jle	.L948
.L923:
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L922
	subl	$1, %eax
	movq	throttles(%rip), %r8
	leaq	16(%rdi), %rdx
	leaq	20(%rdi,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L927:
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L925
	testb	%cl, %cl
	jne	.L949
.L925:
	movslq	(%rdx), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r8, %rax
	leaq	40(%rax), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L926
	cmpb	$3, %cl
	jle	.L950
.L926:
	addq	$4, %rdx
	subl	$1, 40(%rax)
	cmpq	%rsi, %rdx
	jne	.L927
.L922:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L948:
	.cfi_restore_state
	movq	%rdx, %rdi
	call	__asan_report_load4
.L950:
	call	__asan_report_load4
.L949:
	movq	%rdx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	leaq	8(%rdi), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rbp, %rax
	shrq	$3, %rax
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%rax)
	jne	.L991
	movq	%rdi, %rbx
	movq	8(%rdi), %rdi
	leaq	200(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L992
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L954
	cmpb	$3, %al
	jle	.L993
.L954:
	cmpl	$3, (%rbx)
	jne	.L994
.L955:
	call	httpd_close_conn
	leaq	104(%rbx), %r12
	movq	%rbx, %rdi
	call	clear_throttles.isra.0
	movq	%r12, %rbp
	shrq	$3, %rbp
	cmpb	$0, 2147450880(%rbp)
	jne	.L995
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L959
	call	tmr_cancel
	cmpb	$0, 2147450880(%rbp)
	jne	.L996
	movq	$0, 104(%rbx)
.L959:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L961
	cmpb	$3, %al
	jle	.L997
.L961:
	leaq	4(%rbx), %rdi
	movl	$0, (%rbx)
	movl	first_free_connect(%rip), %ecx
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L962
	testb	%dl, %dl
	jne	.L998
.L962:
	movabsq	$-8198552921648689607, %rax
	movl	%ecx, 4(%rbx)
	subq	connects(%rip), %rbx
	sarq	$4, %rbx
	subl	$1, num_connects(%rip)
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L994:
	.cfi_restore_state
	leaq	704(%rdi), %rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L956
	cmpb	$3, %al
	jle	.L999
.L956:
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	%rbp, %rax
	movq	8(%rsp), %rsi
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1000
	movq	8(%rbx), %rdi
	jmp	.L955
.L998:
	call	__asan_report_store4
.L997:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L993:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L992:
	movq	%rax, %rdi
	call	__asan_report_load8
.L991:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L995:
	movq	%r12, %rdi
	call	__asan_report_load8
.L996:
	movq	%r12, %rdi
	call	__asan_report_store8
.L999:
	movq	%rdx, %rdi
	call	__asan_report_load4
.L1000:
	movq	%rbp, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 32
.LC93:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC94:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	96(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%r13, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	shrq	$3, %r12
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%r12)
	jne	.L1074
	movq	%rdi, %rbx
	movq	96(%rdi), %rdi
	movq	%rsi, %rbp
	testq	%rdi, %rdi
	je	.L1003
	call	tmr_cancel
	cmpb	$0, 2147450880(%r12)
	jne	.L1075
	movq	$0, 96(%rbx)
.L1003:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1005
	cmpb	$3, %al
	jle	.L1076
.L1005:
	movl	(%rbx), %ecx
	cmpl	$4, %ecx
	je	.L1077
	leaq	8(%rbx), %r12
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1078
	movq	8(%rbx), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1013
	testb	%sil, %sil
	jne	.L1079
.L1013:
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L1011
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1014
	cmpb	$3, %dl
	jle	.L1080
.L1014:
	movl	704(%rax), %edi
	cmpl	$3, %ecx
	jne	.L1081
.L1015:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1018
	cmpb	$3, %al
	jle	.L1082
.L1018:
	movl	$4, (%rbx)
	movl	$1, %esi
	call	shutdown
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1083
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1020
	cmpb	$3, %dl
	jle	.L1084
.L1020:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbx, %rsi
	leaq	104(%rbx), %r12
	call	fdwatch_add_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1085
	cmpq	$0, 104(%rbx)
	je	.L1022
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1022:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$500, %ecx
	movl	$linger_clear_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1086
	movq	%rax, 104(%rbx)
	testq	%rax, %rax
	je	.L1087
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1081:
	.cfi_restore_state
	call	fdwatch_del_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1088
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1017
	cmpb	$3, %dl
	jle	.L1089
.L1017:
	movl	704(%rax), %edi
	jmp	.L1015
	.p2align 4,,10
	.p2align 3
.L1077:
	leaq	104(%rbx), %r13
	movq	%r13, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1090
	movq	104(%rbx), %rdi
	call	tmr_cancel
	cmpb	$0, 2147450880(%r12)
	jne	.L1091
	leaq	8(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1092
	movq	8(%rbx), %rdx
	leaq	556(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1010
	testb	%cl, %cl
	jne	.L1093
.L1010:
	movl	$0, 556(%rdx)
.L1011:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L1076:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1079:
	call	__asan_report_load4
.L1084:
	call	__asan_report_load4
.L1082:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L1080:
	call	__asan_report_load4
.L1089:
	call	__asan_report_load4
.L1093:
	call	__asan_report_store4
.L1074:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1078:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1086:
	movq	%r12, %rdi
	call	__asan_report_store8
.L1085:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1083:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1075:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1087:
	movl	$2, %edi
	movl	$.LC94, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1088:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1091:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1092:
	call	__asan_report_load8
.L1090:
	movq	%r13, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	addq	$8, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	cmpb	$0, 2147450880(%rax)
	jne	.L1097
	movq	8(%rbx), %rdi
	movq	%rsi, %rbp
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
.L1097:
	.cfi_restore_state
	call	__asan_report_load8
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	addq	$8, %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	cmpb	$0, 2147450880(%rax)
	jne	.L1215
	movq	8(%rbp), %rbx
	leaq	160(%rbx), %r12
	movq	%r12, %r15
	shrq	$3, %r15
	cmpb	$0, 2147450880(%r15)
	jne	.L1216
	leaq	152(%rbx), %r14
	movq	%rsi, %r13
	movq	160(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1217
	movq	152(%rbx), %rdx
	leaq	144(%rbx), %rcx
	cmpq	%rdx, %rsi
	jb	.L1102
	cmpq	$5000, %rdx
	ja	.L1218
	leaq	144(%rbx), %rcx
	addq	$1000, %rdx
	movq	%r14, %rsi
	movq	%rax, 8(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, (%rsp)
	call	httpd_realloc_str
	movq	8(%rsp), %rax
	movq	(%rsp), %rcx
	cmpb	$0, 2147450880(%rax)
	jne	.L1219
	cmpb	$0, 2147450880(%r15)
	movq	152(%rbx), %rdx
	jne	.L1220
	movq	160(%rbx), %rsi
.L1102:
	movq	%rcx, %rax
	subq	%rsi, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1221
	leaq	704(%rbx), %r14
	addq	144(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1109
	cmpb	$3, %al
	jle	.L1222
.L1109:
	movl	704(%rbx), %edi
	call	read
	testl	%eax, %eax
	je	.L1223
	jns	.L1113
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1114
	testb	%cl, %cl
	jne	.L1224
.L1114:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1098
	cmpl	$11, %eax
	jne	.L1225
.L1098:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1113:
	.cfi_restore_state
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1226
	cltq
	addq	%rax, 160(%rbx)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1227
	leaq	88(%rbp), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1228
	movq	%rax, 88(%rbp)
	movq	%rbx, %rdi
	call	httpd_got_request
	testl	%eax, %eax
	je	.L1098
	cmpl	$2, %eax
	je	.L1229
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L1214
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L1230
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L1214
	leaq	528(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1130
	cmpb	$3, %al
	jle	.L1231
.L1130:
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L1131
	leaq	536(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1232
	leaq	136(%rbp), %rdi
	movq	536(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1233
	leaq	544(%rbx), %rdi
	movq	%rax, 136(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1234
	leaq	128(%rbp), %rdi
	movq	544(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	$1, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1235
.L1140:
	movq	%rax, 128(%rbp)
.L1136:
	leaq	712(%rbx), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1236
	cmpq	$0, 712(%rbx)
	je	.L1237
	leaq	136(%rbp), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1238
	movq	%rdi, %rdx
	movq	136(%rbp), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1239
	cmpq	128(%rbp), %rax
	jge	.L1214
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1153
	cmpb	$3, %al
	jle	.L1240
.L1153:
	movq	%r13, %rax
	movl	$2, 0(%rbp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1241
	leaq	80(%rbp), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1242
	leaq	112(%rbp), %rdi
	movq	%rax, 80(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1243
	movq	%r14, %rax
	movq	$0, 112(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1157
	cmpb	$3, %al
	jle	.L1244
.L1157:
	movl	704(%rbx), %edi
	call	fdwatch_del_fd
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1158
	cmpb	$3, %al
	jle	.L1245
.L1158:
	movl	704(%rbx), %edi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbp, %rsi
	movl	$1, %edx
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L1218:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1246
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1247
.L1123:
	movl	$.LC49, %r9d
	movq	httpd_err400title(%rip), %rdx
	movl	$400, %esi
	movq	%rbx, %rdi
	movq	%r9, %rcx
	call	httpd_send_err
.L1214:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r13, %rsi
	movq	%rbp, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1229:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1248
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1123
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1225:
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1249
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1123
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1223:
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1250
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1123
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1230:
	leaq	208(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1251
	movl	$httpd_err503form, %eax
	movq	208(%rbx), %r9
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1252
	movl	$httpd_err503title, %eax
	movq	httpd_err503form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1253
	movq	httpd_err503title(%rip), %rdx
	movl	$.LC49, %ecx
	movl	$503, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
	jmp	.L1214
.L1222:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1224:
	movq	%rax, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1131:
	leaq	192(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1254
	movq	192(%rbx), %rax
	leaq	128(%rbp), %rdi
	testq	%rax, %rax
	js	.L1255
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1140
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1255:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1256
	movq	$0, 128(%rbp)
	jmp	.L1136
.L1237:
	leaq	56(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1143
	cmpb	$3, %al
	jle	.L1257
.L1143:
	leaq	200(%rbx), %rdi
	movl	56(%rbp), %eax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1258
	movq	200(%rbx), %rsi
	testl	%eax, %eax
	jle	.L1150
	subl	$1, %eax
	movq	throttles(%rip), %r9
	leaq	16(%rbp), %rdi
	leaq	20(%rbp,%rax,4), %r8
	.p2align 4,,10
	.p2align 3
.L1149:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1147
	testb	%dl, %dl
	jne	.L1259
.L1147:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r9, %rax
	leaq	32(%rax), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1260
	addq	$4, %rdi
	addq	%rsi, 32(%rax)
	cmpq	%r8, %rdi
	jne	.L1149
.L1150:
	leaq	136(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1261
	movq	%rsi, 136(%rbp)
	jmp	.L1214
.L1215:
	call	__asan_report_load8
.L1217:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1216:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1221:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1219:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1220:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1247:
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
.L1226:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1227:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1228:
	call	__asan_report_store8
.L1246:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1249:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1250:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1258:
	call	__asan_report_load8
.L1260:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L1261:
	call	__asan_report_store8
.L1253:
	movl	$httpd_err503title, %edi
	call	__asan_report_load8
.L1252:
	movl	$httpd_err503form, %edi
	call	__asan_report_load8
.L1251:
	call	__asan_report_load8
.L1254:
	call	__asan_report_load8
.L1232:
	call	__asan_report_load8
.L1257:
	call	__asan_report_load4
.L1259:
	call	__asan_report_load4
.L1248:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1231:
	call	__asan_report_load4
.L1240:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1242:
	call	__asan_report_store8
.L1241:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1243:
	call	__asan_report_store8
.L1245:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1236:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1235:
	call	__asan_report_store8
.L1234:
	call	__asan_report_load8
.L1233:
	call	__asan_report_store8
.L1239:
	call	__asan_report_load8
.L1244:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1238:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1256:
	call	__asan_report_store8
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC95:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC96:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LASANPC29:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L1289
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	shrq	$3, %r15
	xorl	%r14d, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$httpd_err408form, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	shrq	$3, %r12
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L1279
	.p2align 4,,10
	.p2align 3
.L1297:
	testl	%eax, %eax
	jle	.L1266
	cmpl	$3, %eax
	jg	.L1266
	cmpb	$0, 2147450880(%r15)
	jne	.L1292
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1293
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L1294
	.p2align 4,,10
	.p2align 3
.L1266:
	addq	$1, %r14
	cmpl	%r14d, max_connects(%rip)
	jle	.L1295
.L1279:
	leaq	(%r14,%r14,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1264
	cmpb	$3, %al
	jle	.L1296
.L1264:
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L1297
	cmpb	$0, 2147450880(%r15)
	jne	.L1298
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1299
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L1266
	leaq	8(%rbx), %r13
	movq	%r13, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1300
	movq	8(%rbx), %rax
	movq	%rcx, 8(%rsp)
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC95, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	8(%rsp), %rcx
	cmpb	$0, 2147450880(%r12)
	jne	.L1301
	movl	$httpd_err408title, %eax
	movq	httpd_err408form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1302
	cmpb	$0, 2147450880(%rcx)
	movq	httpd_err408title(%rip), %rdx
	jne	.L1303
	movl	$.LC49, %r9d
	movq	8(%rbx), %rdi
	movl	$408, %esi
	addq	$1, %r14
	movq	%r9, %rcx
	call	httpd_send_err
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	cmpl	%r14d, max_connects(%rip)
	jg	.L1279
.L1295:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1294:
	.cfi_restore_state
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1304
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC96, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1266
	.p2align 4,,10
	.p2align 3
.L1289:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
.L1296:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1299:
	call	__asan_report_load8
.L1298:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1293:
	call	__asan_report_load8
.L1292:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1304:
	call	__asan_report_load8
.L1303:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1302:
	movl	$httpd_err408title, %edi
	call	__asan_report_load8
.L1301:
	movl	$httpd_err408form, %edi
	call	__asan_report_load8
.L1300:
	movq	%r13, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.1
.LC97:
	.string	"1 32 32 2 iv "
	.section	.rodata
	.align 32
.LC98:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC99:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC100:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$152, %rsp
	.cfi_def_cfa_offset 208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsi, (%rsp)
	leaq	48(%rsp), %r15
	testl	%eax, %eax
	jne	.L1460
.L1305:
	leaq	8(%r14), %r12
	movq	%r15, %rbx
	movq	$1102416563, (%r15)
	leaq	96(%r15), %rax
	movq	%r12, %rdx
	shrq	$3, %rbx
	movq	$.LC97, 8(%r15)
	shrq	$3, %rdx
	movq	$.LASANPC21, 16(%r15)
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147450888(%rbx)
	cmpb	$0, 2147450880(%rdx)
	jne	.L1461
	leaq	64(%r14), %rcx
	movq	8(%r14), %rbp
	movq	%rcx, %rdx
	movq	%rcx, 16(%rsp)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1462
	movq	64(%r14), %rsi
	movl	$1000000000, %edx
	cmpq	$-1, %rsi
	je	.L1311
	testq	%rsi, %rsi
	leaq	3(%rsi), %rdx
	cmovns	%rsi, %rdx
	sarq	$2, %rdx
.L1311:
	leaq	472(%rbp), %r11
	movq	%r11, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1463
	cmpq	$0, 472(%rbp)
	jne	.L1313
	leaq	128(%r14), %rax
	movq	%rax, 8(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1464
	leaq	136(%r14), %r10
	movq	128(%r14), %rax
	movq	%r10, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1465
	movq	136(%r14), %rsi
	leaq	712(%rbp), %rdi
	subq	%rsi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1466
	leaq	704(%rbp), %r13
	addq	712(%rbp), %rsi
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1317
	cmpb	$3, %al
	jle	.L1467
.L1317:
	movl	704(%rbp), %edi
	movq	%r10, 32(%rsp)
	movq	%r11, 24(%rsp)
	call	write
	movq	24(%rsp), %r11
	movq	32(%rsp), %r10
	testl	%eax, %eax
	js	.L1468
.L1328:
	jne	.L1469
.L1376:
	leaq	112(%r14), %r12
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1470
	movq	%r14, %rax
	addq	$100, 112(%r14)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1333
	cmpb	$3, %al
	jle	.L1471
.L1333:
	movq	%r13, %rax
	movl	$3, (%r14)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1334
	cmpb	$3, %al
	jle	.L1472
.L1334:
	movl	704(%rbp), %edi
	leaq	96(%r14), %r13
	call	fdwatch_del_fd
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1473
	cmpq	$0, 96(%r14)
	je	.L1336
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1336:
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1474
	movq	112(%r14), %rcx
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%r14, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1475
.L1338:
	movq	%rax, 96(%r14)
	testq	%rax, %rax
	je	.L1476
.L1308:
	leaq	48(%rsp), %rax
	cmpq	%r15, %rax
	jne	.L1477
	movq	$0, 2147450880(%rbx)
	movl	$0, 2147450888(%rbx)
.L1307:
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1313:
	.cfi_restore_state
	leaq	368(%rbp), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1478
	leaq	-64(%rax), %r9
	movq	368(%rbp), %rsi
	movq	%r9, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1479
	leaq	8(%r9), %rdi
	movq	%rsi, -64(%rax)
	movq	472(%rbp), %rsi
	movq	%rdi, %r8
	shrq	$3, %r8
	cmpb	$0, 2147450880(%r8)
	jne	.L1480
	leaq	712(%rbp), %rdi
	movq	%rsi, -56(%rax)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1481
	leaq	136(%r14), %r10
	movq	712(%rbp), %rsi
	movq	%r10, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1482
	leaq	16(%r9), %rdi
	movq	136(%r14), %r13
	movq	%rdi, %r8
	shrq	$3, %r8
	addq	%r13, %rsi
	cmpb	$0, 2147450880(%r8)
	jne	.L1483
	leaq	128(%r14), %rcx
	movq	%rsi, -48(%rax)
	movq	%rcx, %rsi
	movq	%rcx, 8(%rsp)
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1484
	movq	128(%r14), %rsi
	leaq	24(%r9), %rdi
	subq	%r13, %rsi
	cmpq	%rdx, %rsi
	cmovbe	%rsi, %rdx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1485
	leaq	704(%rbp), %r13
	movq	%rdx, -40(%rax)
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1327
	cmpb	$3, %al
	jle	.L1486
.L1327:
	movl	704(%rbp), %edi
	movq	%r9, %rsi
	movl	$2, %edx
	movq	%r10, 40(%rsp)
	movq	%r11, 32(%rsp)
	movq	%r9, 24(%rsp)
	call	writev
	movq	24(%rsp), %r9
	movq	40(%rsp), %r10
	movq	32(%rsp), %r11
	shrq	$3, %r9
	movl	$-117901064, 2147450880(%r9)
	testl	%eax, %eax
	jns	.L1328
.L1468:
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1329
	testb	%sil, %sil
	jne	.L1487
.L1329:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1308
	cmpl	$11, %eax
	je	.L1376
	cmpl	$32, %eax
	setne	%sil
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %sil
	je	.L1339
	cmpl	$104, %eax
	jne	.L1488
.L1339:
	movq	(%rsp), %rsi
	movq	%r14, %rdi
	call	clear_connection
	jmp	.L1308
	.p2align 4,,10
	.p2align 3
.L1469:
	movq	(%rsp), %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1489
	leaq	88(%r14), %rdi
	movq	(%rsp), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	movq	(%rcx), %rdx
	cmpb	$0, 2147450880(%rsi)
	jne	.L1490
	movq	%rdx, 88(%r14)
	movq	%r11, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1491
	movq	472(%rbp), %r9
	testq	%r9, %r9
	jne	.L1345
.L1459:
	movslq	%eax, %rdx
.L1346:
	movq	%r10, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1492
	movq	136(%r14), %r8
	movq	%r12, %rax
	shrq	$3, %rax
	addq	%rdx, %r8
	cmpb	$0, 2147450880(%rax)
	movq	%r8, 136(%r14)
	jne	.L1493
	movq	8(%r14), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1494
	movq	200(%rax), %rcx
	leaq	56(%r14), %rdi
	addq	%rdx, %rcx
	movq	%rcx, 200(%rax)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1352
	cmpb	$3, %al
	jle	.L1495
.L1352:
	movl	56(%r14), %eax
	testl	%eax, %eax
	jle	.L1360
	subl	$1, %eax
	movq	throttles(%rip), %r11
	leaq	16(%r14), %rdi
	leaq	20(%r14,%rax,4), %r10
	.p2align 4,,10
	.p2align 3
.L1359:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L1357
	testb	%sil, %sil
	jne	.L1496
.L1357:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r11, %rax
	leaq	32(%rax), %rsi
	movq	%rsi, %r9
	shrq	$3, %r9
	cmpb	$0, 2147450880(%r9)
	jne	.L1497
	addq	$4, %rdi
	addq	%rdx, 32(%rax)
	cmpq	%r10, %rdi
	jne	.L1359
.L1360:
	movq	8(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1498
	cmpq	128(%r14), %r8
	jge	.L1499
	leaq	112(%r14), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1500
	movq	112(%r14), %rax
	cmpq	$100, %rax
	jg	.L1501
.L1362:
	movq	16(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1502
	movq	64(%r14), %rsi
	cmpq	$-1, %rsi
	je	.L1308
	leaq	80(%r14), %rdi
	movq	(%rsp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movq	(%rax), %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1503
	subq	80(%r14), %rax
	movq	%rax, %r8
	je	.L1379
	movq	%rcx, %rax
	cqto
	idivq	%r8
	movq	%rax, %rcx
.L1365:
	cmpq	%rcx, %rsi
	jge	.L1308
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1366
	cmpb	$3, %al
	jg	.L1366
	movq	%r14, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1345:
	movslq	%eax, %rsi
	cmpq	%rsi, %r9
	ja	.L1504
	movq	$0, 472(%rbp)
	subl	%r9d, %eax
	jmp	.L1459
	.p2align 4,,10
	.p2align 3
.L1501:
	subq	$100, %rax
	movq	%rax, 112(%r14)
	jmp	.L1362
	.p2align 4,,10
	.p2align 3
.L1379:
	movl	$1, %r8d
	jmp	.L1365
	.p2align 4,,10
	.p2align 3
.L1366:
	movq	%r13, %rax
	movl	$3, (%r14)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1367
	cmpb	$3, %al
	jg	.L1367
	movq	%r13, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1367:
	movl	704(%rbp), %edi
	movq	%r8, 8(%rsp)
	call	fdwatch_del_fd
	movq	%r12, %rax
	movq	8(%rsp), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1505
	movq	8(%r14), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1506
	movq	16(%rsp), %rdx
	movq	200(%rax), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1507
	cqto
	leaq	96(%r14), %r12
	idivq	64(%r14)
	movl	%eax, %r13d
	movq	%r12, %rax
	shrq	$3, %rax
	subl	%r8d, %r13d
	cmpb	$0, 2147450880(%rax)
	jne	.L1508
	cmpq	$0, 96(%r14)
	je	.L1372
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1372:
	movl	$500, %ecx
	testl	%r13d, %r13d
	jle	.L1373
	movslq	%r13d, %r13
	imulq	$1000, %r13, %rcx
.L1373:
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%r14, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1338
	movq	%r12, %rdi
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1499:
	movq	(%rsp), %rsi
	movq	%r14, %rdi
	call	finish_connection
	jmp	.L1308
	.p2align 4,,10
	.p2align 3
.L1504:
	leaq	368(%rbp), %rdi
	subl	%eax, %r9d
	movq	%rdi, %rax
	movslq	%r9d, %r9
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1509
	movq	368(%rbp), %rdi
	movq	%r9, %rdx
	movq	%r10, 32(%rsp)
	movq	%r9, 24(%rsp)
	addq	%rdi, %rsi
	call	memmove
	movq	24(%rsp), %r9
	xorl	%edx, %edx
	movq	32(%rsp), %r10
	movq	%r9, 472(%rbp)
	jmp	.L1346
.L1472:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1471:
	movq	%r14, %rdi
	call	__asan_report_store4
.L1495:
	call	__asan_report_load4
.L1466:
	call	__asan_report_load8
.L1478:
	call	__asan_report_load8
.L1480:
	call	__asan_report_store8
.L1479:
	movq	%r9, %rdi
	call	__asan_report_store8
.L1484:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1483:
	call	__asan_report_store8
.L1482:
	movq	%r10, %rdi
	call	__asan_report_load8
.L1481:
	call	__asan_report_load8
.L1485:
	call	__asan_report_store8
.L1465:
	movq	%r10, %rdi
	call	__asan_report_load8
.L1464:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1467:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1486:
	movq	%r13, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1488:
	leaq	208(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1510
	movq	208(%rbp), %rdx
	movl	$.LC100, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1339
.L1497:
	movq	%rsi, %rdi
	call	__asan_report_load8
.L1496:
	call	__asan_report_load4
.L1460:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %r15
	jmp	.L1305
.L1463:
	movq	%r11, %rdi
	call	__asan_report_load8
.L1490:
	call	__asan_report_store8
.L1489:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1493:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1494:
	call	__asan_report_load8
.L1498:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1487:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1462:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1470:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1491:
	movq	%r11, %rdi
	call	__asan_report_load8
.L1474:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1475:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1476:
	movl	$2, %edi
	movl	$.LC99, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1477:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%r15)
	movq	%rax, 2147450880(%rbx)
	movl	$-168430091, 2147450888(%rbx)
	jmp	.L1307
.L1461:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1473:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1492:
	movq	%r10, %rdi
	call	__asan_report_load8
.L1500:
	call	__asan_report_load8
.L1502:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1503:
	call	__asan_report_load8
.L1509:
	call	__asan_report_load8
.L1510:
	call	__asan_report_load8
.L1508:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1507:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1506:
	call	__asan_report_load8
.L1505:
	movq	%r12, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC31:
.LFB31:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$120, %rsp
	.cfi_def_cfa_offset 160
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	movq	%rbx, %r13
	testl	%eax, %eax
	jne	.L1518
.L1511:
	leaq	32(%rbx), %rdi
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rbp
	movq	$.LC7, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC31, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-218959360, 2147450884(%rbp)
	movl	$-202116109, 2147450888(%rbp)
	cmpb	$0, 2147450880(%rax)
	movq	%r12, 32(%rbx)
	jne	.L1519
	leaq	104(%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1520
	movq	$0, 104(%r12)
	movq	%r12, %rdi
	call	really_clear_connection
	cmpq	%rbx, %r13
	jne	.L1521
	movq	$0, 2147450880(%rbp)
	movl	$0, 2147450888(%rbp)
.L1513:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L1518:
	.cfi_restore_state
	movl	$96, %edi
	movq	%rsi, 8(%rsp)
	call	__asan_stack_malloc_1
	movq	8(%rsp), %rsi
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1511
.L1521:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%rbp)
	movl	$-168430091, 2147450888(%rbp)
	jmp	.L1513
.L1520:
	call	__asan_report_store8
.L1519:
	call	__asan_report_load8
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC101:
	.string	"1 32 4096 3 buf "
	.globl	__asan_stack_free_7
	.text
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LASANPC22:
.LFB22:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$4160, %rsp
	.cfi_def_cfa_offset 4208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbx
	movq	%rbx, %r12
	testl	%eax, %eax
	jne	.L1545
.L1522:
	leaq	8(%r14), %rdi
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	leaq	4160(%rbx), %rsi
	movq	%rdi, %rax
	shrq	$3, %rbp
	movq	$.LC101, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC22, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-202116109, 2147451396(%rbp)
	cmpb	$0, 2147450880(%rax)
	jne	.L1546
	movq	8(%r14), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1527
	cmpb	$3, %dl
	jle	.L1547
.L1527:
	movl	704(%rax), %edi
	subq	$4128, %rsi
	movl	$4096, %edx
	call	read
	testl	%eax, %eax
	js	.L1548
	je	.L1531
.L1525:
	cmpq	%rbx, %r12
	jne	.L1549
	movl	$0, 2147450880(%rbp)
	movl	$0, 2147451396(%rbp)
.L1524:
	addq	$4160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1548:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1529
	testb	%cl, %cl
	jne	.L1550
.L1529:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1525
	cmpl	$11, %eax
	je	.L1525
.L1531:
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	really_clear_connection
	jmp	.L1525
.L1547:
	call	__asan_report_load4
.L1546:
	call	__asan_report_load8
.L1545:
	movl	$4160, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1522
.L1549:
	movq	$1172321806, (%rbx)
	movq	%r12, %rdx
	movl	$4160, %esi
	movq	%rbx, %rdi
	call	__asan_stack_free_7
	jmp	.L1524
.L1550:
	movq	%rax, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.8
	.align 8
.LC102:
	.string	"3 32 8 2 ai 96 10 7 portstr 160 48 5 hints "
	.section	.rodata
	.align 32
.LC103:
	.string	"%d"
	.zero	61
	.align 32
.LC104:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC105:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC106:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LASANPC37:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rcx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$296, %rsp
	.cfi_def_cfa_offset 352
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rdi, 8(%rsp)
	leaq	32(%rsp), %rbp
	movq	%rdx, (%rsp)
	testl	%eax, %eax
	jne	.L1646
.L1551:
	movq	%rbp, %rbx
	movq	$1102416563, 0(%rbp)
	leaq	160(%rbp), %r12
	leaq	164(%rbp), %rdi
	shrq	$3, %rbx
	movq	$.LC102, 8(%rbp)
	movl	$44, %edx
	xorl	%esi, %esi
	movq	$.LASANPC37, 16(%rbp)
	leaq	256(%rbp), %r15
	movl	$-235802127, 2147450880(%rbx)
	movl	$-218959360, 2147450884(%rbx)
	movl	$-218959118, 2147450888(%rbx)
	movl	$-219020800, 2147450892(%rbx)
	movl	$-218959118, 2147450896(%rbx)
	movl	$-219021312, 2147450904(%rbx)
	movl	$-202116109, 2147450908(%rbx)
	call	memset
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1555
	cmpb	$3, %al
	jle	.L1647
.L1555:
	leaq	-96(%r15), %r10
	movl	$1, -96(%r15)
	leaq	8(%r10), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1556
	cmpb	$3, %al
	jle	.L1648
.L1556:
	leaq	-160(%r15), %r9
	movzwl	port(%rip), %ecx
	movl	$.LC103, %edx
	xorl	%eax, %eax
	movq	%r9, %rdi
	movl	$10, %esi
	movq	%r10, 24(%rsp)
	leaq	-224(%r15), %r12
	movq	%r9, 16(%rsp)
	movl	$1, -88(%r15)
	call	snprintf
	movq	24(%rsp), %r10
	movq	16(%rsp), %r9
	movq	%r12, %rcx
	movq	hostname(%rip), %rdi
	movq	%r10, %rdx
	movq	%r9, %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L1649
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1650
	movq	-224(%r15), %r12
	xorl	%ecx, %ecx
	xorl	%r15d, %r15d
	movq	%r12, %rax
	testq	%r12, %r12
	jne	.L1560
	jmp	.L1651
	.p2align 4,,10
	.p2align 3
.L1655:
	cmpl	$10, %edx
	jne	.L1565
	testq	%rcx, %rcx
	cmove	%rax, %rcx
.L1565:
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1652
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1653
.L1560:
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1563
	testb	%sil, %sil
	jne	.L1654
.L1563:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L1655
	testq	%r15, %r15
	cmove	%rax, %r15
	jmp	.L1565
	.p2align 4,,10
	.p2align 3
.L1653:
	testq	%rcx, %rcx
	je	.L1656
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1570
	cmpb	$3, %al
	jle	.L1657
.L1570:
	movl	16(%rcx), %r8d
	cmpq	$128, %r8
	ja	.L1645
	movq	(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	movq	%rcx, 16(%rsp)
	call	memset
	movq	16(%rsp), %rcx
	leaq	24(%rcx), %rdi
	movl	16(%rcx), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1658
	movq	24(%rcx), %rsi
	movq	(%rsp), %rdi
	call	memmove
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1573
	cmpb	$3, %al
	jle	.L1659
.L1573:
	movl	$1, 0(%r13)
.L1569:
	testq	%r15, %r15
	je	.L1562
	leaq	16(%r15), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1577
	cmpb	$3, %al
	jle	.L1660
.L1577:
	movl	16(%r15), %r8d
	cmpq	$128, %r8
	ja	.L1645
	movq	8(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	call	memset
	leaq	24(%r15), %rdi
	movl	16(%r15), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1661
	movq	24(%r15), %rsi
	movq	8(%rsp), %rdi
	call	memmove
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1580
	cmpb	$3, %al
	jle	.L1662
.L1580:
	movl	$1, (%r14)
.L1576:
	movq	%r12, %rdi
	call	freeaddrinfo
	leaq	32(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L1663
	movl	$0, 2147450896(%rbx)
	pxor	%xmm0, %xmm0
	movq	$0, 2147450904(%rbx)
	movups	%xmm0, 2147450880(%rbx)
.L1553:
	addq	$296, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1651:
	.cfi_restore_state
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1561
	cmpb	$3, %al
	jle	.L1664
.L1561:
	movl	$0, 0(%r13)
.L1562:
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1575
	cmpb	$3, %al
	jle	.L1665
.L1575:
	movl	$0, (%r14)
	jmp	.L1576
.L1656:
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1568
	cmpb	$3, %al
	jle	.L1666
.L1568:
	movl	$0, 0(%r13)
	jmp	.L1569
.L1647:
	movq	%r12, %rdi
	call	__asan_report_store4
.L1648:
	call	__asan_report_store4
.L1652:
	call	__asan_report_load8
.L1654:
	call	__asan_report_load4
.L1650:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1646:
	movl	$256, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L1551
.L1663:
	movdqa	.LC46(%rip), %xmm0
	movq	$1172321806, 0(%rbp)
	movups	%xmm0, 2147450880(%rbx)
	movups	%xmm0, 2147450896(%rbx)
	jmp	.L1553
.L1645:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$.LC106, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1665:
	movq	%r14, %rdi
	call	__asan_report_store4
.L1666:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1664:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1657:
	call	__asan_report_load4
.L1660:
	call	__asan_report_load4
.L1659:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1649:
	movl	%eax, %edi
	movl	%eax, (%rsp)
	call	gai_strerror
	movl	$.LC104, %esi
	movl	$2, %edi
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	syslog
	movl	(%rsp), %r9d
	movl	%r9d, %edi
	call	gai_strerror
	movl	$stderr, %esi
	movq	hostname(%rip), %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rsi
	movq	%rax, %r8
	cmpb	$0, 2147450880(%rsi)
	jne	.L1667
	movq	stderr(%rip), %rdi
	movl	$.LC105, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1661:
	call	__asan_report_load8
.L1667:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1658:
	call	__asan_report_load8
.L1662:
	movq	%r14, %rdi
	call	__asan_report_store4
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.8
	.align 8
.LC107:
	.string	"6 32 4 5 gotv4 96 4 5 gotv6 160 16 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC108:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC109:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC110:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC111:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC112:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC113:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC114:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC115:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC116:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC117:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC118:
	.string	"chdir"
	.zero	58
	.align 32
.LC119:
	.string	"/"
	.zero	62
	.align 32
.LC120:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC121:
	.string	"w"
	.zero	62
	.align 32
.LC122:
	.string	"%d\n"
	.zero	60
	.align 32
.LC123:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC124:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC125:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC126:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC127:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC128:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC129:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC130:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC131:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC132:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC133:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC134:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC135:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC136:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC137:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC138:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC139:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC140:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC141:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LASANPC9:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4776, %rsp
	.cfi_def_cfa_offset 4832
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	64(%rsp), %rbx
	testl	%eax, %eax
	jne	.L1971
.L1668:
	movq	%rbx, %rax
	movq	$1102416563, (%rbx)
	leaq	4704(%rbx), %rbp
	shrq	$3, %rax
	movq	$.LC107, 8(%rbx)
	movq	$.LASANPC9, 16(%rbx)
	movl	$-235802127, 2147450880(%rax)
	movl	$-218959356, 2147450884(%rax)
	movl	$-218959118, 2147450888(%rax)
	movl	$-218959356, 2147450892(%rax)
	movl	$-218959118, 2147450896(%rax)
	movl	$-219021312, 2147450900(%rax)
	movl	$-218959118, 2147450904(%rax)
	movl	$-218959118, 2147450924(%rax)
	movl	$-218959118, 2147450944(%rax)
	movl	$-218959359, 2147451460(%rax)
	movl	$-202116109, 2147451464(%rax)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1972
	movq	0(%r13), %r12
	movl	$47, %esi
	leaq	384(%rbx), %r15
	movq	%r12, %rdi
	movq	%r12, argv0(%rip)
	call	strrchr
	movl	$9, %esi
	testq	%rax, %rax
	leaq	1(%rax), %rdx
	cmovne	%rdx, %r12
	movl	$24, %edx
	movq	%r12, %rdi
	call	openlog
	movq	%r13, %rsi
	movl	%r14d, %edi
	leaq	32(%rbx), %r13
	call	parse_args
	leaq	96(%rbx), %r14
	addq	$224, %rbx
	call	tzset
	movq	%r14, %rcx
	movq	%r15, %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	lookup_hostname.constprop.1
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1674
	cmpb	$3, %al
	jle	.L1973
.L1674:
	movq	%r14, %rax
	movl	-4672(%rbp), %edx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1675
	cmpb	$3, %al
	jle	.L1974
.L1675:
	orl	-4608(%rbp), %edx
	je	.L1975
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L1678
	call	read_throttlefile
.L1678:
	call	getuid
	movl	$32767, 20(%rsp)
	movl	$32767, 40(%rsp)
	testl	%eax, %eax
	je	.L1976
.L1679:
	movq	logfile(%rip), %r12
	testq	%r12, %r12
	je	.L1778
	movl	$.LC112, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1685
	movl	$1, no_log(%rip)
	movq	$0, 8(%rsp)
.L1684:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1693
	call	chdir
	testl	%eax, %eax
	js	.L1977
.L1693:
	leaq	-4160(%rbp), %r12
	movl	$4096, %esi
	movq	%r12, %rdi
	call	getcwd
	movq	%r12, %rdi
	call	strlen
	leaq	-1(%rax), %rdx
	leaq	(%r12,%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L1694
	testb	%cl, %cl
	jne	.L1978
.L1694:
	cmpb	$47, -4160(%rdx,%rbp)
	je	.L1695
	leaq	(%r12,%rax), %rdi
	movl	$2, %edx
	movl	$.LC119, %esi
	call	memcpy
.L1695:
	cmpl	$0, debug(%rip)
	jne	.L1696
	movl	$stdin, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1979
	movq	stdin(%rip), %rdi
	call	fclose
	movl	$stdout, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1980
	movq	stdout(%rip), %rdi
	cmpq	8(%rsp), %rdi
	je	.L1699
	call	fclose
.L1699:
	movl	$stderr, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1981
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	movl	$.LC120, %esi
	testl	%eax, %eax
	js	.L1967
.L1701:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1702
	movl	$.LC121, %esi
	call	fopen
	testq	%rax, %rax
	je	.L1982
	movq	%rax, 24(%rsp)
	call	getpid
	movq	24(%rsp), %rcx
	movl	$.LC122, %esi
	movl	%eax, %edx
	xorl	%eax, %eax
	movq	%rcx, %rdi
	call	fprintf
	movq	24(%rsp), %rcx
	movq	%rcx, %rdi
	call	fclose
.L1702:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects(%rip)
	testl	%eax, %eax
	js	.L1983
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L1984
.L1705:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1710
	call	chdir
	testl	%eax, %eax
	js	.L1985
.L1710:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	movl	do_global_passwd(%rip), %eax
	movq	%r14, %rdx
	movl	no_empty_referers(%rip), %r11d
	shrq	$3, %rdx
	movq	local_pattern(%rip), %r10
	movq	url_pattern(%rip), %rdi
	movl	%eax, 24(%rsp)
	movl	do_vhost(%rip), %eax
	movzbl	2147450880(%rdx), %edx
	movl	cgi_limit(%rip), %r9d
	movl	%eax, 32(%rsp)
	movl	no_symlink_check(%rip), %eax
	movq	cgi_pattern(%rip), %r8
	movzwl	port(%rip), %ecx
	movl	%eax, 44(%rsp)
	movl	no_log(%rip), %eax
	movl	%eax, 48(%rsp)
	movl	max_age(%rip), %eax
	movl	%eax, 52(%rsp)
	movq	p3p(%rip), %rax
	movq	%rax, 56(%rsp)
	movq	charset(%rip), %rax
	testb	%dl, %dl
	je	.L1711
	cmpb	$3, %dl
	jle	.L1986
.L1711:
	cmpl	$0, -4608(%rbp)
	movl	$0, %edx
	movq	%r13, %rsi
	cmovne	%r15, %rdx
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1713
	cmpb	$3, %sil
	jle	.L1987
.L1713:
	cmpl	$0, -4672(%rbp)
	movl	$0, %esi
	pushq	%r11
	.cfi_def_cfa_offset 4840
	cmovne	%rbx, %rsi
	pushq	%r10
	.cfi_def_cfa_offset 4848
	pushq	%rdi
	.cfi_def_cfa_offset 4856
	movl	48(%rsp), %ebx
	movq	hostname(%rip), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 4864
	movl	64(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4872
	movl	84(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4880
	pushq	56(%rsp)
	.cfi_def_cfa_offset 4888
	movl	104(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4896
	pushq	%r12
	.cfi_def_cfa_offset 4904
	movl	124(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4912
	pushq	136(%rsp)
	.cfi_def_cfa_offset 4920
	pushq	%rax
	.cfi_def_cfa_offset 4928
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4832
	movq	%rax, hs(%rip)
	testq	%rax, %rax
	je	.L1968
	movl	$JunkClientData, %ebx
	movq	%rbx, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1988
	movq	JunkClientData(%rip), %rdx
	movl	$occasional, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$120000, %ecx
	call	tmr_create
	movl	$.LC131, %esi
	testq	%rax, %rax
	je	.L1969
	cmpb	$0, 2147450880(%r12)
	jne	.L1989
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L1990
	cmpl	$0, numthrottles(%rip)
	jle	.L1720
	cmpb	$0, 2147450880(%r12)
	jne	.L1991
	movq	JunkClientData(%rip), %rdx
	movl	$update_throttles, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$2000, %ecx
	call	tmr_create
	movl	$.LC133, %esi
	testq	%rax, %rax
	je	.L1969
.L1720:
	shrq	$3, %rbx
	cmpb	$0, 2147450880(%rbx)
	jne	.L1992
	movq	JunkClientData(%rip), %rdx
	movl	$show_stats, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$3600000, %ecx
	call	tmr_create
	movl	$.LC134, %esi
	testq	%rax, %rax
	je	.L1969
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	je	.L1993
.L1725:
	movslq	max_connects(%rip), %r12
	movq	%r12, %rbx
	imulq	$144, %r12, %r12
	movq	%r12, %rdi
	call	malloc
	movq	%rax, connects(%rip)
	testq	%rax, %rax
	je	.L1731
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L1732
.L1736:
	movq	%rdx, %rsi
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1733
	cmpb	$3, %sil
	jle	.L1994
.L1733:
	leaq	4(%rdx), %rdi
	movl	$0, (%rdx)
	addl	$1, %ecx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %r8d
	movq	%rdi, %rsi
	andl	$7, %esi
	addl	$3, %esi
	cmpb	%r8b, %sil
	jl	.L1734
	testb	%r8b, %r8b
	jne	.L1995
.L1734:
	leaq	8(%rdx), %rdi
	movl	%ecx, 4(%rdx)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1996
	movq	$0, 8(%rdx)
	addq	$144, %rdx
.L1732:
	cmpl	%ecx, %ebx
	jg	.L1736
	leaq	-144(%rax,%r12), %rdx
	leaq	4(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1737
	testb	%cl, %cl
	jne	.L1997
.L1737:
	movq	hs(%rip), %rax
	movl	$-1, 4(%rdx)
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L1739
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1740
	cmpb	$3, %dl
	jle	.L1998
.L1740:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1741
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L1741:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1742
	testb	%cl, %cl
	jne	.L1999
.L1742:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1739
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L1739:
	subq	$4544, %rbp
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
.L1744:
	cmpl	$0, terminate(%rip)
	je	.L1776
	cmpl	$0, num_connects(%rip)
	jle	.L2000
.L1776:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L2001
.L1745:
	movq	%rbp, %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	movl	%eax, %ebx
	testl	%eax, %eax
	jns	.L1746
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1747
	testb	%cl, %cl
	jne	.L2002
.L1747:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1744
	cmpl	$11, %eax
	je	.L1744
	movl	$.LC141, %esi
	movl	$3, %edi
	jmp	.L1970
.L1685:
	movl	$.LC83, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1686
	movl	$stdout, %eax
	movq	stdout(%rip), %rcx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	movq	%rcx, 8(%rsp)
	je	.L1684
	movl	$stdout, %edi
	call	__asan_report_load8
.L1983:
	movl	$.LC123, %esi
.L1967:
	movl	$2, %edi
.L1970:
	xorl	%eax, %eax
	call	syslog
.L1968:
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1696:
	call	setsid
	jmp	.L1701
.L1976:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L2003
	leaq	16(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1682
	cmpb	$3, %dl
	jle	.L2004
.L1682:
	leaq	20(%rax), %rdi
	movl	16(%rax), %ecx
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movl	%ecx, 40(%rsp)
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1683
	testb	%cl, %cl
	jne	.L2005
.L1683:
	movl	20(%rax), %eax
	movl	%eax, 20(%rsp)
	jmp	.L1679
.L1778:
	movq	$0, 8(%rsp)
	jmp	.L1684
.L1686:
	movq	%r12, %rdi
	movl	$.LC85, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movl	$384, %esi
	movq	%rax, 8(%rsp)
	movq	%r12, %rdi
	call	chmod
	cmpq	$0, 8(%rsp)
	je	.L1781
	testl	%eax, %eax
	jne	.L1781
	movq	%r12, %rax
	movq	%r12, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L1690
	testb	%al, %al
	je	.L1690
	movq	%r12, %rdi
	call	__asan_report_load1
.L1690:
	cmpb	$47, (%r12)
	jne	.L2006
.L1691:
	movq	8(%rsp), %rdi
	call	fileno
	movl	$1, %edx
	movl	$2, %esi
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L1684
	movq	8(%rsp), %rdi
	call	fileno
	movl	20(%rsp), %edx
	movl	40(%rsp), %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L1684
	movl	$.LC115, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC116, %edi
	call	perror
	jmp	.L1684
.L1990:
	movl	$.LC132, %esi
.L1969:
	movl	$2, %edi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1975:
	xorl	%eax, %eax
	movl	$.LC108, %esi
	movl	$3, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2007
	movq	stderr(%rip), %rdi
	movl	$.LC109, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1977:
	movl	$.LC117, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC118, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1982:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC75, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1984:
	movq	%r12, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L2008
	movq	logfile(%rip), %rcx
	testq	%rcx, %rcx
	je	.L1707
	movl	$.LC83, %esi
	movq	%rcx, %rdi
	movq	%rcx, 24(%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L1707
	movq	%r12, %rdi
	call	strlen
	movq	24(%rsp), %rcx
	movq	%r12, %rsi
	movq	%rax, %rdx
	movq	%rax, 32(%rsp)
	movq	%rcx, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L1708
	movq	24(%rsp), %rcx
	movq	32(%rsp), %r8
	movq	%rcx, %rdi
	leaq	-1(%rcx,%r8), %rsi
	call	strcpy
.L1707:
	movq	%r12, %rdi
	movl	$2, %edx
	movl	$.LC119, %esi
	call	memcpy
	movq	%r12, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L1705
	movl	$.LC127, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC128, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1985:
	movl	$.LC129, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC130, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2006:
	xorl	%eax, %eax
	movl	$.LC113, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2009
	movq	stderr(%rip), %rdi
	movl	$.LC114, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1691
.L1993:
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	movl	$.LC135, %esi
	testl	%eax, %eax
	js	.L1967
	movl	20(%rsp), %edi
	call	setgid
	movl	$.LC136, %esi
	testl	%eax, %eax
	js	.L1967
	movl	20(%rsp), %esi
	movq	user(%rip), %rdi
	call	initgroups
	testl	%eax, %eax
	js	.L2010
.L1728:
	movl	40(%rsp), %edi
	call	setuid
	movl	$.LC138, %esi
	testl	%eax, %eax
	js	.L1967
	cmpl	$0, do_chroot(%rip)
	jne	.L1725
	movl	$.LC139, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1725
.L1974:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1973:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1986:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1987:
	movq	%r13, %rdi
	call	__asan_report_load4
.L2004:
	call	__asan_report_load4
.L2005:
	call	__asan_report_load4
.L2003:
	movq	user(%rip), %rdx
	movl	$.LC110, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2011
	movq	stderr(%rip), %rdi
	movl	$.LC111, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1746:
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L2012
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1763
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1754
	testb	%cl, %cl
	jne	.L2013
.L1754:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1755
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1756
.L1760:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1763
.L1755:
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1761
	cmpb	$3, %dl
	jle	.L2014
.L1761:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1763
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1763
	movq	hs(%rip), %rax
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1762
	cmpb	$3, %dl
	jle	.L2015
.L1762:
	movl	72(%rax), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1744
.L1763:
	call	fdwatch_get_next_client_data
	movq	%rax, %rbx
	cmpq	$-1, %rax
	je	.L2016
	testq	%rbx, %rbx
	je	.L1763
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2017
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1765
	cmpb	$3, %dl
	jle	.L2018
.L1765:
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L2019
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1768
	cmpb	$3, %al
	jle	.L2020
.L1768:
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L1769
	cmpl	$4, %eax
	je	.L1770
	subl	$1, %eax
	jne	.L1763
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L1763
.L2019:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1763
.L2001:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L1745
.L1781:
	movq	%r12, %rdx
	movl	$.LC75, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2008:
	movl	$.LC124, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC21, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2016:
	movq	%rbp, %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L1744
	cmpl	$0, terminate(%rip)
	jne	.L1744
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L1744
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1772
	cmpb	$3, %dl
	jle	.L2021
.L1772:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1773
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L1773:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1774
	testb	%cl, %cl
	jne	.L2022
.L1774:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1775
	call	fdwatch_del_fd
.L1775:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L1744
.L1770:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L1763
.L1769:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L1763
.L1708:
	xorl	%eax, %eax
	movl	$.LC125, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2023
	movq	stderr(%rip), %rdi
	movl	$.LC126, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1707
.L2012:
	movq	%rbp, %rdi
	call	tmr_run
	jmp	.L1744
.L1731:
	movl	$.LC140, %esi
	jmp	.L1967
.L1756:
	movq	hs(%rip), %rdx
	leaq	76(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1758
	testb	%cl, %cl
	jne	.L2024
.L1758:
	movl	76(%rdx), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L1760
	jmp	.L1744
.L2000:
	call	shut_down
	movl	$5, %edi
	movl	$.LC91, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L2010:
	movl	$.LC137, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1728
.L1971:
	movl	$4704, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1668
.L1972:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1978:
	call	__asan_report_load1
.L1980:
	movl	$stdout, %edi
	call	__asan_report_load8
.L1979:
	movl	$stdin, %edi
	call	__asan_report_load8
.L1981:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1994:
	movq	%rdx, %rdi
	call	__asan_report_store4
.L1996:
	call	__asan_report_store8
.L1995:
	call	__asan_report_store4
.L1989:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1988:
	movq	%rbx, %rdi
	call	__asan_report_load8
.L2007:
	movl	$stderr, %edi
	call	__asan_report_load8
.L2017:
	call	__asan_report_load8
.L2018:
	call	__asan_report_load4
.L2021:
	call	__asan_report_load4
.L2024:
	call	__asan_report_load4
.L1992:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1991:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L2014:
	call	__asan_report_load4
.L2015:
	call	__asan_report_load4
.L2013:
	call	__asan_report_load4
.L2023:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1997:
	call	__asan_report_store4
.L2022:
	call	__asan_report_load4
.L2020:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L2011:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1999:
	call	__asan_report_load4
.L1998:
	call	__asan_report_load4
.L2002:
	movq	%rax, %rdi
	call	__asan_report_load4
.L2009:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 8
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 8
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 8
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 8
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 8
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 8
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 8
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 8
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 8
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 8
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 8
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 8
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 8
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 8
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 8
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 8
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC142:
	.string	"thttpd.c"
	.data
	.align 16
	.type	.LASANLOC1, @object
	.size	.LASANLOC1, 16
.LASANLOC1:
	.quad	.LC142
	.long	135
	.long	40
	.align 16
	.type	.LASANLOC2, @object
	.size	.LASANLOC2, 16
.LASANLOC2:
	.quad	.LC142
	.long	135
	.long	30
	.align 16
	.type	.LASANLOC3, @object
	.size	.LASANLOC3, 16
.LASANLOC3:
	.quad	.LC142
	.long	135
	.long	21
	.globl	__odr_asan.terminate
	.bss
	.type	__odr_asan.terminate, @object
	.size	__odr_asan.terminate, 1
__odr_asan.terminate:
	.zero	1
	.data
	.align 16
	.type	.LASANLOC4, @object
	.size	.LASANLOC4, 16
.LASANLOC4:
	.quad	.LC142
	.long	129
	.long	5
	.align 16
	.type	.LASANLOC5, @object
	.size	.LASANLOC5, 16
.LASANLOC5:
	.quad	.LC142
	.long	128
	.long	22
	.align 16
	.type	.LASANLOC6, @object
	.size	.LASANLOC6, 16
.LASANLOC6:
	.quad	.LC142
	.long	118
	.long	12
	.align 16
	.type	.LASANLOC7, @object
	.size	.LASANLOC7, 16
.LASANLOC7:
	.quad	.LC142
	.long	117
	.long	40
	.align 16
	.type	.LASANLOC8, @object
	.size	.LASANLOC8, 16
.LASANLOC8:
	.quad	.LC142
	.long	117
	.long	26
	.align 16
	.type	.LASANLOC9, @object
	.size	.LASANLOC9, 16
.LASANLOC9:
	.quad	.LC142
	.long	117
	.long	12
	.align 16
	.type	.LASANLOC10, @object
	.size	.LASANLOC10, 16
.LASANLOC10:
	.quad	.LC142
	.long	116
	.long	20
	.align 16
	.type	.LASANLOC11, @object
	.size	.LASANLOC11, 16
.LASANLOC11:
	.quad	.LC142
	.long	96
	.long	26
	.align 16
	.type	.LASANLOC12, @object
	.size	.LASANLOC12, 16
.LASANLOC12:
	.quad	.LC142
	.long	96
	.long	12
	.align 16
	.type	.LASANLOC13, @object
	.size	.LASANLOC13, 16
.LASANLOC13:
	.quad	.LC142
	.long	95
	.long	21
	.align 16
	.type	.LASANLOC14, @object
	.size	.LASANLOC14, 16
.LASANLOC14:
	.quad	.LC142
	.long	85
	.long	12
	.align 16
	.type	.LASANLOC15, @object
	.size	.LASANLOC15, 16
.LASANLOC15:
	.quad	.LC142
	.long	84
	.long	14
	.align 16
	.type	.LASANLOC16, @object
	.size	.LASANLOC16, 16
.LASANLOC16:
	.quad	.LC142
	.long	83
	.long	14
	.align 16
	.type	.LASANLOC17, @object
	.size	.LASANLOC17, 16
.LASANLOC17:
	.quad	.LC142
	.long	82
	.long	14
	.align 16
	.type	.LASANLOC18, @object
	.size	.LASANLOC18, 16
.LASANLOC18:
	.quad	.LC142
	.long	81
	.long	14
	.align 16
	.type	.LASANLOC19, @object
	.size	.LASANLOC19, 16
.LASANLOC19:
	.quad	.LC142
	.long	80
	.long	14
	.align 16
	.type	.LASANLOC20, @object
	.size	.LASANLOC20, 16
.LASANLOC20:
	.quad	.LC142
	.long	79
	.long	14
	.align 16
	.type	.LASANLOC21, @object
	.size	.LASANLOC21, 16
.LASANLOC21:
	.quad	.LC142
	.long	78
	.long	14
	.align 16
	.type	.LASANLOC22, @object
	.size	.LASANLOC22, 16
.LASANLOC22:
	.quad	.LC142
	.long	77
	.long	14
	.align 16
	.type	.LASANLOC23, @object
	.size	.LASANLOC23, 16
.LASANLOC23:
	.quad	.LC142
	.long	76
	.long	12
	.align 16
	.type	.LASANLOC24, @object
	.size	.LASANLOC24, 16
.LASANLOC24:
	.quad	.LC142
	.long	75
	.long	14
	.align 16
	.type	.LASANLOC25, @object
	.size	.LASANLOC25, 16
.LASANLOC25:
	.quad	.LC142
	.long	74
	.long	12
	.align 16
	.type	.LASANLOC26, @object
	.size	.LASANLOC26, 16
.LASANLOC26:
	.quad	.LC142
	.long	73
	.long	14
	.align 16
	.type	.LASANLOC27, @object
	.size	.LASANLOC27, 16
.LASANLOC27:
	.quad	.LC142
	.long	72
	.long	59
	.align 16
	.type	.LASANLOC28, @object
	.size	.LASANLOC28, 16
.LASANLOC28:
	.quad	.LC142
	.long	72
	.long	49
	.align 16
	.type	.LASANLOC29, @object
	.size	.LASANLOC29, 16
.LASANLOC29:
	.quad	.LC142
	.long	72
	.long	31
	.align 16
	.type	.LASANLOC30, @object
	.size	.LASANLOC30, 16
.LASANLOC30:
	.quad	.LC142
	.long	72
	.long	23
	.align 16
	.type	.LASANLOC31, @object
	.size	.LASANLOC31, 16
.LASANLOC31:
	.quad	.LC142
	.long	72
	.long	12
	.align 16
	.type	.LASANLOC32, @object
	.size	.LASANLOC32, 16
.LASANLOC32:
	.quad	.LC142
	.long	71
	.long	14
	.align 16
	.type	.LASANLOC33, @object
	.size	.LASANLOC33, 16
.LASANLOC33:
	.quad	.LC142
	.long	70
	.long	14
	.align 16
	.type	.LASANLOC34, @object
	.size	.LASANLOC34, 16
.LASANLOC34:
	.quad	.LC142
	.long	69
	.long	23
	.align 16
	.type	.LASANLOC35, @object
	.size	.LASANLOC35, 16
.LASANLOC35:
	.quad	.LC142
	.long	68
	.long	12
	.align 16
	.type	.LASANLOC36, @object
	.size	.LASANLOC36, 16
.LASANLOC36:
	.quad	.LC142
	.long	67
	.long	14
	.section	.rodata.str1.1
.LC143:
	.string	"watchdog_flag"
.LC144:
	.string	"got_usr1"
.LC145:
	.string	"got_hup"
.LC146:
	.string	"terminate"
.LC147:
	.string	"hs"
.LC148:
	.string	"httpd_conn_count"
.LC149:
	.string	"first_free_connect"
.LC150:
	.string	"max_connects"
.LC151:
	.string	"num_connects"
.LC152:
	.string	"connects"
.LC153:
	.string	"maxthrottles"
.LC154:
	.string	"numthrottles"
.LC155:
	.string	"hostname"
.LC156:
	.string	"throttlefile"
.LC157:
	.string	"local_pattern"
.LC158:
	.string	"no_empty_referers"
.LC159:
	.string	"url_pattern"
.LC160:
	.string	"cgi_limit"
.LC161:
	.string	"cgi_pattern"
.LC162:
	.string	"do_global_passwd"
.LC163:
	.string	"do_vhost"
.LC164:
	.string	"no_symlink_check"
.LC165:
	.string	"no_log"
.LC166:
	.string	"do_chroot"
.LC167:
	.string	"argv0"
.LC168:
	.string	"*.LC96"
.LC169:
	.string	"*.LC117"
.LC170:
	.string	"*.LC39"
.LC171:
	.string	"*.LC84"
.LC172:
	.string	"*.LC137"
.LC173:
	.string	"*.LC79"
.LC174:
	.string	"*.LC80"
.LC175:
	.string	"*.LC1"
.LC176:
	.string	"*.LC129"
.LC177:
	.string	"*.LC132"
.LC178:
	.string	"*.LC70"
.LC179:
	.string	"*.LC35"
.LC180:
	.string	"*.LC61"
.LC181:
	.string	"*.LC76"
.LC182:
	.string	"*.LC63"
.LC183:
	.string	"*.LC83"
.LC184:
	.string	"*.LC55"
.LC185:
	.string	"*.LC124"
.LC186:
	.string	"*.LC130"
.LC187:
	.string	"*.LC36"
.LC188:
	.string	"*.LC21"
.LC189:
	.string	"*.LC32"
.LC190:
	.string	"*.LC136"
.LC191:
	.string	"*.LC56"
.LC192:
	.string	"*.LC45"
.LC193:
	.string	"*.LC104"
.LC194:
	.string	"*.LC29"
.LC195:
	.string	"*.LC6"
.LC196:
	.string	"*.LC3"
.LC197:
	.string	"*.LC108"
.LC198:
	.string	"*.LC106"
.LC199:
	.string	"*.LC82"
.LC200:
	.string	"*.LC77"
.LC201:
	.string	"*.LC116"
.LC202:
	.string	"*.LC31"
.LC203:
	.string	"*.LC40"
.LC204:
	.string	"*.LC50"
.LC205:
	.string	"*.LC57"
.LC206:
	.string	"*.LC41"
.LC207:
	.string	"*.LC119"
.LC208:
	.string	"*.LC62"
.LC209:
	.string	"*.LC30"
.LC210:
	.string	"*.LC0"
.LC211:
	.string	"*.LC85"
.LC212:
	.string	"*.LC138"
.LC213:
	.string	"*.LC122"
.LC214:
	.string	"*.LC12"
.LC215:
	.string	"*.LC47"
.LC216:
	.string	"*.LC48"
.LC217:
	.string	"*.LC103"
.LC218:
	.string	"*.LC128"
.LC219:
	.string	"*.LC43"
.LC220:
	.string	"*.LC99"
.LC221:
	.string	"*.LC19"
.LC222:
	.string	"*.LC25"
.LC223:
	.string	"*.LC127"
.LC224:
	.string	"*.LC110"
.LC225:
	.string	"*.LC111"
.LC226:
	.string	"*.LC141"
.LC227:
	.string	"*.LC20"
.LC228:
	.string	"*.LC51"
.LC229:
	.string	"*.LC73"
.LC230:
	.string	"*.LC89"
.LC231:
	.string	"*.LC67"
.LC232:
	.string	"*.LC64"
.LC233:
	.string	"*.LC65"
.LC234:
	.string	"*.LC114"
.LC235:
	.string	"*.LC16"
.LC236:
	.string	"*.LC121"
.LC237:
	.string	"*.LC120"
.LC238:
	.string	"*.LC78"
.LC239:
	.string	"*.LC123"
.LC240:
	.string	"*.LC4"
.LC241:
	.string	"*.LC125"
.LC242:
	.string	"*.LC17"
.LC243:
	.string	"*.LC68"
.LC244:
	.string	"*.LC22"
.LC245:
	.string	"*.LC42"
.LC246:
	.string	"*.LC66"
.LC247:
	.string	"*.LC26"
.LC248:
	.string	"*.LC86"
.LC249:
	.string	"*.LC33"
.LC250:
	.string	"*.LC49"
.LC251:
	.string	"*.LC118"
.LC252:
	.string	"*.LC126"
.LC253:
	.string	"*.LC105"
.LC254:
	.string	"*.LC100"
.LC255:
	.string	"*.LC139"
.LC256:
	.string	"*.LC95"
.LC257:
	.string	"*.LC75"
.LC258:
	.string	"*.LC9"
.LC259:
	.string	"*.LC134"
.LC260:
	.string	"*.LC71"
.LC261:
	.string	"*.LC81"
.LC262:
	.string	"*.LC54"
.LC263:
	.string	"*.LC69"
.LC264:
	.string	"*.LC58"
.LC265:
	.string	"*.LC135"
.LC266:
	.string	"*.LC90"
.LC267:
	.string	"*.LC140"
.LC268:
	.string	"*.LC2"
.LC269:
	.string	"*.LC93"
.LC270:
	.string	"*.LC5"
.LC271:
	.string	"*.LC94"
.LC272:
	.string	"*.LC133"
.LC273:
	.string	"*.LC98"
.LC274:
	.string	"*.LC91"
.LC275:
	.string	"*.LC23"
.LC276:
	.string	"*.LC59"
.LC277:
	.string	"*.LC10"
.LC278:
	.string	"*.LC115"
.LC279:
	.string	"*.LC112"
.LC280:
	.string	"*.LC87"
.LC281:
	.string	"*.LC34"
.LC282:
	.string	"*.LC131"
.LC283:
	.string	"*.LC44"
.LC284:
	.string	"*.LC27"
.LC285:
	.string	"*.LC88"
.LC286:
	.string	"*.LC92"
.LC287:
	.string	"*.LC52"
.LC288:
	.string	"*.LC72"
.LC289:
	.string	"*.LC38"
.LC290:
	.string	"*.LC53"
.LC291:
	.string	"*.LC60"
.LC292:
	.string	"*.LC37"
.LC293:
	.string	"*.LC28"
.LC294:
	.string	"*.LC13"
.LC295:
	.string	"*.LC14"
.LC296:
	.string	"*.LC109"
.LC297:
	.string	"*.LC24"
.LC298:
	.string	"*.LC113"
.LC299:
	.string	"*.LC18"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 10752
.LASAN0:
	.quad	watchdog_flag
	.quad	4
	.quad	64
	.quad	.LC143
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC1
	.quad	0
	.quad	got_usr1
	.quad	4
	.quad	64
	.quad	.LC144
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC2
	.quad	0
	.quad	got_hup
	.quad	4
	.quad	64
	.quad	.LC145
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC3
	.quad	0
	.quad	terminate
	.quad	4
	.quad	64
	.quad	.LC146
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC4
	.quad	__odr_asan.terminate
	.quad	hs
	.quad	8
	.quad	64
	.quad	.LC147
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC5
	.quad	0
	.quad	httpd_conn_count
	.quad	4
	.quad	64
	.quad	.LC148
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC6
	.quad	0
	.quad	first_free_connect
	.quad	4
	.quad	64
	.quad	.LC149
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC7
	.quad	0
	.quad	max_connects
	.quad	4
	.quad	64
	.quad	.LC150
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC8
	.quad	0
	.quad	num_connects
	.quad	4
	.quad	64
	.quad	.LC151
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC9
	.quad	0
	.quad	connects
	.quad	8
	.quad	64
	.quad	.LC152
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC10
	.quad	0
	.quad	maxthrottles
	.quad	4
	.quad	64
	.quad	.LC153
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC11
	.quad	0
	.quad	numthrottles
	.quad	4
	.quad	64
	.quad	.LC154
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC12
	.quad	0
	.quad	throttles
	.quad	8
	.quad	64
	.quad	.LC34
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC13
	.quad	0
	.quad	max_age
	.quad	4
	.quad	64
	.quad	.LC44
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC14
	.quad	0
	.quad	p3p
	.quad	8
	.quad	64
	.quad	.LC43
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC15
	.quad	0
	.quad	charset
	.quad	8
	.quad	64
	.quad	.LC42
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC16
	.quad	0
	.quad	user
	.quad	8
	.quad	64
	.quad	.LC28
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC17
	.quad	0
	.quad	pidfile
	.quad	8
	.quad	64
	.quad	.LC41
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC18
	.quad	0
	.quad	hostname
	.quad	8
	.quad	64
	.quad	.LC155
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC19
	.quad	0
	.quad	throttlefile
	.quad	8
	.quad	64
	.quad	.LC156
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC20
	.quad	0
	.quad	logfile
	.quad	8
	.quad	64
	.quad	.LC36
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC21
	.quad	0
	.quad	local_pattern
	.quad	8
	.quad	64
	.quad	.LC157
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC22
	.quad	0
	.quad	no_empty_referers
	.quad	4
	.quad	64
	.quad	.LC158
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC23
	.quad	0
	.quad	url_pattern
	.quad	8
	.quad	64
	.quad	.LC159
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC24
	.quad	0
	.quad	cgi_limit
	.quad	4
	.quad	64
	.quad	.LC160
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC25
	.quad	0
	.quad	cgi_pattern
	.quad	8
	.quad	64
	.quad	.LC161
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC26
	.quad	0
	.quad	do_global_passwd
	.quad	4
	.quad	64
	.quad	.LC162
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC27
	.quad	0
	.quad	do_vhost
	.quad	4
	.quad	64
	.quad	.LC163
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC28
	.quad	0
	.quad	no_symlink_check
	.quad	4
	.quad	64
	.quad	.LC164
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC29
	.quad	0
	.quad	no_log
	.quad	4
	.quad	64
	.quad	.LC165
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC30
	.quad	0
	.quad	do_chroot
	.quad	4
	.quad	64
	.quad	.LC166
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC31
	.quad	0
	.quad	data_dir
	.quad	8
	.quad	64
	.quad	.LC23
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC32
	.quad	0
	.quad	dir
	.quad	8
	.quad	64
	.quad	.LC20
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC33
	.quad	0
	.quad	port
	.quad	2
	.quad	64
	.quad	.LC19
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC34
	.quad	0
	.quad	debug
	.quad	4
	.quad	64
	.quad	.LC18
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC35
	.quad	0
	.quad	argv0
	.quad	8
	.quad	64
	.quad	.LC167
	.quad	.LC142
	.quad	0
	.quad	.LASANLOC36
	.quad	0
	.quad	.LC96
	.quad	35
	.quad	96
	.quad	.LC168
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC117
	.quad	11
	.quad	64
	.quad	.LC169
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC39
	.quad	13
	.quad	64
	.quad	.LC170
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC84
	.quad	19
	.quad	64
	.quad	.LC171
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC137
	.quad	16
	.quad	64
	.quad	.LC172
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC79
	.quad	3
	.quad	64
	.quad	.LC173
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC80
	.quad	39
	.quad	96
	.quad	.LC174
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC1
	.quad	70
	.quad	128
	.quad	.LC175
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC129
	.quad	20
	.quad	64
	.quad	.LC176
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC132
	.quad	24
	.quad	64
	.quad	.LC177
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC70
	.quad	3
	.quad	64
	.quad	.LC178
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC35
	.quad	5
	.quad	64
	.quad	.LC179
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC61
	.quad	3
	.quad	64
	.quad	.LC180
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC76
	.quad	16
	.quad	64
	.quad	.LC181
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC63
	.quad	3
	.quad	64
	.quad	.LC182
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC83
	.quad	2
	.quad	64
	.quad	.LC183
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC55
	.quad	3
	.quad	64
	.quad	.LC184
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC124
	.quad	12
	.quad	64
	.quad	.LC185
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC130
	.quad	15
	.quad	64
	.quad	.LC186
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC36
	.quad	8
	.quad	64
	.quad	.LC187
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC21
	.quad	7
	.quad	64
	.quad	.LC188
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC32
	.quad	16
	.quad	64
	.quad	.LC189
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC136
	.quad	12
	.quad	64
	.quad	.LC190
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC56
	.quad	5
	.quad	64
	.quad	.LC191
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC45
	.quad	32
	.quad	64
	.quad	.LC192
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC104
	.quad	26
	.quad	64
	.quad	.LC193
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC29
	.quad	7
	.quad	64
	.quad	.LC194
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC6
	.quad	219
	.quad	256
	.quad	.LC195
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC3
	.quad	65
	.quad	128
	.quad	.LC196
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC108
	.quad	29
	.quad	64
	.quad	.LC197
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC106
	.quad	39
	.quad	96
	.quad	.LC198
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC82
	.quad	20
	.quad	64
	.quad	.LC199
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC77
	.quad	33
	.quad	96
	.quad	.LC200
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC116
	.quad	15
	.quad	64
	.quad	.LC201
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC31
	.quad	7
	.quad	64
	.quad	.LC202
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC40
	.quad	15
	.quad	64
	.quad	.LC203
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC50
	.quad	3
	.quad	64
	.quad	.LC204
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC57
	.quad	4
	.quad	64
	.quad	.LC205
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC41
	.quad	8
	.quad	64
	.quad	.LC206
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC119
	.quad	2
	.quad	64
	.quad	.LC207
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC62
	.quad	3
	.quad	64
	.quad	.LC208
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC30
	.quad	9
	.quad	64
	.quad	.LC209
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC0
	.quad	104
	.quad	160
	.quad	.LC210
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC85
	.quad	2
	.quad	64
	.quad	.LC211
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC138
	.quad	12
	.quad	64
	.quad	.LC212
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC122
	.quad	4
	.quad	64
	.quad	.LC213
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC12
	.quad	16
	.quad	64
	.quad	.LC214
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC47
	.quad	7
	.quad	64
	.quad	.LC215
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC48
	.quad	11
	.quad	64
	.quad	.LC216
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC103
	.quad	3
	.quad	64
	.quad	.LC217
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC128
	.quad	13
	.quad	64
	.quad	.LC218
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC43
	.quad	4
	.quad	64
	.quad	.LC219
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC99
	.quad	37
	.quad	96
	.quad	.LC220
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC19
	.quad	5
	.quad	64
	.quad	.LC221
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC25
	.quad	10
	.quad	64
	.quad	.LC222
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC127
	.quad	18
	.quad	64
	.quad	.LC223
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC110
	.quad	23
	.quad	64
	.quad	.LC224
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC111
	.quad	25
	.quad	64
	.quad	.LC225
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC141
	.quad	13
	.quad	64
	.quad	.LC226
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC20
	.quad	4
	.quad	64
	.quad	.LC227
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC51
	.quad	26
	.quad	64
	.quad	.LC228
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC73
	.quad	3
	.quad	64
	.quad	.LC229
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC89
	.quad	39
	.quad	96
	.quad	.LC230
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC67
	.quad	3
	.quad	64
	.quad	.LC231
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC64
	.quad	3
	.quad	64
	.quad	.LC232
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC65
	.quad	3
	.quad	64
	.quad	.LC233
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC114
	.quad	72
	.quad	128
	.quad	.LC234
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC16
	.quad	2
	.quad	64
	.quad	.LC235
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC121
	.quad	2
	.quad	64
	.quad	.LC236
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC120
	.quad	12
	.quad	64
	.quad	.LC237
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC78
	.quad	38
	.quad	96
	.quad	.LC238
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC123
	.quad	31
	.quad	64
	.quad	.LC239
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC4
	.quad	37
	.quad	96
	.quad	.LC240
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC125
	.quad	74
	.quad	128
	.quad	.LC241
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC17
	.quad	5
	.quad	64
	.quad	.LC242
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC68
	.quad	5
	.quad	64
	.quad	.LC243
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC22
	.quad	9
	.quad	64
	.quad	.LC244
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC42
	.quad	8
	.quad	64
	.quad	.LC245
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC66
	.quad	5
	.quad	64
	.quad	.LC246
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC26
	.quad	9
	.quad	64
	.quad	.LC247
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC86
	.quad	22
	.quad	64
	.quad	.LC248
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC33
	.quad	9
	.quad	64
	.quad	.LC249
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC49
	.quad	1
	.quad	64
	.quad	.LC250
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC118
	.quad	6
	.quad	64
	.quad	.LC251
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC126
	.quad	79
	.quad	128
	.quad	.LC252
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC105
	.quad	25
	.quad	64
	.quad	.LC253
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC100
	.quad	25
	.quad	64
	.quad	.LC254
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC139
	.quad	58
	.quad	96
	.quad	.LC255
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC95
	.quad	35
	.quad	96
	.quad	.LC256
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC75
	.quad	11
	.quad	64
	.quad	.LC257
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC9
	.quad	39
	.quad	96
	.quad	.LC258
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC134
	.quad	30
	.quad	64
	.quad	.LC259
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC71
	.quad	3
	.quad	64
	.quad	.LC260
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC81
	.quad	44
	.quad	96
	.quad	.LC261
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC54
	.quad	3
	.quad	64
	.quad	.LC262
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC69
	.quad	3
	.quad	64
	.quad	.LC263
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC58
	.quad	3
	.quad	64
	.quad	.LC264
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC135
	.quad	15
	.quad	64
	.quad	.LC265
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC90
	.quad	56
	.quad	96
	.quad	.LC266
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC140
	.quad	38
	.quad	96
	.quad	.LC267
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC2
	.quad	62
	.quad	96
	.quad	.LC268
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC93
	.quad	33
	.quad	96
	.quad	.LC269
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC5
	.quad	34
	.quad	96
	.quad	.LC270
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC94
	.quad	43
	.quad	96
	.quad	.LC271
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC133
	.quad	36
	.quad	96
	.quad	.LC272
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC98
	.quad	33
	.quad	96
	.quad	.LC273
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC91
	.quad	8
	.quad	64
	.quad	.LC274
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC23
	.quad	9
	.quad	64
	.quad	.LC275
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC59
	.quad	5
	.quad	64
	.quad	.LC276
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC10
	.quad	5
	.quad	64
	.quad	.LC277
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC115
	.quad	20
	.quad	64
	.quad	.LC278
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC112
	.quad	10
	.quad	64
	.quad	.LC279
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC87
	.quad	22
	.quad	64
	.quad	.LC280
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC34
	.quad	10
	.quad	64
	.quad	.LC281
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC131
	.quad	30
	.quad	64
	.quad	.LC282
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC44
	.quad	8
	.quad	64
	.quad	.LC283
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC27
	.quad	11
	.quad	64
	.quad	.LC284
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC88
	.quad	36
	.quad	96
	.quad	.LC285
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC92
	.quad	25
	.quad	64
	.quad	.LC286
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC52
	.quad	3
	.quad	64
	.quad	.LC287
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC72
	.quad	3
	.quad	64
	.quad	.LC288
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC38
	.quad	8
	.quad	64
	.quad	.LC289
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC53
	.quad	3
	.quad	64
	.quad	.LC290
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC60
	.quad	3
	.quad	64
	.quad	.LC291
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC37
	.quad	6
	.quad	64
	.quad	.LC292
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC28
	.quad	5
	.quad	64
	.quad	.LC293
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC13
	.quad	31
	.quad	64
	.quad	.LC294
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC14
	.quad	36
	.quad	96
	.quad	.LC295
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC109
	.quad	34
	.quad	96
	.quad	.LC296
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC24
	.quad	8
	.quad	64
	.quad	.LC297
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC113
	.quad	67
	.quad	128
	.quad	.LC298
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC18
	.quad	6
	.quad	64
	.quad	.LC299
	.quad	.LC142
	.quad	0
	.quad	0
	.quad	0
	.section	.text.exit,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	movl	$168, %esi
	movl	$.LASAN0, %edi
	jmp	__asan_unregister_globals
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	__asan_init
	call	__asan_version_mismatch_check_v8
	movl	$168, %esi
	movl	$.LASAN0, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__asan_register_globals
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_00099_1_terminate
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC46:
	.quad	-723401728380766731
	.quad	-723401728380766731
	.ident	"GCC: (GNU) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
