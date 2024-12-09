# ROMs from the Portal

Here are the original dumps of portal Serial #

## keyboard.bin

[2716 for keyboard controller](keyboard.bin)

## portal.rom

[2716 for boot ROM](portal.rom)

8085 Assembly, loaded at 0. Only 0x432 (1074) bytes are used.

[Disassembly in progress](portal.asm)

## debug.asm

A test ROM for the portal

- Displays ``PORTAL`` at startup.

- Waits around a second

- Prints all chars on all positions

- Test keyboard:

	- Wait for a key

	- Display it on all positions

	- Stops if 'ESC' is pressed

- Test memory

	- Loops writing and reading back FFH followed by 00H to all memory locations from 0800H to FFFFH (0000h-07FFH is ROM)
	
	- Nothing is displayed on the screen during the test

	- If the test fails (FF or 00 are not sritten), then the address and the failure are displayed:

		1234:---*----

		1234 is the address of the failure, followed but the failed bit pattern ('*' represents failure)

		After displaying the error, the code spams the erroneous address with a bit pattern containing '1' for failed bits. This should enable some hardware debugging to see which memory chips are receiving '1'

		After a press of a key, the test continues at the next memory 'page', ie at the next multiple of 0100H. In the example, it would continue at 1300
	
	- When all the RAM has been tested, a '*' is displayed on the right of the screen and the test is restarted.
