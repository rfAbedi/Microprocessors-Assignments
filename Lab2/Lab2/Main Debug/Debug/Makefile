###############################################################################
# Makefile for project 
###############################################################################

## General options
PROJECT = 
MCU = 8086
COMPILER = "MASM32"
TARGET = Debug
SHELL = C:\Windows\system32\cmd.exe

## Tools general options
ASMFLAGS=/c /Zd /Zi
LDFLAGS=/CODEVIEW

## Processing Tools
ASM=ml.exe
LD=link16.exe
#  C:/Users/ROG/AppData/Local/Temp/VSM Studio/626878d8ecf64fde8c9ae4a91bb31af6/8086_1/Debug/Debug.exe: TOOL=LD
#     C:/Users/ROG/AppData/Local/Temp/VSM Studio/626878d8ecf64fde8c9ae4a91bb31af6/8086_1/Debug/main.obj: TOOL=ASM
#        C:/Users/ROG/AppData/Local/Temp/VSM Studio/626878d8ecf64fde8c9ae4a91bb31af6/8086_1/main.asm

# Build tree:
all:	Debug

Debug:	Debug.exe

Debug.exe:	main.obj 
	$(LD) $(LDFLAGS) main.obj,Debug.exe,nul.map,,,

main.obj:	../main.asm 
	$(ASM) $(ASMFLAGS) ../main.asm

# tidy - delete all temporary files which are not involved in the target generation
tidy:

# cleanup - delete all generated files
clean:	tidy
	rm -rf Debug.exe
	rm -rf main.obj
