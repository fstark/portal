# Hardware

## Motherboard


Manufacturer | Part Number   | Description | Board Marking | Pictures | Documentation
------------ | ------------- | ----------- | ------------- | -------- | -------------
INTEL        | P8253-5       | Programmable Interval Timer | 8253-5 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg) | [Datasheet](datasheets/P8253-5.pdf)
INTEL        | D8202         | DRAM Controller | 8202 | [1](../images/motherboard_1.jpg),[2](../images/motherboard_2.jpg) | [Datasheet](datasheets/8202.pdf)
NEC          | D765AC        | Floppy Controller | uPD 765c | [2](../images/motherboard_2.jpg) | [Datasheet](datasheets/UPD765.pdf)
INTERSIL     | IM6402AIPL    | UART | 6402 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/IM6402-IM6403.pdf)
SIGNETICS    | SCN2652ACIN40 | MPCC(*) | 2652 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/SCN2652.pdf)
MITSUBISHI   | M5L8257P-5    | DMA | 8257-5 | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/M5L8257P-5.pdf)
NEC          | D8259C-5      | PIC(**) | 8259c | [3](../images/motherboard_3.jpg),[4](../images/motherboard_4.jpg) | [Datasheet](datasheets/D8259C.pdf)
NEC          | D8085AC       | CPU | 8085 | [4](../images/motherboard_4.jpg) | [Datasheet](datasheets/NEC_uPD8085AH.pdf)
SMC          | KR3600-017    | Keyboard Encoder | 3600 | [4](../images/motherboard_4.jpg) | [Datasheet](datasheets/KR3600.pdf)

(*)  MPCC = Multi-Protocol Communications Controller
(**) PIC = Programmable Interrupt Controller


## Printer

Thermal printer, using a Mostek F8-based microcontroller.

When resetted, it moves the head back to the first column and feeds one line.

TODO: More details

## Display

The display module is made by R2E, and comprised of 8 Litronix/Siemens DL1416T displays ([datasheet](datasheets/DL1416T.pdf)).

As stated in the findings, they're directly mapped on I/O ports.

## Floppy

The floppy drive is an Olivetti FD501.

Specs:
* Single-sided (although the control board supports 2 heads)
* 75% height (61mm)
* 300 RPM
* 48 TPI
* 40 tracks
* Head load mechanism
* Step time: 11ms (according to µPD765 parameters)

Jumpers (guesswork):
* HS: ?
* DS0-3: Drive select
* HL: Enables head loading when motor spins and pin 2 is low
* HM: Load head when motor spins 
* MS: Motor spin when drive is selected

Pin assignment:
* 2: Head Load if HL jumper is set. Active low
* 4: Unused
* 34: Unused

Default jumper configuration: DS0 / HL. A 150 Ohm terminator resistor pack is installed.

On the model we tested, the belt (labelled Megadyne MF40) and stepper were both still fine.
It was likely manufactured on the 25th week of 1984. There's a 2584 sticker on the side, and the most recent datecode on the control board is 8409.

When using it with a greaseweazle, you will need to :
* Set a bigger step delay: `gw delays --step 20000`
* Remove the `HL` jumper and set it on `HM` OR use `gw pin set 2 L`