; Debug ROM, Hig-memory version

; This is assembled to go at address C000
; It is stored in the ROM at address 0400

	ORG 0C000H

; IO ports (keyboard)
KBDSTROBE EQU 10H
KBDDATA EQU 11H

STEP_PORT EQU 080H
STACK EQU 0F800H

; To follow the code, we will update the latest character with a step

		; '0' => we successfully jumped to the copied code
	MVI A,'0'
	OUT STEP_PORT

; Disable interrupts (again), set up stack frame, remove ROM
	DI

; 0F800H: 	MVI A,0C0H
; 0F802H: 	SIM                  ; Unmap ROM (set 40H to put ROM back)

; Set up stack frame and check stack (call and return)
 	LXI SP,STACK
	CALL JUST_RET
	MVI A,'1'
	OUT STEP_PORT

; Disable ROM
	XRA A
	OUT 11H
	MVI A,'2'

; Test RAM
	; CALL TESTRAM
	CALL DUMPRAM

FINISHED:
	JMP FINISHED


LINESTART:
	MVI A,09FH
	STA CURSOR
	RET

PRCHAR:
	OUT 09FH
NEXTCHAR:
	PUSH H
	LXI H,CURSOR
	INR M
	POP H
	RET

CURSOR EQU PRCHAR+1

PRHEX4:
	MOV A,H
	CALL PRHEX2
	MOV A,L
PRHEX2:
	PUSH PSW
	RRC
	RRC
	RRC
	RRC
	CALL PRHEX1
	POP PSW
PRHEX1:
	PUSH PSW
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
	CALL PRCHAR
	POP PSW
	RET

DUMPADRS:
	CALL PRHEX4
	MVI A,':'
	CALL PRCHAR

	PUSH B
	MVI B,8
DUMPLOOP:
	MOV A,M
	INX H
	CALL PRHEX2
	MVI A,' '
	DCR B
	JNZ DUMPLOOP

	POP B
	RET

DUMPRAM:
	LXI H,0
DUMPLOOP2:
	CALL CLRSCR
	CALL LINESTART
	CALL DUMPADRS
	CALL WAITKEY
	JMP DUMPLOOP2





;	TEST 3 : 00000H-BFFFH RAM
TESTRAM:
	CALL CLRSCR

	LXI H,00000H	; Start of RAM

TESTRAMRECOVER:
	MVI B,0FFH  ; Value stored
	MVI C,000H  ; Alt value stored
TESTRAMLOOP:

	MOV A,L		; We check if we are at the start of a page
	ORA A
	JNZ TESTRAMCONT

				; We print the page address
				; Convert to ASCII using the 8085 DAA trick	
				; High nibble
	MOV A,H
	RRC
	RRC
	RRC
	RRC
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
	OUT 9FH

				; Low nibble
	MOV A,H
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
	OUT 9EH

TESTRAMCONT:
	MOV M,B		; Store B (FF)
	MOV A,M		; Restore A
	XRA B
	JNZ TESTRAMFAILED

	MOV M,C		; Store C (00)
	MOV A,M		; Restore A
	XRA C
	JNZ TESTRAMFAILED

	INX H		; Next address

	MOV A,L
	ORA H
	JNZ TESTRAMLOOP ; Not finished

	JMP TESTRAM ; Again


TESTRAMFAILED:
	CALL DIPLAYRAMFAIL
	JMP TESTRAMRECOVER


; -----------------------------------------------------------
; In case of failure we display
; Address and failed bits with the following format
;    1234:__*_*___
; Ports: 9F 9E 9D 9C 9B 9A 99 98 97 96 95 94 93 92 91 90 8F 8E 8D 8C 8B
; Data : H  H     H  H  L  L  :  B  B  B  B  B  B  B  B     (  R  C  )
; -----------------------------------------------------------
; note: we could use BC instead of DE and save two registers
; -----------------------------------------------------------
DIPLAYRAMFAIL:
	; Failed
	MOV B,A		; Failed bits

	; We display the address of the failed byte
	MOV D,H		; Save address
	MOV E,L

		; First digit
	MOV A,D
	RRC
	RRC
	RRC
	RRC

		; A contains the high nibble
		; Convert to ASCII using the 8085 DAA trick	
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
		; Print
	OUT 9CH

		; Second digit
	MOV A,D

		; A contains the low nibble
		; Convert to ASCII using the 8085 DAA trick	
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
		; Print
	OUT 9BH


		; Third digit
	MOV A,E
	RRC
	RRC
	RRC
	RRC

		; A contains the high nibble
		; Convert to ASCII using the 8085 DAA trick	
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
		; Print
	OUT 9AH


		; Fourth digit
	MOV A,E
		; A contains the low nibble
		; Convert to ASCII using the 8085 DAA trick	
	ANI 0FH
	ADI 90H
	DAA
	ACI 40H
	DAA
		; Print
	OUT 99H

	MVI A,':'
	OUT 98H

		; Display the failed bit
	MOV A,B

	ANI 080H	; Bit 7
	MVI A,'_'   ; '_' = ok
	JZ ERR7
	MVI A,'*'	; '*' = nok
