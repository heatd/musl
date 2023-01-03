.global vfork
.type vfork,@function
vfork:
    li a7, 150 # SYS_vfork
	ecall
    j __syscall_ret
