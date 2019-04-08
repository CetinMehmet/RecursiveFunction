.text

input:		.asciz 	"%ld"
output:		.asciz	"The result is: %d\n"
names:		.asciz	"Mehmet Berk Cetin\n"
userprompt:	.asciz	"Please enter a postive number followed by an exponent: "


.global main

main:	

	movq	$names, %rdi		# first argument for printf
	movq	$0, %rax		# no vector arguments in printf	
	call	printf			# call printf

	# Asks user for input
	movq	$userprompt,%rdi	# first argument of printf 
	movq	$0, %rax		# no vector arguments in printf			
	call	printf			# call printf
	
	call	userinput
	
	# loads parameters into pow function and calls function
	movq	-16(%rbp),%rdi		# loads base as first argument
	movq	-8(%rbp),%rsi		# loads exponent as second argument
	call	pow			# calls pow subroutine
	
	# Prints "total" returned by pow function
	movq	$output, %rdi		# loads first argument of printf
	movq	%rcx, %rsi		# loads "total" as second argument
	movq	$0, %rax		# loads base as first argument	
	call	printf			# call printf

	movq	%rsp, %rbp		# clears local variables from stack		
	popq 	%rbp			# restore caller's base pointer
	
	
	jmp	end			# jumps to end

userinput: 

	# initialize stack
	pushq	%rbp			# push base pointer to stack			
	movq	%rsp, %rbp		# copy stack pointer to RBP
	subq	$16, %rsp		# reserve stack space for variable

	# Gets base parameter from user
	leaq	-16(%rbp), %rsi		# load effective address of stack var to rsi
	movq	$input, %rdi		# load first argument of scanf (base)
	movq	$0, %rax		# no vector arguments in scanf
	call	scanf			# call scanf
	
	# Gets exponent parameter from user
	leaq	-8(%rbp), %rsi		# load effective address of stack var to rsi
	movq	$input, %rdi		# load first argument of scanf (exponent)
	movq	$0, %rax		# no vector arguments in scanf
	call	scanf			# call scanf
	
	ret



	# POW FUNCTION
pow:
	movq	$1, %rcx		# sets "total" = 1
	movq	$0, %rdx		# sets "i" = 0
	jmp	loop			# for loop
	
	# FOR LOOP
loop:	
	cmpq	%rsi, %rdx		# checks if i >= exponent
	jge	loopend			# if i >= exponent jump to end of loop			
	imulq	%rdi, %rcx		# else multiply base by total and store value in total
	incq	%rdx			# increment i
	jmp	loop			# repeat loop


loopend:
	ret				# return total to main	

end:
	mov	$0, %rdi		# load exit code
	call	exit			# call exit
