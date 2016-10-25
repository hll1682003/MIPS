.data
lower: .asciiz "Elephant!"
upper: .space 25
.text
main:
	
	add $s0,$zero,$zero  #initialize i, such that i=0
	la $s1,lower #$s1 is assigned the base address of the original string
	la $s2,upper #$s2 is assigned the base address of the uppercase (to be copied and converted) string
	jal conversion
	sb $v0,upper
	j exit
	

conversion:
	addi $sp,$sp,-8
	sw $s0,0($sp)
	sw $s1,4($sp)
	add $t1,$s1,$s0 #$t1 gets the address of the next character of the original string
	lbu $t3,0($t1) #$t3 is assigned the next character of the original string
	add $t2,$s2,$s0 #$t2 gets the address of the next character of the uppercase string
judge:	
	beq $t3,0,done
	slti $t4,$t3,97 #see if the ascii code is below the lower boundary
	slti $t5,$t3,123 #see if the ascii code is below the upper boundary
	add $t4,$t4,$t5
	bne $t4,1,nottoconvert #if the character is a lowercase letter, the sum of $t4 and $t5=1, and vice versa

convert:
	addi $t3,$t3,-32 #the lowercase character is converted to the corresponding uppercase letter by subtracting 32
	sb $t3,0($t2) #save the converted character into the uppercase string
	addi $s0,$s0,1 #move to the next character
	j conversion
	
nottoconvert:
	sb $t3,0($t2)
	addi $s0,$s0,1
	j conversion

done:
	lw $s0,0($sp)
	lw $s1,4($sp)
	addi $sp,$sp,8
	jr $ra
	
exit:#end the program
	li $v0,10
	syscall
	
