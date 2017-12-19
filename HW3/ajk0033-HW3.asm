;Author: Austin Keelin
;
;Username: ajk0033
;
;Homework 3

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	input byte 1,0Bh,9,5,0Fh,8,2,0Eh,7,6,3,4
	output byte LENGTHOF input dup(?)
	shift dword 7
	;Output should be:8,2,E,7,6,3,4,1,B,9,5,F
.code
	main proc
		mov eax, 0
		mov ebx, LENGTHOF input
		sub ebx, shift
		mov ecx, shift
		mov edx, 0
		L:
			mov al, input[ebx]
			mov output[edx], al
			inc edx
			inc ebx
		loop L
		
		mov edx, 0
		mov ebx, shift
		mov ecx, LENGTHOF input
		M:
			mov al, input[edx]
			mov output[ebx], al
			inc edx
			inc ebx
		loop M

		mov edx, 0
		mov ecx, LENGTHOF input
		N:
			mov al, output[edx]
			inc edx
		loop N

		invoke ExitProcess,0
	main endp
end main