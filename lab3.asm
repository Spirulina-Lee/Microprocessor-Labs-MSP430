;--------------------------------------------------------------------------
-----
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;--------------------------------------------------------------------------
-----
 .cdecls C,LIST,"msp430.h" ; Include device header file
 
;--------------------------------------------------------------------------
-----
 .def RESET ; Export program entry-point to
 ; make it known to linker.
;--------------------------------------------------------------------------
-----
 .text ; Assemble into program memory.
 .retain ; Override ELF conditional linking
 ; and retain current section.
 .retainrefs ; And retain any sections that 
have
 ; references to current section.
;--------------------------------------------------------------------------
-----
RESET mov.w #__STACK_END,SP ; Initialize stackpointer
StopWDT mov.w #WDTPW|WDTHOLD,&WDTCTL ; Stop watchdog timer
;--------------------------------------------------------------------------
-----
; Main loop here
;--------------------------------------------------------------------------
-----
 .data
Scores: .byte 17,18,20,0,6,10,16,19,13,16,14,18,16,14
Last_Score: .byte 16
Max_Score: .byte 0
Count_Score: .space 15
Mode: .byte 0
 .text
main: ; Main program
; Max part
clr.b R4 ; Initialize the first address
clr.b R5 ; Initialize the first comparison bit
clr.b R6 ; Initialize the second comparison bit
clr.b R7 ; Initialize the last address
 clr.b R8 ; Initialize the variable to store the maximum score
 clr.b R9 ; Initialize the last address++
 ; Histogram part
 clr.b R10 ; Temporary bit
clr.b R11 ; Compare scores
clr.b R12 ; Count bit
clr.b R14 ; Count_Score
clr.b R15 ; Compare bit
mov.w #Scores, R4 ; Copy the first address of Scores into R4
mov.w #Scores, R11 ; Histogram scores used for counting
mov.w #Last_Score, R7 ; Copy the address of Last_Score into R7
mov.w R7, R9 ; Copy the address of Last_Score into R9
add.w #1, R9 ; Increment the Last address++
; Call Max part
call #Max ; Find the maximum score and store it in R8
mov.b R8, Max_Score ; Copy R8 (maximum score) into Max_Score
; Histogram_Build part
Histogram_Build:
clr.b R12 ; Reset the Count bit
call #Histogram ; Build the histogram
mov.b R12, Count_Score(R14) ; Count the number of each score that has 
occurred
inc R14 ; Move to the next score's histogram
mov.b @R11, R15 ; Move the data to R15
add.w #1, R11 ; Point to the next score
cmp.w R11, R9 ; Check if it has reached the end
jne Histogram_Build ; Continue
; Mode_Find part
Mode_Find:
mov.w #Count_Score, R4 ; Copy the first address of Count_Score into R4
mov.w #Mode, R7 ; Copy the address of Mode into R7
sub.w #1, R7 ; Now R7 is the last address of Count_Score
call #Max ; Find the maximum Count_Score (mode) and store it in R8
mov.b R8, Mode ; Copy R8 (maximum Count_Score mode) into Mode
mov.w #Scores, R4 ; Initialize the state finally
mov.w #Last_Score, R7 ; Copy the address of Last_Score into R7
jmp Exit ; Once all tasks are finished, exit
; This part is to find the maximum score and store it in R12
Max: ; Initialize the state
mov.b @R4, R5 ; Copy the first score into R5
mov.w R5, R8 ; Store the maximum score
jmp Compare ; Jump to the Compare section
Compare: ; Compare the maximum score with other scores
cmp.w R4, R7 ; Check if it has reached the end
jl Max_Done ; Max_Done
add.w #1, R4 ; Point to the next value
mov.b @R4, R6 ; Copy the second value into R6
cmp.w R6, R8 ; R8 - R6 (the result is not saved)
jn Update ; If the result is negative, jump to Update
jmp Compare ; Jump to Compare
Update: ; Update the maximum score in R12
mov.b R6, R8 ; Update the maximum score
jmp Compare ; Jump to Compare
Max_Done:
ret ; Return from the subroutine
; This part is to build the histogram
Histogram:
mov.w #Scores, R4 ; Initialize the state again
mov.w #Last_Score, R7 ; Copy the address of Last_Score into R7
Again:
mov.b @R4, R10 ; Move data to R10
cmp.b R10, R15 ; Is R11 the same as the value?
jne Skip ; If it's not the same, then skip
inc R12 ; Found a score the same as the value, R12 (Count++)
Skip:
add.w #1, R4 ; Point to the next address
cmp.w R4, R7 ; Check if it has reached the end
jl Histo_Done ; Done with the list, go to return
jmp Again ; Jump to Again
Histo_Done:
ret ; Return from the subroutine
Exit:
jmp $; Stop after the sorting is completed
 
;--------------------------------------------------------------------------
-----
; Stack Pointer definition
;--------------------------------------------------------------------------
-----
 .global __STACK_END
 .sect .stack
 
;--------------------------------------------------------------------------
-----
; Interrupt Vectors
;--------------------------------------------------------------------------
-----
 .sect ".reset" ; MSP430 RESET Vector
 .short RE