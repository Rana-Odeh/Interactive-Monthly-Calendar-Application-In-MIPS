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
errorSlot: .asciiz "The slot is not valid as it shares the same starting and ending positions. Please input a valid slot. \n"
slash_N: .asciiz "\n"
S_num :.word 0
F_num:.word 0
time1:.space 5
time:.space 5
time2:.space 5
T1:.word 0
T2:.word 0
Final_slots:.space 50
str : .space 10 # file name
C_search: .space 10 
fileWord:.space 1024 # value from file
result:.space 100 
add_appointment2: .space 1024
Type: .space 3
buffer: .space 100
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
      li $t7,0
      li $t6,0
      li $t8,0
      beq $t1,$t5,CH1.1  # option 1
      beq $t2,$t5,CH1.2  # option 2
      beq $t3,$t5,CH1.3  # option 3
      beq $t4,$t5,CH1.4  # option 4
      j view_calendar
#---------------------------------------------------------
    CH1.1:	#the program will let the user view the calendar per day
         la $a0 ,str # a0=address to save value of file name
         li $a1 , 0
         li $v0 ,13
         syscall
         bltz $v0, open_file_error # Verify that the file is open
         move $a0,$v0
         la $a1 , fileWord 
         li $a2,1024
         li $v0, 14
         syscall
         li $v0, 16
         syscall
	CH.1:	la $a0,option  
		li $v0 ,4
		syscall
		la $a0,C_search
		li $a1,10
		li $v0 ,8
		syscall 
	        jal remove_newline
	        la $a1 , fileWord 
	        beq $t7,3, ch3.1
	        la $a0 ,result 
                jal Clean_MEM
		la $a2 , result
		la $a0,C_search
      find_day:li $t3, 58 # ASCII value for ":"
		lb  $t0, 0($a0)
		lb  $t1, 0($a1)
		beq $t7,3,c3
	   cont:bne  $t3, $t1, next
		bnez $t0,next
		j found 
          next:beq  $t0, $t1, continue_search  
   		j not_foundInThisLine
continue_search:addi $a0, $a0, 1       
   		addi $a1, $a1, 1       
   		j find_day
        found: beq $t7 ,3,add_appointment1
   		addi $a1, $a1, 1
   		beq $t6,3, ch3.1
   		lb  $t1, 0($a1)
   		beq $t1, 10, f_print
	 	beq $t1,0,f_print
	 	sb $t1,0($a2)
	 	addi $a2, $a2, 1
	 	j found 
	f_print:la $a0,result
	        li $v0 ,4
	 	syscall
	        subi $t8,$t8,1
	        bgtz $t8,m 
	        j view_calendar
not_foundInThisLine:
	 	beq $t7 ,3,c3.1
        	addi $a1, $a1, 1
   		lb  $t1, 0($a1)
   		beq $t1, 10, f
	 	beq $t1,0,k
   		j not_foundInThisLine
   	     f :addi $a1, $a1, 1
   	        la $a0 , result
   	        jal Clean_MEM
   	        la $a2 , result
   	        la $a0,C_search
   	        j find_day	
              k:la $a0,end
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
    m:  blez $t8,view_calendar
        la $a0,slash_N  
	li $v0 ,4
	syscall
	j CH1.1
