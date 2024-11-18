BOOT_LOAD:   ; 0
BOOT_LOOP:   ; 0AH
BOOT_START:   ; 17H
BOOT_UNUSED:   ; 432H
IGNORE:   ; 0F7E9H
INT_VECTOR:   ; 0F7F8H
MSG1:   ; 0F7FBH
DF7FD:   ; 0F7FDH
RAM_START:   ; 0F800H
MONITOR:   ; 0F824H
MONITOR2:   ; 0F839H
CMD_B:   ; 0F861H
CMD_ENTER:   ; 0F879H
LOOP_819:   ; 0F886H
AGAIN:   ; 0F8EFH
DF912:   ; 0F912H
DF92C:   ; 0F92CH
DF932:   ; 0F932H
DF93E:   ; 0F93EH
JMP_HL:   ; 0F95DH
WEIRD:   ; 0F95EH
NON_ZERO_C:   ; 0F968H
DF990:   ; 0F990H
DF997:   ; 0F997H
DIV:   ; 0F99FH
LOOP:   ; 0F9A4H
BIT7:   ; 0F9ADH
SKIP_217:   ; 0F9AFH
SKIP:   ; 0F9CEH
LOOP_609:   ; 0F9E8H
DFA0E:   ; 0FA0EH
MEMCPY:   ; 0FA1EH
DFA27:   ; 0FA27H
XXX_635:   ; 0FA34H
INTERRUPT:   ; 0FA7AH
INTERRUPT_READ:   ; 0FA84H
INTERRUPT_RETURN:   ; 0FA9AH
INTERRUPT_END:   ; 0FA9DH
INTERRUPT_ERROR:   ; 0FAA5H
INTERRUPT_RETRY:   ; 0FAAAH
READ_51H:   ; 0FAB7H
LOOP_576:   ; 0FABCH
WRITE_51H:   ; 0FAD3H
WRITE2_51H:   ; 0FADAH
XXX_891:   ; 0FAEDH
BUSY_LOOP:   ; 0FAF5H
DATA_S0:   ; 0FAFDH
DATA_TR:   ; 0FAFFH
DATA_X4:   ; 0FB00H
READ_HL:   ; 0FB05H
LOOP_811:   ; 0FB0BH
SKIP_442:   ; 0FB23H
FAILED:   ; 0FB33H
DONE:   ; 0FB3CH
CMD_STAR:   ; 0FB3EH
LOOP_230:   ; 0FB40H
LF:   ; 0FB58H
CONT:   ; 0FB60H
CMD_G:   ; 0FB66H
CMD_AMP:   ; 0FB6DH
MONITOR_REENTER:   ; 0FB79H
WAIT_KEY:   ; 0FB81H
PSTR_PORTAL:   ; 0FB8CH
STR_PORTAL:   ; 0FB8DH
READ_CHAR_ECHO:   ; 0FB97H
PRINT_CHAR:   ; 0FB9BH
PRINT_CR:   ; 0FBB7H
UPDATE_SCREEN:   ; 0FBCCH
LOOP_737:   ; 0FBD3H
PRINT_LF:   ; 0FBE7H
LOOP_272:   ; 0FBF2H
PRINT_PSTR:   ; 0FC0CH
LOOP_874:   ; 0FC0FH
BUFFER:   ; 0FC1BH
DATA51H_3:   ; 0FC1FH
DRIVE:   ; 0FC23H
PORT51_INDATA:   ; 0FC2AH
FLAG2:   ; 0FC2BH
FLAG3:   ; 0FC33H
SKIP_INTERRUP:   ; 0FC34H
XXX_DATA:   ; 0FC35H
BOOT_HL:   ; 0FC3DH
DFC3F:   ; 0FC3FH
CURSOR:   ; 0FD5DH
SCREEN:   ; 0FD5FH
OTHER:   ; 0FD7FH
	ORG 0F7E9H
;
; R2E Micral Portal boot rom disassembly (in progress) 
; This code is executed from 0 and copies the rest into F800 in RAM
;
IGNORE:   ; 0F7E9H
	DI
	LXI H,17H	; Test @RAM_START
	LXI B,41CH
	LXI D,RAM_START	; Start of boot @RAM_START...
	MOV A,M
	STAX D
	INX H
	INX D
	DCX B
;
; Copies the code 'JMP FA7A' (HOOK) here
; This is also written to by F809H and becomes @INT_VECTOR
; (JMP @FA7AH / JMP @INTERRUPT)
; PIC sets interrupts to be at F7E0+4*INT#, so this is INT 6.
;
INT_VECTOR:   ; 0F7F8H
	MOV A,B
	ORA C
	JNZ 0AH
	DB 0C2H
MSG1:   ; 0F7FBH
	DB 0AH,0
DF7FD:   ; 0F7FDH
	JMP RAM_START
;
; The real start in RAM
; Ports:
;   11: 00
;   60: F6
;   61: F7 BF
;
RAM_START:   ; 0F800H
	MVI A,0C0H
	SIM	; Set Serial Data Out to 1
	LXI SP,CURSOR
	XRA A
	OUT 11H
	LXI H,INT_VECTOR
	MVI M,0C3H	; JMP
	INX H
	MVI M,7AH	; LOW(@INTERRUPT)
	INX H
	MVI M,0FAH	; HI(@INTERRUPT)
	MVI A,0F6H	; ICW1 : PIC init word 1
	OUT 60H
	MVI A,0F7H	; ICW2 : PIC init word 2 (interrupt at F7E0+4*INT)
	OUT 61H
	MVI A,0BFH	; ICW3 : PIC init word 3
	OUT 61H
	XRA A
	STA SKIP_INTERRUP	; Some flag?
;
; Resets stack, print 
;
MONITOR:   ; 0F824H
	LXI SP,CURSOR
	CALL PRINT_LF
	LXI H,PSTR_PORTAL
	CALL PRINT_PSTR
	LXI H,110H	; Can be changed by the @CMD_AMP command
	SHLD BOOT_HL
	LXI D,80H	; Can be changed by the @CMD_B command. I Suspect it is some track/sector
MONITOR2:   ; 0F839H
	MVI B,0	; 0 to 3, can be changed by @CMD_B command
	CALL READ_CHAR_ECHO
	MOV A,C
	CPI 26H
	JZ CMD_AMP	; '&' command
	CPI 0DH
	XCHG
	JZ CMD_ENTER	; '
' command
	CPI 2AH
	JZ CMD_STAR	; '*' command
	MOV B,A
	MVI C,3AH	; ':'
	CALL PRINT_CHAR
	MVI A,47H
	CMP B
	JZ CMD_G	; 'G' command
	MVI A,42H
	CMP B
	JNZ MONITOR_REENTER
;
; Here the 'B' (Boot ?) command starts
; Asks for a 0-3 number (drive #?)
; then a 4 hex number (#of bytes to read? sector?)
; and executes the 'ENTER' function (real boot)
;
CMD_B:   ; 0F861H
	CALL READ_HL	; Drive #
	JNC MONITOR_REENTER
	MOV A,H
	ORA A
	JNZ MONITOR_REENTER
	MOV A,L
	CPI 4
	JNC MONITOR_REENTER	; Must be 0 to 3
	MOV B,L
	CALL READ_HL	; Size? Len? @F836H (defaults to 0080)
	JNC MONITOR_REENTER
;
; B : Drive #
;
CMD_ENTER:   ; 0F879H
	MVI A,1
	STA SKIP_INTERRUP	; We skip interrupt code
	MVI A,30H
	OUT 11H
	LXI D,84C6H	; 33990 (loop counter)
	EI
LOOP_819:   ; 0F886H
	XTHL	; Waste some cycles
	XTHL
	DCX D
	MOV A,E
	ORA D
	JNZ LOOP_819	; Loops 33990 times
	DI
	XRA A
	STA SKIP_INTERRUP	; We activate the @INTERRUPT code
	SHLD XXX_DATA
	MOV A,B
	STA DRIVE
	LXI H,DATA_S0
	LXI D,DATA51H_3
	MVI A,3
	STAX D
	INX D
	MVI C,2
	CALL MEMCPY
	MVI C,3
	LXI H,DATA51H_3	; Contains [3,'S','0']
	CALL WRITE2_51H
	LXI H,0FFFFH
	SHLD BUFFER	; Drive 0 & 1
	SHLD BUFFER+2	; Drive 2 & 3
	LXI H,DATA51H_3+3
	MVI M,4
	MVI C,2
	CALL WRITE2_51H
	CALL READ_51H
	MOV A,M	; Wtf is this code?
	ANI 8	; ?
	RLC	; ?
	RLC	; ?
	RLC	; ?
	RLC	; ?
	MVI A,40H	; ?
	ORI 6	; We juste did an MVI A,46H
	STA DATA51H_3+3
	LXI H,DATA_TR
	RLC	; Why?
	MOV A,M
	JNC 0F8DEH	; C is always 0
	RLC
	INX H
	INX H
	MOV L,M
	MOV H,A
	SHLD XXX_DATA+2
	LHLD BOOT_HL
	XCHG
	LXI H,0
	SHLD 0FC3BH
;
; Redoes whatever this function tries to do.
; WEIRD ends here if C is zero
;
AGAIN:   ; 0F8EFH
	CALL WEIRD
	ANA A
	JZ MONITOR_REENTER
	MOV C,A
	CALL WEIRD
	MOV B,A
	MOV A,C
	CPI 3
	JC DF912
	CALL WEIRD
	MOV H,A
	CALL WEIRD
	MOV L,A
	CALL WEIRD
	ANI 1
	JZ DF912
	DAD D
DF912:   ; 0F912H
	MOV A,B
	CPI 0C2H
	JZ DF932
	CPI 0D2H
	JZ DF93E
	CPI 0C6H
	JZ JMP_HL
	CPI 0C1H
	JC MONITOR_REENTER
	CPI 0DBH
	JNC MONITOR_REENTER
DF92C:   ; 0F92CH
	CALL WEIRD
	JMP DF92C
DF932:   ; 0F932H
	CALL WEIRD
	MOV M,A
	CMP M
	JNZ MONITOR_REENTER
	INX H
	JMP DF932
DF93E:   ; 0F93EH
	CALL WEIRD
	MVI B,4
	RLC
	JC MONITOR_REENTER
	RLC
	JNC 0F955H
	PUSH PSW
	MOV A,M
	ADD E
	MOV M,A
	INX H
	MOV A,M
	ADC D
	MOV M,A
	DCX H
	POP PSW
	INX H
	DCR B
	JNZ DF93E+5
	JMP DF93E
;
; Jumps to content of HL
;
JMP_HL:   ; 0F95DH
	PCHL
;
; Weird function with a suprious POP if C is zero...
;
WEIRD:   ; 0F95EH
	INR C
	DCR C
	JNZ NON_ZERO_C
	POP PSW	; Weird...
	INR C	; C = 1
	JMP AGAIN	; Again
;
; Called when C is not Zero. Why? No idea yet.
;
NON_ZERO_C:   ; 0F968H
	PUSH H
	LHLD 0FC3BH
	MOV A,H
	ORA L
	JNZ DF990
	PUSH H
	PUSH D
	PUSH B
	LHLD XXX_DATA+2
	XCHG
	LHLD XXX_DATA
	CALL DIV	; HL = HL / E
	SHLD XXX_DATA
	POP B
	POP D
	POP H
	LXI H,0FFH
	SHLD 0FC3BH
	LXI H,DFC3F
	JMP DF997
DF990:   ; 0F990H
	DCX H
	SHLD 0FC3BH
	LHLD XXX_DATA+4
DF997:   ; 0F997H
	MOV A,M
	INX H
	SHLD XXX_DATA+4
	POP H
	DCR C
	RET
;
; Divides HL by E
;   (E may be C6H (198) from '@CMD_ENTER'?)
;
DIV:   ; 0F99FH
	PUSH H
	PUSH D
	XRA A
	MVI D,10H
;
; 16 times (every bit of HL)
;
LOOP:   ; 0F9A4H
	DAD H	; C = HL & 8000 ; HL <<= 1
	RAL	; A gets the high bit of HL
	JC BIT7
	CMP E
	JC SKIP_217	; A < E
BIT7:   ; 0F9ADH
	INR L	; L |= 1
	SUB E
SKIP_217:   ; 0F9AFH
	DCR D
	JNZ LOOP
	INR A
	STA DRIVE+3
	MOV A,L
	POP D
	CMP D
	JNC MONITOR_REENTER
	LDA DATA51H_3+3
	RLC
	MVI B,0
	MOV A,L
	JNC SKIP
	ORA A
	RAR
	JNC SKIP
	MVI B,4
SKIP:   ; 0F9CEH
	STA DRIVE+1
	LXI H,DRIVE
	MOV A,B
	ORA M
	MOV M,A
	MOV A,B
	RRC
	RRC
	STA DRIVE+2
	LXI H,DATA_X4	; 01 10 20 00
	MVI C,4
	LXI D,DRIVE+4
	CALL MEMCPY
LOOP_609:   ; 0F9E8H
	MVI A,3FH
	OUT 40H
	MVI A,0FCH
	OUT 40H
	MVI A,0FFH
	OUT 41H
	MVI A,40H
	OUT 41H
	MVI A,0E5H
	OUT 48H
	CALL XXX_635
	MVI C,9	; Read 9 bytes
	LXI H,DATA51H_3+3
	CALL XXX_891
	DCR A
	JNZ DFA0E
	POP H
	INX H
	RET
DFA0E:   ; 0FA0EH
	LDA FLAG2+1
	ANI 84H
	JZ LOOP_609
	CALL DFA27
	MVI M,0FFH
	JMP LOOP_609
;
; Copies C bytes from HL to DE
;
MEMCPY:   ; 0FA1EH
	MOV A,M
	STAX D
	INX H
	INX D
	DCR C
	JNZ MEMCPY
	RET
;
; HL = @BUFFER + @DRIVE & 0x3
;
DFA27:   ; 0FA27H
	LDA DRIVE
	ANI 3
	LXI H,BUFFER
	ADD L
	MOV L,A
	RNC
	INR H
	RET
XXX_635:   ; 0FA34H
	CALL DFA27
	MOV A,M
	INR A
	JZ 0FA5FH
	LDA DRIVE+1
	CMP M
	RZ
	ORA A
	XCHG
	JZ 0FA69H
	LXI H,DATA51H_3+2
	MOV M,A
	MVI B,0FH
	MVI C,3
	LXI H,DATA51H_3+1
	LDA DRIVE
	MOV M,A
	DCX H
	MOV M,B
	CALL XXX_891
	LDA DRIVE+1
	STAX D
	RET
	XCHG
	CALL 0FA69H
	XCHG
	MVI M,0
	JMP 0FA3CH
	MVI B,7
	MVI C,2
	CALL 0FA4EH
	LDA FLAG3
	DCR A
	MVI A,0
	RZ
	JMP 0FA69H
;
; Interrupt?
; Stored as the target of a JMP instruction in 0008
; (See RAM_START)
;
INTERRUPT:   ; 0FA7AH
	PUSH PSW
	PUSH B
	PUSH H
	LDA SKIP_INTERRUP
	ANA A
	JNZ INTERRUPT_END	; Skip interrupt code
;
; Reads from 51H
;
INTERRUPT_READ:   ; 0FA84H
	CALL READ_51H
	MOV A,B	; B is length (0 or 1)
	ANA A
	JZ INTERRUPT_RETRY	; B=0 => No data read
	LXI H,FLAG2
	MOV A,M	; Data read from 51H
	RLC
	JC INTERRUPT_ERROR	; Checks it is 0xxxxxxx
	RLC
	JC INTERRUPT_ERROR	; Checks it is 00xxxxxx
	MVI A,1	; Signal we are done
;
; Returns with a code (in @FLAG3)
;
INTERRUPT_RETURN:   ; 0FA9AH
	STA FLAG3
INTERRUPT_END:   ; 0FA9DH
	MVI A,66H
	OUT 60H
	POP H
	POP B
	POP PSW
	RET
;
; I suspect this is an error code
;
INTERRUPT_ERROR:   ; 0FAA5H
	MVI A,7FH
	JMP INTERRUPT_RETURN
;
; I guess this is a retry to get some data
; (writes 1 in bit 4 of 51H)
;
INTERRUPT_RETRY:   ; 0FAAAH
	LXI H,DATA51H_3
	MVI M,8
	MVI C,1
	CALL WRITE_51H	; Write [0x08]
	JMP INTERRUPT_READ
;
; Reads from 51H into PORT51_INDATA
; Reads as long as 50H bits 6 and 7 are set
; Stops if 50H has bit 7 set and bit 5 cleared
; B contains number of bytes read
; Called from interrupt
;
READ_51H:   ; 0FAB7H
	LXI H,PORT51_INDATA	; Actually @FLAG2-1
	MVI B,0
LOOP_576:   ; 0FABCH
	IN 50H
	RLC
	JNC LOOP_576	; Wait for bit 7
	MOV C,A
	ANI 20H	; 0010 0000
	RZ	; Return if 5th bit clear
	MOV A,C
	RLC
	JNC LOOP_576	; Wait for bit 6
	IN 51H
	INX H	; @FLAG2 (@PORT51_INDATA+1)
	INR B
	MOV M,A
	JMP LOOP_576
;
; Write C chars into HL (from floppy?)
; Waits for 50H bit 4 to clear
; Then similar logic to READ:
; Waits for bit 7 set and 6 cleared
;
WRITE_51H:   ; 0FAD3H
	IN 50H
	ANI 10H
	JNZ WRITE_51H
;
; Writes C chars from HL to 51H
; (waits for 50H bit 7 to be set)
;
WRITE2_51H:   ; 0FADAH
	IN 50H
	RLC
	JNC WRITE2_51H
	RLC
	JC WRITE2_51H
	MOV A,M
	OUT 51H
	INX H
	DCR C
	JNZ WRITE2_51H
	RET
;
; Suspects that is is read from floppy sync
;
XXX_891:   ; 0FAEDH
	CALL WRITE_51H
	XRA A
	STA FLAG3
	EI
BUSY_LOOP:   ; 0FAF5H
	LDA FLAG3	; Interrup will set this to 1
	ORA A
	JZ BUSY_LOOP
	RET
;
; 2 bytes of data 
;
DATA_S0:   ; 0FAFDH
	DB "S0",0
;
; Maybe track count? Inited at 40...
;
DATA_TR:   ; 0FAFFH
	DB 28H	; 28H = 40. Tracks?
;
; 4 bytes of data
;
DATA_X4:   ; 0FB00H
	DB 1,10H,20H,0,32H
;
; Reads HL in hex
; Digits must be entered and finished with ESC
; My understanding is that we will crash at the 8th digit
;
READ_HL:   ; 0FB05H
	PUSH B
	LXI H,0	; Starts with 0000
	MVI B,9	; Read at most 8 hex chars
LOOP_811:   ; 0FB0BH
	CALL READ_CHAR_ECHO	; Read one digit
	MOV A,C
	SUI 30H	; ; '0' is at 0
	JC FAILED	; Fails if <'0'
	ADI 0E9H	; 'F' is at FF
	JC FAILED	; Fails if original char >'F'
	ADI 6	; 'A' is at 0
	JP SKIP_442	; Jumps if original was 'A'-'F'
	ADI 7	; '9' is at FF
	JC FAILED	; Jumps if orignal >'9' and <'A'
SKIP_442:   ; 0FB23H
	ADI 0AH	; '0' is at 0, 'F' at 15
	ORA A	; Why?
	DCR B
	JZ DONE	; Will crash because lack of POP B
	DAD H	; *2
	DAD H	; *4
	DAD H	; *8
	DAD H	; *16
	ORA L	; Why?
	MOV L,A	; Replace last hex digit
	JMP LOOP_811
FAILED:   ; 0FB33H
	MOV A,C
	CPI 1BH	; ESC
	POP B	; Only correct way to exit
	JZ DONE
	STC	; Error
	RET	; Return
DONE:   ; 0FB3CH
	ORA A	; Why?
	RET
;
; Weird infinite loop with echo of the type char (if not space).
; May be a keyboard tester
;
CMD_STAR:   ; 0FB3EH
	MVI B,9	; Probably current column
LOOP_230:   ; 0FB40H
	CALL WAIT_KEY
	MOV C,A
	CPI 0DH	; 

	JZ LF
	CPI 0AH	; 
	JZ LF
	INR B	; 0AH initial call
	MOV A,B
	CPI 20H	; ' '
	JNZ CONT
	CALL PRINT_LF
LF:   ; 0FB58H
	MVI B,0
	CALL PRINT_CHAR
	JMP LOOP_230
CONT:   ; 0FB60H
	CALL PRINT_CHAR	; Useless should have been FB5A
	JMP LOOP_230
;
; User typed 'G' in the monitor
;
CMD_G:   ; 0FB66H
	CALL READ_HL
	JNC MONITOR_REENTER
	PCHL	; Jumpto address
;
; User typed '&' in the monitor
;
CMD_AMP:   ; 0FB6DH
	CALL READ_HL
	JNC MONITOR_REENTER
	SHLD BOOT_HL
	JMP MONITOR2
;
; Display '#' and goes to monitor
;
MONITOR_REENTER:   ; 0FB79H
	MVI C,23H	; '#'
	CALL PRINT_CHAR
	JMP MONITOR
;
; Waits for a char and reads it in A
;
WAIT_KEY:   ; 0FB81H
	IN 10H	; Char READY (bit 0)
	RRC	; Bit 0 -> Carry
	JNC WAIT_KEY	; Wait for char
	IN 11H	; Char
	ANI 7FH	; Force ASCII
	RET
;
; TAB+SPACE+PORTAL
;
PSTR_PORTAL:   ; 0FB8CH
	DB 9	; 9 Bytes string
STR_PORTAL:   ; 0FB8DH
	DB " PORTAL..",0
;
; ? Unsure, maybe be reading a char
;
READ_CHAR_ECHO:   ; 0FB97H
	CALL WAIT_KEY
	MOV C,A
;
; Prints char in C
;
PRINT_CHAR:   ; 0FB9BH
	MOV A,C
	CPI 0DH
	JZ PRINT_CR
	CPI 0AH
	JZ PRINT_LF
	PUSH H
	LHLD CURSOR
	MOV M,C
	INX H
	SHLD CURSOR
	MVI A,5FH	; '_'
	MOV M,A
	CALL UPDATE_SCREEN
	POP H
	RET
;
; Erase current cursor and put cursor at start of screen
;
PRINT_CR:   ; 0FBB7H
	PUSH H
	LHLD CURSOR
	MVI A,20H	; ' '
	MOV M,A
	LXI H,SCREEN
	SHLD CURSOR
	MVI A,5FH	; '_'
	MOV M,A
	CALL UPDATE_SCREEN
	POP H
	RET
;
; Outputs the content of @SCREEN to ports 9F downto 80 
;
UPDATE_SCREEN:   ; 0FBCCH
	PUSH H
	PUSH B
	LXI H,SCREEN
	MVI B,9FH	; Port
LOOP_737:   ; 0FBD3H
	PUSH H
	LXI H,0FBDBH
	MOV M,B
	POP H
	MOV A,M
	OUT 9FH	; Will be patched
	INX H
	DCR B
	MOV A,B
	CPI 7FH
	JNZ LOOP_737
	POP B
	POP H
	RET
;
; Clear screen, put cursor at column 0
;
PRINT_LF:   ; 0FBE7H
	PUSH PSW
	PUSH B
	PUSH D
	PUSH H
	MVI A,20H	; ' '
	LXI H,SCREEN
	MVI C,20H	; Do 32 times (32 characters)
LOOP_272:   ; 0FBF2H
	MOV M,A
	INX H
	DCR C
	JNZ LOOP_272	; Copies 32 spaces
	LXI H,SCREEN
	MVI A,5FH	; '_'
	MOV M,A	; Overrides fist ' ' with '_'
	CALL UPDATE_SCREEN
	LXI H,SCREEN
	SHLD CURSOR
	POP H
	POP D
	POP B
	POP PSW
	RET
;
; Prints pascal string pointed by HL
; First byte is length
;
PRINT_PSTR:   ; 0FC0CH
	PUSH B
	PUSH H
	MOV B,M	; Length
LOOP_874:   ; 0FC0FH
	INX H
	MOV C,M
	CALL PRINT_CHAR
	DCR B
	JNZ LOOP_874
	POP H
	POP B
	RET
;
; (At least 9 bytes are used, maybe more)
;
BUFFER:   ; 0FC1BH
	DB 0,0,0,0
;
; Buffer often written to 51H (3 bytes or 1 byte)
;
DATA51H_3:   ; 0FC1FH
	DB 0,0,0,0
;
; 0-3, boot drive
;
DRIVE:   ; 0FC23H
	DB 0,0,0,0,0,0,0
PORT51_INDATA:   ; 0FC2AH
	DB 0
;
; Another 0/1 flag
;
FLAG2:   ; 0FC2BH
	DB 0,0,0,0,0,0,0,0
;
; 00, 01 or 7F
;
FLAG3:   ; 0FC33H
	DB 0
;
; Interrupt code does nothing if set to 1
;
SKIP_INTERRUP:   ; 0FC34H
	DB 0
XXX_DATA:   ; 0FC35H
	DB 0,0,0,0,0,0,0,0
;
; Unsure what this is for yet
; 0110H by default
;
BOOT_HL:   ; 0FC3DH
	DW 0
DFC3F:   ; 0FC3FH
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0
;
; Location of the cursor in the SCREEN area.
; Before CURSOR, the inital Stack Frame
;
CURSOR:   ; 0FD5DH
	DB 0,0
;
; 32 bytes for the screen buffer.
; Cursor is represented by '_'
;
SCREEN:   ; 0FD5FH
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
OTHER:   ; 0FD7FH
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0
	END
