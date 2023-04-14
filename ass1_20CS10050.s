	.file	"asgn1.c" # source file name
	.text
	.section	.rodata  # read only data section
	.align 8       # align with 8-byte boundary
.LC0:                   # Label of f-string-1st printf
	.string	"Enter the string (all lowrer case): "
.LC1:                            # Label of f-string scanf
	.string	"%s"
.LC2:                                   # Label of f-string-2nd printf
	.string	"Length of the string: %d\n"
	.align 8             # align with 8-byte boundary
.LC3:                        # Label of f-string-3rd printf
	.string	"The string in descending order: %s\n"
	.text
	.globl	main
	.type	main, @function


main:                           # main: starts
.LFB0:
	.cfi_startproc        # call frame information
	endbr64	
	pushq	%rbp	      # save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	# rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6
	subq	$80, %rsp	# create space for local array and variables



	movq	%fs:40, %rax	# segment addressing
	movq	%rax, -8(%rbp)	# rax->rbp-8
	xorl	%eax, %eax	# clear eax


# printf("Enter the string (all lowrer case): ");


	leaq	.LC0(%rip), %rdi  # .LC0 + rip -> rdi, store 1st parameter of printf
	movl	$0, %eax	  # 0->eax, clear eax
	call	printf@PLT	  # calls printf


# scanf("%s", str);  



	leaq	-64(%rbp), %rax	# rbp - 64 -> rax,str -> rax
	movq	%rax, %rsi	# rax -> rsi, store str, 2nd parameter of scanf
	leaq	.LC1(%rip), %rdi  # .LC1 + rip -> rdi, store format string "%s", 1st parameter of scanf
	movl	$0, %eax	 # 0->eax, clear eax
	call	__isoc99_scanf@PLT	# call scanf


# len = length(str); //calling length function


	leaq	-64(%rbp), %rax	 # rbp-64 -->rax
	movq	%rax, %rdi	 # rax -->rdi
	call	length	         # calls the length 
	movl	%eax, -68(%rbp)	 #eax <--ebp-68   here the len tends to eax


# printf("Length of the string: %d\n", len);


	movl	-68(%rbp), %eax	 # rbp - 68 -> eax, len -> eax
	movl	%eax, %esi	 # eax -> esi, store n, 2nd parameter of printf
	leaq	.LC2(%rip), %rdi  # .LC2 + rip -> rdi, store 1st parameter of printf
	movl	$0, %eax	 # 0->eax, clear eax
	call	printf@PLT	 # calls printf


# sort(str, len, dest); //calling sorting function


	leaq	-32(%rbp), %rdx	 # rbp-32 -->rdx (dest -->rdx)
	movl	-68(%rbp), %ecx	 # rbp-68 -->ecx  (len-->ecx)
	leaq	-64(%rbp), %rax	 # rbp-64 -->rax  (str-->rax)
	movl	%ecx, %esi	 # ecx-->esi it stores the len in the second parameter of sort function
	movq	%rax, %rdi	 # rax-->rdi it stores the str in the first parameter of the sort function
	call	sort	# call sort function


# printf("The string in descending order: %s\n", dest);


	leaq	-32(%rbp), %rax	# rbp-32-->rax here the dest tends to the rax
	movq	%rax, %rsi	# rax-->rsi
	leaq	.LC3(%rip), %rdi # .LC3 + rip -> rdi, store 1st parameter of printf	
	movl	$0, %eax	# 0->eax, clear eax
	call	printf@PLT	# calls printf


# return 0;


	movl	$0, %eax	# 0-->eax this is return value from main that is 0
	movq	-8(%rbp), %rcx	# rbp-8-->rcx
	xorq	%fs:40, %rcx	
	je	.L3	
	call	__stack_chk_fail@PLT 

.L3:
	leave	
	.cfi_def_cfa 7, 8
	ret	                   # return to the main
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	length
	.type	length, @function


