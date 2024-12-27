
# Ports (incomplete)

Port | Input Description | Ouput Description
-----|-------------------|-----------------
10H | Keyboard strobe |
11H | Keyboard data | 00H at start, 30H before big loop
40H |
41H |
48H |
50H | (Drive Strobe)
51H | (Drive Data)
60H |
61H |
80H-9FH	| Screen


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

# PIC

PIC:
	0 F6 ICW1 => A7-A6-A5 = 1, Edge triggered mode, Call Adrs Interval = 4, Single mode, no ICW4
	1 F7 ICW2 => Interrupt vector = F7E0
	1 BF


F7F8 = F7E0 + 18

Interrupt = 6


# Boot ports setup

| Port | Values |
|------|--------|
|  11  | 00     |
|  60  | F6     |
|  61  | F7 BF  |

Interrupt:

Start:
    loop:
        Wait until PORT(50H) & 0x80
        if not PORT(50&0x20)
            return
        Store PORT(51H) in FC2A and after (only latest is used, apparently)

At end of interrupt, PORT(60H) <= 66H


# [Boot ROM](../roms/portal.asm) commands:

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

Reads hex number from keyboard, must be 0-3 (drive #)
Followed by 4 hex digits which are unclear.

Cmd '*':

Weird command that juse echoes the keyboard on a loop

Cmd '&':

Allows to edit the value of 'HL' at boot (initially 0110H)


# History

Presented at the Paris SICOB, 17-26 Sept 1980.

CCMC: https://www.lemonde.fr/archives/article/1988/08/20/restructuration-dans-les-services-informatiques-ccmc-entre-dans-la-galaxie-thomson_4093359_1819218.html


An earlier version was presented at the Personal Computer Festival in Arlington, where it was called "La Valise Micral V2" (V2 of Micral Suitcase). Note the difference on the screen and printer scroll button.

https://archive.org/details/ord-ind-s1-019/page/122/mode/1up


L'Ordinateur individuel #46 (1983/03): Portal listed among a list of various portable and luggable computers

https://archive.org/details/ord-ind-s1-046/page/132/mode/2up


L'Ordinateur individuel #50bis (1983/06): Lists the Portal as selling 700 units since 11/1981 (???)

https://archive.org/details/ord-ind-s1-050bis/page/168/mode/2up


According to Ordinateur Individuel #68, the Portal Price was 35 000F in 1985.

"FAST PORTAL" software

https://archive.org/details/micro-ordinateurs-oric/Micro_Ordinateurs_017-Decembre%201983%20-%20Pages%200%2C74-75%2C87%2C94-95%2C100%2C106%2C109%2C110-111/page/n5/mode/1up

