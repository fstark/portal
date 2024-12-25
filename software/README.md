# Software

Some software (`.O`) extracted from disks:
* `SYSTEM`: bootable Prologue operating system
* `/`, `LIST`: list files on floppy disk. Usually named `CAT` on other Prologue systems
* `ASG`: run command scripts
* `CP`: File manipulation util (format, duplicate, create, rename, delete, copy)
* `CPS`: Raw sector copy
* `ED`: Text editor
* `EDL`: ?
* `EX`: Another text editor?
* `FM`: Formatting util?
* `IMP`: Small printer test program?
* `LOEXT`: ?
* `MAC`: ?
* `MEM`: ?
* `MPORT`: ?
* `PATCH`: View & modify sector data
* `MM`: MOMIC monitor
* `STATUS`: floppy disk status
* `STT`: ?
* `TELECOM`: ?
* `TR`: Micral BAL language compiler
* `TSMG`: ?

Other files:
* `.VOLUME`: Disk name
* `*.S`: Some scripts (`TS.S`, ...), some sources (`TRANSP.S`, `MPORT.S`, `IMP.S`) and some BAL programs
* `*.T`: Not sure, there's some BAL programs (`CLAVIER.T`) and other misc. stuff, maybe compiled BAL?
* `RETOUR`, `SAISIE`, `LABEL`: Some accounting work test files. No confidential company data

Since the filesystem uses 4K multiples for file sizes, most contain remnants of previous files. These remnants are sometimes source code!

TODO:
* Check unused sectors on disks, and unused sectors in files for recoverable source code
* Identify purpose of unknown programs
* Identify differences between OS and program versions

## System

Bootable OS, always the first disk catalog entry, located at 0x8000 on the floppy disks.

We count 9 different versions, which come with various names.

| Version | Disks     | Name(s)   |
| ------- | --------- | --------- |
| A       | 1,20,21   | PORTAL.O  |
| B       | 2,16      | SYSPOT.O  |
| C       | 5,15,19   | PORTAL.O  |
| D       | 6,7,22,25 | SYSTPOR.O |
| E       | 8,9,14    | SY/PO.O   |
| F       | 10,13     | SYSTPOR, SYSTPOT |
| G       | 11,23     | TELECOM.O |
| H       | 12        | SYSTPOR.O |

A and C are almost identical.

TODO: Check differences between versions, see if there's data in unused sectors

## Slash

Program used for listing files.

Known arguments:
* `,GR`: detailed listing
* `,LIS=LO`: output on printer

We count 3 versions, we name as such:
* A: in disks 01,08,09,11,15,19,20,21,23.
* B: in disks 02,06,07,10,12,14,16,22,25  (named `LIST` in disks 2 & 16).
* C: in disk  13.

The corrupted one from disk 05 matches the one in 01.

Major differences between A and B. B and C are very similar except for a few bytes.

They all contain remains of their source code!

## Status

Disk status?

Known arguments:
* `,LIS=LO`: output on printer

2 versions:
* A: in disks 3,4,6,7,12,14,17,18,22,25
* B: in disks 5,15,19

A contained partial source code.
