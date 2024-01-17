# 1201910_Hidaya_Mustafa
# 1201750_Rana_Odeh
.data  
num_day:.asciiz "---> Enter the number of day : "
filename:.asciiz "** Enter the file name :  "
end:.asciiz " -----> There are no appointments on this day\n"
end_S:.asciiz " -----> There are no appointments on this slot\n"
Conflict:.asciiz " -----> There is a conflict with this appointment\n"
error_mssg: .asciiz "\n*Open File error*\n"
option: .asciiz " ---> Enter the day: "
main_menu:"\n--------------------------------\nChoose one of the following options:\n 1.View the calendar.\n 2. View Statistics. \n 3. Add a new appointment.\n 4. Delete an appointment.\n 5.exit\n"
menu1:"\n******************\nChoose one of the following options:\n 1. View the calendar per day.\n 2. View the calendar per set of days.\n 3. View the calendar for a given slot in a given day.\n 4.return to main memu \n"
p_s_slots:.asciiz " ---> Enter the beginning of the slot: "
p_f_slots:.asciiz " ---> Enter the end of the slot: "
type: .asciiz " ---> Enter the type:"
num_L: .asciiz "\n ->Number of lectures (in hours) = "
num_OH: .asciiz "\n ->Number of OH (in hours) = "
num_M: .asciiz "\n ->Number of Meetings (in hours) = "
Average: .asciiz "\n ->Average lectures per day = "
ratio: .asciiz "\n ->Ratio between number of lectures and number of OH = "
No_day: .asciiz "There are no days in the file \n"
nothing: .asciiz "Nothing OH"
not_Range:.asciiz "This hours not in range , Re_enter the values \n"
errorSlot: .asciiz "The slot is not valid as it shares the same starting and ending positions. Please input a valid slot. \n"
add_succes:.asciiz " The appointment has been added successfully \n"
delet_succes:.asciiz " The appointment has been deleted successfully \n"
no_delet:.asciiz " This appointment does not exist \n"
slash_N: .asciiz "\n"
S_num :.word 0
F_num:.word 0
time1:.space 5
time:.space 5
time2:.space 5
T1:.word 0
T2:.word 0
Final_slots:.space 50
str : .space 20 # file name
C_search: .space 10 
fileWord:.space 1024 # value from file
result:.space 100 
add_appointment2: .space 1024
Type: .space 3
buffer: .space 100
TY: .space 3

.text 
.globl main
main:
# Load the filename prompt
la $a0, filename
li $v0, 4
syscall

# Get user input for the filename
la $a0, str            # a0 = address to save the value of the file name
li $a1, 20           # a1 = max length
li $v0, 8              # read str
syscall
jal remove_newline

# Main loop
Loop:
    # Menu options
    li $t1, 1
    li $t2, 2
    li $t3, 3
    li $t4, 4
    li $t6, 5

    # Display the main menu
    la $a0, main_menu
    li $v0, 4
    syscall

    # Get user choice
    li $v0, 5
    syscall
    move $t0, $v0    # Store user choice in $t0

    # Check user choice
    beq $t1, $t0, view_calendar
    beq $t2, $t0, view_statistics
    beq $t3, $t0, add_appointment
    beq $t4, $t0, delete_appointment
    beq $t6, $t0, exit_program

    j Loop
#---------------------------------------------------------

# view_calendar subroutine
view_calendar:
    # Menu options
    li $t1, 1
    li $t2, 2
    li $t3, 3
    li $t4, 4

    # Display the calendar menu
    la $a0, menu1
    li $v0, 4
    syscall

    # Get user choice
    li $v0, 5
    syscall
    move $t5, $v0    # Store user choice in $t5

    # Initialize VAR
    li $t7, 0  
    li $t6, 0  
    li $t8, 0  

    # Check user choice
    beq $t1, $t5, CH1.1  # Option 1
    beq $t2, $t5, CH1.2  # Option 2
    beq $t3, $t5, CH1.3  # Option 3
    beq $t4, $t5, CH1.4  # Option 4

    # Jump back to view_calendar if the choice is not recognized
    j view_calendar

#---------------------------------------------------------

# view the calendar per day
CH1.1: #Open a file to read the calendar data
la $a0, str
li $a1, 0
li $v0, 13           # Open file syscall
syscall

bltz $v0, open_file_error  # Verify that the file is open

move $a0, $v0
la $a1, fileWord
li $a2, 1024
li $v0, 14           # Read file syscall
syscall

