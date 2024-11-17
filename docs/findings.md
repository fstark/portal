
# Technical

Manufacturer | Part Number | Description | Board Marking | Pictures | Documentation
----------- | ----------- | ----------- | ------------- | -------- | -------------
INTEL | P8253-5 | Programmable Interval Timer | 8253-5 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg) | [Datasheet](datasheets/P8253-5.pdf)
INTEL | D8202 | DRAM Controller | 8202 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg) | [Datasheet](datasheets/8202.pdf)
NEC | D765AC | Floppy Controller | uPD 765c | [2](../images/motherboard_2.jpg) | [Datasheet](datasheets/UPD765.pdf)
INTERSIL | IM6402AIPL | UART | 6402 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/IM6402-IM6403.pdf)
SIGNETICS | SCN2652ACIN40 | MPCC(*) | 2652 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/SCN2652.pdf)
MITSUBISHI | M5L8257P-5 | DMA | 8257-5 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/M5L8257P-5.pdf)
NEC | D8259C-5 | PIC(**) | 8259c | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/D8259C.pdf)
NEC | D8085AC | CPU | 8085 | [4](../images/motherboard_4.jpg) | [Datasheet](datasheets/NEC_uPD8085AH.pdf)
SMC | KR3600-017 | Keyboard Encoder | 3600 | [4](../images/motherboard_4.jpg) | [Datasheet](datasheets/KR3600.pdf)

(*)  MPCC = Multi-Protocol Communications Controller
(**) PIC = Programmable Interrupt Controller

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

Presented for the first time a the Paris SICOB, 17-26 Sept 1980

CCMC: https://www.lemonde.fr/archives/article/1988/08/20/restructuration-dans-les-services-informatiques-ccmc-entre-dans-la-galaxie-thomson_4093359_1819218.html

According to Ordinateur Individuel #68, the Portal Price was 35 000F in 1985.

"FAST PORTAL" software

https://archive.org/details/micro-ordinateurs-oric/Micro_Ordinateurs_017-Decembre%201983%20-%20Pages%200%2C74-75%2C87%2C94-95%2C100%2C106%2C109%2C110-111/page/n5/mode/1up

Picture of the Portal at the "personal computer festival" 1980 arlington, at the time where it was called "La Valise Micral V2" (V2 of Micral Suitcase). Note the difference on the screen and printer scroll button.

https://archive.org/details/ord-ind-s1-019/page/122/mode/1up
