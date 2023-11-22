.data  
num_day:.asciiz "Enter the number of day  \n"
filename:.asciiz "Enter the file name \n"
str : .space 10 # value file name
C_search: .space 10
option: .asciiz "\nEnter the day\n"
fileWord:.space 1024
result:.space 100
end:.asciiz "There are no appointments on this day\n"
error_mssg: .asciiz "\nOpen File error\n"
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
li $a1 , 0
li $v0 ,13
syscall
bltz $v0, open_file_error
move $s0, $v0
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
       li $t1, 1  
       li $t2, 2  
       li $t3, 3  
       li $t4, 4
      la $a0 ,menu1
      li $v0 , 4
      syscall
      li $v0,5
      syscall
      move $t5,$v0 # store user choice in $t5
      beq $t1,$t5,CH1.1  # option 1
      beq $t2,$t5,CH1.2  # option 2
      beq $t3,$t5,CH1.3  # option 3
      beq $t4,$t5,CH1.4  # option 4
      j view_calendar
    CH1.1:	#the program will let the user view the calendar per day
        la $a0,option  
	li $v0 ,4
	syscall
	la $a0,C_search
	li $a1,10
	li $v0 ,8
	syscall 
       remove_newline:
       		lb $t0, 0($a0)
       		beq $t0, 10, found_newline  # Check for newline character
       		beq $t0, 0, end_remove  # Check for null terminator
       		addi $a0, $a0, 1
       		j remove_newline
      found_newline:
    		sb $zero, 0($a0)  # Replace newline character with null terminator
      end_remove:
	move $a0 , $s0 #a0=file discriptor
	la $a1 , fileWord 
	la $a2 , 1024
	li $v0, 14
	syscall
        la $a2 , result
	la $a0,C_search
   	la $a1, fileWord
        find_day:
        	li $t3, 58 # ASCII value for ":"
		lb   $t0, 0($a0)
		lb   $t1, 0($a1)
    		bne  $t3, $t1, next
		bnez $t0,next
		j found 
		next:            
   		beq  $t0, $t1, continue_search  
   		j not_foundInThisLine
        continue_search:
   		addi $a0, $a0, 1       
   		addi $a1, $a1, 1       
   		j find_day
        found:
   		addi $a1, $a1, 1
   		lb  $t1, 0($a1)
   		beq $t1, 10, f_print
	 	beq $t1,0,f_print
	 	sb $t1,0($a2)
	 	addi $a2, $a2, 1
	 	j found 
	 f_print:
	 	la $a0,result
	       li $v0 ,4
	       syscall
	       subi $t8,$t8,1
	       bgtz $t8,m 
	       j view_calendar
        not_foundInThisLine:
        	addi $a1, $a1, 1
   		lb  $t1, 0($a1)
   		beq $t1, 10, f
	 	beq $t1,0,k
   		j not_foundInThisLine
   	f :
   	  la $a0,C_search
   	  addi $a1, $a1, 1
   	  la $a2 , result
   	  j find_day	
       k:
   	 la $a0,end
  	 li $v0,4
  	 syscall
  	 subi $t8,$t8,1
  	 bgtz $t8,m 
  	 j view_calendar
  	 
  	 #-----------------------------------------
    CH1.2:
	la $a0,num_day  
	li $v0 ,4
	syscall
	li $v0 ,5
	syscall 
	move $t8,$v0
    m:
        blez $t8,view_calendar
        j CH1.1
	
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
end_file:
    # Close the file
    li      $v0, 16          # System call for close file
    move    $a0, $s0         # File descriptor
    syscall