#---------------------------------------------------------
    CH1.3:  #the program will let the user view the calendar slot in a given day
	li $t6,3
        li $t7,0
	j  CH1.1
  ch3.1:la $a0, p_s_slots 
	li $v0 ,4
	syscall
	li   $v0, 5              
        syscall
        sw   $v0, S_num
        move $t0,$v0
        jal Convert_24
        sw  $t0 , S_num
        move $t1,$t0
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
        beq $t0,$t1,error_slot
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

        #---------------
      Q: beq $t7 ,3 ,add_Type
      FS:la $a0,Final_slots 
         move $s5,$a0
   ch3.2:la $a0,time1
         jal Clean_MEM
         la $a0,time2
         jal Clean_MEM
         la $a3,time1
         la $a2,time2
   ch3.3:addi $a1, $a1,1
   	 lb  $t1, 0($a1)
   	 beq $t1,45,first
	 sb $t1,0($a3)
	 addi $a3, $a3, 1
	 j ch3.3    
  first:addi $a1, $a1, 1
       c:lb  $t1, 0($a1)
         beq $t1,32,space
         sb $t1,0($a2)
	 addi $a2, $a2, 1
	 addi $a1, $a1, 1
         j c
   space:move $s1,$a1
         j compare
     h : addi $a1, $a1, 1
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
         move $s5,$a0
         j ch3.2
     compare:
         la $a0,time1
         la $a1,T1
         jal str_to_int
         sw $t0, 0($a1)
         lw $t0,T1
         jal Convert_24
         sw $t0,T1
         #---------------
         la $a0,time2
         la $a1,T2
         jal str_to_int
         sw $t0, 0($a1)
         lw $t0,T2
         jal Convert_24
         sw $t0,T2
         move $a1,$s1
         move $a0,$s5
         #compare
         lw $t0,S_num
         lw $t3,F_num
         lw $t1,T1
         lw $t2,T2
         #---------------
         blt $t0,$t1, com_con 
         blt $t3,$t1, com_con 
         bgt $t0,$t2, com_con
         bgt $t3,$t2, com_con 
         move $t4,$t0
         move $t5,$t3
         j P
  
com_con:  #---------------
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
# number of lectures (in hours), 
#number of OH (in hours), 
#and the number of Meetings (in hour). 
#verage lectures per day 
#the ratio between total number of lectures and the total number of OH.
         la $a0 ,str # a0=address to save value of file name
         li $a1 , 0
         li $v0 ,13
         syscall
         bltz $v0, open_file_error # Verify that the file is open
         move $a0,$v0
         la $a1 , fileWord 
         li $a2,1024
         li $v0, 14
         syscall
         li $v0, 16
         syscall
         la $a1 , fileWord 
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
  first1:addi $a1, $a1, 1
         lb  $t1, 0($a1)
         beq $t1,45,ch2.2
         sb $t1,0($a2)
	 addi $a2, $a2, 1
         j first1
   ch2.2:addi $a1, $a1, 1
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
         #---------------
         la $a0,time2
         jal str_to_int
         jal Convert_24
         move $t8,$t0
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
     com: la $a0,time1
          jal Clean_MEM
          la $a2,time1
          la $a0,time2
          jal Clean_MEM
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
         beqz $t3,division_by_zero_handler
         mtc1 $t3, $f1
         cvt.s.w $f0, $f0
         cvt.s.w $f1, $f1
         div.s $f12,$f0,$f1
         li $v0,2
         syscall
     rat:la $a0,ratio
         li $v0,4
         syscall
         mtc1 $t6, $f0
         beqz $t5,division_by_zero_handler1
         mtc1 $t5, $f1
         cvt.s.w $f0, $f0
         cvt.s.w $f1, $f1
         div.s $f12,$f0,$f1
         li $v0,2
         syscall
         #--------------
         j Loop
division_by_zero_handler:
         la $a0 ,No_day
         li $v0,4
         syscall 
         j rat
division_by_zero_handler1:
         la $a0 ,nothing
         li $v0,4
         syscall 
        la $a0,time1
        jal Clean_MEM
        la $a0,time2
        jal Clean_MEM
         j Loop
#---------------------------------------------------------
add_appointment:li $t7,3
                li $t9,0
            F1: la $a3,add_appointment2
                j CH1.1
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
             c3:sb $t1,0($a3)
		addi $a3, $a3, 1
                j cont
          c3.1:addi $a1, $a1, 1
   		lb  $t1, 0($a1)
   		beq $t1, 10, c3.2
	 	beq $t1,0,add_newLine
   		sb $t1 ,0($a3)
   		addi $a3, $a3, 1
   		j c3.1
   	   c3.2:sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        la $a0,C_search
   	        addi $a1, $a1, 1
   	        lb  $t1, 0($a1)
   	        beq $t1,0,add_newLine1
   	        j find_day
