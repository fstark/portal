	ORG 0F7E9H
;
; R2E Micral Portal boot rom disassembly (in progress) 
; This code is executed from 0 and copies the rest into F800 in RAM
;
IGNORE:
	DI
	LXI H,17H
	LXI B,41CH
	LXI D,0F800H
	MOV A,M
	STAX D
	INX H
	INX D
	DCX B
;
; Copies the code 'JMP FA7A' (HOOK) here
; This is also RST 1
;
RST1:
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
	MVI M,7AH	; LOW(HOOK)
	INX H
	MVI M,0FAH	; HI(HOOK)
	MVI A,0F6H
	OUT 60H
	MVI A,0F7H
	OUT 61H
	MVI A,0BFH
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
	LXI H,110H	; Can be changed by B command. I Suspect it is some track/sector
	SHLD 0FC3DH
	LXI D,80H
MONITOR2:
	MVI B,0	; 0 to 3, can be changed by B command
	CALL 0FB97H
	MOV A,C
	CPI 26H
	JZ 0FB6DH	; '&' command
	CPI 0DH
	XCHG
	JZ 0F879H	; '\n' command
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
; Read B (0-3) and re-reads HL (gets ignored)
;
CMD_B:
	CALL 0FB05H	; 'B' command
	JNC 0FB79H
	MOV A,H
	ORA A
	JNZ 0FB79H
	MOV A,L
	CPI 4
	JNC 0FB79H	; Must be 0 to 3
	MOV B,L
	CALL 0FB05H
	JNC 0FB79H
;
; B : Drive #
;
CMD_ENTER:
	MVI A,1
	STA 0FC34H
	MVI A,30H
	OUT 11H
	LXI D,84C6H	; 33990 (loop counter)
	EI
LOOP_819:
	XTHL
	XTHL
	DCX D
	MOV A,E
	ORA D
	JNZ 0F886H	; Loops 33990 times
	DI
	XRA A
	STA 0FC34H
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
	LXI H,0FC1FH
	CALL 0FADAH
	LXI H,0FFFFH
	SHLD 0FC1BH
	SHLD 0FC1DH
	LXI H,0FC22H
	MVI M,4
	MVI C,2
	CALL 0FADAH
	CALL 0FAB7H
	MOV A,M
	ANI 8
	RLC
	RLC
	RLC
	RLC
	MVI A,40H
	ORI 6
	STA 0FC22H
	LXI H,0FAFFH
	RLC
	MOV A,M
	JNC 0F8DEH
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
	CALL 0F95EH
	JMP 0F92CH
	CALL 0F95EH
	MOV M,A
	CMP M
	JNZ 0FB79H
	INX H
	JMP 0F932H
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
	CALL 0F99FH
	SHLD 0FC35H
	POP B
	POP D
	POP H
	LXI H,0FFH
	SHLD 0FC3BH
	LXI H,0FC3FH
	JMP 0F997H
	DCX H
	SHLD 0FC3BH
	LHLD 0FC39H
	MOV A,M
	INX H
	SHLD 0FC39H
	POP H
	DCR C
	RET
;
; (LOoks like some sort of division of HL by E)
; Need to understand what:
; HL is at start
; E is at start (not modified)
;   (E may be C6H (198) from 'CMD_ENTER')
;
MYSTERY_CODE:
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
	LXI H,0FB00H
	MVI C,4
	LXI D,0FC27H
	CALL 0FA1EH
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
	MVI C,9
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
; HL = 'UNUSED2' + 'VALUE_B' & 0x3
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
	JNZ 0FA9DH
	CALL 0FAB7H
	MOV A,B
	ANA A
	JZ 0FAAAH	; No data read
	LXI H,0FC2BH
	MOV A,M
	RLC
	JC 0FAA5H
	RLC
	JC 0FAA5H
	MVI A,1
STORE_FLAG3:
	STA 0FC33H
DONE_54:
	MVI A,66H
	OUT 60H
	POP H
	POP B
	POP PSW
	RET
XXX:
	MVI A,7FH
	JMP 0FA9AH
XXX_898:
	LXI H,0FC1FH
	MVI M,8
	MVI C,1
	CALL 0FAD3H
	JMP 0FA84H
;
; Reads from 51H into PORT51_INDATA
; B contains number of bytes read
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
	RZ
	MOV A,C
	RLC
	JNC 0FABCH	; Cannot happen
	IN 51H
	INX H
	INR B
	MOV M,A
	JMP 0FABCH
XXX_698:
	IN 50H
	ANI 10H
	JNZ 0FAD3H
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
XXX_891:
	CALL 0FAD3H
	XRA A
	STA 0FC33H
	EI
	LDA 0FC33H
	ORA A
	JZ 0FAF5H
	RET
YYY:
	DB 53H,30H,28H
DFB00:
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
;
CMD_STAR:
	MVI B,9
LOOP_230:
	CALL 0FB81H
	MOV C,A
	CPI 0DH	; \n
	JZ 0FB58H
	CPI 0AH	; \r
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
; Outputs the content of SCREEN to ports 9F downto 80 
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
UNUSED2:
	DB 0,0,0,0,0,0,0,0
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
; Flag that contains 0 at boot, and 1 during the 39990 loop...
;
FLAG1:
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
