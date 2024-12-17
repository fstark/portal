# Disk structure

This is the structure for Portal-specific disks:
* Single sided
* 40 tracks
* 16 soft sectors per track
* 256 bytes per sector

| Start  | End     | Sectors | Contents             |
| ------ | ------- | ------- | -------------------- |
| 0x0    | 0xFF    | 1       | Block allocation map |
| 0x100  | 0x3FF   | 3       | Empty                |
| 0x400  | 0X1FFF  | 28      | File table           |
| 0x2000 | 0x27FFF | 608     | File contents        |

Disks can hold 152 KB of data, including the OS.

# Prologue filesystem

Below is a description of the Prologue filesystem headers, applicable to the Portal.
Some information not relevant to the Portal use-case is omitted.

It is based off the official documentation, and we translate the French terms as follows:
* Granule -> Block
* Catalogue -> File Allocation Table

```C
/* First entry in the File Allocation table, defines disk properties */
struct ngr {
	/* Number of 256 byte sectors used in logical blocks.
	 * Defines the minimum file size. Can only be multiples of 2. */
	uint8_t lgr;
	/* Number of the first sector not belonging to the FAT.
	 * Limited between 13 and 76. */
	uint8_t lcat;
	/* Magic value = 9F */
	uint8_t ind;
	uint8_t unused[5];	
}

struct file_descriptor
{
	uint16_t read_permissions;
	uint16_t write_permissions;
	uint8_t unused[3];
	struct {
		uint8_t block_quantity;
		/* First 4 bits are ignored */
		uint16_t block_number;
	} blocks[19];
}

struct fat_blocks
{
	uint8_t filename[31][8];
	uint8_t unused[64];
	struct file_descriptor descriptors[32];
}

struct prologue_fat
{
	struct ngr ngr;

	/* number of entries depends on ngr.lcat */
	struct fat_blocks fat[...];
}
```

Similar to CP/M, the exact filesize is not known. It's a multiple of the block size, in this case 4KB.

Sources:

R2E Prologue documentation: https://oldcomputers.dyndns.org/public/pub/rechner/olympia/boss/manual/r2e_prologue_(noir-et-blanc).pdf


## Example

Analyzing disk 10. Converted it with `hxcfe -finput:dumps/0010.afi -conv:RAW_LOADER -foutput:0010.img`

```
0X0000: 23 00 FF FF FF FF 60 00
-> 37 used blocks?

0x400: 1016 9f00 0000 0000
-> LGR = 0x10 = 16 sectors per block
-> LCAT = 0x16 = files start at sector 22 (0x1600?)

First two entries:
0x408: 5359 5354 504f 524f   SYSTPORO
0x410: 2f20 2020 2020 204f   /      O

0x500: 5359 5354 2020 2020 0000 0000 0000 0000  SYST    ........
0x510: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0x520: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0x530: 0000 0000 0000 0000 0000 0000 0000 0000  ................

0x540: 2020 2020 0000 0004 0008 0000 0000 0000      ............
0x550: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0x560: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0x570: 0000 0000 0000 0000 0000 0000 0000 0000  ................

```
