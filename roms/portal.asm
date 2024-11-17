	ORG 0F7E9H
;
; R2E Micral Portal boot rom disassembly (in progress) 
; This code is executed from 0 and copies the rest into F800 in RAM
;
IGNORE:
	DI
	LXI H,17H	; Test @RAM_START
	LXI B,41CH
	LXI D,0F800H	; Start of boot @RAM_START...
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
INT_VECTOR:
	MOV A,B
	ORA C
	JNZ 0AH
	DB 0C2H
MSG1:
	DB 0AH,0
DF7FD:
	JMP 0F800H
;
; The real start in RAM
; Ports:
;   11: 00
;   60: F6
;   61: F7 BF
;
RAM_START:
	MVI A,0C0H
	SIM	; Set Serial Data Out to 1
	LXI SP,0FD5DH
	XRA A
	OUT 11H
	LXI H,0F7F8H
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
	STA 0FC34H	; Some flag?
;
; Resets stack, print 
;
MONITOR:
	LXI SP,0FD5DH
	CALL 0FBE7H
	LXI H,0FB8CH
	CALL 0FC0CH
	LXI H,110H	; Can be changed by the @CMD_AMP command
	SHLD 0FC3DH
	LXI D,80H	; Can be changed by the @CMD_B command. I Suspect it is some track/sector
MONITOR2:
	MVI B,0	; 0 to 3, can be changed by @CMD_B command
	CALL 0FB97H
	MOV A,C
	CPI 26H
	JZ 0FB6DH	; '&' command
	CPI 0DH
	XCHG
	JZ 0F879H	; '
' command
	CPI 2AH
	JZ 0FB3EH	; '*' command
	MOV B,A
	MVI C,3AH	; ':'
	CALL 0FB9BH
	MVI A,47H
	CMP B
	JZ 0FB66H	; 'G' command
	MVI A,42H
	CMP B
	JNZ 0FB79H
;
; Here the 'B' (Boot ?) command starts
; Asks for a 0-3 number (drive #?)
; then a 4 hex number (#of bytes to read? sector?)
; and executes the 'ENTER' function (real boot)
;
CMD_B:
	CALL 0FB05H	; Drive #
	JNC 0FB79H
	MOV A,H
	ORA A
	JNZ 0FB79H
	MOV A,L
	CPI 4
	JNC 0FB79H	; Must be 0 to 3
	MOV B,L
	CALL 0FB05H	; Size? Len? @F836H (defaults to 0080)
	JNC 0FB79H
;
; B : Drive #
;
CMD_ENTER:
	MVI A,1
	STA 0FC34H	; We skip interrupt code
	MVI A,30H
	OUT 11H
	LXI D,84C6H	; 33990 (loop counter)
	EI
LOOP_819:
	XTHL	; Waste some cycles
	XTHL
	DCX D
	MOV A,E
	ORA D
	JNZ 0F886H	; Loops 33990 times
	DI
	XRA A
	STA 0FC34H	; We activate the @INTERRUPT code
	SHLD 0FC35H
	MOV A,B
	STA 0FC23H
	LXI H,0FAFDH
	LXI D,0FC1FH
	MVI A,3
	STAX D
	INX D
	MVI C,2
	CALL 0FA1EH
	MVI C,3
	LXI H,0FC1FH	; Contains [3,'S','0']
	CALL 0FADAH
	LXI H,0FFFFH
	SHLD 0FC1BH	; Drive 0 & 1
	SHLD 0FC1DH	; Drive 2 & 3
	LXI H,0FC22H
	MVI M,4
	MVI C,2
	CALL 0FADAH
	CALL 0FAB7H
	MOV A,M	; Wtf is this code?
	ANI 8	; ?
	RLC	; ?
	RLC	; ?
	RLC	; ?
	RLC	; ?
	MVI A,40H	; ?
	ORI 6	; We juste did an MVI A,46H
	STA 0FC22H
	LXI H,0FAFFH
	RLC	; Why?
	MOV A,M
	JNC 0F8DEH	; C is always 0
	RLC
	INX H
	INX H
	MOV L,M
	MOV H,A
	SHLD 0FC37H
	LHLD 0FC3DH
	XCHG
	LXI H,0
	SHLD 0FC3BH
;
; Redoes whatever this function tries to do.
; WEIRD ends here if C is zero
;
AGAIN:
	CALL 0F95EH
	ANA A
	JZ 0FB79H
	MOV C,A
	CALL 0F95EH
	MOV B,A
	MOV A,C
	CPI 3
	JC 0F912H
	CALL 0F95EH
	MOV H,A
	CALL 0F95EH
	MOV L,A
	CALL 0F95EH
	ANI 1
	JZ 0F912H
	DAD D
DF912:
	MOV A,B
	CPI 0C2H
	JZ 0F932H
	CPI 0D2H
	JZ 0F93EH
	CPI 0C6H
	JZ 0F95DH
	CPI 0C1H
	JC 0FB79H
	CPI 0DBH
	JNC 0FB79H
DF92C:
	CALL 0F95EH
	JMP 0F92CH
DF932:
	CALL 0F95EH
	MOV M,A
	CMP M
	JNZ 0FB79H
	INX H
	JMP 0F932H
DF93E:
	CALL 0F95EH
	MVI B,4
	RLC
	JC 0FB79H
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
	JNZ 0F943H
	JMP 0F93EH
;
; Jumps to content of HL
;
JMP_HL:
	PCHL
;
; Weird function with a suprious POP if C is zero...
;
WEIRD:
	INR C
	DCR C
	JNZ 0F968H
	POP PSW	; Weird...
	INR C	; C = 1
	JMP 0F8EFH	; Again
;
; Called when C is not Zero. Why? No idea yet.
;
NON_ZERO_C:
	PUSH H
	LHLD 0FC3BH
	MOV A,H
	ORA L
	JNZ 0F990H
	PUSH H
	PUSH D
	PUSH B
	LHLD 0FC37H
	XCHG
	LHLD 0FC35H
	CALL 0F99FH	; HL = HL / E
	SHLD 0FC35H
	POP B
	POP D
	POP H
	LXI H,0FFH
	SHLD 0FC3BH
	LXI H,0FC3FH
	JMP 0F997H
DF990:
	DCX H
	SHLD 0FC3BH
	LHLD 0FC39H
DF997:
	MOV A,M
	INX H
	SHLD 0FC39H
	POP H
	DCR C
	RET
;
; Divides HL by E
;   (E may be C6H (198) from '@CMD_ENTER'?)
;
DIV:
	PUSH H
	PUSH D
	XRA A
	MVI D,10H
;
; 16 times (every bit of HL)
;
LOOP:
	DAD H	; C = HL & 8000 ; HL <<= 1
	RAL	; A gets the high bit of HL
	JC 0F9ADH
	CMP E
	JC 0F9AFH	; A < E
BIT7:
	INR L	; L |= 1
	SUB E
SKIP_217:
	DCR D
	JNZ 0F9A4H
	INR A
	STA 0FC26H
	MOV A,L
	POP D
	CMP D
	JNC 0FB79H
	LDA 0FC22H
	RLC
	MVI B,0
	MOV A,L
	JNC 0F9CEH
	ORA A
	RAR
	JNC 0F9CEH
	MVI B,4
SKIP:
	STA 0FC24H
	LXI H,0FC23H
	MOV A,B
	ORA M
	MOV M,A
	MOV A,B
	RRC
	RRC
	STA 0FC25H
	LXI H,0FB00H	; 01 10 20 00
	MVI C,4
	LXI D,0FC27H
	CALL 0FA1EH
LOOP_609:
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
	CALL 0FA34H
	MVI C,9	; Read 9 bytes
	LXI H,0FC22H
	CALL 0FAEDH
	DCR A
	JNZ 0FA0EH
	POP H
	INX H
	RET
DFA0E:
	LDA 0FC2CH
	ANI 84H
	JZ 0F9E8H
	CALL 0FA27H
	MVI M,0FFH
	JMP 0F9E8H
;
; Copies C bytes from HL to DE
;
MEMCPY:
	MOV A,M
	STAX D
	INX H
	INX D
	DCR C
	JNZ 0FA1EH
	RET
;
; HL = @BUFFER + @DRIVE & 0x3
;
DFA27:
	LDA 0FC23H
	ANI 3
	LXI H,0FC1BH
	ADD L
	MOV L,A
	RNC
	INR H
	RET
XXX_635:
	CALL 0FA27H
	MOV A,M
	INR A
	JZ 0FA5FH
	LDA 0FC24H
	CMP M
	RZ
	ORA A
	XCHG
	JZ 0FA69H
	LXI H,0FC21H
	MOV M,A
	MVI B,0FH
	MVI C,3
	LXI H,0FC20H
	LDA 0FC23H
	MOV M,A
	DCX H
	MOV M,B
	CALL 0FAEDH
	LDA 0FC24H
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
	LDA 0FC33H
	DCR A
	MVI A,0
	RZ
	JMP 0FA69H
;
; Interrupt?
; Stored as the target of a JMP instruction in 0008
; (See RAM_START)
;
INTERRUPT:
	PUSH PSW
	PUSH B
	PUSH H
	LDA 0FC34H
	ANA A
	JNZ 0FA9DH	; Skip interrupt code
;
; Reads from 51H
;
INTERRUPT_READ:
	CALL 0FAB7H
	MOV A,B
	ANA A
	JZ 0FAAAH	; B=0 => No data read
	LXI H,0FC2BH
	MOV A,M
	RLC
	JC 0FAA5H
	RLC
	JC 0FAA5H
	MVI A,1	; Signal we are done
;
; Returns with a code (in @FLAG3)
;
INTERRUPT_RETURN:
	STA 0FC33H
INTERRUPT_END:
	MVI A,66H
	OUT 60H
	POP H
	POP B
	POP PSW
	RET
;
; I suspect this is an error code
;
INTERRUPT_ERROR:
	MVI A,7FH
	JMP 0FA9AH
;
; I guess this is a retry to get some data
; (writes 1 in bit 4 of 51H)
;
INTERRUPT_RETRY:
	LXI H,0FC1FH
	MVI M,8
	MVI C,1
	CALL 0FAD3H	; Write [0x08]
	JMP 0FA84H
;
; Reads from 51H into PORT51_INDATA
; Reads as long as 50H bits 6 and 7 are set
; Stops if 50H has bit 7 set and bit 5 cleared
; B contains number of bytes read
; Called from interrupt
;
READ_51H:
	LXI H,0FC2AH
	MVI B,0
LOOP_576:
	IN 50H
	RLC
	JNC 0FABCH	; Wait for bit 7
	MOV C,A
	ANI 20H	; 0010 0000
	RZ	; Return if 5th bit clear
	MOV A,C
	RLC
	JNC 0FABCH	; Wait for bit 6
	IN 51H
	INX H
	INR B
	MOV M,A
	JMP 0FABCH
;
; Write C chars into HL (from floppy?)
; Waits for 50H bit 4 to clear
; Then similar logic to READ:
; Waits for bit 7 set and 6 cleared
;
WRITE_51H:
	IN 50H
	ANI 10H
	JNZ 0FAD3H
;
; Writes C chars from HL to 51H
; (waits for 50H bit 7 to be set)
;
WRITE2_51H:
	IN 50H
	RLC
	JNC 0FADAH
	RLC
	JC 0FADAH
	MOV A,M
	OUT 51H
	INX H
	DCR C
	JNZ 0FADAH
	RET
;
; Suspects that is is read from floppy sync
;
XXX_891:
	CALL 0FAD3H
	XRA A
	STA 0FC33H
	EI
BUSY_LOOP:
	LDA 0FC33H	; Interrup will set this to 1
	ORA A
	JZ 0FAF5H
	RET
;
; 2 bytes of data 
;
DATA_S0:
	DB "S0",0
;
; Maybe track count? Inited at 40...
;
DATA_TR:
	DB 28H	; 28H = 40. Tracks?
;
; 4 bytes of data
;
DATA_X4:
	DB 1,10H,20H,0,32H
;
; Reads HL in hex
; Digits must be entered and finished with ESC
; My understanding is that we will crash at the 8th digit
;
READ_HL:
	PUSH B
	LXI H,0	; Starts with 0000
	MVI B,9	; Read at most 8 hex chars
LOOP_811:
	CALL 0FB97H	; Read one digit
	MOV A,C
	SUI 30H	; ; '0' is at 0
	JC 0FB33H	; Fails if <'0'
	ADI 0E9H	; 'F' is at FF
	JC 0FB33H	; Fails if original char >'F'
	ADI 6	; 'A' is at 0
	JP 0FB23H	; Jumps if original was 'A'-'F'
	ADI 7	; '9' is at FF
	JC 0FB33H	; Jumps if orignal >'9' and <'A'
SKIP_442:
	ADI 0AH	; '0' is at 0, 'F' at 15
	ORA A	; Why?
	DCR B
	JZ 0FB3CH	; Will crash because lack of POP B
	DAD H	; *2
	DAD H	; *4
	DAD H	; *8
	DAD H	; *16
	ORA L	; Why?
	MOV L,A	; Replace last hex digit
	JMP 0FB0BH
FAILED:
	MOV A,C
	CPI 1BH	; ESC
	POP B	; Only correct way to exit
	JZ 0FB3CH
	STC	; Error
	RET	; Return
DONE:
	ORA A	; Why?
	RET
;
; Weird infinite loop with echo of the type char (if not space).
; May be a keyboard tester
;
CMD_STAR:
	MVI B,9	; Probably current column
LOOP_230:
	CALL 0FB81H
	MOV C,A
	CPI 0DH	; 

	JZ 0FB58H
	CPI 0AH	; 
	JZ 0FB58H
	INR B	; 0AH initial call
	MOV A,B
	CPI 20H	; ' '
	JNZ 0FB60H
	CALL 0FBE7H
LF:
	MVI B,0
	CALL 0FB9BH
	JMP 0FB40H
CONT:
	CALL 0FB9BH	; Useless should have been FB5A
	JMP 0FB40H
;
; User typed 'G' in the monitor
;
CMD_G:
	CALL 0FB05H
	JNC 0FB79H
	PCHL	; Jumpto address
;
; User typed '&' in the monitor
;
CMD_AMP:
	CALL 0FB05H
	JNC 0FB79H
	SHLD 0FC3DH
	JMP 0F839H
;
; Display '#' and goes to monitor
;
MONITOR_REENTER:
	MVI C,23H	; '#'
	CALL 0FB9BH
	JMP 0F824H
;
; Waits for a char and reads it in A
;
WAIT_KEY:
	IN 10H	; Char READY (bit 0)
	RRC	; Bit 0 -> Carry
	JNC 0FB81H	; Wait for char
	IN 11H	; Char
	ANI 7FH	; Force ASCII
	RET
;
; TAB+SPACE+PORTAL
;
PSTR_PORTAL:
	DB 9	; 9 Bytes string
STR_PORTAL:
	DB " PORTAL..",0
;
; ? Unsure, maybe be reading a char
;
READ_CHAR_ECHO:
	CALL 0FB81H
	MOV C,A
;
; Prints char in C
;
PRINT_CHAR:
	MOV A,C
	CPI 0DH
	JZ 0FBB7H
	CPI 0AH
	JZ 0FBE7H
	PUSH H
	LHLD 0FD5DH
	MOV M,C
	INX H
	SHLD 0FD5DH
	MVI A,5FH	; '_'
	MOV M,A
	CALL 0FBCCH
	POP H
	RET
;
; Erase current cursor and put cursor at start of screen
;
PRINT_CR:
	PUSH H
	LHLD 0FD5DH
	MVI A,20H	; ' '
	MOV M,A
	LXI H,0FD5FH
	SHLD 0FD5DH
	MVI A,5FH	; '_'
	MOV M,A
	CALL 0FBCCH
	POP H
	RET
;
; Outputs the content of @SCREEN to ports 9F downto 80 
;
UPDATE_SCREEN:
	PUSH H
	PUSH B
	LXI H,0FD5FH
	MVI B,9FH	; Port
LOOP_737:
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
	JNZ 0FBD3H
	POP B
	POP H
	RET
;
; Clear screen, put cursor at column 0
;
PRINT_LF:
	PUSH PSW
	PUSH B
	PUSH D
	PUSH H
	MVI A,20H	; ' '
	LXI H,0FD5FH
	MVI C,20H	; Do 32 times (32 characters)
LOOP_272:
	MOV M,A
	INX H
	DCR C
	JNZ 0FBF2H	; Copies 32 spaces
	LXI H,0FD5FH
	MVI A,5FH	; '_'
	MOV M,A	; Overrides fist ' ' with '_'
	CALL 0FBCCH
	LXI H,0FD5FH
	SHLD 0FD5DH
	POP H
	POP D
	POP B
	POP PSW
	RET
;
; Prints pascal string pointed by HL
; First byte is length
;
PRINT_PSTR:
	PUSH B
	PUSH H
	MOV B,M	; Length
LOOP_874:
	INX H
	MOV C,M
	CALL 0FB9BH
	DCR B
	JNZ 0FC0FH
	POP H
	POP B
	RET
;
; (At least 9 bytes are used, maybe more)
;
BUFFER:
	DB 0,0,0,0
;
; Buffer often written to 51H (3 bytes or 1 byte)
;
DATA51H_3:
	DB 0,0,0,0
;
; 0-3, boot drive
;
DRIVE:
	DB 0,0,0,0,0,0,0
PORT51_INDATA:
	DB 0
;
; Another 0/1 flag
;
FLAG2:
	DB 0,0,0,0,0,0,0,0
;
; 00, 01 or 7F
;
FLAG3:
	DB 0
;
; Interrupt code does nothing if set to 1
;
SKIP_INTERRUP:
	DB 0
XXX_DATA:
	DB 0,0,0,0,0,0,0,0
;
; Unsure what this is for yet
; 0110H by default
;
BOOT_HL:
	DW 0
DFC3F:
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
CURSOR:
	DB 0,0
;
; 32 bytes for the screen buffer.
; Cursor is represented by '_'
;
SCREEN:
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
	DB 0,0,0,0,0,0,0,0
OTHER:
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