length:
.LFB1:
	.cfi_startproc      # call frame information
	endbr64	
	pushq	%rbp	     # save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	# set new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)	 # rdi-->rbp-24 (first argument str tends to rbp-24

# for(i=0; str[i]!='\0'; i++) //computing length of the string


	movl	$0, -4(%rbp)	# 0-->rbp-4(assign the value 0 to i(i=0))




	jmp	.L5	# enter to the for loop conditional check
.L6:


	addl	$1, -4(%rbp)	#, i
.L5:




	movl	-4(%rbp), %eax	 # rbp-4-->eax  (i-->eax)
	movslq	%eax, %rdx	 # eax-->rdx this means 32 bits to 64 bits
	movq	-24(%rbp), %rax  # rbp-24-->rax(str-->rax)
	addq	%rdx, %rax	 # rdx+rax-->rax ,str+i=str[i],str[i]-->rax
	movzbl	(%rax), %eax	 # rax-->eax(32 bits)





	testb	%al, %al	# tests str[i]
	jne	.L6	        # if str[i] not equal to '\n' than its jump in to the loop
        movl	-4(%rbp), %eax	# rbp-4-->eax

	popq	%rbp	         # Here the pop is a base pointer
	.cfi_def_cfa 7, 8
	ret	                  # return from the length
	.cfi_endproc
.LFE1:
	.size	length, .-length
	.globl	sort               # sort is a function
	.type	sort, @function     # sort function starts
sort:
.LFB2:
	.cfi_startproc          # call from start function
	endbr64	               
	pushq	%rbp	 # save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	 # rsp-->rbp(set new stack base pointer)
	.cfi_def_cfa_register 6
	subq	$48, %rsp	# rsp-48->rsp
	movq	%rdi, -24(%rbp)	 # rdi-->rbp-24(first argument,rdi-->str)
	movl	%esi, -28(%rbp)	# esi-->rbp-28(second argument,esi-->len)
	movq	%rdx, -40(%rbp)	# rdx-->rbp-40(Third argument,rdx-->dest


	movl	$0, -8(%rbp) # 0->rbp-8, assign 0 to i	


	jmp	.L9	# go to the for loop conditional check

.L13:

# for(j=0; j<len; j++)


	movl	$0, -4(%rbp)	# 0->rbp-8, assign 0 to j


	jmp	.L10	# go to the for loop conditional check
.L12:


# if(str[i]<str[j]) //sorting in ascending order


	movl	-8(%rbp), %eax	# rbp-8 -> eax, i -> eax
	movslq	%eax, %rdx	# eax-->rdx converts 32 bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax (str-->rax)
	addq	%rdx, %rax	# rdx+rax-->rax ,i+str=str[i],str[i]-->rax
	movzbl	(%rax), %edx	# rax-->edx


	movl	-4(%rbp), %eax	# rbp-4-->eax  (j-->eax)
	movslq	%eax, %rcx	# eax+rcx-->rcx
	movq	-24(%rbp), %rax	# rbp-24-->rax (str-->rax)
	addq	%rcx, %rax	# rcx+rax-->rax,j+str=str[j],str[j]-->rax
	movzbl	(%rax), %eax	 # rax-->eax





	cmpb	%al, %dl           # logical comparision between str[i] and str[j]	
	jge	.L11	           # jump to next, if str[i]<str[j]


	movl	-8(%rbp), %eax	# rbp-8-->eax (i-->eax)
	movslq	%eax, %rdx	# eax-->rdx,32bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax (str-->rax)
	addq	%rdx, %rax	# rdx+rax-->rax ,i+str=str[i],str[i]-->rax




	movzbl	(%rax), %eax	# rax-->eax (32 bits)
	movb	%al, -9(%rbp)	





	movl	-4(%rbp), %eax	# rbp-4-->eax ,j-->eax
	movslq	%eax, %rdx	# eax-->rdx,32 bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax,str-->eax
	addq	%rdx, %rax	# rdx+rax-->rax,str+j=str[j],str[j]-->rax


	movl	-8(%rbp), %edx	# rbp-8-->edx , i-->edx
	movslq	%edx, %rcx	 # edx-->ecx , 32 bits to 64 bits
	movq	-24(%rbp), %rdx	 # rbp-24-->rax , str-->rax
	addq	%rcx, %rdx	 # rcx+rdx-->rdx , str+i=str[i] ,str[i]-->rdx





	movzbl	(%rax), %eax	# rax-->eax ,32 bits




	movb	%al, (%rdx)	





	movl	-4(%rbp), %eax	 # rbp-4-->eax
	movslq	%eax, %rdx	 # eax-->rdx,32 bits to 64bits
	movq	-24(%rbp), %rax	 # rbp-24-->rax
	addq	%rax, %rdx	 # rax+rdx-->rdx


	movzbl	-9(%rbp), %eax	#rbp-9-->eax ,32 bits
	movb	%al, (%rdx)	
