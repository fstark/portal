# Disk structure

This is the structure for Portal-specific disks:
* Single sided
* 40 tracks
* 16 soft sectors per track
* 256 bytes per sector

| Start  | End     | Sectors | Contents               |
| ------ | ------- | ------- | ---------------------- |
| 0x0    | 0xFF    | 1       | Granule allocation map |
| 0x100  | 0x3FF   | 3       | Empty                  |
| 0x400  | 0X1FFF  | 28      | File table (catalog)   |
| 0x2000 | 0x27FFF | 608     | File contents          |

Disks can theorically hold 152 KB of data, including the OS.
The exact size per disk depends on the filesystem headers.

# Prologue filesystem

Below is a description of the Prologue filesystem headers, applicable to the Portal.
Some information not relevant to the Portal use-case is omitted.

It is based off the official documentation. Some concepts:
* Granule = logical blocks
* Catalog = File Allocation Table

```C
/* First entry in the catalog, defines disk properties */
struct ngr {
	/* Number of 256 byte sectors used in granules.
	 * Defines the minimum file size. Can only be multiples of 2. */
	uint8_t lgr;
	/* Number of the first sector not belonging to the catalog.
	 * Limited between 13 and 76. */
	uint8_t lcat;
	/* Magic value = 9F */
	uint8_t ind;
	uint8_t unused[5];
};

/* Not applicable to the first catalog entry */
struct file_descriptor
{
	uint16_t read_permissions;
	uint16_t write_permissions;
	uint8_t unused[3];
	struct {
		uint8_t quantity;
		/* First 4 bits are ignored */
		uint16_t number;
	} granules[19];
};

struct catalog_entries
{
	/* First catalog entry is a struct ngr */
	uint8_t filename[32][8];
	uint8_t unused[64];
	struct file_descriptor descriptors[32];
};

struct prologue_catalog
{
	struct ngr ngr;

	/* number of entries depends on ngr.lcat */
	struct catalog_entries *entries;
};
```

Similar to CP/M, the exact filesize is not known. It's a multiple of the granule size, in this case 4KB.

Sources:

R2E Prologue documentation: https://oldcomputers.dyndns.org/public/pub/rechner/olympia/boss/manual/r2e_prologue_(noir-et-blanc).pdf


## Example

Analyzing disk 10. Converted it with `hxcfe -finput:dumps/0010.afi -conv:RAW_LOADER -foutput:0010.img`

Granules values below are annotated as number(address)

| Index | Name        | Granules             | Size |
| ----- | ----------- | -------------------- | ---- |
| 0     | -           |                      |      |
| 1     | `SYSTPOT.O` | 4(0x8)               | 4    |
| 2     | `MM.O`      | 2(0x10)              | 2    |
| 3     | `ED.O`      | 2(0x18)              | 2    |
| 4     | `LOEXT.O`   | 2(0x4)               | 2    |
| 5     | `FM.O`      | 2(0xc)               | 2    |
| 6     | `TEST.S`    | 1(0x14)              | 1    |
| 7     | `MODENS.O`  | 1(0x1c)              | 1    |
| 8     | `EX.O`      | 1(0x2) 1(0x1f) 2(0x21)| 4    |
| 9     | `CP.O`      | 2(0xe)               | 2    |
| 10    | `/.O`       | 2(0x12)              | 2    |
| 11    | `TRANSP.S`  | 2(0x16) 1(0x1a)      | 3    |
| 12    | `IMP.S`     | 1(0x15)              | 1    |
| 13    | `IMP.O`     | 1(0x6)               | 1    |
| 14    | `TR.O`      | 1(0x3) 1(0x7) 1(0x1b) 1(0x1d) | 4    |
| 15    | `SYSTER.O`  | 1(0x1e)              | 1    |
| 16    | `TEST.T`    | 1(0x20)              | 1    |

Total: 33 allocated. Header bitmap says 34 though?

```
0X0000: 23 00 FF FF FF FF 60 00
-> 0x23 = 35 max granules
-> 0xFFFFFFFF60 = 34 bits set, only one free.

0x400: 1016 9f00 0000 0000
-> LGR  = 0x10 = 16 sectors per granule
-> LCAT = 0x16 = files start at sector 22 (0x1600?)

We get a max capacity of 35 * 16 * 256 = 140KB

First two entries:
0x408: 5359 5354 504f 544f   SYSTPOTO
0x410: 4d4d 2020 2020 204f   MM     O

0x500: 5359 5354 2020 2020 0000 0000 0000 0000  SYST    ........
[0000]
0x540: 2020 2020 0000 0004 0008 0000 0000 0000      ............
[0000]
0x580: 2020 2020 0000 0002 0010 0000 0000 0000      ............
-> SYSPOT.O = 4 granules, starts at 8th
-> MM.O = 2 granules, start at 0x10th
```

# Binary files

It appears binary files have a header, which purpose is unknown yet.

For instance, the two versions of `STATUS.O` start with:
* Version A: `03d0 065e ffc2 0000 0100 c34f 02`
* Version B: `03d0 0799 ffc2 0000 0100 c34f 03`

It is safe to assume the program really starts at the 10th byte, as it's `NOP`
followed by a `JMP`. This is because the (French) R2E Prologue documentation
mentions programs starting with a `NOP` can be "reinitialized without being reloaded".

All executable files start with `0x03D0`, including the OS. The rest appears to be of varying size and finishes with `0x0001`, except for the OS.
