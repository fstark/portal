all: debug8.bin

debug.hex: debug.asm
	../../a85/a85 debug.asm -o debug.ihex -l debug.lst

debug.bin: debug.hex
	objcopy --input-target=ihex --output-target=binary debug.ihex debug.bin
	truncate -s 2048 debug.bin

debug8.bin: debug.bin
	cat debug.bin debug.bin debug.bin debug.bin > debug8.bin

clean:
	rm -f debug.ihex debug.bin debug8.bin debug.lst
