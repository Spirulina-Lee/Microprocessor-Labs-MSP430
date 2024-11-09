;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
      .data
X:    .word 0x1234
Y:    .word 0xABCD
Z1:   .word 0x12
Z2:   .word 0x0F
Mem:  .space 100

      .text
      mov.w X,Mem  ;a

      swpb Mem         ;b,Swap the first eight bits and the last eight bits of the Mem
      mov.b Mem,Mem+4  ;Transfer the value of register Mem to MEM + 4
      swpb Mem         ;Restore the Mem exchange

      mov.b X,Mem+8    ;c

      mov.w Y,R4       ;d,Save the value of Y to R4
      add.w X,Y        ;Perform a logical addition between X and Y
      mov.w Y,Mem+12   ;Transfer the value of register Y to MEM + 12
      mov.w R4,Y       ;Store the value of Y in R4

      mov.b Z2,R4      ;Save the value of Z2 to R4
      add.b Z1,Z2      ;Perform a logical addition between Z1 and Z2
      mov.b Z2,Mem+16  ;Transfer the value of register Z2 to MEM + 16
      mov.b R4,Z2      ;e,Store the value of Z2 in R4

      mov.b Z1,R4      ;Save the value of Z1 to R4
      sub.b Z2,Z1      ;Perform a logical subtraction between Z2 and Z1
      mov.b Z1,Mem+20  ;Transfer the value of register Z2 to MEM + 20
      mov.b R4,Z1      ;f,Store the value of Z1 in R4

      mov.b Z2,R4      ;Save the value of Z2 to R4
      sub.b Z1,Z2      ;Perform a logical subtraction between Z1 and Z2
      mov.b Z2,Mem+24  ;Transfer the value of register Z2 to MEM + 24
      mov.b R4,Z2      ;g,Store the value of Z2 in R4

      mov.w Y,R4       ;Save the value of Y to R4
      sub.w X,Y        ;Perform a logical subtraction between X and Y
      mov.w Y,Mem+28   ;Transfer the value of register Y to MEM + 28
      mov.w R4,Y       ;h,Store the value of Y in R4

      mov.w X,R4       ;Save the value of X to R4
      sub.w Y,X        ;Perform a logical subtraction between X and Y
      mov.w X,Mem+32   ;Transfer the value of register X to MEM + 32
      mov.w R4,X       ;i,Store the value of X in R4

      mov.w Y,R4       ;Save the value of Y to R4
      inv.w Y          ;Sort the data for each bit in Y in reverse order
      mov.w Y,Mem+36   ;Transfer the value of register Y to MEM + 36
      mov.w R4,Y       ;j,Store the value of Y in R4

      mov.b Z1,R4      ;Save the value of Z1 to R4
      inv.b Z1         ;Sort the data for each bit in Z1 in reverse order
      mov.b Z1,Mem+40  ;Transfer the value of register Z1 to MEM + 40
      mov.b R4,Z1      ;k,Store the value of Z1 in R4

      mov.w X,Mem+44   ;l,Save the value of X to Mem + 44

      mov.b Z2,R4      ;Save the value of Z2 to R4
      and.b Z1,Z2      ;Perform a logical addition between Z1 and Z2
      mov.b Z2,Mem+48  ;Transfer the value of register Z2 to MEM + 48
      mov.b R4,Z2      ;m,Store the value of Z2 in R4

      mov.b Z2,R4      ;Save the value of Z2 to R4
      xor.b Z1,Z2      ;Perform logical XOR operations on Z1 and Z2
      mov.b Z2,Mem+52  ;Transfer the value of register Z2 to MEM + 52
      mov.b R4,Z2      ;n,Store the value of Z2 in R4

      mov.b Z1,R4      ;Save the value of Z1 to R4
      dec Z1           ;Substract one from the value of Z1
      mov.b Z1,Mem+56  ;Transfer the value of register Z1 to MEM + 56
      mov.b R4,Z1      ;o,Store the value of Z1 in R4

      mov.b Z2,R4      ;Save the value of Z2 to R4
      dec.b Z2         ;Substract one from the value of Z2
      dec.b Z2         ;Substract one from the value of Z2
      mov.b Z2,Mem+60  ;Transfer the value of register Z2 to MEM + 60
      mov.b R4,Z2      ;p,Store the value of Z2 in R4

      mov.b X,R4       ; Save the value of X to R4
      swpb R4          ;Swap the first eight bits and the last eight bits of the R4
      mov.w R4,Mem+64  ;q,Save the value of R4 to Mem + 64

      jmp $            ; infinite loop to end program

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