li $v0, 16           # Close file syscall
syscall

CH.1: #Get user input for search and handle user options
la $a0, option
li $v0, 4
syscall

la $a0, C_search
li $a1, 10
li $v0, 8
syscall

# Remove newline character from user input
jal remove_newline
la $a1, fileWord

# Check user options
beq $t7, 3, ch3.1
beq $t7, 7, ch3.1

la $a0, result
jal Clean_MEM
la $a2, result
la $a0, C_search

# Search for the specified day in the calendar
find_day:
    li $t3, 58      # ASCII value for ":"
    lb $t0, 0($a0)
    lb $t1, 0($a1)
    beq $t7, 3, c3
    beq $t7, 7, Del4
cont:
    bne $t3, $t1, next
    bnez $t0, next
    j found

next:
    beq $t0, $t1, continue_search
    j not_foundInThisLine

continue_search:
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j find_day

# Process the found day based on user options
found:
    beq $t7, 3, add_appointment1
    beq $t7, 7, delete_app
    addi $a1, $a1, 1
    beq $t6, 3, ch3.1
    lb $t1, 0($a1)
    beq $t1, 10, f_print
    beq $t1, 0, f_print
    sb $t1, 0($a2)
    addi $a2, $a2, 1
    j found

f_print:
    la $a0, result
    li $v0, 4
    syscall
    subi $t8, $t8, 1
    bgtz $t8, Print_DAYS
    j view_calendar

not_foundInThisLine:
    beq $t7, 3, c3.1
    beq $t7, 7, Del4.1
    addi $a1, $a1, 1
    lb $t1, 0($a1)
    beq $t1, 10, NEW_LINE
    beq $t1, 0, END_File
    j not_foundInThisLine

NEW_LINE:
    addi $a1, $a1, 1
    la $a0, result
    jal Clean_MEM
    la $a2, result
    la $a0, C_search
    j find_day

END_File:
    la $a0, end
    li $v0, 4
    syscall
    subi $t8, $t8, 1
    bgtz $t8, Print_DAYS
    j view_calendar

#---------------------------------------------------------

# The program will let the user view the calendar per set of days
CH1.2:
    la $a0, num_day     # Prompt user for the number of days to view
    li $v0, 4
    syscall
    li $v0, 5    # Get user input for the number of days
    syscall
    
    move $t8, $v0  # Store the number of days in $t8
    
Print_DAYS:
    blez $t8, view_calendar      # Check if the number of days is less than or equal to zero
    # Print a newline character
    la $a0, slash_N
    li $v0, 4
    syscall

    j CH1.1       # Jump to the calendar view subroutine 
#---------------------------------------------------------
    CH1.3:  #the program will let the user view the calendar slot in a given day
	li $t6,3
        li $t7,0
	j  CH1.1
#Read the beginning of the slot and convert it to 24 hour system
  ch3.1:la $a0, p_s_slots 
	li $v0 ,4
	syscall
	li $v0, 5              
        syscall
        
        sw   $v0, S_num
        move $t0,$v0
        jal Convert_24
        sw  $t0 , S_num
        move $t1,$t0
#Read the end of the slot and convert it to 24 hour system
	la $a0, p_f_slots 
	li $v0 ,4
	syscall
	li  $v0, 5              
        syscall
        
        sw  $v0, F_num
        move $t0,$v0
        jal Convert_24
        sw  $t0 , F_num
 #Checking that the beginning of the slot entered does not equal its end    
        beq $t0,$t1,error_slot
 #Checking the slot entered is between 8am-5pm  
        beq $t1,17,not_in_range
        beq $t1,6,not_in_range
        beq $t1,7,not_in_range
        beq $t0,7,not_in_range
        beq $t0,6,not_in_range
        beq $t0,8,not_in_range
        j Q
        
not_in_range: la $a0,not_Range 
	      li $v0 ,4
	      syscall
	      j ch3.1
	      
error_slot: la $a0,errorSlot 
	      li $v0 ,4
	      syscall
	      j ch3.1

      Q: beq $t7 ,3 ,add_Type
         beq $t7 ,7,add_Type1
 #To store the contents of the required slot of the Calendar        
      FS:la $a0,Final_slots 
         move $s5,$a0
 #Clean memory        
   ch3.2:la $a0,time1
         jal Clean_MEM
         la $a0,time2
         jal Clean_MEM
         la $a3,time1
         la $a2,time2
 # Here begins the process of cutting and reading the file and searching for the required slot      
  ch3.3:addi $a1, $a1,1
   	 lb  $t1, 0($a1)
   	 beq $t1,45,first
