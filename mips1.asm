.data  
filename:.asciiz "Enter the file name \n"
str : .space 10 # value file name
C_search: .space 10
option: .asciiz "\nEnter the day\n"
error_mssg1: "\nRead File error\n"
fileWord:.space 1024
error_mssg: .asciiz "\nOpen File error\n"
result_str:.space 10
main_menu:"\nChoose one of the following options:\n 1.View the calendar.\n 2. View Statistics. \n 3. Add a new appointment.\n 4. Delete an appointment.\n 5.exit\n"
menu1:"\nChoose one of the following options:\n 1. per day.\n 2.per set of days.\n 3. fora given slot in a given day.\n 4.return to main memu\n"
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
bltz $v0, open_file_error

#read file
move $a0 , $v0 #a0=file discriptor
la $a1 , fileWord 
la $a2 , 1024
li $v0 , 14
syscall
# Check if read was successful
bltz $v0, read_error  

Loop:  
       li $t1, 1  
       li $t2, 2  
       li $t3, 3  
       li $t4, 4  
       li $t6, 5  
       la $a0 ,main_menu
       li $v0 , 4
       syscall
       li $v0,5
       syscall
       move $t0,$v0 # store user choice in $t0
       beq $t1, $t0, view_calendar
       beq $t2, $t0, view_statistics
       beq $t3, $t0, add_appointment
       beq $t4, $t0, delete_appointment
       beq $t6, $t0, exit_program
       j Loop
       
view_calendar: 
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

    CH1.1:	
        la $a0,option  #the program will let the user view the calendar per day
	li $v0 ,4
	syscall
	li $v0 ,5
	syscall 
	move $t9 ,$v0
	sw $v0, C_search
	la $a0,fileWord
        la $a1, C_search
	find_day:
	 	lb $t2, 0($a0)
	 	lb $t0, 0($a1)
	 	li $t3, 58 # ASCII value for ":"
        	beqz $t0, ch
                beq $t2, $t3, not_found
        	bne $t0, $t2, not_found
               addi $a1, $a1, 1
               addi $a0, $a0, 1
        	j find_day
        ch:
        	beq $t2, $t3, found
        	
	found:
        	# print full line 
        	j CH1.1
        	
	not_found :
      		# read another  line from file
      		j main
	j L
    CH1.2:

    CH1.3:

    CH1.4: j Loop

view_statistics:
add_appointment:
delete_appointment:

exit_program : li $v0, 10    # Exit program
               syscall
               
open_file_error: li $v0,4
		 la $a0,error_mssg
		 syscall
		 j main
			
read_error:	li $v0,4
		la $a0,error_mssg1
		syscall
		j main