.L11:



	addl	$1, -4(%rbp)	
.L10:

	movl	-4(%rbp), %eax	# rbp-4-->eax  (j-->eax)
	cmpl	-28(%rbp), %eax	# it is the logical comparision between  j and len  
	jl	.L12	# if j is less than len jump to the loop body
	addl	$1, -8(%rbp)	# 1+(rbp-8)=rbp-8  (i=i+1)


.L9:                             # for(i=0;i<len;i++)
	movl	-8(%rbp), %eax	 # rbp-8-->eax  (i) 
	cmpl	-28(%rbp), %eax	 # rbp-28-->eax(here it is the logical comparision between i and the len)

	jl	.L13	         # if i less than len go inside the loop
	movq	-40(%rbp), %rdx	  # rbp-40-->rdx(dest-->rdx)
	movl	-28(%rbp), %ecx	   # rbp-28-->ecx(len-->ecx)
	movq	-24(%rbp), %rax	   # rbp-24-->rax(str-->rax)
	movl	%ecx, %esi	 # ecx-->esi
	movq	%rax, %rdi	# rax-->rdi
	call	reverse	           # calls reverse

	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	                # return from the sort
	.cfi_endproc
.LFE2:
	.size	sort, .-sort
	.globl	reverse       # Here the reverse is a global name
	.type	reverse, @function # reverse is a function
reverse:                      # reverse function starts
.LFB3:
	.cfi_startproc          # call frame information
	endbr64	
	pushq	%rbp	        # save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	# rsp-->rbp(set new stack base pointer)
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)	# rdi-->rbp-24(first argument(rdi-->str))
	movl	%esi, -28(%rbp)	# esi-->rbp-28(second argument(esi-->len))
	movq	%rdx, -40(%rbp)	# rdx-->rbp-40(third argument(rdx-->dest))
	movl	$0, -8(%rbp)	# 0-->rbp-8(Assign i equal to 0)
	jmp	.L15	      # jump to the for loop condition check
