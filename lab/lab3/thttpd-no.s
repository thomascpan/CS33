	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
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
	.section	.rodata.str1.8
	.align 8
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 8
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 8
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r8d
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
	testl	%r8d, %r8d
	jg	.L7
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L36:
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	%ebx, %edx
	movl	$.LC1, %esi
	movl	$5, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
.L35:
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%rdi
	.cfi_def_cfa_offset 32
	addq	%rbp, %rcx
	movq	24(%rcx), %r8
.L10:
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L11
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L11
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	movl	$.LC3, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$5, %edi
	xorl	%eax, %eax
	call	syslog
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	.p2align 4,,10
	.p2align 3
.L11:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L13
.L7:
	movq	throttles(%rip), %rcx
	addq	%rbp, %rcx
	movq	32(%rcx), %rdx
	movq	24(%rcx), %rsi
	movq	$0, 32(%rcx)
	movq	8(%rcx), %r9
	movq	%rdx, %rax
	shrq	$63, %rax
	addq	%rdx, %rax
	sarq	%rax
	leaq	(%rax,%rsi,2), %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	subq	%rsi, %rdx
	movq	%rdx, %r8
	movq	%rdx, 24(%rcx)
	cmpq	%r9, %rdx
	jle	.L10
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L11
	leaq	(%r9,%r9), %rdx
	movq	(%rcx), %rcx
	cmpq	%rdx, %r8
	jg	.L36
	subq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	%ebx, %edx
	movl	$.LC2, %esi
	movl	$6, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L13:
	.cfi_restore_state
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	movq	connects(%rip), %r9
	subl	$1, %eax
	movq	throttles(%rip), %r11
	movq	$-1, %rbp
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	leaq	144(%r9), %r8
	addq	%r8, %rbx
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L15:
	movq	%r8, %r9
	cmpq	%r8, %rbx
	je	.L6
.L39:
	addq	$144, %r8
.L20:
	movl	(%r9), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L15
	movl	56(%r9), %ecx
	movq	%rbp, 64(%r9)
	testl	%ecx, %ecx
	jle	.L15
	movslq	16(%r9), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r11, %rax
	movslq	40(%rax), %rsi
	movq	8(%rax), %rax
	cqto
	idivq	%rsi
	leaq	20(%r9), %rsi
	movq	%rax, %rdi
	leal	-1(%rcx), %eax
	leaq	(%rsi,%rax,4), %r10
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L38:
	cmpq	%rax, %rdi
	cmovg	%rax, %rdi
.L18:
	addq	$4, %rsi
.L21:
	cmpq	%r10, %rsi
	je	.L37
	movslq	(%rsi), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r11, %rcx
	movq	8(%rcx), %rax
	movslq	40(%rcx), %r12
	cqto
	idivq	%r12
	cmpq	$-1, %rdi
	jne	.L38
	movq	%rax, %rdi
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L37:
	movq	%rdi, 64(%r9)
	movq	%r8, %r9
	cmpq	%r8, %rbx
	jne	.L39
.L6:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"%s: no value required for %s option\n"
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L45
	ret
.L45:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movl	$.LC4, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"%s: value required for %s option\n"
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L51
	ret
.L51:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movl	$.LC5, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T 
charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.text
	.p2align 4,,15
	.type	usage, @function
usage:
.LFB11:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC6, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LFB30:
	.cfi_startproc
	cmpl	$3, (%rdi)
	movq	$0, 96(%rdi)
	je	.L56
	ret
	.p2align 4,,10
	.p2align 3
.L56:
	movq	8(%rdi), %rax
	movl	$2, (%rdi)
	movq	%rdi, %rsi
	movl	$1, %edx
	movl	704(%rax), %eax
	movl	%eax, %edi
	jmp	fdwatch_add_fd
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L61
.L58:
	movq	(%rdi), %rax
	movl	$1, %ecx
	movl	$.LC7, %esi
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
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L61:
	.cfi_restore_state
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday
	movq	%rsp, %rdi
	jmp	.L58
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
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
	xorl	%edi, %edi
	movl	(%rax), %ebp
	movq	%rax, %rbx
	call	logstats
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"/tmp"
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
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
	movl	(%rax), %ebp
	movl	watchdog_flag(%rip), %eax
	testl	%eax, %eax
	je	.L70
	movl	$0, watchdog_flag(%rip)
	movl	$360, %edi
	call	alarm
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L70:
	.cfi_restore_state
	movl	$.LC8, %edi
	call	chdir
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC9:
	.string	"child wait - %m"
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movl	(%rax), %r12d
	movq	%rax, %rbx
.L72:
	movl	$1, %edx
	leaq	12(%rsp), %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L73
	js	.L88
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L72
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%ebp, %eax
	movl	%eax, 36(%rdx)
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L88:
	movl	(%rbx), %eax
	cmpl	$4, %eax
	je	.L72
	cmpl	$11, %eax
	je	.L72
	cmpl	$10, %eax
	jne	.L89
.L73:
	movl	%r12d, (%rbx)
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
.L89:
	.cfi_restore_state
	movl	$.LC9, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movl	%r12d, (%rbx)
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"out of memory copying a string"
	.align 8
.LC11:
	.string	"%s: out of memory copying a string\n"
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L93
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L93:
	.cfi_restore_state
	movl	$.LC10, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC11, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC12:
	.string	"r"
.LC13:
	.string	" \t\n\r"
.LC14:
	.string	"debug"
.LC15:
	.string	"port"
.LC16:
	.string	"dir"
.LC17:
	.string	"chroot"
.LC18:
	.string	"nochroot"
.LC19:
	.string	"data_dir"
.LC20:
	.string	"symlink"
.LC21:
	.string	"nosymlink"
.LC22:
	.string	"symlinks"
.LC23:
	.string	"nosymlinks"
.LC24:
	.string	"user"
.LC25:
	.string	"cgipat"
.LC26:
	.string	"cgilimit"
.LC27:
	.string	"urlpat"
.LC28:
	.string	"noemptyreferers"
.LC29:
	.string	"localpat"
.LC30:
	.string	"throttles"
.LC31:
	.string	"host"
.LC32:
	.string	"logfile"
.LC33:
	.string	"vhost"
.LC34:
	.string	"novhost"
.LC35:
	.string	"globalpasswd"
.LC36:
	.string	"noglobalpasswd"
.LC37:
	.string	"pidfile"
.LC38:
	.string	"charset"
.LC39:
	.string	"p3p"
.LC40:
	.string	"max_age"
	.section	.rodata.str1.8
	.align 8