# Store the beginning of the first slot of the desired day  	
	 sb $t1,0($a3)
	 addi $a3, $a3, 1
	 j ch3.3    
	 
  first:addi $a1, $a1, 1
       c:lb  $t1, 0($a1)
         beq $t1,32,space
# Store the end of the first slot of the desired day
         sb $t1,0($a2)
	 addi $a2, $a2, 1
	 addi $a1, $a1, 1
         j c
         
   space:move $s1,$a1
         j compare
 #After taking the beginning and end of the fatha and comparing and finding that the fatha is in conflict, the reading continues today until reaching the next slot and here it stops
     h : addi $a1, $a1, 1
   	 lb  $t1, 0($a1)
   	 beq $t1,',',q
   	 beq $t1,0,final
         beq $t1,10,final
         j h
#After taking the beginning and end of the fatha and comparing and finding that the fatha is in not_conflict, the reading  continues today and storing until reaching the next slot and here it stops
      h1:lb $t1, 0($a1)
   	 sb $t1,0($a0)
	 addi $a0, $a0, 1
   	 beq $t1,44,q
   	 beq $t1,0,final
         beq $t1,10,final
         addi $a1, $a1, 1 
   	 j h1
   	 
      q: addi $a1, $a1, 1
         move $s5,$a0
         j ch3.2
#Here the entered slot is compared with the slot taken from the file        
     compare:
         la $a0,time1
         la $a1,T1
         jal str_to_int
         sw $t0, 0($a1)
         lw $t0,T1
         jal Convert_24
         sw $t0,T1

         la $a0,time2
         la $a1,T2
         jal str_to_int
         sw $t0, 0($a1)
         lw $t0,T2
         jal Convert_24
         sw $t0,T2
         move $a1,$s1
         move $a0,$s5

         lw $t0,S_num
         lw $t3,F_num
         lw $t1,T1
         lw $t2,T2

         blt $t0,$t1, com_con  # Branch to com_con if S_num is less than start time
         blt $t3,$t1, com_con # Branch to com_con if F_num is less than start time
         bgt $t0,$t2, com_con # Branch to com_con if S_num is greater than end time
         bgt $t3,$t2, com_con # Branch to com_con if F_num is greater than end time
         move $t4,$t0 #Copy S_num to $t4
         move $t5,$t3 #Copy F_num to $t5
         j P # Jump to P label To be added
  
com_con: 
         ble $t1,$t0, i 
         bge $t1,$t3, i 
         move $t4 ,$t1
         j s
 #Compare the beginning of the slot        
      i: move $t4 ,$t0
      s: ble $t2,$t0, z 
         bge $t2,$t3, z 
         move $t5 ,$t2
         j d
 #Compare the end of the slot       
      z: move $t5 ,$t3
      d: bne $t4,$t0,P  
         bne $t5,$t3,P
         beq $t1,$t0,P
         beq $t2,$t3,P
         j h
 #  jump here if the slot not conflict     
      P: li $t6,45
         move $t0,$t4
         jal Convert_12
         jal int_to_str
         sb $t6,0($a0)
         addi $a0,$a0,1
         move $t0,$t5
         jal Convert_12
         jal int_to_str
         j h1
         
   final:la $a0,time1
         jal Clean_MEM
         la $a0,time2
         jal Clean_MEM
         la $a0,Final_slots
         beq $t7,3,check
         lb $t1 ,0($a0)
         bnez $t1,endS
         la $a0,end_S 
         
    endS:li $v0 ,4
     	 syscall
     	 jal Clean_MEM
     	 j view_calendar
#---------------------------------------------------------
   CH1.4: j Loop   #Return to main menu
#---------------------------------------------------------
view_statistics:
# Set up to open file and read its contents
la $a0, str        # a0 = address to save the value of the file name
li $a1, 0
li $v0, 13
syscall
bltz $v0, open_file_error  # Verify that the file is open
move $a0, $v0
la $a1, fileWord
li $a2, 1024
li $v0, 14
syscall
li $v0, 16
syscall

# Initialize variables for counting lectures, OH, and Meetings
la $a1, fileWord
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $t6, 0
li $t7, 0
li $t8, 0
li $t9, 0
la $a2, time1
la $a3, time2

# Loop to parse the file and extract time information
ch2.1:
    lb  $t1, 0($a1)
    beq $t1, 0, end_sum    # Check for end of file
    beq $t1, 58, w          # Check for colon (':')
