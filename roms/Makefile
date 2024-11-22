all: debug.bin

debug.hex: debug.asm
	../../a85/a85 debug.asm -o debug.ihex -l debug.lst

debug.bin: debug.hex
	objcopy --input-target=ihex --output-target=binary debug.ihex debug.bin
	truncate -s 2048 debug.bin

2716.bin: debug.bin
	cat debug.bin > 2716.bin

2732.bin: 2716.bin
	cat 2716.bin 2716.bin > 2732.bin

2764.bin: 2732.bin
	cat 2732.bin 2732.bin > 2764.bin

clean:
	rm -f debug.ihex debug.bin 2732.bin 2764.bin debug.lst

burn: debug.bin
	minipro -p M2716@DIP24 -w debug.bin

burn2732A: 2732.bin
	minipro -p M2732A@DIP24 -w 2732.bin --vpp 21

display2716:
	minipro -p M2716@DIP24 -r /tmp/temp.bin
	xxd /tmp/temp.bin | head

display2732:
	minipro -p M2732A@DIP24 -r /tmp/temp.bin
	xxd /tmp/temp.bin | head

blank2716:
	minipro -p M2716@DIP24 -b

blank2732:
	minipro -p M2732A@DIP24 -b
