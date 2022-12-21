# 1 "src/string/x86_64/memmove.S"
# 1 "<built-in>" 1
# 1 "src/string/x86_64/memmove.S" 2
# 26 "src/string/x86_64/memmove.S"
# 1 "src/string/x86_64/cache.h" 1
# 27 "src/string/x86_64/memmove.S" 2
# 92 "src/string/x86_64/memmove.S"
 .section .text.sse2,"ax",@progbits
.type memmove, @function; .globl memmove; .p2align 4; memmove: .cfi_startproc
 push %rbx;;
 mov %rdi, %rax


 cmp %rsi, %rdi
 je .Lmm_return
 jg .Lmm_len_0_or_more_backward



 cmp $16, %rdx
 jbe .Lmm_len_0_16_bytes_forward

 cmp $32, %rdx
 ja .Lmm_len_32_or_more_forward


 movdqu (%rsi), %xmm0
 movdqu -16(%rsi, %rdx), %xmm1
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, -16(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_32_or_more_forward:
 cmp $64, %rdx
 ja .Lmm_len_64_or_more_forward


 movdqu (%rsi), %xmm0
 movdqu 16(%rsi), %xmm1
 movdqu -16(%rsi, %rdx), %xmm2
 movdqu -32(%rsi, %rdx), %xmm3
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, 16(%rdi)
 movdqu %xmm2, -16(%rdi, %rdx)
 movdqu %xmm3, -32(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_64_or_more_forward:
 cmp $128, %rdx
 ja .Lmm_len_128_or_more_forward


 movdqu (%rsi), %xmm0
 movdqu 16(%rsi), %xmm1
 movdqu 32(%rsi), %xmm2
 movdqu 48(%rsi), %xmm3
 movdqu -64(%rsi, %rdx), %xmm4
 movdqu -48(%rsi, %rdx), %xmm5
 movdqu -32(%rsi, %rdx), %xmm6
 movdqu -16(%rsi, %rdx), %xmm7
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, 16(%rdi)
 movdqu %xmm2, 32(%rdi)
 movdqu %xmm3, 48(%rdi)
 movdqu %xmm4, -64(%rdi, %rdx)
 movdqu %xmm5, -48(%rdi, %rdx)
 movdqu %xmm6, -32(%rdi, %rdx)
 movdqu %xmm7, -16(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_128_or_more_forward:


 movdqu (%rsi), %xmm0
 movdqu 16(%rsi), %xmm1
 movdqu 32(%rsi), %xmm2
 movdqu 48(%rsi), %xmm3

 lea 64(%rdi), %r8
 and $-64, %r8
 sub %rdi, %rsi

 movdqu (%r8, %rsi), %xmm4
 movdqu 16(%r8, %rsi), %xmm5
 movdqu 32(%r8, %rsi), %xmm6
 movdqu 48(%r8, %rsi), %xmm7

 movdqu %xmm0, (%rdi)
 movdqu %xmm1, 16(%rdi)
 movdqu %xmm2, 32(%rdi)
 movdqu %xmm3, 48(%rdi)
 movdqa %xmm4, (%r8)
 movaps %xmm5, 16(%r8)
 movaps %xmm6, 32(%r8)
 movaps %xmm7, 48(%r8)
 add $64, %r8

 lea (%rdi, %rdx), %rbx
 and $-64, %rbx
 cmp %r8, %rbx
 jbe .Lmm_copy_remaining_forward

 cmp $((4096*1024) / 2), %rdx
 jae .Lmm_large_page_loop_forward

 .p2align 4
.Lmm_main_loop_forward:

 prefetcht0 128(%r8, %rsi)

 movdqu (%r8, %rsi), %xmm0
 movdqu 16(%r8, %rsi), %xmm1
 movdqu 32(%r8, %rsi), %xmm2
 movdqu 48(%r8, %rsi), %xmm3
 movdqa %xmm0, (%r8)
 movaps %xmm1, 16(%r8)
 movaps %xmm2, 32(%r8)
 movaps %xmm3, 48(%r8)
 lea 64(%r8), %r8
 cmp %r8, %rbx
 ja .Lmm_main_loop_forward

.Lmm_copy_remaining_forward:
 add %rdi, %rdx
 sub %r8, %rdx



 lea (%r8, %rsi), %r9

.Lmm_remaining_0_64_bytes_forward:
 cmp $32, %rdx
 ja .Lmm_remaining_33_64_bytes_forward
 cmp $16, %rdx
 ja .Lmm_remaining_17_32_bytes_forward
 test %rdx, %rdx
 .p2align 4,,2
 je .Lmm_return

 cmpb $8, %dl
 ja .Lmm_remaining_9_16_bytes_forward
 cmpb $4, %dl
 .p2align 4,,5
 ja .Lmm_remaining_5_8_bytes_forward
 cmpb $2, %dl
 .p2align 4,,1
 ja .Lmm_remaining_3_4_bytes_forward
 movzbl -1(%r9,%rdx), %esi
 movzbl (%r9), %ebx
 movb %sil, -1(%r8,%rdx)
 movb %bl, (%r8)
 jmp .Lmm_return

.Lmm_remaining_33_64_bytes_forward:
 movdqu (%r9), %xmm0
 movdqu 16(%r9), %xmm1
 movdqu -32(%r9, %rdx), %xmm2
 movdqu -16(%r9, %rdx), %xmm3
 movdqu %xmm0, (%r8)
 movdqu %xmm1, 16(%r8)
 movdqu %xmm2, -32(%r8, %rdx)
 movdqu %xmm3, -16(%r8, %rdx)
 jmp .Lmm_return

.Lmm_remaining_17_32_bytes_forward:
 movdqu (%r9), %xmm0
 movdqu -16(%r9, %rdx), %xmm1
 movdqu %xmm0, (%r8)
 movdqu %xmm1, -16(%r8, %rdx)
 jmp .Lmm_return

.Lmm_remaining_5_8_bytes_forward:
 movl (%r9), %esi
 movl -4(%r9,%rdx), %ebx
 movl %esi, (%r8)
 movl %ebx, -4(%r8,%rdx)
 jmp .Lmm_return

.Lmm_remaining_9_16_bytes_forward:
 mov (%r9), %rsi
 mov -8(%r9, %rdx), %rbx
 mov %rsi, (%r8)
 mov %rbx, -8(%r8, %rdx)
 jmp .Lmm_return

.Lmm_remaining_3_4_bytes_forward:
 movzwl -2(%r9,%rdx), %esi
 movzwl (%r9), %ebx
 movw %si, -2(%r8,%rdx)
 movw %bx, (%r8)
 jmp .Lmm_return

.Lmm_len_0_16_bytes_forward:
 testb $24, %dl
 jne .Lmm_len_9_16_bytes_forward
 testb $4, %dl
 .p2align 4,,5
 jne .Lmm_len_5_8_bytes_forward
 test %rdx, %rdx
 .p2align 4,,2
 je .Lmm_return
 testb $2, %dl
 .p2align 4,,1
 jne .Lmm_len_2_4_bytes_forward
 movzbl -1(%rsi,%rdx), %ebx
 movzbl (%rsi), %esi
 movb %bl, -1(%rdi,%rdx)
 movb %sil, (%rdi)
 jmp .Lmm_return

.Lmm_len_2_4_bytes_forward:
 movzwl -2(%rsi,%rdx), %ebx
 movzwl (%rsi), %esi
 movw %bx, -2(%rdi,%rdx)
 movw %si, (%rdi)
 jmp .Lmm_return

.Lmm_len_5_8_bytes_forward:
 movl (%rsi), %ebx
 movl -4(%rsi,%rdx), %esi
 movl %ebx, (%rdi)
 movl %esi, -4(%rdi,%rdx)
 jmp .Lmm_return

.Lmm_len_9_16_bytes_forward:
 mov (%rsi), %rbx
 mov -8(%rsi, %rdx), %rsi
 mov %rbx, (%rdi)
 mov %rsi, -8(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_recalc_len:


 mov %rbx, %rdx
 sub %rdi, %rdx

.Lmm_len_0_or_more_backward:



 cmp $16, %rdx
 jbe .Lmm_len_0_16_bytes_backward

 cmp $32, %rdx
 ja .Lmm_len_32_or_more_backward


 movdqu (%rsi), %xmm0
 movdqu -16(%rsi, %rdx), %xmm1
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, -16(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_32_or_more_backward:
 cmp $64, %rdx
 ja .Lmm_len_64_or_more_backward


 movdqu (%rsi), %xmm0
 movdqu 16(%rsi), %xmm1
 movdqu -16(%rsi, %rdx), %xmm2
 movdqu -32(%rsi, %rdx), %xmm3
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, 16(%rdi)
 movdqu %xmm2, -16(%rdi, %rdx)
 movdqu %xmm3, -32(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_64_or_more_backward:
 cmp $128, %rdx
 ja .Lmm_len_128_or_more_backward


 movdqu (%rsi), %xmm0
 movdqu 16(%rsi), %xmm1
 movdqu 32(%rsi), %xmm2
 movdqu 48(%rsi), %xmm3
 movdqu -64(%rsi, %rdx), %xmm4
 movdqu -48(%rsi, %rdx), %xmm5
 movdqu -32(%rsi, %rdx), %xmm6
 movdqu -16(%rsi, %rdx), %xmm7
 movdqu %xmm0, (%rdi)
 movdqu %xmm1, 16(%rdi)
 movdqu %xmm2, 32(%rdi)
 movdqu %xmm3, 48(%rdi)
 movdqu %xmm4, -64(%rdi, %rdx)
 movdqu %xmm5, -48(%rdi, %rdx)
 movdqu %xmm6, -32(%rdi, %rdx)
 movdqu %xmm7, -16(%rdi, %rdx)
 jmp .Lmm_return

.Lmm_len_128_or_more_backward:


 movdqu -16(%rsi, %rdx), %xmm0
 movdqu -32(%rsi, %rdx), %xmm1
 movdqu -48(%rsi, %rdx), %xmm2
 movdqu -64(%rsi, %rdx), %xmm3

 lea (%rdi, %rdx), %r9
 and $-64, %r9

 mov %rsi, %r8
 sub %rdi, %r8

 movdqu -16(%r9, %r8), %xmm4
 movdqu -32(%r9, %r8), %xmm5
 movdqu -48(%r9, %r8), %xmm6
 movdqu -64(%r9, %r8), %xmm7

 movdqu %xmm0, -16(%rdi, %rdx)
 movdqu %xmm1, -32(%rdi, %rdx)
 movdqu %xmm2, -48(%rdi, %rdx)
 movdqu %xmm3, -64(%rdi, %rdx)
 movdqa %xmm4, -16(%r9)
 movaps %xmm5, -32(%r9)
 movaps %xmm6, -48(%r9)
 movaps %xmm7, -64(%r9)
 lea -64(%r9), %r9

 lea 64(%rdi), %rbx
 and $-64, %rbx

 cmp %r9, %rbx
 jae .Lmm_recalc_len

 cmp $((4096*1024) / 2), %rdx
 jae .Lmm_large_page_loop_backward

 .p2align 4
.Lmm_main_loop_backward:

 prefetcht0 -128(%r9, %r8)

 movdqu -64(%r9, %r8), %xmm0
 movdqu -48(%r9, %r8), %xmm1
 movdqu -32(%r9, %r8), %xmm2
 movdqu -16(%r9, %r8), %xmm3
 movdqa %xmm0, -64(%r9)
 movaps %xmm1, -48(%r9)
 movaps %xmm2, -32(%r9)
 movaps %xmm3, -16(%r9)
 lea -64(%r9), %r9
 cmp %r9, %rbx
 jb .Lmm_main_loop_backward
 jmp .Lmm_recalc_len


.Lmm_len_0_16_bytes_backward:
 testb $24, %dl
 jnz .Lmm_len_9_16_bytes_backward
 testb $4, %dl
 .p2align 4,,5
 jnz .Lmm_len_5_8_bytes_backward
 test %rdx, %rdx
 .p2align 4,,2
 je .Lmm_return
 testb $2, %dl
 .p2align 4,,1
 jne .Lmm_len_3_4_bytes_backward
 movzbl -1(%rsi,%rdx), %ebx
 movzbl (%rsi), %ecx
 movb %bl, -1(%rdi,%rdx)
 movb %cl, (%rdi)
 jmp .Lmm_return

.Lmm_len_3_4_bytes_backward:
 movzwl -2(%rsi,%rdx), %ebx
 movzwl (%rsi), %ecx
 movw %bx, -2(%rdi,%rdx)
 movw %cx, (%rdi)
 jmp .Lmm_return

.Lmm_len_9_16_bytes_backward:
 movl -4(%rsi,%rdx), %ebx
 movl -8(%rsi,%rdx), %ecx
 movl %ebx, -4(%rdi,%rdx)
 movl %ecx, -8(%rdi,%rdx)
 sub $8, %rdx
 jmp .Lmm_len_0_16_bytes_backward

.Lmm_len_5_8_bytes_backward:
 movl (%rsi), %ebx
 movl -4(%rsi,%rdx), %ecx
 movl %ebx, (%rdi)
 movl %ecx, -4(%rdi,%rdx)

.Lmm_return:
 pop %rbx;; ret;



 .p2align 4
.Lmm_large_page_loop_forward:
 movdqu (%r8, %rsi), %xmm0
 movdqu 16(%r8, %rsi), %xmm1
 movdqu 32(%r8, %rsi), %xmm2
 movdqu 48(%r8, %rsi), %xmm3
 movntdq %xmm0, (%r8)
 movntdq %xmm1, 16(%r8)
 movntdq %xmm2, 32(%r8)
 movntdq %xmm3, 48(%r8)
 lea 64(%r8), %r8
 cmp %r8, %rbx
 ja .Lmm_large_page_loop_forward
 sfence
 jmp .Lmm_copy_remaining_forward


 .p2align 4
.Lmm_large_page_loop_backward:
 movdqu -64(%r9, %r8), %xmm0
 movdqu -48(%r9, %r8), %xmm1
 movdqu -32(%r9, %r8), %xmm2
 movdqu -16(%r9, %r8), %xmm3
 movntdq %xmm0, -64(%r9)
 movntdq %xmm1, -48(%r9)
 movntdq %xmm2, -32(%r9)
 movntdq %xmm3, -16(%r9)
 lea -64(%r9), %r9
 cmp %r9, %rbx
 jb .Lmm_large_page_loop_backward
 sfence
 jmp .Lmm_recalc_len

.cfi_endproc; .size memmove, .-memmove

.globl memcpy; .equ memcpy, memmove
