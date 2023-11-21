.data  
filename:.asciiz "\nEnter the file name : \n"
r:.asciiz "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\n"
str : .space 10 # value file name
C_search : .space 10
option: .asciiz "\nEnter the day :"
error_mssg1: "\nRead File error\n"
fileWord:.space 1024
error_mssg: .asciiz "\nOpen File error\n"
result_str :.space 10
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
	la $a0,C_search
	li $v0 ,8
	syscall 
	la $a1,result_str
        la $a0, fileWord
	find_day:
	 	lb $t4, 0($a0)
	 	li $t3, 58 # ASCII value for ":"
                beq $t4, $t3, compare
                sb $t4, 0($a1)
                addi $a1, $a1, 1
                addi $a0, $a0, 1
                addi $t0, $t0, 1
        	j find_day
        compare:
        
        
         la $a0, C_search  
         li $v0,4
         syscall
         la $a0, result_str 
         li $v0,4
         syscall
         #----------------------------------------------
          # Remove newline character
    la $a0, C_search
remove_newline:
    lb $t0, 0($a0)
    beq $t0, 10, found_newline  # Check for newline character
    beq $t0, 0, end_remove  # Check for null terminator
    addi $a0, $a0, 1
    j remove_newline

found_newline:
    sb $zero, 0($a0)  # Replace newline character with null terminator

end_remove:
    
         #----------------------------------
          # Convert string to integer
    la $a0, result_str   # Load address of the string
    move $t0, $zero  # Initialize result to 0
parse_digit_loop:
    lb $t1, 0($a0)   # Load the ASCII value of the current character
    beq $t1, $zero, end_parse1 # If the character is null (end of string), exit loop
    sub $t1, $t1, 48
    # Multiply the current result by 10 and add the new digit
    mul $t0, $t0, 10
    add $t0, $t0, $t1
    addi $a0, $a0, 1  # Move to the next character in the string
    j parse_digit_loop
end_parse1:
    move $t8, $t0
    
    
    la $a0, C_search   # Load address of the strin
    move $t0, $zero  # Initialize result to 0
parse_digit_loop2:
    lb $t1, 0($a0)   # Load the ASCII value of the current character
    beq $t1, $zero, end_parse  # If the character is null (end of string), exit loop
    sub $t1, $t1, 48
    # Multiply the current result by 10 and add the new digit
    mul $t0, $t0, 10
    add $t0, $t0, $t1
    addi $a0, $a0, 1  # Move to the next character in the string
    j parse_digit_loop2
end_parse:
    move $t9, $t0  
    
    bne $t8,$t9 , not_found  	
        	la $a0, r
        	li $v0, 4
        	syscall
	not_found :
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