slash:
    beq $t1, 32, first1     # Check for space (' ')
    addi $a1, $a1, 1
    j ch2.1

# Count lectures, OH, and Meetings
w:
    addi $t3, $t3, 1
    j slash

first1:
    addi $a1, $a1, 1
    lb  $t1, 0($a1)
    beq $t1, 45, ch2.2      # Check for hyphen ('-')
    sb $t1, 0($a2)
    addi $a2, $a2, 1
    j first1

ch2.2:
    addi $a1, $a1, 1
    lb  $t1, 0($a1)
    beq $t1, 32, compare1   # Check for space (' ')
    sb $t1, 0($a3)
    addi $a3, $a3, 1
    j ch2.2

# Convert and compare times
compare1:
    la $a0, time1
    jal str_to_int
    jal Convert_24
    move $t9, $t0

    la $a0, time2
    jal str_to_int
    jal Convert_24
    move $t8, $t0

    # Calculate time difference
    sub $t7, $t8, $t9

# Summation of lectures, OH, and Meetings
x:
    addi $a1, $a1, 1
    lb  $t1, 0($a1)
    beq $t1, 76, sum_L       # 'L'
    beq $t1, 72, sum_OH      # 'H'
    beq $t1, 77, sum_M       # 'M'
    j x

sum_L:
    add $t6, $t6, $t7
    j com

sum_OH:
    add $t5, $t5, $t7
    j com

sum_M:
    add $t4, $t4, $t7
    j com

# Cleanup memory and display results
com:
    la $a0, time1
    jal Clean_MEM
    la $a2, time1
    la $a0, time2
    jal Clean_MEM
    la $a3, time2

complete:
    addi $a1, $a1, 1
    lb  $t1, 0($a1)
    beq $t1, 32, first1     # Check for space (' ')
    beq $t1, 10, ch2.1      # Check for newline character
    beq $t1, 0, end_sum     # Check for end of file
    j complete

end_sum:
    # Display results: number of lectures, OH, Meetings, average, and ratio
    la $a0, num_L
    li $v0, 4
    syscall
    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, num_OH
    li $v0, 4
    syscall
    move $a0, $t5
    li $v0, 1
    syscall

    la $a0, num_M
    li $v0, 4
    syscall
    move $a0, $t4
    li $v0, 1
    syscall

    la $a0, Average
    li $v0, 4
    syscall
    # Converting integer values to floating-point for division
    mtc1 $t6, $f0
    beqz $t3, division_by_zero_handler
    mtc1 $t3, $f1
    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1
    li $v0, 2
    syscall

rat:
    la $a0, ratio
    li $v0, 4
    syscall
    # Converting integer values to floating-point for division
    mtc1 $t6, $f0
    beqz $t5, division_by_zero_handler1
    mtc1 $t5, $f1
    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1
    li $v0, 2
    syscall

# Restart the loop
j Loop

# Handlers for division by zero errors
division_by_zero_handler:
    la $a0, No_day
    li $v0, 4
    syscall
    j rat

division_by_zero_handler1:
    la $a0, nothing
    li $v0, 4
    syscall
     # Cleaning memory
    la $a0, time1
    jal Clean_MEM
    la $a0, time2
    jal Clean_MEM
    j Loop

#---------------------------------------------------------
add_appointment:li $t7,3
                li $t9,0
            F1: la $a3,add_appointment2
                j CH1.1
# add_Type label, prepare for Type input
      add_Type:la $a0,Type
               jal Clean_MEM
                la $a0 ,type
   		li $v0 , 4
     	        syscall
     	        la $a0 ,Type
   	        li $v0 ,8
   	        syscall 
   	        la $a0,C_search 
		j find_day
		
# c3 label, store $t1 at $a3, continue to cont
           c3:  sb $t1,0($a3)
		addi $a3, $a3, 1
                j cont
 # c3.1 label, add newline character and continue
          c3.1: addi $a1, $a1, 1
   		lb  $t1, 0($a1)
   		beq $t1, 10, c3.2
	 	beq $t1,0,add_newLine
   		sb $t1 ,0($a3)
   		addi $a3, $a3, 1
   		j c3.1
 # c3.2 label, continue finding day
   	   c3.2:sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        la $a0,C_search
   	        addi $a1, $a1, 1
   	        lb  $t1, 0($a1)
   	        beq $t1,0,add_newLine1
   	        j find_day
   	        
