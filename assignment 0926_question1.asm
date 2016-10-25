.data
lower: .asciiz "hola"
upper: .asciiz "\0"
.text
main:
	add $s0,$zero,$zero  #initialize i, such that i=0
	la $s1,lower #$s1 is assigned the base address of the lowercase string
	la $s2,upper #$s2 is assigned the base address of the uppercase (to be copied and converted) string
loop:
	add $t1,$s1,$s0 #$t1 gets the address of the next character of the lowercase string
	lbu $t3,0($t1) #$t3 is assigned the next character of the lowercase string
	add $t2,$s2,$s0 #$t2 gets the address of the next character of the uppercase string
	addi $t3,$t3,-32 #the lowercase character is converted to the corresponding uppercase one by subtracting 32 from it
	beq $t3,-32,exit #branch condition is -32, because 0-32=-32
	sb $t3,0($t2) #save the converted character into the uppercase string
	addi $s0,$s0,1 #move to the next character
	lbu $a0,upper
	la $a0,($t2)
	li $v0,4
	syscall #print out a converted character
	j loop
exit:
	li $v0,10
	syscall

