; This is a debug ROM for the Portal
; It tests the screen, the keyboard and the RAM

	ORG 0

; IO ports (keyboard)
KBDSTROBE EQU 10H
KBDDATA EQU 11H

; Boot (portal ROM does the same)
	DI
	XRA A
	OUT KBDDATA

	LXI H,PORTAL
	JMP WAIT1S

;	TEST 0 : prints 'PORTAL'
PORTAL:
	; Output 'PORTAL' to screen
	MVI A,'P'
	OUT 9FH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MVI A,'O'
	OUT 9EH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MVI A,'R'
	OUT 9DH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MVI A,'T'
	OUT 9CH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MVI A,'A'
	OUT 9BH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MVI A,'L'
	OUT 9AH
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	; JMP PORTAL

	LXI H,SCREEN
	JMP WAIT1S

;	TEST 1 : prints all chars on all positions
SCREEN:
	MVI A,' '		; First char
LOOP:
	LXI H,NEXT0
	JMP DISPLAYALL
NEXT0:
	LXI H,NEXT1
	JMP WAIT100MS
NEXT1:
	INR A
	CPI 060H
	JNZ LOOP		; Last char

;	TEST 2 : keyboards echo on all screen until ESC
WAITKEY:
	IN KBDSTROBE
	RRC
	JNC WAITKEY
	IN KBDDATA
	ANI 7FH
	; TODO: TOUPPER

	CPI 1BH ; ESC
	JZ CLRSCR
	LXI H,WAITKEY
	JMP DISPLAYALL

CLRSCR:
	MVI A,' '
	LXI H,TESTRAM
	JMP DISPLAYALL

;	TEST 3 : Test all RAM
TESTRAM:
	LXI H,0800H	; Start of RAM

TESTRAMRECOVER:
	MVI B,0FFH  ; Value stored
	MVI C,000H  ; Alt value stored
TESTRAMLOOP:
	MOV M,B		; Store B (FF)
	MOV A,M		; Restore A
	XRA B
	JNZ TESTRAMFAILED

	MOV M,C		; Store C (00)
	MOV A,M		; Restore A
	XRA C
	JNZ TESTRAMFAILED

	INX H		; Next address

	MOV L,A
	ORA H
	JNZ TESTRAMLOOP ; Not finished

	LDA '*'			; Prints a '*' on the right of the screen
	OUT 80H

	JMP TESTRAM

; In case of failure we display
; Address and failed bits with the following format
; 1234:__*_*___

TESTRAMFAILED:
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
	OUT 9FH

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
	OUT 9EH


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
	OUT 9DH


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
	OUT 9CH

	MVI A,':'
	OUT 9BH

		; Display the failed bit
	MOV A,B

	ANI 080H	; Bit 7
	MVI A,'_'   ; '_' = ok
	JNZ ERR7
	MVI A,'*'	; '*' = nok
ERR7:
	OUT 9AH

	MOV A,B
	ANI 040H	; Bit 6
	MVI A,'_'   ; '_' = ok
	JNZ ERR6
	MVI A,'*'	; '*' = nok
ERR6:
	OUT 99H

	MOV A,B
	ANI 020H	; Bit 5
	MVI A,'_'   ; '_' = ok
	JNZ ERR5
	MVI A,'*'	; '*' = nok
ERR5:
	OUT 98H

	MOV A,B
	ANI 010H	; Bit 4
	MVI A,'_'   ; '_' = ok
	JNZ ERR4
	MVI A,'*'	; '*' = nok
ERR4:
	OUT 97H

	MOV A,B
	ANI 008H	; Bit 3
	MVI A,'_'   ; '_' = ok
	JNZ ERR3
	MVI A,'*'	; '*' = nok
ERR3:
	OUT 96H

	MOV A,B
	ANI 004H	; Bit 2
	MVI A,'_'   ; '_' = ok
	JNZ ERR2
	MVI A,'*'	; '*' = nok
ERR2:
	OUT 95H

	MOV A,B
	ANI 002H	; Bit 1
	MVI A,'_'   ; '_' = ok
	JNZ ERR1
	MVI A,'*'	; '*' = nok
ERR1:
	OUT 94H

	MOV A,B
	ANI 001H	; Bit 0
	MVI A,'_'   ; '_' = ok
	JNZ ERR0
	MVI A,'*'	; '*' = nok
ERR0:
	OUT 93H

	INR H		; We skip to the next page to accelerate the test
	MVI L,0

; DE is the offending address
; B is the offending byte pattern

	XCHG

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

	IN KBDSTROBE
	RRC
	JNC SPAM

	IN KBDDATA

	XCHG


; 		; WAIT A BIT
; 	LXI D,0FFFFH
; LOOP3:
; 	XCHG
; 	XCHG
; 	DCR E
; 	JNZ LOOP3
; 	DCR D
; 	JNZ LOOP3

	JMP TESTRAMRECOVER


	; Displays character A in all locations
	; Returns to HL
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
	PCHL

	; Waits around 1 second and jumps to HL
	; Overrides DE
WAIT1S:
	LXI D,0FFFFH
LOOP1:
	XCHG
	XCHG
	DCR E
	JNZ LOOP1
	DCR D
	JNZ LOOP1
	PCHL

	; Waits around 100ms second and jumps to HL
	; Overrides DE
WAIT100MS:
	LXI D,01FFFH
LOOP2:
	XCHG
	XCHG
	DCR E
	JNZ LOOP2
	DCR D
	JNZ LOOP2
	PCHL


	END