# add_appointment1 label, prepare for buffer input   	        
add_appointment1:la $a2 ,buffer
                 addi $a1, $a1, 1
                 move $s4,$a1
# add_appointment12 label, copy buffer to a2 until newline or null character                 
add_appointment12:        
                 lb  $t1, 0($a1)
                 beq $t1,10, addit
                 beq $t1,0, addit
   		 sb $t1 ,0($a2)
   		 sb $t1, 0($a1)
   	         addi $a2, $a2, 1
   	         addi $a1, $a1, 1
   	         j add_appointment12
# addit label, increment a1 and jump to FS
   	   addit:addi $a1, $a1, 1
		 move $s3,$a3
		 move $a1,$s4
		 j FS
         check: move $a3,$s3
                la $a2 ,buffer
     Check_Line:lb $t0 ,0($a0)
                li $t9,5
		bnez $t0,printConflict
		la $a0,add_succes 
    	        li $v0 ,4
    	        syscall 
    ADD_LINE1:la $a0,time
              jal Clean_MEM
              la $a0,time
# ADD_LINE labels, add characters to a3
     ADD_LINE:addi $a2, $a2,1
   	      lb  $t1, 0($a2)
   	      beq $t1,45,SUB_NUM1
	      sb $t1,0($a0)
	      addi $a0, $a0, 1
	      j  ADD_LINE
  # SUB_NUM1 label, convert time to 24-hour format and check for conflicts	      
   SUB_NUM1:  la $a0,time
              jal str_to_int
              jal Convert_24
              lw,$t8,F_num
              ble $t8,$t0,add_app
           RE:li $t1,32
              sb $t1,0($a3)
              addi $a3, $a3,1
              la $a0,time
# N1 label, copy characters from time to a3 until null character
         N1:  lb $t1,0($a0)
              beqz $t1,CN1
   	      sb $t1,0($a3)
   	      addi $a0, $a0,1
   	      addi $a3, $a3,1
   	      j N1   	      
   	  CN1:lb $t1,0($a2)
   	      beqz $t1,add_app1
   	      sb $t1,0($a3)
   	      addi $a3, $a3,1
   	      addi $a2, $a2,1
   	      beq $t1,44,ADD_LINE1
              j CN1
 # add_app1 label, clean memory, add comma to a3, and jump to add_app              
     add_app1:la $a0,buffer
              jal Clean_MEM
              li $t1,44
   	       sb $t1 ,0($a3)
              addi $a3, $a3, 1
              j add_app
 # printConflict label, print conflict message and jump to conflict
printConflict:la $a0,Conflict 
    	      li $v0 ,4
     	      syscall
       conflict:lb  $t1, 0($a2)
                beq $t1,0,cc
   		sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a2, $a2, 1
                j  conflict   	        
    add_newLine1:subi $a3, $a3, 1
                 beq $t9,5, Write_File
 # add_newLine labels, add newline character and continue
   add_newLine: beq $t9,5, Write_File
                la $a0,C_search
   	        li $t1,10
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
# cont_day label, copy characters from C_search to a3 until null character	        
       cont_day:lb  $t1, 0($a0)
   	        beqz $t1,con_add_slot
   		sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j cont_day
# con_add_slot label, add : character to a3
   con_add_slot:move $s6,$a0
                la $a0,add_succes 
    	        li $v0 ,4
    	        syscall
    	        move $a0,$s6
                li $t1,58
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
 # add_app label, add space character to a3 and convert and add S_num and F_num to a3
       add_app:li $t1,32
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        lw,$t0,S_num
   	        jal Convert_12
   	        la $a0,time1
   	        jal int_to_str
   	        la $a0,time1
