.global vfork
.type vfork,@function
vfork:
	li a7, 150 # SYS_vfork
	ecall
	.hidden __syscall_ret
	j __syscall_ret
