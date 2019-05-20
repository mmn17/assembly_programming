


#/*************************************************************************
#*  Name: Mohammed Namadi                                                 *
#*                                                                        *
#*  Project: Implementation of Sudoku Game simulation                     *
#*************************************************************************/


		.data 
	#SPACE:	.asciiz " "
	Hello:  .asciiz "\nHello,Enter a file name: \n"
			.align 2
	NoFile: .asciiz "Error encountered, file did not open\n" 
	Invalid: .asciiz "\nError: Invalid Sudoku Game! \n"
	TheValue: .asciiz "The value [ "
	Column: .asciiz " ] was encountered more than once in column: "
	Row: .asciiz " ] was encountered more than once in row: "
	Quadrant: .asciiz " ] was encountered more than once in quadrant: "

					.align 2
	BAR:			.byte	'|'
	EOL:			.byte '\n'
	EOL1:			.byte ' '
	UNDER:			.asciiz "-------------------\n"
	SUDOKU:		 .space 164
	REAL_SUDOKU:		 .space 328
	NUllCh:			.word 0
	Filename:		.space 256	
	arr1:			.space 108
	arr2:			.space 108
	arr3:			.space 108
					.align 2

				.text
				.globl main
	main: 

# ###################################################################################
# #  -	Get the filename and it's contant of the file                               #
# ###################################################################################

			addiu $sp,$sp,-4		
			sw $ra,0($sp)
			la	$a0,Filename			
			jal	Open_File

			move $s0,$v0
			lw $ra,0($sp)
			addiu $sp,$sp,4


			li $v0,14
			move	$a0,$s0
			la	$a1,SUDOKU
			li $a2,400
			syscall

# ###################################################################################
# #  -	Initialization list                                                         #
# ###################################################################################
			
			la		$s1,SUDOKU	 		# load Sudoku into register $s1;
			la      $s5,REAL_SUDOKU
			la      $s2,arr1
			la 		$s3,arr2
			la 		$s4,arr3
			li      $t0,81       		 # main counter is initialize to 9x9 size;
			li 		$t1,4                # counter1;  
			li      $t2,7				 # counter2;  
			li		$t3,0
			li 		$t5,10
			li      $t6,9

	loop:
			
			lb $s0,0($s1)  
			addiu $s1,$s1,2  

# ###################################################################################
# #  -	Subtract asciiz number of zero to change to actual number.                  #
# ###################################################################################
			#----------------------
			addiu $s0,$s0,-48        
			#----------------------

			#blt $s0,$zero,NegetivaNum    	# Negative number can also be check here if needed.
			addiu $t3,$t3,1 			    # Normal counter.

			sw	  $s0,0($s5)				# Real Sudoku.
			addiu $s5,$s5,4

			slt $t4,$t3,$t1
			beq $t4,$zero,Else1
			sw	  $s0,0($s2)
			addiu $s2,$s2,4

			j Endif


# ################################################################################
# #  -	Distributing the sudoku into three different sub-columns arrays.         #
# #  - 	Arr1, Arr2, and Arr3.                                                    #
# #                        ----------------------                                #
# #                        | Arr1 | Arr2 | Arr3 |                                #
# #                        ----------------------                                #
# #                        | Arr1 | Arr2 | Arr3 |                                #
# #                        ----------------------                                #
# #                        | Arr1 | Arr2 | Arr3 |                                #
# #                        ----------------------                                #
# ################################################################################

		Else1:
			li $t4,0
			slt $t4,$t3,$t2
			beq $t4,$zero,Else2
			sw $s0,0($s3)
			addiu $s3,$s3,4

			j Endif

		Else2:
			li $t4,0
			slt $t4,$t3,$t5
			beq $t4,$zero,Endif
			sw $s0,0($s4)
			addiu $s4,$s4,4

		Endif:
			bgt		$t6, $t3, Endif2	# if $t3 > $t1 then target
			li 		$t3,0  

		Endif2:
		 	addiu $t0,$t0,-1         	
			bne $t0,$zero,loop 


# ###################################################################################
# #  -	Calling the print function on the Sudoku Game 2D array.                     #
# ###################################################################################

			li	$v0,11		# Tell syscall to print a character
			lb	$a0,EOL		# Print end of line
			syscall


			la	$a0,SUDOKU
			la $a1,9
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)	
			jal	PRINT_FUNCTION		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	

# ###################################################################################
# #  -	Checking each row for validity.                                             #
# ###################################################################################

			li $t0,9
			li	$s7,0
			li $a0,0
			li $a1,0
			la	$a0,REAL_SUDOKU
			la	$a1,REAL_SUDOKU			
	ROW:
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			addiu	$s7,$s7,1
			move	$s6,$a1
			li  $t6,1
			
			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip_row
			j skiip_row

	skip_row:
			li $v0,4
			la $a3,Invalid
			syscall

			li $v0,4
			la $a3,TheValue
			syscall

			li $v0,1
			move $a3,$s6
			syscall

			li $v0,4
			la $a3,Row
			syscall

			li $v0,1
			move $a3,$s7
			syscall

			jr	$ra
	skiip_row:


			addiu	$t0,$t0,-1
			addiu $a0,$a0,36
			addiu $a1,$a1,36
			bne   $t0,$zero,ROW  

