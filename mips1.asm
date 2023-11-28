.data  
num_day:.asciiz "Enter the number of day  \n"
filename:.asciiz "Enter the file name \n"
end:.asciiz "There are no appointments on this day\n"
error_mssg: .asciiz "\nOpen File error\n"
option: .asciiz "\nEnter the day\n"
main_menu:"\nChoose one of the following options:\n 1.View the calendar.\n 2. View Statistics. \n 3. Add a new appointment.\n 4. Delete an appointment.\n 5.exit\n"
menu1:"\nChoose one of the following options:\n 1. View the calendar per day.\n 2. View the calendar per set of days.\n 3. View the calendar for a given slot in a given day.\n 4.return to main memu\n"
p_s_slots:"Enter the beginning of the slot: "
p_f_slots:"Enter the end of the slot: "
num_L: .asciiz "\n Number of lectures (in hours): "
num_OH: .asciiz "\n Number of OH (in hours): "
num_M: .asciiz "\n Number of Meetings (in hours): "
Average: .asciiz "\n Average lectures per day :"
ratio: .asciiz "\n Ratio between number of lectures and number of OH : "
S_num :.word 0
F_num:.word 0
time1:.space 5
time2:.space 5
T1:.word 0
T2:.word 0
Final_slots:.space 50
str : .space 10 # file name
C_search: .space 10 
fileWord:.space 1024 # value from file
result:.space 100 
.text 
.globl main
main:
la $a0 , filename 
li $v0 , 4
syscall
la $a0 ,str # a0=address to save value of file name
li $a1 , 10 # a1=max length
li $v0 , 8 # read str
syscall
#open file 
li $a1 , 0
li $v0 ,13
syscall
bltz $v0, open_file_error # Verify that the file is open
move $a0,$v0
la $a1 , fileWord 
la $a2 , 1024
li $v0, 14
syscall
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
#---------------------------------------------------------
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
#---------------------------------------------------------
    CH1.1:	#the program will let the user view the calendar per day
        la $a0,option  
	li $v0 ,4
	syscall
	la $a0,C_search
	li $a1,10
	li $v0 ,8
	syscall 
        jal remove_newline
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
   		beq $t6,3, ch3.1
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
   	 y:
           li $t9, 0
           sb $t9,0($a2)
	   addi $a2, $a2, 1
	   j t
        t:
           lb $t7,0($a2)
           bnez $t7,y
   	   la $a2 , result
   	j find_day	
       k:
   	 la $a0,end
  	 li $v0,4
  	 syscall
  	 subi $t8,$t8,1
  	 bgtz $t8,m 
  	 j view_calendar
#---------------------------------------------------------
    CH1.2: #the program will let the user view the calendar per set of day
	la $a0,num_day  
	li $v0 ,4
	syscall
	li $v0 ,5
	syscall 
	move $t8,$v0
    m:
        blez $t8,view_calendar
        j CH1.1
