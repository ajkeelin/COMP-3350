;Author: Austin Keelin
;
;Username: ajk0033
;
;Homework 4

.386
.model flat, stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	s1 byte "DANGER"
	s2 byte "GARDEN"
	c1 byte 26 dup(0)
	c2 byte 26 dup(0)
.code
	main proc
		mov eax, 1
		mov ebx, 0
		mov ecx, lengthof s1
		mov edx, 0

		L1:
			mov dl, s1[ebx] ;ebx used as counter to select each char from s1 and s2
			inc c1[edx - 65] ;Substract 65 from each decimal value of the selected char ie 'A' = 0, 'B' = 1 ...
			mov edx, 0
			mov dl, s2[ebx]
			inc c2[edx - 65]
			mov edx, 0
			inc ebx
		loop L1

		mov ebx, 0
		mov ecx, 26
		mov edx, 0
		L2:
			dec ecx		;Decrement ecx
			cmp ecx, 0	;Compare ecx to lowest value 0, which is char 'A'
			JL exit	;Exit if ecx is less than A
			mov bl, c1[ecx]
			mov dl, c2[ecx]
			cmp bl, dl	;Compare c1 and c2 using registers
			JE L2	;Loop if c1 and c2 are equal
			mov eax, 0	;If they are not equal, set eax to 0 and exit
		
		exit:

	invoke ExitProcess,0
	main endp
end main