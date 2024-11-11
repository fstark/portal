
# Technical

Manufacturer | Part Number | Description | Board Marking | Pictures | Documentation
----------- | ----------- | ----------- | ------------- | -------- | -------------
INTEL | P8253-5 | Programmable Interval Timer | 8253-5 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg)
INTEL | D8202 | DRAM Controller | 8202 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg) | [Datasheet](https://archive.org/details/intel-8202-datasheet)
NEC | D765AC | Floppy Controller | uPD 765c | [2](../images/motherboard_2.jpg) | [Datasheet](UPD765_Datasheet_OCRed.pdf)
INTERSIL | IM6402AIPL | UART | 6402 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg)
SIGNETICS | SCN2652ACIN40 | MPCC(*) | 2652 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](364-22200-0-SCN2652.pdf)
MITSUBISHI | M5l8257P-5 | DMA | 8257-5 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg)
NEC | D8259C-5 | PIC(**) | 8259c | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg)
NEC | D8085AC | CPU | 8085 | [4](../images/motherboard_4.jpg)
SMC | KR3600-017 | Keyboard Encoder | 3600 | [4](../images/motherboard_4.jpg) | [Datasheet](SMC%20KR3600-XX,ST,STD,PRO%20specifications.pdf)

(*)  MPCC = Multi-Protocol Communications Controller
(**) PIC = Programmable Interrupt Controller

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
Followed by 4 hex digits which are ignored.

Cmd '*':

Weird command that juse echoes the keyboard on a loop

Cmd '&':

Allows to edit the value of 'HL' at boot (initially 0110H)