# ###################################################################################
# #  -	Calling the check validity function to check columns.                       #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,0
			la	$a0,REAL_SUDOKU
			la	$a1,REAL_SUDOKU	
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid_Col		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			move	$s7,$a0
			move	$t2,$a1
			li  $t6,1
			bne   $a2,$t6,skip_col
			j skiip_col

	skip_col:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Column
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip_col:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 1.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,1
			la	$a0,arr1
			la	$a1,arr1	
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip9
			j skiip9

	skip9:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip9:

# ###################################################################################
# #  -	Calling the check validity function to check quadrant 4.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,4
			la	$a0,arr1
			la	$a1,arr1	
			addiu	$a0,$a0,36
			addiu	$a1,$a1,36
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip8
			j skiip8

	skip8:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip8:

# ###################################################################################
# #  -	Calling the check validity function to check quadrant 7.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,7
			la	$a0,arr1
			la	$a1,arr1	
			addiu	$a0,$a0,72
			addiu	$a1,$a1,72
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip7
			j skiip7

	skip7:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip7:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 2.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,2
			la	$a0,arr2
			la	$a1,arr2	
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

		    move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip6
			j skiip6

	skip6:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip6:

# ###################################################################################
# #  -	Calling the check validity function to check quadrant 5.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,5
			la	$a0,arr2
			la	$a1,arr2	
			addiu	$a0,$a0,36
			addiu	$a1,$a1,36
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip5
			j skiip5

	skip5:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip5:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 8.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,8
			la	$a0,arr2
			la	$a1,arr2	
			addiu	$a0,$a0,72
			addiu	$a1,$a1,72
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip4
			j skiip4

	skip4:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip4:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 3.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,3
			la	$a0,arr3
			la	$a1,arr3	
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip3
			j skiip3

	skip3:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip3:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 6.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,6
			la	$a0,arr3
			la	$a1,arr3	
			addiu	$a0,$a0,36
			addiu	$a1,$a1,36
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip2
			j skiip2

	skip2:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip2:


# ###################################################################################
# #  -	Calling the check validity function to check quadrant 9.                    #
# ###################################################################################

			li $a0,0
			li $a1,0
			li $s7,9
			la	$a0,arr3
			la	$a1,arr3	
			addiu	$a0,$a0,72
			addiu	$a1,$a1,72
			addiu	$sp,$sp,-4	
			sw	$ra,0($sp)
			jal	Check_Valid		
			lw	$ra,0($sp)
			addiu	$sp,$sp,4	
			li  $t6,1

			move	$t1,$a0
			move	$t2,$a1
			bne   $a2,$t6,skip1
			j skiip1

	skip1:
			li $v0,4
			la $a0,Invalid
			syscall

			li $v0,4
			la $a0,TheValue
			syscall

			li $v0,1
			move $a0,$t2
			syscall

			li $v0,4
			la $a0,Quadrant
			syscall

			li $v0,1
			move $a0,$s7
			syscall

			jr	$ra
	skiip1:
  
			jr	$ra


#_________(-_-)__________*_ Check For Validity Function 1 __________(-_-)___________#
# ###################################################################################
# #  - Check the validity of the Quadrant and row by offseting 4 each       	    #
# #    time to get the next number.                                                 #
# #  - The function has three return values	Index,Quadrant or row number,           #
# #    and the actually value                                                       #
# ###################################################################################	


	Check_Valid:
			li  $t5,9
			move  $s2,$a0 
			li $t6,9
			li $t0,1
			li $t1,0
			li $t2,2
		
	For1:    
			li $s5,0
			xor $s5,$s5,$a1  
			li $t7,0
			li $s0,0
			lw  $s0,0($s2)
			addiu $s2,$s2,4
			addiu $t1,$t1,1
			addiu $t5,$t5,-1

			li $t6,9
		For2:   
			lw $s6,0($s5)
			addiu $s5,$s5,4
			addiu  $t6,$t6,-1
			beq  $s6,$s0,Flag

			j EndFor2
			Flag:
				addiu   $t7,$t7,1

				beq $t7,$t2,smart2
				j EndFor2
			smart2:
				move $t2,$s6

		EndFor2:
			
			bne $t6,$zero,For2  
			bgt   $t7,$t0,return_to_Caller
			bne $t5,$zero,For1  

	return_to_Caller:

			move 	$a0,$t1 		# return the row that make the sudoku invalid;
			move	$a1,$t2         # return value that makes the sudoku invalid;
			move	$a2,$t7 		# return the flag if invalid column is encounter;

			jr $ra


