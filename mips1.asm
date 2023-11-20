.data  
filename:.asciiz "Enter the file name \n"
str : .space 10 # value file name
C_search: .space 10
option: .asciiz "\nEnter the day\n"
error_mssg1: "\nRead File error\n"
fileWord:.space 1024
error_mssg: .asciiz "\nOpen File error\n"
main_menu:"\nChoose one of the following options:\n 1.View the calendar.\n 2. View Statistics. \n 3. Add a new appointment.\n 4. Delete an appointment.\n5.exit\n"
menu1:"\n1. per day.\n2.per set of days.\n3. fora given slot in a given day.\n4.return to main memu\n"
.text 
.globl main
main:
la $a0 , filename
li $v0 , 4
syscall
la $a0 ,str # a0=address of str
li $a1 , 10 # a1=max length
li $v0 , 8 # read str
syscall
#open file 
li $v0 ,13
la $a0 , str
li $a1 , 0
syscall
#Check if opened file was successful
bltz $v0, open_file_error

#read file
move $a0 , $v0 #a0=file discriptor
la $a1 , fileWord 
la $a2 , 1024
li $v0 , 14
syscall

# Check if read was successful
bltz $v0, read_error

# different menu options
li $t1, 1  
li $t2, 2  
li $t3, 3  
li $t4, 4  
li $t6, 5  

Loop:  la $a0 ,main_menu
       li $v0 , 4
       syscall
       li $v0,5
       syscall
       move $t0,$v0 # store user choice in $t0
       beq $t1,$t0,CH1   # option 1
       beq $t2,$t0,CH2   # option 2
       beq $t3,$t0,CH3   # option 3
       beq $t4,$t0,CH4   # option 4
       beq $t6,$t0,CH5   # option 5
       j Loop
       
CH1:
L:    la $a0 ,menu1
      li $v0 , 4
      syscall
      li $v0,5
      syscall
      move $t5,$v0 # store user choice in $t5
      beq $t1,$t5,CH1.1  # option 1
      beq $t2,$t5,CH1.2  # option 2
      beq $t3,$t5,CH1.3  # option 3
      beq $t4,$t5,CH1.4  # option 4
      j L

CH1.1:	la $a0,option
	li $v0 ,4
	syscall
	li $v0 ,5
	syscall 
	sw $v0, C_search
	
CH1.2:
CH1.3:
CH1.4:
j Loop


CH2:
CH3:
CH4:
CH5: li $v0, 10    # Exit program
     syscall
open_file_error:	li $v0,4
			la $a0,error_mssg
			syscall
			j main
			
read_error:	li $v0,4
		la $a0,error_mssg1
		syscall
		j main

search:
