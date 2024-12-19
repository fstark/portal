# Software

(Messy unorganized section ahead)

Some software extracted from disks.

Since the filesystem uses 4K multiples for file sizes, most contain remnants of previous files. These remnants are sometimes source code!

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

A and C are almost identical. Need to check the rest and overwritten files

## Slash

Program used for listing files.

We count 3 versions, we name as such:
* A: in disks 01,08,09,11,15,19,20,21,23.
* B: in disks 06,07,10,12,14,22,25.
* C: in disk  13.

The corrupted one from disk 05 matches the one in 01.

Major differences between A and B. B and C are very similar except for a few bytes.

They all contain remains of their source code!