# num1 label, copy characters from time1 to a3 until null character
   	   num1:lb $t1,0($a0)
   	        beqz $t1,pre_num2
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j num1
 # pre_num2 label, add hyphen character to a3 and convert and add F_num to a3
      pre_num2: li $t1,45
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        lw,$t0,F_num
   	        jal Convert_12
   	        la $a0,time2
   	        jal int_to_str
   	        la $a0,time2
 # num2 label, copy characters from time2 to a3 until null character
   	   num2:lb $t1,0($a0)
   	        beqz $t1,post_num2
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j num2
 # post_num2 label, add space character to a3 and convert and add Type to a3   	        
     post_num2:li $t1,32
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        la $a0,Type
 # TYPE label, copy characters from Type to a3 until newline character
   	   TYPE:lb $t1,0($a0)
   	        beq $t1,10,AddNewLine
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j TYPE
 # AddNewLine label, clean memory and add newline characters
   AddNewLine:la $a0,time1
              jal Clean_MEM
              la $a0,time2
              jal Clean_MEM
              la $a0,S_num
              jal Clean_MEM
              la $a0,F_num
              jal Clean_MEM
              bne $t9,5, Write_File
              la $a0,buffer
              lb $t1,0($a0)
              beqz $t1,cc
   	      li $t1,44
   	      sb $t1 ,0($a3)
              addi $a3, $a3, 1
              li $t1,32
              sb $t1 ,0($a3) 
              addi $a3, $a3, 1
              la $a0 ,time
              
 # ADD_T1 label, copy characters from time to a3 until null character
         ADD_T1:lb $t1,0($a0)
                beqz $t1,CLEAR
   	        sb $t1 ,0($a3) 
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	      j ADD_T1
   	      
    CLEAR:  la $a0,time
             jal Clean_MEM
# CN2 label, copy characters from buffer to a3 until null character
      CN2:   lb $t1,0($a2)
   	     beqz $t1,cc
   	     sb $t1,0($a3)
   	     addi $a3, $a3,1
   	     addi $a2, $a2,1
             j CN2
 # cc label, add newline character to a3 and jump to c3.1              
        
        cc:  li $t1,10
             sb $t1 ,0($a3) 
             addi $a3, $a3, 1
             j c3.1
              

 # Write_File label, write the content of add_appointment2 to a file             
 Write_File:
               la $a0,str
    	       la $a1,1
   	       li $v0,13
   	        syscall
   	        move $a0,$v0
   	        la $a1,add_appointment2
   	        li $a2,1000
   	        li $v0,15
   	        syscall
   	        li $v0,16
   	        syscall
   	        la $a0,add_appointment2
   	        jal Clean_MEM 
                la $a0 ,buffer  
                jal Clean_MEM
                la $a0 ,Final_slots 
                jal Clean_MEM
                j Loop
#---------------------------------------------------------
delete_appointment: # This part will delete the input slote
                   li $t7,7              
                   la $a3,add_appointment2  
                   j CH1.1            

add_Type1:         la $a0,Type           
                   jal Clean_MEM        # Jump and link to Clean_MEM to clean type
                   la $a0 ,type          
   		   li $v0 , 4             # (syscall for print string)
     	           syscall               
     	           la $a0 ,Type         
   	           li $v0 ,8             # (syscall for read string)
   	           syscall               
   	           la $a0,C_search       
		   j find_day            

Del4:              sb $t1,0($a3)          
   	           addi $a3, $a3, 1      
                   j cont                  

Del4.1:         addi $a1, $a1, 1       
   		 lb  $t1, 0($a1)         
   		 beq $t1, 10, Del4.2     # Branch to Del4.2 if $t1 is newline
	 	 beq $t1,0,Write_File1   # Branch to Write_File1 if $t1 is null (end of string)
   		 sb $t1 ,0($a3)          # Store the byte from $t1 into the destination address
   		 addi $a3, $a3, 1      
   		 j Del4.1              

Del4.2:         sb $t1 ,0($a3)       # Store the newline character into the destination address
   	        addi $a3, $a3, 1      
   	        la $a0,C_search       
   	        addi $a1, $a1, 1      
   	        lb  $t1, 0($a1)         
   	        beq $t1,0,Write_File1  # Branch to Write_File1 if $t1 is null (end of sourse mem )
   	        j find_day          

delete_app:       addi $a1,$a1,1          
                  la $a0 ,time1           
                  jal Clean_MEM           
                  la $a0 ,time2           
                  jal Clean_MEM           
                  la $a0 ,TY              
                  jal Clean_MEM           
                  la $a0,time1            # Load address of the string time1 into $a0
                  la $a2,time2            # Load address of the string time2 into $a2

delete_app2:      addi $a1, $a1, 1        
                  lb  $t1, 0($a1)          
                  beq $t1,45, Del4.3      # Branch to Del4.3 if $t1 is '-' (hyphen)
   	          sb $t1 ,0($a0)          
   	          addi $a0, $a0, 1     
   	          j delete_app2           