.L20:

	movl	-28(%rbp), %eax	# rbp-28-->eax (len-->eax) 
	subl	-8(%rbp), %eax	# eax-(rbp-8)-->eax  (len-i-->eax)
	subl	$1, %eax	# eax-1-->eax   (len-i-1-->eax)
	movl	%eax, -4(%rbp)	# eax-->(rbp-4)  (eax-->j)
	nop	
	movl	-28(%rbp), %eax	# rbp-28-->eax  (len-->eax)
	movl	%eax, %edx	# eax-->edx
	shrl	$31, %edx	# shift the value of edx to the right by 31 bits
	addl	%edx, %eax	# edx+eax-->eax
	sarl	%eax	        # shift eax to the right by 1 bit
	cmpl	%eax, -4(%rbp)	# logical comparision between j and len/2
	jl	.L18	        # go inside the loop if len/2 is less than j
	movl	-8(%rbp), %eax	# rbp-8-->eax  (i-->eax)
	cmpl	-4(%rbp), %eax	# logical comparision of i and j
	je	.L23	        # jump in the loop if i equal to j
	movl	-8(%rbp), %eax	# rbp-8-->eax  (i-->eax)
	movslq	%eax, %rdx	# eax-->edx ,32 bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax  (str-->rax)
	addq	%rdx, %rax	# rdx+rax-->rax  ,str+i-->str[i],str[i]-->rax

	movzbl	(%rax), %eax	# rax-->eax (32 bits)
	movb	%al, -9(%rbp)	

	movl	-4(%rbp), %eax	# rbp-4-->eax  (j-->eax)
	movslq	%eax, %rdx	# eax-->rdx ,32 bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax  (str-->rax)
	addq	%rdx, %rax	# rdx+rax-->rax

	movl	-8(%rbp), %edx	# rbp-8-->edx
	movslq	%edx, %rcx	# edx-->rcx ,32 bits to 64 bits
	movq	-24(%rbp), %rdx	# rbp-24-->rdx  (str-->rdx)
	addq	%rcx, %rdx	 # rcx+rdx-->rdx

	movzbl	(%rax), %eax	# rax-->eax(32 bits)

	movb	%al, (%rdx)	

	movl	-4(%rbp), %eax	# rbp-4-->eax (j-->eax)
	movslq	%eax, %rdx	# eax-->rdx ,32 bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax(str-->rax)
	addq	%rax, %rdx	 # rax+rdx-->rdx ,str+j-->str[j]

	movzbl	-9(%rbp), %eax	 # rbp-9-->eax
	movb	%al, (%rdx)	

	jmp	.L18	# jump from the loop

.L23:

	nop	
.L18:

	addl	$1, -8(%rbp)	
.L15:

	movl	-28(%rbp), %eax	 # rbp-28-->eax  (len-->eax)
	movl	%eax, %edx	 # eax-->edx
	shrl	$31, %edx	# shrl means shift edx moving right by 31 bits
	addl	%edx, %eax	 # edx+eax-->eax 
	sarl	%eax	           # shift eax to right by moving one bit

	cmpl	%eax, -8(%rbp)	# logical comparision of j and len/2
	jl	.L20	         # If i is less than len/2 go inside the loop

	movl	$0, -8(%rbp)	# 0-->rbp-8(Assign i equal to 0)

	jmp	.L21	 # jump to the for loop
.L22:




	movl	-8(%rbp), %eax	# rbp-8-->eax
	movslq	%eax, %rdx	# eax-->rdx ,32bits to 64 bits
	movq	-24(%rbp), %rax	# rbp-24-->rax  (str-->rax)
	addq	%rdx, %rax	# rdx+rax-->rax ,str+i=str[i],str[i]-->rax



	movl	-8(%rbp), %edx	# rbp-8-->edx  ,(i->edx )
	movslq	%edx, %rcx	# edx-->rcx  ,32 bits to 64 bits
	movq	-40(%rbp), %rdx	# rbp-40-->rdx  (dest-->rdx)
	addq	%rcx, %rdx	# rcx+rdx-->rdx ,i+dest=dest[i],dest[i]-->rdx





	movzbl	(%rax), %eax	 # rax-->eax





	movb	%al, (%rdx)	





	addl	$1, -8(%rbp)	
.L21:



	movl	-8(%rbp), %eax	# rbp-8-->eax (i-->eax)
	cmpl	-28(%rbp), %eax	  # logical comparision between i and len
	jl	.L22	        # jump inside the loop if i is less tha len

	nop	
	nop	
	popq	%rbp	  # pop the base pointer
	.cfi_def_cfa 7, 8
	ret	           # return from reverse
	.cfi_endproc
.LFE3:
	.size	reverse, .-reverse
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
