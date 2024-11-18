# Floppy images

The following images come from the same box of Portal software archives. They were dumped by Jeff/HxC2001

All disks are single sided, 40 tracks, 16 soft sectors, 256 bytes per sector.

Number | Title                              | Dump | Bootable | Contents 
------ | ---------------------------------- | ---- | -------- | --------
 0001  | SYST1.9                            |  OK* | ?        | ?
 0002  | Trans. Emission                    |  OK  | ?        | ?
 0003  | Trans. Recepteur                   |  OK  | ?        | ?
 0004  | Test Transmission Portal N°2       |  OK  | ?        | ?
 0005  | Test auto Portal                   |  OK* | ?        | ?
 0006  | Test endurance floppy              |  OK  | ?        | ?
 0007  | 2bis                               |  OK  | ?        | ?
 0008  | Test floppy sous TSMG              |  OK  | ?        | ?
 0009  | TSMG.FLOPPY                        |  OK  | ?        | ?
 0010  | Prologue Portal avec S/P IMP-O     |  OK  | ?        | ?
 0011  | Systeme Prologue avec sortie EPSON |  OK  | ?        | ?
 0012  | Portal Test Mémoire CR             |  OK* | ?        | ?
 0013  | PORTAL.AZM PATCH 2                 |  OK  | ?        | ?
 0014  | test disquette                     |  OK  | ?        | ?
 0015  | essais TSMG                        |  OK  | ?        | ?
 0016  | Trans Emetteur                     |  OK  | ?        | ?
 0017  | Test Transmission N°2 reception    |  OK  | ?        | ?
 0018  | Test Transmission N°2 reception    |  OK  | ?        | ?
 0019  | Test Automat.                      |  OK  | ?        | ?
 0020  | Verif Epson Automatique            |  OK  | ?        | ?
 0021  | Test imprimante Epson              |  OK  | ?        | ?
 0022  | Prologue Portal                    |  OK  | ?        | ?
 0023  | Systeme avec sortie Epson          |  OK  | ?        | ?
 0024  | Test memoire Portal                |  OK  | ?        | ?
 0025  | Test V24 Portal CDC Modens         |  OK  | ?        | ?

\*: 1 corrupted sector

The images use the .AFI file format, which is readable in [HxC2001_FloppyEmulator](https://github.com/jfdelnero/HxCFloppyEmulator).

Either drag and drop the file in the GUI, or use `hxcfe` to convert it:
```bash
# AFI -> IMD
hxcfe -finput:0022.afi -conv:IMD_IMG -foutput:0022.imd

# AFI -> Raw sectors
hxcfe -finput:0022.afi -conv:RAW_LOADER -foutput:0022.img
```