Del4.3:           addi $a1, $a1, 1        
                 lb  $t1, 0($a1)           
                 beq $t1,32, Del4.T       # Branch to Del4.T if $t1 is space
                 sb $t1 ,0($a2)           
   	         addi $a2, $a2, 1      
                 j Del4.3                

 Del4.T:          la $a2,TY                # Load address of the string TY into $a2
 Del4.4:          addi $a1, $a1, 1         
                  lb  $t1, 0($a1)          # Load the byte from the source address into $t1
                  beq $t1,10, user_Type1   # Branch to user_Type1 if $t1 is newline
                  beq $t1,0, user_Type2    # Branch to user_Type2 if $t1 is null (end of string)
                  beq $t1,44,user_Type3    # Branch to user_Type3 if $t1 is ',' (comma)
                  sb $t1 ,0($a2)           # Store the byte from $t1 into the destination address
   	          addi $a2, $a2, 1      
   	          j Del4.4                 
   	   
user_Type1:       jal user_Type           # Jump and link to user_Type subroutine
                  beq $t9,7,cont_store     # Branch to cont_store if $t9 is 7
                  subi $a3,$a3,1           
                  j cont_store              
           
user_Type2:       jal user_Type           # Jump and link to user_Type subroutine
                  beq $t9,7,Write_File1    # Branch to Write_File1 if $t9 is 7
                  subi $a3,$a3,1          
                  j Write_File1            
           
user_Type3:     jal user_Type           # Jump and link to user_Type subroutine
  	        beq $t9,8,add_one       # Branch to add_one if $t9 is 8
  	        li $t1,44                
                sb $t1,0($a3)           # Store the ',' (comma) into the destination address
                addi $a3,$a3,1           
  	         j delete_app              
  	         
add_one:          addi $a1,$a1,1           
cont_store:       lb $t1,0($a1)             
                  beq $t1,0, Write_File1   # Branch to Write_File1 if $t1 is null (end of string)
                  sb $t1,0($a3)            
                  addi $a1,$a1,1           
                  addi $a3,$a3,1           
                  j cont_store  
            	  	  
#***********   
user_Type:
          move $s0,$ra  # Save the return address

          li $t9,7        # Load immediate value 7 into register $t9
          la $a2,TY       # Load address of the string TY into $a2
          la $a0,Type     # Load address of the string Type into $a0 	
          lb  $t0, 0($a2) # Load the first byte of TY into $t0
	  lb  $t1, 0($a0) # Load the first byte of Type into $t1
	  beq $t0,$t1,comp_time # Branch to comp_time if characters match to check time slote
	  j not_delet      # Jump to not_delet if characters do not match to add this slote in mem dont delete

