; Debug ROM, Hig-memory version

; This is assembled to go at address C000
; It is stored in the ROM at address 0400

	ORG 0C000H

	MVI A,'!'
	OUT 9FH
DONE:
	INR A
	OUT 9EH
	JMP DONE

	END