.LC41:
	.string	"%s: unknown config option '%s'\n"
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LFB12:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$.LC12, %esi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	subq	$112, %rsp
	.cfi_def_cfa_offset 160
	call	fopen
	testq	%rax, %rax
	je	.L141
	movabsq	$4294977024, %rbp
	movq	%rax, %r14
.L95:
	movq	%r14, %rdx
	movl	$1000, %esi
	movq	%rsp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L145
	movl	$35, %esi
	movq	%rsp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L96
	movb	$0, (%rax)
.L96:
	movl	$.LC13, %esi
	movq	%rsp, %rdi
	call	strspn
	leaq	(%rsp,%rax), %r12
	cmpb	$0, (%r12)
	je	.L95
	.p2align 4,,10
	.p2align 3
.L97:
	movl	$.LC13, %esi
	movq	%r12, %rdi
	call	strcspn
	leaq	(%r12,%rax), %rbx
	movzbl	(%rbx), %eax
	cmpb	$32, %al
	ja	.L98
	btq	%rax, %rbp
	jnc	.L98
	.p2align 4,,10
	.p2align 3
.L99:
	addq	$1, %rbx
	movzbl	(%rbx), %edx
	movb	$0, -1(%rbx)
	cmpb	$32, %dl
	jbe	.L146
.L98:
	movl	$61, %esi
	movq	%r12, %rdi
	xorl	%r13d, %r13d
	call	strchr
	testq	%rax, %rax
	je	.L100
	movb	$0, (%rax)
	leaq	1(%rax), %r13
.L100:
	movl	$.LC14, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L147
	movl	$.LC15, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L148
	movl	$.LC16, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L149
	movl	$.LC17, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L150
	movl	$.LC18, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L151
	movl	$.LC19, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L152
	movl	$.LC20, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L143
	movl	$.LC21, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L144
	movl	$.LC22, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L143
	movl	$.LC23, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L144
	movl	$.LC24, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L153
	movl	$.LC25, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L154
	movl	$.LC26, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L155
	movl	$.LC27, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L156
	movl	$.LC28, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L157
	movl	$.LC29, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L158
	movl	$.LC30, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L159
	movl	$.LC31, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L160
	movl	$.LC32, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L161
	movl	$.LC33, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L162
	movl	$.LC34, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L163
	movl	$.LC35, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L164
	movl	$.LC36, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L165
	movl	$.LC37, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L166
	movl	$.LC38, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L167
	movl	$.LC39, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L168
	movl	$.LC40, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L128
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L102
	.p2align 4,,10
	.p2align 3
.L146:
	btq	%rdx, %rbp
	jc	.L99
	jmp	.L98
	.p2align 4,,10
	.p2align 3
.L147:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
.L102:
	movl	$.LC13, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %r12
	cmpb	$0, (%r12)
	jne	.L97
	jmp	.L95
.L148:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L102
.L149:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L102
.L150:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L102
.L151:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L102
.L152:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L102
.L143:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L102
.L144:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L102
.L153:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L102
.L145:
	movq	%r14, %rdi
	call	fclose
	addq	$112, %rsp
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
.L154:
	.cfi_restore_state
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L102
.L156:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L102
.L155:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L102
.L158:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L102
.L157:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L102
.L159:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L102
.L161:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L102
.L160:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L102
.L141:
	movq	%rbx, %rdi
	call	perror
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L164:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L102
.L128:
	movq	stderr(%rip), %rdi
	movq	%r12, %rcx
	movl	$.LC41, %esi
	xorl	%eax, %eax
	movq	argv0(%rip), %rdx
	call	fprintf
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L168:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L102
.L167:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L102
.L166:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L102
.L165:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L102
.L163:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L102
.L162:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L102
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata.str1.1
.LC42:
	.string	"nobody"
.LC43:
	.string	"iso-8859-1"
.LC44:
	.string	""
.LC45:
	.string	"-V"
.LC46:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC47:
	.string	"-C"
.LC48:
	.string	"-p"
.LC49:
	.string	"-d"
.LC50:
	.string	"-r"
.LC51:
	.string	"-nor"
.LC52:
	.string	"-dd"
.LC53:
	.string	"-s"
.LC54:
	.string	"-nos"
.LC55:
	.string	"-u"
.LC56:
	.string	"-c"
.LC57:
	.string	"-t"
.LC58:
	.string	"-h"
.LC59:
	.string	"-l"
.LC60:
	.string	"-v"
.LC61:
	.string	"-nov"
.LC62:
	.string	"-g"
.LC63:
	.string	"-nog"
.LC64:
	.string	"-i"
.LC65:
	.string	"-T"
.LC66:
	.string	"-P"
.LC67:
	.string	"-M"
.LC68:
	.string	"-D"
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$80, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movl	%edi, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movw	%ax, port(%rip)
	movl	$0, debug(%rip)
	movq	$0, dir(%rip)
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
	movq	$.LC42, user(%rip)
	movq	$.LC43, charset(%rip)
	movq	$.LC44, p3p(%rip)
	movl	$-1, max_age(%rip)
	cmpl	$1, %edi
	jle	.L200
	movq	8(%rsi), %rbx
	movq	%rsi, %r14
	movl	$1, %ebp
	movl	$.LC45, %r12d
	cmpb	$45, (%rbx)
	je	.L171
	jmp	.L172
	.p2align 4,,10
	.p2align 3
.L217:
	leal	1(%rbp), %r15d
	cmpl	%r13d, %r15d
	jl	.L215
	movl	$.LC48, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	je	.L178
.L177:
	movl	$.LC49, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L178
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L178
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, dir(%rip)
	.p2align 4,,10
	.p2align 3
.L176:
	addl	$1, %ebp
	cmpl	%ebp, %r13d
	jle	.L170
.L218:
	movslq	%ebp, %rax
	movq	(%r14,%rax,8), %rbx
	cmpb	$45, (%rbx)
	jne	.L172
.L171:
	movl	$3, %ecx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	je	.L216
	movl	$.LC47, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	je	.L217
	movl	$.LC48, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L177
	leal	1(%rbp), %r15d
	cmpl	%r13d, %r15d
	jge	.L178
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	addl	$1, %ebp
	call	atoi
	movw	%ax, port(%rip)
	cmpl	%ebp, %r13d
	jg	.L218
	.p2align 4,,10
	.p2align 3
.L170:
	cmpl	%ebp, %r13d
	jne	.L172
	addq	$8, %rsp
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
.L178:
	.cfi_restore_state
	movl	$.LC50, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L179
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L176
	.p2align 4,,10
	.p2align 3
.L179:
	movl	$.LC51, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L180
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L176
	.p2align 4,,10
	.p2align 3
