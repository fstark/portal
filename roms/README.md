# Portal ROMs

Here are the original dumps of my Portal, made to reverse engineer it to be able to bring it back into a bootable state.

Anyone with a broken portal will need those ROMs to be able to fix it.

All the ROMs were written on 2716 EPROMs.

## Dumps

Dump list:
* [1160110: boot ROM](portal.bin)
* [1160110: boot ROM (variant)](portal_variant.bin): this comes from another machine
* [2021310: keyboard ROM](keyboard.bin)

8085 Assembly, loaded at 0. Only 0x432 (1074) bytes are used.

See [hardware docs](../docs/hardware.md) for more information.