add_appointment1:la $a2 ,buffer
                 addi $a1, $a1, 1
                 move $s4,$a1
add_appointment12:        
                 lb  $t1, 0($a1)
                 beq $t1,10, addit
                 beq $t1,0, addit
   		 sb $t1 ,0($a2)
   		 sb $t1, 0($a1)
   	         addi $a2, $a2, 1
   	         addi $a1, $a1, 1
   	         j add_appointment12
   	   addit:addi $a1, $a1, 1
		 move $s3,$a3
		 move $a1,$s4
		 j FS
         check: move $a3,$s3
                la $a2 ,buffer
     Check_Line:lb $t0 ,0($a0)
                li $t9,5
		bnez $t0,printConflict
    ADD_LINE1:la $a0,time
              jal Clean_MEM
              la $a0,time
     ADD_LINE:addi $a2, $a2,1
   	      lb  $t1, 0($a2)
   	      beq $t1,45,SUB_NUM1
	      sb $t1,0($a0)
	      addi $a0, $a0, 1
	      j  ADD_LINE
   SUB_NUM1:  la $a0,time
              jal str_to_int
              jal Convert_24
              lw,$t8,F_num
              ble $t8,$t0,add_app
           RE:li $t1,32
              sb $t1,0($a3)
              addi $a3, $a3,1
              la $a0,time
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
     add_app1:la $a0,buffer
              jal Clean_MEM
              li $t1,44
   	       sb $t1 ,0($a3)
              addi $a3, $a3, 1
              j add_app
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
   add_newLine: beq $t9,5, Write_File
                la $a0,C_search
   	        li $t1,10
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1	        
       cont_day:lb  $t1, 0($a0)
   	        beqz $t1,con_add_slot
   		sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j cont_day
      con_add_slot:li $t1,58
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
       add_app:li $t1,32
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        lw,$t0,S_num
   	        jal Convert_12
   	        la $a0,time1
   	        jal int_to_str
   	        la $a0,time1
   	   num1:lb $t1,0($a0)
   	        beqz $t1,pre_num2
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j num1
      pre_num2: li $t1,45
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        lw,$t0,F_num
   	        jal Convert_12
   	        la $a0,time2
   	        jal int_to_str
   	        la $a0,time2
   	   num2:lb $t1,0($a0)
   	        beqz $t1,post_num2
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j num2
     post_num2:li $t1,32
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        la $a0,Type
   	   TYPE:lb $t1,0($a0)
   	        beq $t1,10,AddNewLine
   	        sb $t1 ,0($a3)
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	        j TYPE
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
         ADD_T1:lb $t1,0($a0)
                beqz $t1,CLEAR
   	        sb $t1 ,0($a3) 
   	        addi $a3, $a3, 1
   	        addi $a0, $a0, 1
   	      j ADD_T1
   	   CLEAR:
   	       la $a0,time
              jal Clean_MEM
       CN2:   lb $t1,0($a2)
   	       beqz $t1,cc
   	       sb $t1,0($a3)
   	       addi $a3, $a3,1
   	       addi $a2, $a2,1
              j CN2
            cc:
              li $t1,10
              sb $t1 ,0($a3) 
              addi $a3, $a3, 1
              j c3.1
              
   Write_File:la $a0,str
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
delete_appointment:

#---------------------------------------------------------
exit_program :li $v0, 10    # Exit program
              syscall
#---------------------------------------------------------
Clean_MEM :     li $t0, 0
                sb $t0,0($a0)
                addi $a0, $a0, 1
	        j T4
            T4: lb $t2,0($a0)
	        bnez $t2,Clean_MEM 
	        jr $ra
#---------------------------------------------------------  
open_file_error:
              li $v0,4
	       la $a0,error_mssg
	       syscall
               j main
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
Convert_12:
	ble $t0,12,r1
	subi $t0,$t0,12
    r1: jr  $ra
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