ERR7:
	OUT 97H

	MOV A,B
	ANI 040H	; Bit 6
	MVI A,'_'   ; '_' = ok
	JZ ERR6
	MVI A,'*'	; '*' = nok
ERR6:
	OUT 96H

	MOV A,B
	ANI 020H	; Bit 5
	MVI A,'_'   ; '_' = ok
	JZ ERR5
	MVI A,'*'	; '*' = nok
ERR5:
	OUT 95H

	MOV A,B
	ANI 010H	; Bit 4
	MVI A,'_'   ; '_' = ok
	JZ ERR4
	MVI A,'*'	; '*' = nok
ERR4:
	OUT 94H

	MOV A,B
	ANI 008H	; Bit 3
	MVI A,'_'   ; '_' = ok
	JZ ERR3
	MVI A,'*'	; '*' = nok
ERR3:
	OUT 93H

	MOV A,B
	ANI 004H	; Bit 2
	MVI A,'_'   ; '_' = ok
	JZ ERR2
	MVI A,'*'	; '*' = nok
ERR2:
	OUT 92H

	MOV A,B
	ANI 002H	; Bit 1
	MVI A,'_'   ; '_' = ok
	JZ ERR1
	MVI A,'*'	; '*' = nok
ERR1:
	OUT 91H

	MOV A,B
	ANI 001H	; Bit 0
	MVI A,'_'   ; '_' = ok
	JZ ERR0
	MVI A,'*'	; '*' = nok
ERR0:
	OUT 90H

	MVI A,'('
	OUT 8EH

; Find bank
	MOV A,H
	RLC
	RLC
	ANI 003H		; To two bits
	ADI 'A'			; Bank A to D
	OUT 8DH

; Find chip
	MOV A,B
	MVI C,'1'
LOOPCHIP:
	RRC
	JC COLFOUND
	INR C
	JMP LOOPCHIP

COLFOUND:
; Print column
	MOV A,C
	OUT 8CH

	MVI A,')'
	OUT 8BH

	CALL SPAM
	RET



; -----------------------------------------------------------
; HL is the offending address
; B is the offending byte pattern
; -----------------------------------------------------------
SPAM:
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B
	MOV M,B

	CALL CHECKKEY
	JNC SPAM

	IN KBDDATA

	INR H		; We skip to the next page to accelerate the test
	MVI L,0

	RET

CHECKKEY:
	IN KBDSTROBE
	RRC
	RET

WAITKEY:
	CALL CHECKKEY
	JNC WAITKEY
	IN KBDDATA
	RET

; -----------------------------------------------------------
; Clear screen
; -----------------------------------------------------------
CLRSCR:
	MVI A,' '
	JMP DISPLAYALL

; -----------------------------------------------------------
; Displays a character A in all locations
; Returns to HL
; -----------------------------------------------------------
DISPLAYALL:
	OUT 9FH
	OUT 9EH
	OUT 9DH
	OUT 9CH
	OUT 9BH
	OUT 9AH
	OUT 99H
	OUT 98H
	OUT 97H
	OUT 96H
	OUT 95H
	OUT 94H
	OUT 93H
	OUT 92H
	OUT 91H
	OUT 90H
	OUT 8FH
	OUT 8EH
	OUT 8DH
	OUT 8CH
	OUT 8BH
	OUT 8AH
	OUT 89H
	OUT 88H
	OUT 87H
	OUT 86H
	OUT 85H
	OUT 84H
	OUT 83H
	OUT 82H
	OUT 81H
	OUT 80H

JUST_RET:
	RET

; -----------------------------------------------------------
; Waits around 1 second and jumps to HL
; Overrides DE
; -----------------------------------------------------------
WAIT1S:
	LXI D,0FFFFH
LOOP1:
	XCHG
	XCHG
	DCR E
	JNZ LOOP1
	DCR D
	JNZ LOOP1
	RET

; -----------------------------------------------------------
; Waits around 100ms second and jumps to HL
; Overrides DE
; -----------------------------------------------------------
WAIT100MS:
	LXI D,01FFFH
LOOP2:
	XCHG
	XCHG
	DCR E
	JNZ LOOP2
	DCR D
	JNZ LOOP2
	RET

	END
