.data

height: .word  0
weight: .word 0
bmi:	.double 0.0
temp: .double 0.0
sevenothree: .word 703
boundary1: .double 18.5
boundary2: .double 25.0
boundary3: .double 30.0
name:	.space 30
prompt1:	.asciiz "What is your name? "
prompt2:	.asciiz  "Please enter your height in inches: "
prompt3:	.asciiz "Now enter your weight in pounds (round to a whole number): "
msg1:	.asciiz ", your bmi is: \n"
msg2:	.asciiz "\nThis is considered underweight. "
msg3:	.asciiz "\nThis is a normal weight. "
msg4:	.asciiz "\nThis is considered overweight. "
msg5:	.asciiz "\nThis is considered obese. "

.text
main:
la $a0,prompt1 #prompt the user to input name
li $v0,4
syscall

la $a0,name
li $a1,30
li $v0,8 #read in username
syscall

la $a0,prompt2#prompt the user to input height
li $v0,4
syscall

li $v0,5 #read in height
syscall
add $t1,$v0,$zero	#save height to register $t1

la $a0,prompt3	#prompt the user to input weight
li $v0,4
syscall

li $v0,5 #read in weight
syscall
add $t2,$v0,$zero	#save weight to register $t2
lw $t3,sevenothree	#load 703 into $t3

mult $t2,$t3	#weight*=703, and save it back to $t2
mflo $t2 
sw $t2,temp #save weight*=703 into label temp
l.d $f20,temp#load weight*=703 to coprocessor1
cvt.d.w $f20,$f20#convert to double precision FP

mult $t1,$t1 #height^2, and save it back to $t1
mflo $t1
sw $t1,temp#save height^2 into label temp
l.d $f22,temp#load height^2 to coprocessor1
cvt.d.w $f22,$f22

la $a0,name #output name
li $v0,4
syscall 

la $a0,msg1 #ouput message1
syscall

div.d $f24,$f20,$f22#calculate the bmi value and save to $f24
mov.d $f12,$f24
li $v0,3#output bmi value
syscall

l.d $f14,boundary1#load boundaries
l.d $f16,boundary2
l.d $f18,boundary3

c.lt.d $f24,$f14 #judge if it's underweight
bc1t underweight

c.lt.d $f24,$f16#judge if it's normal
bc1t normal

c.lt.d $f24,$f18#judge if it's overweight
bc1t overweight

j default#default condition

underweight: #output when bmi<18.5
la $a0,msg2
li $v0,4
syscall 
j exit

normal:#ouput when 18.5<bmi<25
la $a0,msg3
li $v0,4
syscall 
j exit

overweight:#output when 25<bmi<30
la $a0,msg4
li $v0,4
syscall 
j exit

default:#ouput when bmi is even greater
la $a0,msg5
li $v0,4
syscall 

exit:#end the program
li $v0,10
syscall