.L215:
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	call	read_config
	jmp	.L176
	.p2align 4,,10
	.p2align 3
.L180:
	movl	$.LC52, %edi
	movl	$4, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L181
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jl	.L219
.L181:
	movl	$.LC53, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L182
	movl	$0, no_symlink_check(%rip)
	jmp	.L176
.L182:
	movl	$.LC54, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L183
	movl	$1, no_symlink_check(%rip)
	jmp	.L176
.L219:
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, data_dir(%rip)
	jmp	.L176
.L183:
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L184
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L184
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, user(%rip)
	jmp	.L176
.L216:
	movl	$.LC46, %edi
	call	puts
	xorl	%edi, %edi
	call	exit
.L184:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L185
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jl	.L220
.L185:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L186
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L187
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, throttlefile(%rip)
	jmp	.L176
.L186:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L188
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L189
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, hostname(%rip)
	jmp	.L176
.L187:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L189
.L188:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L189
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L189
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, logfile(%rip)
	jmp	.L176
.L189:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L221
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L191
	movl	$0, do_vhost(%rip)
	jmp	.L176
.L220:
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L176
.L221:
	movl	$1, do_vhost(%rip)
	jmp	.L176
.L200:
	movl	$1, %ebp
	jmp	.L170
.L191:
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L192
	movl	$1, do_global_passwd(%rip)
	jmp	.L176
.L192:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L193
	movl	$0, do_global_passwd(%rip)
	jmp	.L176
.L193:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L194
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L195
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, pidfile(%rip)
	jmp	.L176
.L194:
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L196
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L195
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, charset(%rip)
	jmp	.L176
.L195:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L198
.L197:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L198
	leal	1(%rbp), %r15d
	cmpl	%r13d, %r15d
	jge	.L198
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L176
.L196:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L197
	leal	1(%rbp), %eax
	cmpl	%r13d, %eax
	jge	.L198
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, p3p(%rip)
	jmp	.L176
.L198:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L172
	movl	$1, debug(%rip)
	jmp	.L176
.L172:
	call	usage
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.1
.LC69:
	.string	"%.80s - %m"
.LC70:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.8
	.align 8
.LC71:
	.string	"unparsable line in %.80s - %.80s"
	.align 8
.LC72:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC73:
	.string	"|/"
	.section	.rodata.str1.8
	.align 8
.LC74:
	.string	"out of memory allocating a throttletab"
	.align 8
.LC75:
	.string	"%s: out of memory allocating a throttletab\n"
	.section	.rodata.str1.1
.LC76:
	.string	" %4900[^ \t] %ld-%ld"
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$.LC12, %esi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10056, %rsp
	.cfi_def_cfa_offset 10112
	call	fopen
	testq	%rax, %rax
	je	.L257
	xorl	%esi, %esi
	leaq	16(%rsp), %rdi
	leaq	32(%rsp), %rbp
	movq	%rax, %r12
	call	gettimeofday
	leaq	5041(%rsp), %r14
	movabsq	$4294977024, %rbx
	.p2align 4,,10
	.p2align 3
.L229:
	movq	%r12, %rdx
	movl	$5000, %esi
	movq	%rbp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L258
	movl	$35, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L225
	movb	$0, (%rax)
.L225:
	movq	%rbp, %rdx
.L226:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L226
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	movl	%eax, %esi
	addb	%al, %sil
	sbbq	$3, %rdx
	subq	%rbp, %rdx
	movslq	%edx, %rax
	je	.L229
	subl	$1, %edx
	movslq	%edx, %rcx
	movzbl	32(%rsp,%rcx), %ecx
	cmpb	$32, %cl
	jbe	.L259
	.p2align 4,,10
	.p2align 3
.L230:
	xorl	%eax, %eax
	movq	%rsp, %r8
	leaq	8(%rsp), %rcx
	movl	$.LC76, %esi
	leaq	5040(%rsp), %rdx
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L234
	xorl	%eax, %eax
	movq	%rsp, %rcx
	leaq	5040(%rsp), %rdx
	movq	%rbp, %rdi
	movl	$.LC70, %esi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L260
	movq	%rbp, %rcx
	movq	%r13, %rdx
	xorl	%eax, %eax
	movl	$.LC71, %esi
	movl	$2, %edi
	call	syslog
	movq	%rbp, %r8
	movq	%r13, %rcx
	movl	$.LC72, %esi
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L229
	.p2align 4,,10
	.p2align 3
.L259:
	btq	%rcx, %rbx
	jnc	.L230
	addq	%rbp, %rax
	movl	%edx, %edx
	movq	%rax, %rcx
	subq	%rdx, %rcx
	.p2align 4,,10
	.p2align 3
.L232:
	movb	$0, -1(%rax)
	cmpq	%rcx, %rax
	je	.L229
	movzbl	-2(%rax), %edx
	cmpb	$32, %dl
	ja	.L230
	subq	$1, %rax
	btq	%rdx, %rbx
	jc	.L232
	jmp	.L230
	.p2align 4,,10
	.p2align 3
.L260:
	movq	$0, 8(%rsp)
.L234:
	cmpb	$47, 5040(%rsp)
	jne	.L237
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L238:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L237:
	movl	$.LC73, %esi
	leaq	5040(%rsp), %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L238
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L239
	testl	%eax, %eax
	jne	.L240
	movl	$100, maxthrottles(%rip)
	movl	$4800, %edi
	call	malloc
	movq	%rax, throttles(%rip)
.L241:
	testq	%rax, %rax
	je	.L242
	movslq	numthrottles(%rip), %rdx
.L243:
	leaq	(%rdx,%rdx,2), %rdx
	leaq	5040(%rsp), %rdi
	salq	$4, %rdx
	leaq	(%rax,%rdx), %r15
	call	e_strdup
	movq	(%rsp), %rcx
	movq	%rax, (%r15)
	movslq	numthrottles(%rip), %rax
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	addl	$1, %edx
	movq	%rcx, 8(%rax)
	movq	8(%rsp), %rcx
	movq	$0, 24(%rax)
	movq	%rcx, 16(%rax)
	movq	$0, 32(%rax)
	movl	$0, 40(%rax)
	movl	%edx, numthrottles(%rip)
	jmp	.L229
.L240:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L241
.L239:
	movq	throttles(%rip), %rax
	jmp	.L243
.L261:
	movq	%r14, %rsi
	leaq	5040(%rsp), %rdi
	call	strcpy
	jmp	.L237
.L258:
	movq	%r12, %rdi
	call	fclose
	addq	$10056, %rsp
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
.L257:
	.cfi_restore_state
	movq	%r13, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r13, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L242:
	movl	$.LC74, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC75, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata.str1.1