comp_time: 
           move $s2,$a1   # Move $a1 to $s2
           la $a0,time1   # Load address of the string time1 into $a0
           la $a1,T1      # Load address of the string T1 into $a1
           jal str_to_int # Jump and link to str_to_int subroutine
           sw $t0, 0($a1)  # Store the integer value in T1
           lw $t0,T1       # Load the value back into $t0
           jal Convert_24  # Jump and link to Convert_24 subroutine
           sw $t0,T1       # Store the result in T1

           #---------------
           la $a0,time2   # Load address of the string time2 into $a0
           la $a1,T2      # Load address of the string T2 into $a1
           jal str_to_int # Jump and link to str_to_int subroutine
           sw $t0, 0($a1)  # Store the integer value in T2
           lw $t0,T2       # Load the value back into $t0
           jal Convert_24  # Jump and link to Convert_24 subroutine
           sw $t0,T2       # Store the result in T2
           #---------------
           move $a1,$s2   # Move $s2 back to $a1
           lw $t0,S_num     # Load the value of S_num into $t0
           lw $t3,F_num     # Load the value of F_num into $t3
           lw $t1,T1        # Load the value of T1 into $t1
           lw $t2,T2        # Load the value of T2 into $t2
          #---------------
           blt $t1,$t0, not_delet  # Branch to not_delet if T1 < S_num
           bgt $t1,$t3, not_delet  # Branch to not_delet if T1 > F_num
           blt $t2,$t0, not_delet  # Branch to not_delet if T2 < S_num
           bgt $t2,$t3, not_delet  # Branch to not_delet if T2 > F_num
           la $a0,delet_succes 
    	   li $v0 ,4
    	   syscall 
           li $t9,8         
    move $ra,$s0        # Move $s0 back to $ra
    jr  $ra             # Jump to the return address with delete this slot
 
 not_delet:     li $t1,32      
   	        sb $t1 ,0($a3)   # Store the space character in the destination address
   	        addi $a3, $a3, 1 
   	        la $a0,time1    
   	 D_num1:lb $t1,0($a0)  
   	        beqz $t1,D_pre_num2  # Branch to D_pre_num2 if $t1 is zero (end of time1)
   	        sb $t1 ,0($a3)   # Store the byte in the destination address
   	        addi $a3, $a3, 1 
   	        addi $a0, $a0, 1 
   	        j D_num1        

    D_pre_num2: li $t1,45   # Load immediate value 45 (ASCII for '-') into register $t1
   	        sb $t1 ,0($a3)   # Store the '-' character in the destination address
   	        addi $a3, $a3, 1 
   	        la $a0,time2    
   	D_num2: lb $t1,0($a0)  
   	        beqz $t1,D_post_num2  # Branch to D_post_num2 if $t1 is zero (end of time2)
   	        sb $t1 ,0($a3)   
   	        addi $a3, $a3, 1 
   	        addi $a0, $a0, 1 
   	        j D_num2        

  D_post_num2:  li $t1,32  
   	        sb $t1 ,0($a3)   # Store the space character in the destination address
   	        addi $a3, $a3, 1 
   	        la $a0,TY        
   	D_TYPE: lb $t1,0($a0)  # Load the byte from TY into $t1
   	        beq $t1,0,D_retutn  # Branch to D_retutn if $t1 is zero (end of type)
   	        sb $t1 ,0($a3)   
   	        addi $a3, $a3, 1 
   	        addi $a0, $a0, 1 
   	        j D_TYPE       
     D_retutn:
   	        move $ra,$s0          # Move $s0 back to $ra
   	        jr  $ra               # Jump to the return address
   	      #**********
 Write_File1:
    la $a0, str               # Load the address of the string "str" into $a0 --str include file name
    la $a1, 1                 # Load constant value 1 into $a1 to write in file
    li $v0, 13                # System call for open file
    syscall                   

    move $a0, $v0             # Move the result of the syscall into $a0
    la $a1, add_appointment2  # Load the address of add_appointment2 into $a1
    li $a2, 1000              # Set constant value 1000 to $a2
    li $v0, 15                # System call for reading a line of input
    syscall                   # Invoke the system call

    li $v0, 16                # System call for printing an integer (presumably for debugging)
    syscall                   # Invoke the system call

    la $a0, add_appointment2 # Load the address of add_appointment2 into $a0
    jal Clean_MEM # Call the Clean_MEM function to zero out memory
    beq $t9,8,finish          
    la $a0,no_delet 
    li $v0 ,4
    syscall 
    finish:j Loop
    
#---------------------------------------------------------
exit_program :li $v0, 10    # Exit program
              syscall
#---------------------------------------------------------
Clean_MEM:  #This function to clean memory
    li $t0, 0          
    sb $t0, 0($a0)     # Store the value in $t0 (0) at the memory address pointed to by $a0
    addi $a0, $a0, 1    
    j T4                
T4:
    lb $t2, 0($a0)      # Load a byte from the memory address pointed to by $a0 into $t2
    bnez $t2, Clean_MEM 
    jr $ra              
#---------------------------------------------------------  
open_file_error:   # Handles an error condition related to opening a file.
    li $v0, 4             
    la $a0, error_mssg   # Load the address of the error message into $a0
    syscall               
    j main                # Jump to the main part of the program
#---------------------------------------------------------
remove_newline:    #This function Removes newline characters from a null-terminated string.
    lb $t0, 0($a0)        
    beq $t0, 10, found_newline  # Check for newline character (ASCII 10)
    beq $t0, 0, end_remove  # Check for null terminator (end of string)
    addi $a0, $a0, 1      
    j remove_newline      
found_newline:
    sb $zero, 0($a0)      # Replace newline character with null terminator
end_remove:
    jr $ra                # Jump to the return address
#---------------------------------------------------------         
Convert_24:    # This function converts hours to type 24
    bgt $t0, 5, r  
    addi $t0, $t0, 12  
r:
    jr $ra  # Jump to the return address
#---------------------------------------------------------         
Convert_12:    #This function Convert hours to type 12
    ble $t0, 12, r1    
    subi $t0, $t0, 12  
r1:
    jr $ra             # Jump to the return address
#---------------------------------------------------------
	
str_to_int:  #This function Convert ASCII to integer 
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

int_to_str:      # This function Convert the digit to ASCII and store 
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
    addi $t3, $t3, 48    # Convert digit to ASCII
    sb $t3, 0($a0)  # Store the ASCII digit in the MEM
    addi $a0, $a0, 1     
    j convert_loop1
return:
    jr   $ra
#---------------------------------------------------------