#---------------------------------------------------------
    CH1.3:  #the program will let the user view the calendar slot in a given day
	li $t6,3
	j CH1.1
      ch3.1:
	la $a0, p_s_slots 
	li $v0 ,4
	syscall
	li   $v0, 5              
        syscall
        sw   $v0, S_num
        move $t0,$v0
        jal Convert_24
        sw  $t0 , S_num
	#---------------
	la $a0, p_f_slots 
	li $v0 ,4
	syscall
	li  $v0, 5              
        syscall
        sw  $v0, F_num
        move $t0,$v0
        jal Convert_24
        sw  $t0 , F_num
        la $a0,Final_slots
      ch3.2:
        la $a3,time1
        la $a2,time2
     ch3.3:
	 addi $a1, $a1, 1
   	 lb  $t1, 0($a1)  
   	 beq $t1,45,first
	 sb $t1,0($a3)
	 addi $a3, $a3, 1
	 j ch3.3    
     first: 
         addi $a1, $a1, 1
       c:   
         lb  $t1, 0($a1)
         beq $t1,32,space
         sb $t1,0($a2)
	 addi $a2, $a2, 1
	 addi $a1, $a1, 1
         j c
     space:
         move $s1,$a1
         j compare
       h:
         addi $a1, $a1, 1
   	 lb  $t1, 0($a1)
   	 beq $t1,',',q
   	 beq $t1,0,final
         beq $t1,10,final
   	 j h
   	 
      h1:lb $t1, 0($a1)
   	 sb $t1,0($a0)
	 addi $a0, $a0, 1
   	 beq $t1,44,q
   	 beq $t1,0,final
         beq $t1,10,final
         addi $a1, $a1, 1 
   	 j h1
      q: addi $a1, $a1, 1
      la $a3,time1
      la $a2,time2
      y1:  li $t9, 0
           sb $t9,0($a2)
	   addi $a2, $a2, 1
	   j t1
      t1:  lb $t7,0($a2)
           bnez $t7,y1
      y2:
           sb $t9,0($a3)
	   addi $a3, $a3, 1
	   j t2
      t2:
           lb $t7,0($a3)
           bnez $t7,y2	
           j ch3.2
 
     compare:
         move $s4,$a0
         la $a0,time1
         la $a1,T1
         jal str_to_int
         sw   $t0, 0($a1)         
         jal Convert_24
         sw $t0,T1
         #---------------
         la $a0,time2
         la $a1,T2
         jal str_to_int
         sw   $t0, 0($a1) 
         lw $t0,T2
         jal Convert_24
         sw $t0,T2
         move $a1,$s1
         move $a0,$s4
         #compare
         lw $t0,S_num
         lw $t3,F_num
         lw $t1,T1
         lw $t2,T2

         ble $t1,$t0, i # 1st condition false?
         bge $t1,$t3, i # 2nd condition false?
         move $t4 ,$t1
         j s
      i: move $t4 ,$t0
      
      s: ble $t2,$t0, z 
         bge $t2,$t3, z 
         move $t5 ,$t2
         j d
         
      z: move $t5 ,$t3
     
      d: bne $t4,$t0,P  
         bne $t5,$t3,P
         beq $t1,$t0,P  
         beq $t2,$t3,P
         j h
         
     P: li $t6,45
         move $t0,$t4
         jal int_to_str
         sb $t6,0($a0)
         addi $a0,$a0,1
         move $t0,$t5
         jal int_to_str
         j h1
            
     final:la $a0,Final_slots
           li $v0 ,4
     	   syscall 
     	      li $t9, 0
     	 y3:
           sb $t9,0($a0)
	   addi $a0, $a0, 1
	   j t3
        t3:
           lb $t7,0($a0)
           bnez $t7,y3
   	   la $a0 , Final_slots
     	   j view_calendar
#---------------------------------------------------------
    CH1.4: j Loop   #Return to main menu
#---------------------------------------------------------
view_statistics: 
# number of lectures (in hours), 
#number of OH (in hours), 
#and the number of Meetings (in hour). 
#In addition, the program will show the average lectures per day and the ratio
#between total number of hours reserved for lectures and the total number of hours reserved OH.
         li $t0,0
         li $t1,0
         li $t2,0
         li $t3,0
         li $t4,0
         li $t5,0
         li $t6,0
         li $t7,0
         li $t8,0
         li $t9,0
         la $a1,fileWord 
         la $a2,time1
         la $a3,time2
   ch2.1:
         lb  $t1, 0($a1)
         beq $t1,0,end_sum
         beq $t1,58,w
   slash:beq $t1,32,first1
         addi $a1, $a1, 1
	 j ch2.1 
     w: addi $t3,$t3,1
        j slash
     first1: 
         addi $a1, $a1, 1
         lb  $t1, 0($a1)
         beq $t1,45,ch2.2
         sb $t1,0($a2)
	 addi $a2, $a2, 1
         j first1
     ch2.2:
        addi $a1, $a1, 1
         lb  $t1, 0($a1)
         beq $t1,32,compare1
         sb $t1,0($a3)
	 addi $a3, $a3, 1
         j ch2.2
     #-------------------------------
     compare1:
         la $a0,time1
         jal str_to_int
         jal Convert_24
         move $t9,$t0
      la $a3,time1
      la $a2,time2
    com4:li $t0, 0
         sb $t0,0($a0)
	 addi $a0, $a0, 1
	 j com5
    com5:lb $t2,0($a0)
          bnez $t2,com4
         #---------------
         la $a0,time2
         jal str_to_int
         jal Convert_24
         move $t8,$t0
         #---------------
     com6:li $t0, 0
         sb $t0,0($a0)
	 addi $a0, $a0, 1
	 j com7
    com7:lb $t2,0($a0)
          bnez $t2,com6
          #---------------
         #summation
         sub $t7,$t8,$t9
      x: addi $a1, $a1, 1
         lb  $t1, 0($a1)
         beq $t1,76,sum_L
         beq $t1,72,sum_OH
         beq $t1,77,sum_M
         j x
  sum_L: add $t6,$t6,$t7   
          j com
  sum_OH:add $t5,$t5,$t7
          j com
  sum_M:add $t4,$t4,$t7
          j com
  com: li $t0, 0
        sb $t0,0($a2)
	addi $a2, $a2, 1
	j com1
  com1: lb $t2,0($a2)
        bnez $t2,com
  com2: sb $t0,0($a3)
	addi $a3, $a3, 1
	j com3
  com3: lb $t2,0($a3)
         bnez $t2,com2
         
         la $a2,time1
         la $a3,time2
 complete:
         addi $a1, $a1, 1
         lb  $t1, 0($a1)           
     	 beq $t1,32,first1
     	 beq $t1,10,ch2.1
     	 beq $t1,0,end_sum
     	 j complete
     	
 end_sum:
         la $a0,num_L
         li $v0,4
         syscall
         move $a0,$t6
         li $v0,1
         syscall
         #--------------
         la $a0,num_OH
         li $v0,4
         syscall
         move $a0,$t5
         li $v0,1
         syscall
         #--------------
         la $a0,num_M
         li $v0,4
         syscall
         move $a0,$t4
         li $v0,1
         syscall
         #--------------
         la $a0,Average
         li $v0,4
         syscall
         mtc1 $t6, $f0
         mtc1 $t3, $f1
         cvt.s.w $f0, $f0
         cvt.s.w $f1, $f1
         div.s $f12,$f0,$f1
         li $v0,2
         syscall
         #--------------
         la $a0,ratio
         li $v0,4
         syscall
         mtc1 $t6, $f0
         mtc1 $t5, $f1
         cvt.s.w $f0, $f0
         cvt.s.w $f1, $f1
         div.s $f12,$f0,$f1
         li $v0,2
         syscall
         #--------------
         j Loop