.LC77:
	.string	"-"
.LC78:
	.string	"re-opening logfile"
.LC79:
	.string	"a"
.LC80:
	.string	"re-opening %.80s - %m"
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L262
	cmpq	$0, hs(%rip)
	je	.L262
	movq	logfile(%rip), %rsi
	testq	%rsi, %rsi
	je	.L262
	movl	$.LC77, %edi
	movl	$2, %ecx
	repz cmpsb
	seta	%al
	sbbb	$0, %al
	testb	%al, %al
	jne	.L276
.L262:
	ret
	.p2align 4,,10
	.p2align 3
.L276:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC78, %esi
	movl	$5, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	chmod
	testq	%rbx, %rbx
	je	.L266
	testl	%eax, %eax
	jne	.L266
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
.L266:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC80, %esi
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
	.section	.rodata.str1.1
.LC81:
	.string	"too many connections!"
	.section	.rodata.str1.8
	.align 8
.LC82:
	.string	"the connects free list is messed up"
	.align 8
.LC83:
	.string	"out of memory allocating an httpd_conn"
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movabsq	$-4294967295, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movl	%esi, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L286:
	cmpl	%eax, max_connects(%rip)
	jle	.L296
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L280
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L280
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L297
.L282:
	movq	hs(%rip), %rdi
	movl	%ebp, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L284
	cmpl	$2, %eax
	je	.L288
	movl	4(%rbx), %eax
	movq	%r13, (%rbx)
	addl	$1, num_connects(%rip)
	movl	%eax, first_free_connect(%rip)
	movq	(%r12), %rax
	movq	$0, 96(%rbx)
	movq	%rax, 88(%rbx)
	movq	8(%rbx), %rax
	movq	$0, 104(%rbx)
	movl	$0, 56(%rbx)
	movl	704(%rax), %edi
	movq	$0, 136(%rbx)
	call	httpd_set_ndelay
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L286
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L286
	.p2align 4,,10
	.p2align 3
.L288:
	movl	$1, %eax
.L277:
	addq	$24, %rsp
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
.L284:
	.cfi_restore_state
	movq	%r12, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$24, %rsp
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
.L297:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	movq	%rax, %rdx
	movq	%rax, 8(%rbx)
	testq	%rax, %rax
	je	.L298
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	jmp	.L282
	.p2align 4,,10
	.p2align 3
.L296:
	xorl	%eax, %eax
	movl	$.LC81, %esi
	movl	$4, %edi
	call	syslog
	movq	%r12, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L277
.L280:
	movl	$.LC82, %esi
.L295:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L298:
	movl	$.LC83, %esi
	jmp	.L295
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata.str1.8
	.align 8
.LC84:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	movq	$-1, %rax
	movl	$0, 56(%rdi)
	movq	%rax, 72(%rdi)
	movq	%rax, 64(%rdi)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jle	.L323
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	xorl	%ebx, %ebx
	jmp	.L300
	.p2align 4,,10
	.p2align 3
.L306:
	cmpq	%rdi, %rax
	cmovl	%rdi, %rax
	movq	%rax, 72(%rbp)
.L302:
	addl	$1, %r13d
	cmpl	%r13d, numthrottles(%rip)
	jle	.L307
.L324:
	addq	$1, %rbx
	cmpl	$9, 56(%rbp)
	jg	.L307
.L300:
	movq	8(%rbp), %rax
	leaq	(%rbx,%rbx,2), %r12
	movl	%ebx, %r13d
	movl	%ebx, %r14d
	salq	$4, %r12
	movq	240(%rax), %rsi
	movq	throttles(%rip), %rax
	movq	(%rax,%r12), %rdi
	call	match
	testl	%eax, %eax
	je	.L302
	movq	throttles(%rip), %rcx
	addq	%r12, %rcx
	movq	8(%rcx), %rax
	movq	24(%rcx), %rdx
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L310
	movq	16(%rcx), %rdi
	cmpq	%rdi, %rdx
	jl	.L310
	movl	40(%rcx), %esi
	testl	%esi, %esi
	js	.L303
	addl	$1, %esi
	cqto
	movslq	%esi, %r8
	idivq	%r8
.L304:
	movslq	56(%rbp), %rdx
	leal	1(%rdx), %r8d
	movl	%r8d, 56(%rbp)
	movl	%r14d, 16(%rbp,%rdx,4)
	movq	64(%rbp), %rdx
	movl	%esi, 40(%rcx)
	cmpq	$-1, %rdx
	je	.L305
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L305:
	movq	%rax, 64(%rbp)
	movq	72(%rbp), %rax
	cmpq	$-1, %rax
	jne	.L306
	addl	$1, %r13d
	cmpl	%r13d, numthrottles(%rip)
	movq	%rdi, 72(%rbp)
	jg	.L324
.L307:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	$1, %eax
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
.L303:
	.cfi_restore_state
	movl	$.LC84, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	movl	$1, %esi
	addq	%r12, %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdi
	movl	$0, 40(%rcx)
	jmp	.L304
	.p2align 4,,10
	.p2align 3
.L310:
	popq	%rbx
	.cfi_def_cfa_offset 40
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L323:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%esi, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rsp, %rdi
	call	gettimeofday
	movq	%rsp, %rdi
	call	logstats
	movl	max_connects(%rip), %edx
	testl	%edx, %edx
	jg	.L326
	jmp	.L331
	.p2align 4,,10
	.p2align 3
.L329:
	testq	%rdi, %rdi
	je	.L330
	call	httpd_destroy_conn
	movq	connects(%rip), %r12
	addq	%rbx, %r12
	movq	8(%r12), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	movq	$0, 8(%r12)
.L330:
	addl	$1, %ebp
	addq	$144, %rbx
	cmpl	%ebp, max_connects(%rip)
	jle	.L331
.L326:
	movq	connects(%rip), %rax
	addq	%rbx, %rax
	movq	8(%rax), %rdi
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L329
	movq	%rsp, %rsi
	call	httpd_close_conn
	movq	connects(%rip), %rax
	movq	8(%rax,%rbx), %rdi
	jmp	.L329
	.p2align 4,,10
	.p2align 3
