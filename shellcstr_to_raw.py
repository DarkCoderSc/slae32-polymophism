#!/usr/bin/python3

# Jean-Pierre LESUEUR (@DarkCoderSc)
# www.phrozen.io
# SLAE32

import sys

def bytestr_to_bytearr(data):
	return list(bytearray.fromhex(data.replace("\\x", " ")))

if (len(sys.argv) != 2):
	print("Usage: shellcode_to_raw.py <shellcode[Ex: \\xff\\x90\\x92...]>")
else:
	sys.stdout.buffer.write(bytes(bytestr_to_bytearr(sys.argv[1])))
