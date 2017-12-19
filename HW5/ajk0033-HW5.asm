;Author: Austin Keelin
;
;User: ajk0033
;
;Homework 5
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	pt byte "MEMORY" ;Use this pt when encrypting
	ct byte lengthof pt dup(0)
	key byte "BAD"
	;pt byte lengthof ct dup(0) ;Use this pt when decrypting
	keypt byte lengthof ct dup(0) ;Used to repeat text of key

	alpha byte 26 * 26 dup(0) ;Array for cipher
.code
	main proc
		call TwoDimArray
		call RepKey
		call Encrypt
		call Decrypt

		invoke ExitProcess, 0
	main endp

	TwoDimArray proc
		mov bl, 65
		mov dl, 65
		mov ecx, 26
		mov edi, 0
		mov esi, 0
		OL:
			IL:
				mov alpha[esi], bl
				inc bl
				cmp bl, 91
				jl J
				mov bl, 65 ;When bl passes 'Z', return to 'A'
				J:

				inc esi
			loop IL
		inc edi
		cmp edi, 26
		jz Exit
		inc dl
		mov bl, dl ;dl starts at 'A' and increments until 'Z'
		mov ecx, 26
		jmp OL
		Exit:

		ret
	TwoDimArray endp

	RepKey proc
		mov eax, lengthof key
		mov ebx, lengthof keypt
		mov ecx, 0
		mov edx, 0
		mov edi, 0
		L:	
			mov cl, key[edi]
			mov keypt[edx], cl
			inc edx
			inc edi
			cmp edi, eax
			jl A
			mov edi, 0
			A:
			cmp edx, ebx
			jl L

		ret
	RepKey endp

	Encrypt proc
		mov ecx, 0
		L:
			mov eax, 0
			mov eax, 26
			mov ebx, 0

			mov bl, pt[ecx] ;Move next char in pt into bl
			sub bl, 65
			mov edx, 0
			mov dl, keypt[ecx] ;Move next char in keypt into dl
			sub dl, 65
			mul dl ;Mul 26 * row number [keypt]
			add eax, ebx ;Add column number [pt]

			mov edx, 0
			mov dl, alpha[eax] ;eax is the position of the encrypted char
			mov ct[ecx], dl ;Encrypted char is moved into current position of ct

			inc ecx
			cmp ecx, lengthof keypt
			jl L

		ret
	Encrypt endp

	Decrypt proc
		;Counters
		;eax - what row to search
		;ebx - what row we are in
		;edi - position of what we're decrypting
		mov edi, 0
		mov ebx, 0
		mov ecx, 0
		mov edx, 0
		OL:
			mov eax, 26
			mov cl, ct[edi] ;Target: cypher text you are trying to find in the row
			sub ecx, 65
			mov bl, keypt[edi] ;Move in next char from the key
			sub ebx, 65
			mul bl ;determine what row to search
			mov ebx, -1 ;Then used in IL as counter to determine what row we find the target char in
			IL:
				mov dl, alpha[eax] ;Go through each char in the target row
				sub dl, 65
				inc eax
				inc ebx
				cmp cl, dl ;Compare each char in row to the target char in ecx
				jne IL
				add bl, 65
				mov pt[edi], bl
			
			inc edi
			cmp edi, lengthof keypt
			jne OL

		ret
	Decrypt endp
end main