.L331:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L328
	movq	$0, hs(%rip)
	movl	72(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L352
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L353
.L333:
	movq	%rbx, %rdi
	call	httpd_terminate
.L328:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L325
	call	free
.L325:
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
.L353:
	.cfi_restore_state
	call	fdwatch_del_fd
	jmp	.L333
	.p2align 4,,10
	.p2align 3
.L352:
	call	fdwatch_del_fd
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	je	.L333
	jmp	.L353
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata.str1.1
.LC85:
	.string	"exiting"
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L359
	movl	$1, got_usr1(%rip)
	ret
	.p2align 4,,10
	.p2align 3
.L359:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata.str1.1
.LC86:
	.string	"exiting due to signal %d"
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
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
	movl	$.LC86, %esi
	call	syslog
	call	closelog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB36:
	.cfi_startproc
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L362
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	leaq	16(%rdi), %rdx
	leaq	20(%rdi,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L364:
	movslq	(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	subl	$1, 40(%rcx,%rax)
	cmpq	%rsi, %rdx
	jne	.L364
.L362:
	ret
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	cmpl	$3, (%rbx)
	je	.L367
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	8(%rbx), %rdi
	movq	8(%rsp), %rsi
.L367:
	call	httpd_close_conn
	movq	%rbx, %rdi
	call	clear_throttles.isra.0
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L368
	call	tmr_cancel
	movq	$0, 104(%rbx)
.L368:
	movl	first_free_connect(%rip), %eax
	movl	$0, (%rbx)
	subl	$1, num_connects(%rip)
	movl	%eax, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC87:
	.string	"replacing non-null linger_timer!"
	.align 8
.LC88:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	96(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L374
	call	tmr_cancel
	movq	$0, 96(%rbx)
.L374:
	movl	(%rbx), %eax
	cmpl	$4, %eax
	je	.L387
	movq	8(%rbx), %rdx
	movl	556(%rdx), %ecx
	testl	%ecx, %ecx
	je	.L376
	movl	704(%rdx), %edi
	cmpl	$3, %eax
	jne	.L388
.L377:
	movl	$4, (%rbx)
	movl	$1, %esi
	call	shutdown
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	cmpq	$0, 104(%rbx)
	je	.L378
	movl	$.LC87, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L378:
	xorl	%r8d, %r8d
	movl	$500, %ecx
	movq	%rbx, %rdx
	movl	$linger_clear_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	movq	%rax, 104(%rbx)
	testq	%rax, %rax
	je	.L389
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L388:
	.cfi_restore_state
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
	movl	704(%rax), %edi
	jmp	.L377
	.p2align 4,,10
	.p2align 3
.L387:
	movq	104(%rbx), %rdi
	call	tmr_cancel
	movq	8(%rbx), %rax
	movq	$0, 104(%rbx)
	movl	$0, 556(%rax)
.L376:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L389:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC88, %esi
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbx
	movq	160(%rbx), %rsi
	movq	152(%rbx), %rdx
	cmpq	%rdx, %rsi
	jb	.L393
	cmpq	$5000, %rdx
	ja	.L417
	addq	$1000, %rdx
	leaq	152(%rbx), %rsi
	leaq	144(%rbx), %rdi
	call	httpd_realloc_str
	movq	152(%rbx), %rdx
	movq	160(%rbx), %rsi
.L393:
	movl	704(%rbx), %edi
	subq	%rsi, %rdx
	addq	144(%rbx), %rsi
	call	read
	testl	%eax, %eax
	je	.L417
	jns	.L396
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L392
	cmpl	$11, %eax
	jne	.L417
.L392:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L396:
	.cfi_restore_state
	cltq
	addq	%rax, 160(%rbx)
	movq	(%r12), %rax
	movq	%rbx, %rdi
	movq	%rax, 88(%rbp)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L392
	cmpl	$2, %eax
	jne	.L398
.L417:
	movl	$.LC44, %r9d
	movq	httpd_err400form(%rip), %r8
	movl	$400, %esi
	movq	%rbx, %rdi
	movq	httpd_err400title(%rip), %rdx
	movq	%r9, %rcx
	call	httpd_send_err
.L416:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L398:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L416
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L418
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L416
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L402
	movq	536(%rbx), %rax
	movq	%rax, 136(%rbp)
	movq	544(%rbx), %rax
	addq	$1, %rax
	movq	%rax, 128(%rbp)
.L403:
	cmpq	$0, 712(%rbx)
	je	.L419
	movq	128(%rbp), %rax
	cmpq	%rax, 136(%rbp)
	jge	.L416
	movq	(%r12), %rax
	movl	$2, 0(%rbp)
	movq	$0, 112(%rbp)
	movl	704(%rbx), %edi
	movq	%rax, 80(%rbp)
	call	fdwatch_del_fd
	movl	704(%rbx), %edi
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movl	$1, %edx
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L418:
	.cfi_restore_state
	movq	208(%rbx), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC44, %ecx
	movq	%rbx, %rdi
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	call	httpd_send_err
	jmp	.L416
	.p2align 4,,10
	.p2align 3
.L402:
	movq	192(%rbx), %rax
	movl	$0, %edx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	movq	%rax, 128(%rbp)
	jmp	.L403
.L419:
	movl	56(%rbp), %eax
	movq	200(%rbx), %rsi
	testl	%eax, %eax
	jle	.L408
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	leaq	16(%rbp), %rdx
	leaq	20(%rbp,%rax,4), %rdi
	.p2align 4,,10
	.p2align 3
.L407:
	movslq	(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rsi, 32(%rcx,%rax)
	cmpq	%rdx, %rdi
	jne	.L407
.L408:
	movq	%rsi, 136(%rbp)
	jmp	.L416
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.8
	.align 8
.LC89:
	.string	"%.80s connection timed out reading"
	.align 8
.LC90:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L429
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	jmp	.L425
	.p2align 4,,10
	.p2align 3
.L434:
	testl	%eax, %eax
	jle	.L423
	cmpl	$3, %eax
	jg	.L423
	movq	(%r12), %rax
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L432
	.p2align 4,,10
	.p2align 3
.L423:
	addq	$1, %rbp
	cmpl	%ebp, max_connects(%rip)
	jle	.L433
.L425:
	leaq	0(%rbp,%rbp,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L434
	movq	(%r12), %rax
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L423
	movq	8(%rbx), %rax
	addq	$1, %rbp
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC89, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movl	$.LC44, %r9d
	movq	8(%rbx), %rdi
	movq	httpd_err408form(%rip), %r8
	movq	httpd_err408title(%rip), %rdx
	movq	%r9, %rcx
	movl	$408, %esi
	call	httpd_send_err
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	cmpl	%ebp, max_connects(%rip)
	jg	.L425
.L433:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L432:
	.cfi_restore_state
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC90, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L423
	.p2align 4,,10
	.p2align 3
.L429:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC91:
	.string	"replacing non-null wakeup_timer!"
	.align 8
.LC92:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC93:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$1000000000, %eax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	64(%rdi), %rcx
	movq	8(%rdi), %r12
	cmpq	$-1, %rcx
	je	.L436
	testq	%rcx, %rcx
	leaq	3(%rcx), %rdx
	cmovns	%rcx, %rdx
	movq	%rdx, %rax
	sarq	$2, %rax
.L436:
	movq	136(%rbx), %rdx
	movq	128(%rbx), %rdi
	movq	712(%r12), %rsi
	movq	472(%r12), %rcx
	subq	%rdx, %rdi
	addq	%rdx, %rsi
	movq	%rdi, %rdx
	cmpq	%rax, %rdi
	movl	704(%r12), %edi
	cmova	%rax, %rdx
	testq	%rcx, %rcx
	jne	.L437
	call	write
	testl	%eax, %eax
	js	.L489
.L439:
	jne	.L490
.L458:
	addq	$100, 112(%rbx)
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	cmpq	$0, 96(%rbx)
	je	.L442
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L442:
	movq	112(%rbx), %rcx
.L488:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$wakeup_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	movq	%rax, 96(%rbx)
	testq	%rax, %rax
	je	.L491
.L435:
	addq	$40, %rsp
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
.L437:
	.cfi_restore_state
	movq	368(%r12), %rax
	movq	%rsi, 16(%rsp)
	movq	%rsp, %rsi
	movq	%rdx, 24(%rsp)
	movl	$2, %edx
	movq	%rax, (%rsp)
	movq	%rcx, 8(%rsp)
	call	writev
	testl	%eax, %eax
	jns	.L439
.L489:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L435
	cmpl	$11, %eax
	je	.L458
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L443
	cmpl	$104, %eax
	je	.L443
	movq	208(%r12), %rdx
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L443:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	addq	$40, %rsp
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
.L490:
	.cfi_restore_state
	movq	0(%rbp), %rdx
	movslq	%eax, %rsi
	movq	%rdx, 88(%rbx)
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	jne	.L445
.L446:
	movq	8(%rbx), %rdx
	movq	136(%rbx), %r9
	movq	200(%rdx), %rax
	addq	%rsi, %r9
	movq	%r9, 136(%rbx)
	addq	%rsi, %rax
	movq	%rax, 200(%rdx)
	movl	56(%rbx), %edx
	testl	%edx, %edx
	jle	.L452
	subl	$1, %edx
	movq	throttles(%rip), %rdi
	leaq	16(%rbx), %rcx
	leaq	20(%rbx,%rdx,4), %r8
	.p2align 4,,10
	.p2align 3
.L451:
	movslq	(%rcx), %rdx
	addq	$4, %rcx
	leaq	(%rdx,%rdx,2), %rdx
	salq	$4, %rdx
	addq	%rsi, 32(%rdi,%rdx)
	cmpq	%rcx, %r8
	jne	.L451
.L452:
	cmpq	128(%rbx), %r9
	jge	.L492
	movq	112(%rbx), %rdx
	cmpq	$100, %rdx
	jg	.L493
.L453:
	movq	64(%rbx), %rcx
	cmpq	$-1, %rcx
	je	.L435
	movq	0(%rbp), %rdx
	subq	80(%rbx), %rdx
	movq	%rdx, %r13
	je	.L461
	cqto
	idivq	%r13
.L454:
	cmpq	%rax, %rcx
	jge	.L435
	movl	$3, (%rbx)
	movl	704(%r12), %edi
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
	movq	200(%rax), %rax
	cqto
	idivq	64(%rbx)
	movl	%eax, %r12d
	subl	%r13d, %r12d
	cmpq	$0, 96(%rbx)
	je	.L455
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L455:
	movl	$500, %ecx
	testl	%r12d, %r12d
	jle	.L488
	movslq	%r12d, %r12
	imulq	$1000, %r12, %rcx
	jmp	.L488
	.p2align 4,,10
	.p2align 3
.L445:
	cmpq	%rsi, %rdx
	ja	.L494
	movq	$0, 472(%r12)
	subl	%edx, %eax
	movslq	%eax, %rsi
	jmp	.L446
	.p2align 4,,10
	.p2align 3
.L493:
	subq	$100, %rdx
	movq	%rdx, 112(%rbx)
	jmp	.L453
	.p2align 4,,10
	.p2align 3
.L461:
	movl	$1, %r13d
	jmp	.L454
	.p2align 4,,10
	.p2align 3
.L492:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L494:
	subl	%eax, %edx
	movq	368(%r12), %rdi
	movslq	%edx, %r13
	addq	%rdi, %rsi
	movq	%r13, %rdx
	call	memmove
	movq	%r13, 472(%r12)
	xorl	%esi, %esi
	jmp	.L446
.L491:
	movl	$2, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movq	$0, 104(%rdi)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$4096, %edx
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$4104, %rsp
	.cfi_def_cfa_offset 4128
	movq	8(%rdi), %rax
	movq	%rsp, %rsi
	movl	704(%rax), %edi
	call	read
	testl	%eax, %eax
	js	.L505
	je	.L498
.L496:
	addq	$4104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L505:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L496
	cmpl	$11, %eax
	je	.L496
.L498:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	really_clear_connection
	addq	$4104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC94:
	.string	"%d"
.LC95:
	.string	"getaddrinfo %.80s - %.80s"
.LC96:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	movq	%rdx, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	$.LC94, %edx
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	movl	$10, %esi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movzwl	port(%rip), %ecx
	leaq	22(%rsp), %rdi
	movups	%xmm0, 36(%rsp)
	movups	%xmm0, 52(%rsp)
	movq	$0, 68(%rsp)
	movl	$0, 76(%rsp)
	movl	$1, 32(%rsp)
	movl	$1, 40(%rsp)
	call	snprintf
	leaq	8(%rsp), %rcx
	leaq	32(%rsp), %rdx
	movq	hostname(%rip), %rdi
	leaq	22(%rsp), %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L523
	movq	8(%rsp), %r14
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	movq	%r14, %rax
	testq	%r14, %r14
	jne	.L508
	jmp	.L524
	.p2align 4,,10
	.p2align 3
.L526:
	cmpl	$10, %edx
	jne	.L511
	testq	%rsi, %rsi
	cmove	%rax, %rsi
.L511:
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L525
.L508:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L526
	testq	%r13, %r13
	cmove	%rax, %r13
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L508
.L525:
	testq	%rsi, %rsi
	je	.L527
	movl	16(%rsi), %r8d
	cmpq	$128, %r8
	ja	.L522
	movl	$16, %ecx
	movq	%r15, %rdi
	rep stosq
	movq	%r15, %rdi
	movl	16(%rsi), %edx
	movq	24(%rsi), %rsi
	call	memmove
	movl	$1, (%r12)
.L513:
	testq	%r13, %r13
	je	.L509
	movl	16(%r13), %r8d
	cmpq	$128, %r8
	ja	.L522
	xorl	%eax, %eax
	movl	$16, %ecx
	movq	%rbx, %rdi
	rep stosq
	movq	%rbx, %rdi
	movl	16(%r13), %edx
	movq	24(%r13), %rsi
	call	memmove
	movl	$1, 0(%rbp)
.L516:
	movq	%r14, %rdi
	call	freeaddrinfo
	addq	$88, %rsp
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
.L524:
	.cfi_restore_state
	movl	$0, (%r12)
.L509:
	movl	$0, 0(%rbp)
	jmp	.L516
.L527:
	movl	$0, (%r12)
	jmp	.L513
.L522:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$.LC97, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L523:
	movl	%eax, %edi
	movl	%eax, %r13d
	call	gai_strerror
	movl	$.LC95, %esi
	movl	$2, %edi
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	syslog
	movl	%r13d, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movl	$.LC96, %esi
	movq	hostname(%rip), %rcx
	movq	argv0(%rip), %rdx
	movq	%rax, %r8
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.1
.LC98:
	.string	"can't find any valid address"
	.section	.rodata.str1.8
	.align 8
.LC99:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC100:
	.string	"unknown user - '%.80s'"
.LC101:
	.string	"%s: unknown user - '%s'\n"
.LC102:
	.string	"/dev/null"
	.section	.rodata.str1.8
	.align 8
.LC103:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 8
.LC104:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC105:
	.string	"fchown logfile - %m"
.LC106:
	.string	"fchown logfile"
.LC107:
	.string	"chdir - %m"
.LC108:
	.string	"chdir"
.LC109:
	.string	"daemon - %m"
.LC110:
	.string	"w"
.LC111:
	.string	"%d\n"
	.section	.rodata.str1.8
	.align 8
.LC112:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC113:
	.string	"chroot - %m"
	.section	.rodata.str1.8
	.align 8
.LC114:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 8
.LC115:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC116:
	.string	"chroot chdir - %m"
.LC117:
	.string	"chroot chdir"
.LC118:
	.string	"data_dir chdir - %m"
.LC119:
	.string	"data_dir chdir"
.LC120:
	.string	"tmr_create(occasional) failed"
.LC121:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC123:
	.string	"tmr_create(show_stats) failed"
.LC124:
	.string	"setgroups - %m"
.LC125:
	.string	"setgid - %m"
.LC126:
	.string	"initgroups - %m"
.LC127:
	.string	"setuid - %m"
	.section	.rodata.str1.8
	.align 8
.LC128:
	.string	"started as root without requesting chroot(), warning only"
	.align 8
.LC129:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC130:
	.string	"fdwatch - %m"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB9:
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
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4424, %rsp
	.cfi_def_cfa_offset 4480
	movq	(%rsi), %rbx
	movl	$47, %esi
	movq	%rbx, %rdi
	movq	%rbx, argv0(%rip)
	call	strrchr
	movl	$9, %esi
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	cmovne	%rdx, %rbx
	movl	$24, %edx
	movq	%rbx, %rdi
	leaq	176(%rsp), %rbx
	call	openlog
	movl	%r12d, %edi
	movq	%rbp, %rsi
	leaq	48(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	28(%rsp), %rcx
	movq	%rbx, %rdx
	movq	%r12, %rdi
	leaq	24(%rsp), %rsi
	call	lookup_hostname.constprop.1
	movl	24(%rsp), %eax
	orl	28(%rsp), %eax
	je	.L657
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L531
	call	read_throttlefile
.L531:
	call	getuid
	movl	$32767, %r14d
	movl	$32767, %r15d
	testl	%eax, %eax
	je	.L658
.L532:
	movq	logfile(%rip), %rbp
	testq	%rbp, %rbp
	je	.L598
	movl	$.LC102, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L535
	movl	$1, no_log(%rip)
	xorl	%r13d, %r13d
.L534:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L540
	call	chdir
	testl	%eax, %eax
	js	.L659
.L540:
	leaq	304(%rsp), %rbp
	movl	$4096, %esi
	movq	%rbp, %rdi
	call	getcwd
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdi
	repnz scasb
	movq	%rcx, %rdx
	notq	%rdx
	movq	%rdx, %rcx
	subq	$1, %rcx
	cmpb	$47, 303(%rsp,%rcx)
	je	.L541
	movw	$47, 0(%rbp,%rcx)
.L541:
	cmpl	$0, debug(%rip)
	jne	.L542
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%r13, %rdi
	je	.L543
	call	fclose
.L543:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	movl	$.LC109, %esi
	testl	%eax, %eax
	js	.L655
.L544:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L545
	movl	$.LC110, %esi
	call	fopen
	testq	%rax, %rax
	je	.L660
	movq	%rax, (%rsp)
	call	getpid
	movq	(%rsp), %rcx
	movl	$.LC111, %esi
	movl	%eax, %edx
	xorl	%eax, %eax
	movq	%rcx, %rdi
	call	fprintf
	movq	(%rsp), %rcx
	movq	%rcx, %rdi
	call	fclose
.L545:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects(%rip)
	testl	%eax, %eax
	js	.L661
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L662
.L548:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L552
	call	chdir
	testl	%eax, %eax
	js	.L663
.L552:
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
	movl	no_empty_referers(%rip), %eax
	xorl	%esi, %esi
	movq	%rbx, %rdx
	cmpl	$0, 28(%rsp)
	movzwl	port(%rip), %ecx
	cmove	%rsi, %rdx
	cmpl	$0, 24(%rsp)
	pushq	%rax
	.cfi_def_cfa_offset 4488
	movl	do_global_passwd(%rip), %eax
	pushq	local_pattern(%rip)
	.cfi_def_cfa_offset 4496
	cmovne	%r12, %rsi
	movl	cgi_limit(%rip), %r9d
	pushq	url_pattern(%rip)
	.cfi_def_cfa_offset 4504
	movq	cgi_pattern(%rip), %r8
	pushq	%rax
	.cfi_def_cfa_offset 4512
	movl	do_vhost(%rip), %eax
	movq	hostname(%rip), %rdi
	pushq	%rax
	.cfi_def_cfa_offset 4520
	movl	no_symlink_check(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 4528
	movl	no_log(%rip), %eax
	pushq	%r13
	.cfi_def_cfa_offset 4536
	pushq	%rax
	.cfi_def_cfa_offset 4544
	movl	max_age(%rip), %eax
	pushq	%rbp
	.cfi_def_cfa_offset 4552
	pushq	%rax
	.cfi_def_cfa_offset 4560
	pushq	p3p(%rip)
	.cfi_def_cfa_offset 4568
	pushq	charset(%rip)
	.cfi_def_cfa_offset 4576
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4480
	movq	%rax, hs(%rip)
	testq	%rax, %rax
	je	.L656
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	movl	$occasional, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L664
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L665
	cmpl	$0, numthrottles(%rip)
	jle	.L558
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	movl	$update_throttles, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L666
.L558:
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	movl	$show_stats, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L667
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	jne	.L561
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	movl	$.LC124, %esi
	testl	%eax, %eax
	js	.L655
	movl	%r14d, %edi
	call	setgid
	movl	$.LC125, %esi
	testl	%eax, %eax
	js	.L655
	movq	user(%rip), %rdi
	movl	%r14d, %esi
	call	initgroups
	testl	%eax, %eax
	js	.L668
.L564:
	movl	%r15d, %edi
	call	setuid
	movl	$.LC127, %esi
	testl	%eax, %eax
	js	.L655
	cmpl	$0, do_chroot(%rip)
	jne	.L561
	movl	$.LC128, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
.L561:
	movslq	max_connects(%rip), %rbp
	movq	%rbp, %rbx
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	movq	%rax, connects(%rip)
	testq	%rax, %rax
	je	.L567
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L568
.L569:
	addl	$1, %ecx
	movl	$0, (%rdx)
	addq	$144, %rdx
	movl	%ecx, -140(%rdx)
	movq	$0, -136(%rdx)
.L568:
	cmpl	%ecx, %ebx
	jg	.L569
	movl	$-1, -140(%rax,%rbp)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L571
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L572
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L572:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L571
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L571:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
.L574:
	cmpl	$0, terminate(%rip)
	je	.L596
	cmpl	$0, num_connects(%rip)
	jle	.L669
.L596:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L670
.L575:
	leaq	32(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	movl	%eax, %ebx
	testl	%eax, %eax
	jns	.L576
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L574
	cmpl	$11, %eax
	je	.L574
	movl	$3, %edi
	movl	$.LC130, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L535:
	movl	$.LC77, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L536
	movq	stdout(%rip), %r13
	jmp	.L534
.L661:
	movl	$.LC112, %esi
.L655:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
.L656:
	movl	$1, %edi
	call	exit
.L542:
	call	setsid
	jmp	.L544
.L658:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L671
	movl	16(%rax), %r15d
	movl	20(%rax), %r14d
	jmp	.L532
.L598:
	xorl	%r13d, %r13d
	jmp	.L534
.L536:
	movq	%rbp, %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %r13
	movq	%rbp, %rdi
	call	chmod
	testq	%r13, %r13
	je	.L601
	testl	%eax, %eax
	jne	.L601
	cmpb	$47, 0(%rbp)
	jne	.L672
.L539:
	movq	%r13, %rdi
	call	fileno
	movl	$1, %edx
	movl	$2, %esi
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L534
	movq	%r13, %rdi
	call	fileno
	movl	%r14d, %edx
	movl	%r15d, %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L534
	movl	$.LC105, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC106, %edi
	call	perror
	jmp	.L534
.L657:
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC99, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
.L659:
	movl	$.LC107, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC108, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L660:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC69, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L662:
	movq	%rbp, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L673
	movq	logfile(%rip), %r8
	testq	%r8, %r8
	je	.L550
	movl	$.LC77, %esi
	movq	%r8, %rdi
	movq	%r8, (%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L550
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movq	(%rsp), %r8
	repnz scasb
	movq	%rbp, %rsi
	movq	%r8, %rdi
	movq	%rcx, %rdx
	notq	%rdx
	movq	%rdx, %rcx
	leaq	-1(%rdx), %rdx
	movq	%rcx, 8(%rsp)
	call	strncmp
	testl	%eax, %eax
	jne	.L551
	movq	(%rsp), %r8
	movq	8(%rsp), %rcx
	movq	%r8, %rdi
	leaq	-2(%r8,%rcx), %rsi
	call	strcpy
.L550:
	movw	$47, 304(%rsp)
	movq	%rbp, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L548
	movl	$.LC116, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC117, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L663:
	movl	$.LC118, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC119, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L672:
	xorl	%eax, %eax
	movl	$.LC103, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC104, %esi
	call	fprintf
	jmp	.L539
.L666:
	movl	$2, %edi
	movl	$.LC122, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L671:
	movq	user(%rip), %rdx
	movl	$.LC100, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movl	$.LC101, %esi
	xorl	%eax, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	call	fprintf
	movl	$1, %edi
	call	exit
.L664:
	movl	$2, %edi
	movl	$.LC120, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L576:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L674
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L588
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L583
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L584
.L587:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L588
.L583:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L588
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L588
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	72(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L574
.L588:
	call	fdwatch_get_next_client_data
	movq	%rax, %rbx
	cmpq	$-1, %rax
	je	.L675
	testq	%rbx, %rbx
	je	.L588
	movq	8(%rbx), %rax
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L676
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L591
	cmpl	$4, %eax
	je	.L592
	subl	$1, %eax
	jne	.L588
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L588
.L676:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L588
.L670:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L575
.L601:
	movq	%rbp, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L673:
	movl	$.LC113, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC17, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L667:
	movl	$2, %edi
	movl	$.LC123, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L675:
	leaq	32(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L574
	cmpl	$0, terminate(%rip)
	jne	.L574
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L574
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L594
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L594:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L595
	call	fdwatch_del_fd
.L595:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L574
.L592:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L588
.L591:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L588
.L665:
	movl	$2, %edi
	movl	$.LC121, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L551:
	xorl	%eax, %eax
	movl	$.LC114, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC115, %esi
	call	fprintf
	jmp	.L550
.L674:
	leaq	32(%rsp), %rdi
	call	tmr_run
	jmp	.L574
.L567:
	movl	$.LC129, %esi
	jmp	.L655
.L584:
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	76(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L587
	jmp	.L574
.L669:
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
.L668:
	movl	$.LC126, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L564
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,8,8
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,8,8
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,8,8
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,8,8
	.local	charset
	.comm	charset,8,8
	.local	user
	.comm	user,8,8
	.local	pidfile
	.comm	pidfile,8,8
	.local	hostname
	.comm	hostname,8,8
	.local	throttlefile
	.comm	throttlefile,8,8
	.local	logfile
	.comm	logfile,8,8
	.local	local_pattern
	.comm	local_pattern,8,8
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,8,8
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,8,8
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,8,8
	.local	dir
	.comm	dir,8,8
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,8,8
	.ident	"GCC: (GNU) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
