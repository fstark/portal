
## debug.asm

A test ROM for the portal

This ROM does not need any working memory.

It tests the screen, the keyboard and the RAM.


- Displays ``PORTAL`` at startup.

- Waits around a second

- Prints all chars on all positions

- Test keyboard:

	- Wait for a key

	- Display it on all positions

	- Stops if 'ESC' is pressed

- Test memory

	- Loops writing and reading back FFH followed by 00H to all memory locations from 0800H to FFFFH (0000h-07FFH is ROM)
	
	- NThe current tested page is displayed on the left of the screen (00-FF)

	- If the test fails (FF or 00 are not written), then the address and the failure are displayed:

		1234:---*----

		1234 is the address of the failure, followed but the failed bit pattern ('*' represents failure)

		After displaying the error, the code spams the erroneous address with a bit pattern containing '1' for failed bits. This should enable some hardware debugging to see which memory chips are receiving '1'

		After a press of a key, the test continues at the next memory 'page', ie at the next multiple of 0100H. In the example, it would continue at 1300
	
	- When all the RAM has been tested, a '*' is displayed on the right of the screen and the test is restarted, so it is possible to know if at least one test was sucessful


Ram layout:

```
       (The labels A1-D8 are the coordinates printed on the motherboard)

                                 BACK

             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  
             |D1 |  |D2 |  |D3 |  |D4 |  |D5 |  |D6 |  |D7 |  |D8 |  
   BANK 3    |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
C000H-FFFFH  | 0 |  | 1 |  | 2 |  | 3 |  | 4 |  | 5 |  | 6 |  | 7 |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  

             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  
             |C1 |  |C2 |  |C3 |  |C4 |  |C5 |  |C6 |  |C7 |  |C8 |  
   BANK 2    |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
8000H-BFFFH  | 0 |  | 1 |  | 2 |  | 3 |  | 4 |  | 5 |  | 6 |  | 7 |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  

             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  
             |B1 |  |B2 |  |B3 |  |B4 |  |B5 |  |B6 |  |B7 |  |B8 |  
   BANK 1    |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
4000H-7FFFH  | 0 |  | 1 |  | 2 |  | 3 |  | 4 |  | 5 |  | 6 |  | 7 |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  

             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  
             |A1 |  |A2 |  |A3 |  |A4 |  |A5 |  |A6 |  |A7 |  |A8 |  
   BANK 0    |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
0000H-3FFFH  | 0 |  | 1 |  | 2 |  | 3 |  | 4 |  | 5 |  | 6 |  | 7 |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             |   |  |   |  |   |  |   |  |   |  |   |  |   |  |   |  
             +---+  +---+  +---+  +---+  +---+  +---+  +---+  +---+  

                             FRONT (KEYBOARD)
```

## TODO

* Test sound

* Test memory unmapping

* Test 0000-07FF ram (is this really useful? hard to know. Maybe just copy code to 0800, then unmap and copy back in unmapping?)

* Test printer

* Test floppy

* Test serial (parallel?)
