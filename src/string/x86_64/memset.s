# 1 "src/string/x86_64/memset.S"
# 1 "<built-in>" 1
# 1 "src/string/x86_64/memset.S" 2
# 26 "src/string/x86_64/memset.S"
# 1 "src/string/x86_64/cache.h" 1
# 27 "src/string/x86_64/memset.S" 2
# 77 "src/string/x86_64/memset.S"
.section .data
.align 16
.global __has_avx
__has_avx: .long 0

 .section .text.avx2,"ax",@progbits
# 95 "src/string/x86_64/memset.S"
.type memset_avx2, @function; .globl memset_avx2; .p2align 4; memset_avx2: .cfi_startproc

 movq __has_avx@GOTPCREL(%rip), %rax
 movl (%rax), %eax
 cmp $0, %eax
 je memset_sse2

 movq %rdi, %rax
 and $0xff, %rsi
 mov $0x0101010101010101, %rcx
 imul %rsi, %rcx
 cmpq $16, %rdx
 jae .L16bytesormore
 testb $8, %dl
 jnz .L8_15bytes
 testb $4, %dl
 jnz .L4_7bytes
 testb $2, %dl
 jnz .L2_3bytes
 testb $1, %dl
 jz .Lreturn
 movb %cl, (%rdi)
.Lreturn:
 ret

.L8_15bytes:
 movq %rcx, (%rdi)
 movq %rcx, -8(%rdi, %rdx)
 ret

.L4_7bytes:
 movl %ecx, (%rdi)
 movl %ecx, -4(%rdi, %rdx)
 ret

.L2_3bytes:
 movw %cx, (%rdi)
 movw %cx, -2(%rdi, %rdx)
 ret

 .p2align 4
.L16bytesormore:
 movd %rcx, %xmm0
 pshufd $0, %xmm0, %xmm0
 movdqu %xmm0, (%rdi)
 movdqu %xmm0, -16(%rdi, %rdx)
 cmpq $32, %rdx
 jbe .L32bytesless
 movdqu %xmm0, 16(%rdi)
 movdqu %xmm0, -32(%rdi, %rdx)
 cmpq $64, %rdx
 jbe .L64bytesless
 movdqu %xmm0, 32(%rdi)
 movdqu %xmm0, 48(%rdi)
 movdqu %xmm0, -64(%rdi, %rdx)
 movdqu %xmm0, -48(%rdi, %rdx)
 cmpq $128, %rdx
 jbe .L128bytesless
        vpbroadcastb %xmm0, %ymm0
 vmovdqu %ymm0, 64(%rdi)
 vmovdqu %ymm0, 96(%rdi)
 vmovdqu %ymm0, -128(%rdi, %rdx)
 vmovdqu %ymm0, -96(%rdi, %rdx)
 cmpq $256, %rdx
        ja .L256bytesmore
.L32bytesless:
.L64bytesless:
.L128bytesless:
 ret

 .p2align 4
.L256bytesmore:
 leaq 128(%rdi), %rcx
 andq $-128, %rcx
 movq %rdx, %r8
 addq %rdi, %rdx
 andq $-128, %rdx
 cmpq %rcx, %rdx
 je .Lreturn


 cmp $(4096*1024), %r8



 ja .L256bytesmore_nt

 .p2align 4
.L256bytesmore_normal:
 vmovdqa %ymm0, (%rcx)
 vmovdqa %ymm0, 32(%rcx)
 vmovdqa %ymm0, 64(%rcx)
 vmovdqa %ymm0, 96(%rcx)
 addq $128, %rcx
 cmpq %rcx, %rdx
 jne .L256bytesmore_normal
 ret

 .p2align 4
.L256bytesmore_nt:
 movntdq %xmm0, (%rcx)
 movntdq %xmm0, 16(%rcx)
 movntdq %xmm0, 32(%rcx)
 movntdq %xmm0, 48(%rcx)
 movntdq %xmm0, 64(%rcx)
 movntdq %xmm0, 80(%rcx)
 movntdq %xmm0, 96(%rcx)
 movntdq %xmm0, 112(%rcx)
 leaq 128(%rcx), %rcx
 cmpq %rcx, %rdx
 jne .L256bytesmore_nt
 sfence
 ret

.cfi_endproc; .size memset_avx2, .-memset_avx2

.globl memset; .equ memset, memset_avx2




.type memset_sse2, @function; .globl memset_sse2; .p2align 4; memset_sse2: .cfi_startproc
 movq %rdi, %rax
 and $0xff, %rsi
 mov $0x0101010101010101, %rcx
 imul %rsi, %rcx
 cmpq $16, %rdx
 jae .Lsse216bytesormore
 testb $8, %dl
 jnz .Lsse28_15bytes
 testb $4, %dl
 jnz .Lsse24_7bytes
 testb $2, %dl
 jnz .Lsse22_3bytes
 testb $1, %dl
 jz .Lsse2return
 movb %cl, (%rdi)
.Lsse2return:
 ret

.Lsse28_15bytes:
 movq %rcx, (%rdi)
 movq %rcx, -8(%rdi, %rdx)
 ret

.Lsse24_7bytes:
 movl %ecx, (%rdi)
 movl %ecx, -4(%rdi, %rdx)
 ret

.Lsse22_3bytes:
 movw %cx, (%rdi)
 movw %cx, -2(%rdi, %rdx)
 ret

 .p2align 4
.Lsse216bytesormore:
 movd %rcx, %xmm0
 pshufd $0, %xmm0, %xmm0
 movdqu %xmm0, (%rdi)
 movdqu %xmm0, -16(%rdi, %rdx)
 cmpq $32, %rdx
 jbe .Lsse232bytesless
 movdqu %xmm0, 16(%rdi)
 movdqu %xmm0, -32(%rdi, %rdx)
 cmpq $64, %rdx
 jbe .Lsse264bytesless
 movdqu %xmm0, 32(%rdi)
 movdqu %xmm0, 48(%rdi)
 movdqu %xmm0, -64(%rdi, %rdx)
 movdqu %xmm0, -48(%rdi, %rdx)
 cmpq $128, %rdx
 ja .Lsse2128bytesmore
.Lsse232bytesless:
.Lsse264bytesless:
 ret

 .p2align 4
.Lsse2128bytesmore:
 leaq 64(%rdi), %rcx
 andq $-64, %rcx
 movq %rdx, %r8
 addq %rdi, %rdx
 andq $-64, %rdx
 cmpq %rcx, %rdx
 je .Lsse2return


 cmp $(4096*1024), %r8



 ja .Lsse2128bytesmore_nt

 .p2align 4
.Lsse2128bytesmore_normal:
 movdqa %xmm0, (%rcx)
 movaps %xmm0, 0x10(%rcx)
 movaps %xmm0, 0x20(%rcx)
 movaps %xmm0, 0x30(%rcx)
 addq $64, %rcx
 cmpq %rcx, %rdx
 jne .Lsse2128bytesmore_normal
 ret

 .p2align 4
.Lsse2128bytesmore_nt:
 movntdq %xmm0, (%rcx)
 movntdq %xmm0, 0x10(%rcx)
 movntdq %xmm0, 0x20(%rcx)
 movntdq %xmm0, 0x30(%rcx)
 leaq 64(%rcx), %rcx
 cmpq %rcx, %rdx
 jne .Lsse2128bytesmore_nt
 sfence
 ret

.cfi_endproc; .size memset_sse2, .-memset_sse2
