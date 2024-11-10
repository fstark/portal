# Screen

Screen is composed of 32 characters. Cursor is software emulated with the '_' character.

|Col | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 |
|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
|Port| 9F | 9E | 9D | 9C | 9B | 9A | 99 | 98 | 97 | 96 | 95 | 94 | 93 | 92 | 91 | 90 | 8F | 8E | 8D | 8C | 8B | 8A | 89 | 88 | 87 | 86 | 85 | 84 | 83 | 82 | 81 | 80 |

In memory, the screen is stored at FD5F

Routine at FBCC outputs the screen buffer to the physical screen.

# Keyboard

Port 10 is keyboard strobe (bit 0 = 1 if key pressed)
Port 11 is key (bits 0-6)

WAIT_KEY is at FB81

# Boot ports setup

| Port | Values |
|------|--------|
|  11  | 00     |
|  60  | F6     |
|  61  | F7 BF  |


# Boot ROM commands:

| Key | Command      |
|-----|--------------|
| &   | (not known)  |
| \n  | (not known)  | 
| *   | (not known)  |
| :   | (not known)  |
| G   | (not known)  |
| B   | (not known)  |

Cmd \n:

* Flag = 1
* Sends 30 on port 11.
* Enable interrupts
* Loop 39990 times
* Disable interrupts
* Flag = 0
?

Cmd 'B':

Reads hex number from keyboard, must be 0-3
Followed by 4 hex digits