#_________(-_-)__________*_ Check For Validity Function 2 __________(-_-)___________#
# ###################################################################################
# #  - Check the validity of the columns by offseting 36 each time to get the 	    #
# #    correspounding column on the next row.                                       #
# #  - The function has three return values	Index,cloumn number,                    #
# #    and the actually value.                                                      #
# #  - The function Only check columns validity.                                    #
# ###################################################################################	


	Check_Valid_Col:
			li  $t5,9
			move  $s2,$a0 
			li $t6,9
			li $t0,0
			li $t2,2
		

	For3:    
			li $s5,0
			xor $s5,$s5,$a1  
			li $t7,0
			li $s0,0
			lw  $s0,0($s2)
			addiu $s2,$s2,36
			addiu $t1,$t1,1
			addiu $t5,$t5,-1

			li $t6,9
		For4:   
			lw $s6,0($s5)
			addiu $s5,$s5,36
			addiu  $t6,$t6,-1
			beq  $s6,$s0,Flag2

			j EndFor4
			Flag2:
				addiu   $t7,$t7,1

				beq $t7,$t2,smart4
				j EndFor4
			smart4:
				move $t2,$s6

		EndFor4:
			bne $t6,$zero,For4  
			bgt   $t7,$t0,return_to_Caller2
			bne $t5,$zero,For3  

	return_to_Caller2:
			addiu 	$t1,$t1,-1
			move 	$a0,$t1 		# return the column that make the sudoku invalid;
			move	$a1,$t2         # return value that makes the sudoku invalid, if needed to;
			move	$a2,$t7 		# return the flag if invalid column is encounter;

			jr $ra



####_____________(-_-)____________*_PRINT FUNCTION _*____________(-_-)___________####
# ###################################################################################
# #  -	Author:  Dr. David A. Gaitros                                               #
# #  - 	Date:  *****************                                                    #
# ###################################################################################

	PRINT_FUNCTION: 
		move	$s0,$a0		# Preserve parameter 
		move	$s1,$a1		# Set up Counter

	TOP:	beq	$s1,$zero,Return	# Branch to DONE if counter is zero
		li	$v0,4		# Tell syscal to print a string
		la	$a0,UNDER	# Print underscore
		syscall 		# 

		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,0($s0)	# Print first number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to load a byte
		lb	$a0,2($s0)	# Print second number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,4($s0)	# Print third number in row
		syscall 


		li	$v0,11		# Tell syscall to print a character
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,6($s0)	# Print first number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to load a byte
		lb	$a0,8($s0)	# Print second number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,10($s0)	# Print third number in row
		syscall 


		li	$v0,11		# Tell syscall to print a character
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,12($s0)	# Print first number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to load a byte
		lb	$a0,14($s0)	# Print second number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall
		li	$v0,11		# Tell syscall to print a character
		lb	$a0,16($s0)	# Print third number in row
		syscall 
		li	$v0,11		# Print vertical bar
		lb	$a0,BAR		# Load the BAR
		syscall


		li	$v0,11		# Tell syscall to print a character
		lb	$a0,EOL		# Print end of line
		syscall
		addiu	$s0,$s0,18	# Get next row
		addiu	$s1,$s1,-1	# Subtract from counter
		j	TOP
	Return:
		li	$v0,4
		la	$a0,UNDER
		syscall 
		jr	$ra



####____________(-_-)____________*_OPEN FILE FUNCTION _*___________(-_-)_________####
# ###################################################################################
# #  -	Author:  Dr. David A. Gaitros                                               #
# #  - 	Date:  ****************                                                     #
# ###################################################################################


	Open_File:																		  		
		move	$t1,$a0			# Move address of where we want the file name to go to 
	Again:					#    $t1
		li	$v0,4			# Tell syscall to print a string
		la	$a0,Hello		# Load address of string to print		
		syscall				# Print string
		move	$a0,$t1			# Load $a0 with the address of where we want the 
						#    Filename to go. 
		li	$a1,264			# Load max size of string
		li	$v0,8			# Tell syscall to read a string
		syscall				# Read a string
# ###################################################################################
# # Ok, we have read in a string.. Now we want to scan the string and find a line   #
# # feed (the number 10 or hex A) and replace it with binary zeros which is a       #
# # null character.                                                                 #
# ###################################################################################
		la	$t2,EOL			# EOL is the character after the filename 
						#    declaration. 
		sub	$t3,$t2,$t1		# Subtract the address of the EOL from 
						#    the address of the Filen to get the length
		move	$t4,$t1			# Put address of filename in $t4
	GetB:	lb	$t5,0($t4)		# load byte into $t5
		li	$s5,10			# Load line feed in $s1
		beq	$t5,$s5,Done		# Go to Done when line feed found
		addiu	$t4,$t4,1		# Get next byte
		j	GetB			
	Done:
		li	$s5,0			# Load zero (null character) into $s1
		sb	$s5,0($t4)		# Replace the line feed with null character

# ###################################################################################
# #  Try to open the file,  If it works move the file pointer to $v0 and return.    #
# #  If not, go back and read in another filename.                                  #
# ###################################################################################	
		li	$v0,13			# tell syscall to open a file
		move	$a0,$t1			# Move address of file in $a0
		li	$a1,0			# Open for reading
		li	$a2,0			# No purpose
		syscall				# Open file
		move    $s6,$v0
		ble	$s6,$zero,Again		# Bad file, try it again. 
		move	$v0,$s6
		jr	$ra