#---------------------------------------------------------
add_appointment:
#---------------------------------------------------------
delete_appointment:
#---------------------------------------------------------
exit_program : li $v0, 10    # Exit program
               syscall
#---------------------------------------------------------
open_file_error: li $v0,4
		 la $a0,error_mssg
		 syscall
		 j main
#---------------------------------------------------------
end_file:
    # Close the file
    li      $v0, 16          # System call for close file
    move    $a0, $s0         # File descriptor
    syscall
#---------------------------------------------------------
remove_newline:
       		lb $t0, 0($a0)
       		beq $t0, 10, found_newline  # Check for newline character
       		beq $t0, 0, end_remove  # Check for null terminator
       		addi $a0, $a0, 1
       		j remove_newline
      found_newline:
    		sb $zero, 0($a0)  # Replace newline character with null terminator
      end_remove:
           jr  $ra
#---------------------------------------------------------         
Convert_24:
	bgt $t0,5,r
	addi $t0,$t0,12
     r: jr  $ra

#---------------------------------------------------------	
str_to_int:
    li   $t0, 0               # Initialize result to 0
    li   $t1, 10              # Set divisor to 10
convert_loop:
    lb   $t2, 0($a0)          # Load a byte from the string
    beq  $t2, 10, done     # If null terminator is reached, exit loop
    beq  $t2, 0, done 
    subiu $t2, $t2, 48        # Convert ASCII to integer 
    mul  $t0, $t0, $t1         # Multiply the current result by 10
    addu  $t0, $t0, $t2         # Add the new digit to the result

    addi $a0, $a0, 1           # Move to the next character in the string
    j    convert_loop
done:
    jr   $ra
#---------------------------------------------------------
int_to_str:
    li $v0, 0      # Clear $v0 for accumulating the digit count
    li $t1, 10     # Divisor for dividing the integer by 10
convert_loop1:
    bge $t0, $t1, continue_loop  # Continue loop if the integer is greater than or equal to the divisor
    addi $t0, $t0, 48    # Convert digit to ASCII
    sb $t0, 0($a0)  # Store the ASCII digit in the buffer
    addi $a0, $a0, 1     # Increment index
    j return # Exit the loop
continue_loop:
    # Divide the integer by 10
    div  $t0, $t1
    mflo $t3        # Quotient (digit)
    mfhi $t0        # Remainder
    # Convert the digit to ASCII and store 
    addi $t3, $t3, 48    # Convert digit to ASCII
    sb $t3, 0($a0)  # Store the ASCII digit in the buffer
    addi $a0, $a0, 1     # Increment buffer index
    j convert_loop1
return:
    jr   $ra
#---------------------------------------------------------
