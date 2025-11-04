        .686p
        .mmx
        .model tiny

; ===========================================================================

; Segment type: Pure code
seg000      segment byte public 'CODE' use16
        assume cs:seg000
        org 100h
        assume es:nothing, ss:nothing, ds:seg000, fs:nothing, gs:nothing

; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

        public start
start       proc near
        jmp short $+2
; ---------------------------------------------------------------------------

main:                   ; CODE XREF: startj
        mov ax, cs
        mov ds, ax
        mov es, ax
        assume es:seg000
        call    initmem
        call    initscreen
        call    initwindow
        cmp byte ptr ds:80h, 0
        jnz short loc_10120

loc_10118:              ; CODE XREF: start+38j
        mov word ptr unk_1450C, 0
        jmp short loc_10151
; ---------------------------------------------------------------------------

loc_10120:              ; CODE XREF: start+16j
        mov bl, ds:80h
        xor bh, bh
        add bx, 81h
        mov byte ptr [bx], 0
        mov dx, 81h
        call    strip
        call    strlen
        or  ax, ax
        jz  short loc_10118
        mov bx, dx

loc_1013C:              ; CODE XREF: start+42j
        cmp byte ptr [bx], 20h
        jnz short loc_10144
        inc bx
        jmp short loc_1013C
; ---------------------------------------------------------------------------

loc_10144:              ; CODE XREF: start+3Fj
        mov si, bx
        mov di, 450Ch
        mov dx, di
        call    strcpy
        call    strupr

loc_10151:              ; CODE XREF: start+1Ej
        call    sub_10C74
        call    sub_101BA
        call    sub_103DA
        call    sub_10834
        call    sub_111C8
        call    sub_11C32
        call    sub_11D1E
        call    sub_1226A
        call    sub_12570
        call    sub_1259D
        cmp byte ptr unk_1450C, 0
        jz  short loc_10183
        mov si, 450Ch
        call    sub_10688
        jb  short loc_10190
        call    sub_10456
        jmp short loc_1018A
; ---------------------------------------------------------------------------

loc_10183:              ; CODE XREF: start+74j
        xor ax, ax
        call    sub_126A9
        jb  short loc_10190

loc_1018A:              ; CODE XREF: start+81j
        call    sub_112F2
        call    sub_125D6

loc_10190:              ; CODE XREF: start+7Cj start+88j
        call    nullsub_4
        call    nullsub_3
        call    sub_11D22
        call    sub_11CB9
        call    nullsub_2
        call    sub_10857
        call    nullsub_1
        call    sub_101F9
        call    sub_10D28

loc_101AB:              ; CODE XREF: sub_101BA+15j
                    ; sub_10834+16j sub_10C74+1Dj
                    ; sub_10C74+56j sub_10C74+84j
        call    sub_13338
        call    nullsub_5
        call    nullsub_6
        mov ax, 4C00h
        int 21h     ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
start       endp            ; AL = exit code

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_101BA   proc near       ; CODE XREF: start+54p
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        mov ax, 4000h
        call    sub_13793
        or  ax, ax
        jnz short loc_101D2
        mov dx, 3C7Dh
        call    sub_10DA6
        jmp loc_101AB
; ---------------------------------------------------------------------------

loc_101D2:              ; CODE XREF: sub_101BA+Dj
        mov word ptr unk_14504, es
        mov word ptr unk_14506, ax
        mov ax, 3000h
        int 21h     ; DOS - GET DOS VERSION
                    ; Return: AL = major version number (00h for DOS 1.x)
        cmp al, 3
        ja  short loc_101E7
        cmp ah, 0Ah
        jb  short loc_101F3

loc_101E7:              ; CODE XREF: sub_101BA+26j
        push    ds
        mov ax, 2524h
        mov dx, 208h
        push    cs
        pop ds
        int 21h     ; DOS - SET INTERRUPT VECTOR
                    ; AL = interrupt number
                    ; DS:DX = new vector to be used for specified interrupt
        pop ds

loc_101F3:              ; CODE XREF: sub_101BA+2Bj
        pop es
        assume es:nothing
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_101BA   endp


; =============== S U B R O U T I N E =======================================


sub_101F9   proc near       ; CODE XREF: start+A5p
        push    ax
        push    es
        mov es, word ptr unk_14504
        mov ax, word ptr unk_14506
        call    sub_1381B
        pop es
        pop ax
        retn
sub_101F9   endp

; ---------------------------------------------------------------------------
        db 1Eh, 0Eh, 1Fh, 0C6h, 6, 56h, 39h, 1, 1Fh, 0B0h, 3, 0CFh

; =============== S U B R O U T I N E =======================================


sub_10214   proc near       ; CODE XREF: sub_103E9:loc_10418p
                    ; sub_1205E+6p
        push    ax
        push    dx
        push    dx
        mov dx, 3B42h
        call    message
        pop dx
        mov ax, 3D00h
        int 21h     ; DOS - 2+ - OPEN DISK FILE WITH HANDLE
                    ; DS:DX -> ASCIZ filename
                    ; AL = access mode
                    ; 0 - read
        jnb short loc_1022B
        call    closewindow
        stc
        jmp short loc_10237
; ---------------------------------------------------------------------------

loc_1022B:              ; CODE XREF: sub_10214+Fj
        mov word ptr unk_14502, ax
        xor ax, ax
        mov word ptr unk_1450A, ax
        mov word ptr unk_14508, ax
        clc

loc_10237:              ; CODE XREF: sub_10214+15j
        pop dx
        pop ax
        retn
sub_10214   endp


; =============== S U B R O U T I N E =======================================


sub_1023A   proc near       ; CODE XREF: sub_1026A+17p
        push    ax
        push    bx
        push    cx
        push    dx
        mov ah, 3Fh
        mov bx, word ptr unk_14502
        mov cx, 4000h
        xor dx, dx
        push    ds
        mov ds, word ptr unk_14504
        int 21h     ; DOS - 2+ - READ FROM FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to read
                    ; DS:DX -> buffer
        pop ds
        jnb short loc_1025C
        mov dx, 3C8Bh
        call    sub_10DA6
        stc
        jmp short $+2
; ---------------------------------------------------------------------------

loc_1025C:              ; CODE XREF: sub_1023A+17j
                    ; sub_1023A+20j
        mov word ptr unk_1450A, ax
        mov word ptr unk_14508, 0
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_1023A   endp


; =============== S U B R O U T I N E =======================================


sub_1026A   proc near       ; CODE XREF: sub_103E9:loc_10425p
                    ; sub_1205E+2Dp
        push    bx
        push    cx
        push    di
        push    si
        push    es
        mov di, dx
        mov bx, ax
        mov es, word ptr unk_14504
        mov si, word ptr unk_14508

loc_1027B:              ; CODE XREF: sub_1026A+31j
                    ; sub_1026A+3Fj
        cmp si, word ptr unk_1450A
        jb  short loc_10291
        call    sub_1023A
        jb  short loc_102C1
        mov si, word ptr unk_14508
        cmp word ptr unk_1450A, 0
        jz  short loc_102AE

loc_10291:              ; CODE XREF: sub_1026A+15j
        mov al, es:[si]
        inc si
        cmp al, 1Ah
        jz  short loc_102AE
        cmp al, 0Dh
        jz  short loc_1027B
        cmp al, 0Ah
        jz  short loc_102AB
        xor bx, bx
        dec cx
        jz  short loc_102B5
        mov [di], al
        inc di
        jmp short loc_1027B
; ---------------------------------------------------------------------------

loc_102AB:              ; CODE XREF: sub_1026A+35j
        inc bx
        jmp short loc_102BD
; ---------------------------------------------------------------------------

loc_102AE:              ; CODE XREF: sub_1026A+25j
                    ; sub_1026A+2Dj
        cmp di, dx
        jnz short loc_102BD
        stc
        jmp short loc_102C1
; ---------------------------------------------------------------------------

loc_102B5:              ; CODE XREF: sub_1026A+3Aj
        push    dx
        mov dx, 3CD6h
        call    sub_10DA6
        pop dx

loc_102BD:              ; CODE XREF: sub_1026A+42j
                    ; sub_1026A+46j
        mov byte ptr [di], 0
        clc

loc_102C1:              ; CODE XREF: sub_1026A+1Aj
                    ; sub_1026A+49j
        mov word ptr unk_14508, si
        mov ax, bx
        pop es
        pop si
        pop di
        pop cx
        pop bx
        retn
sub_1026A   endp


; =============== S U B R O U T I N E =======================================


sub_102CD   proc near       ; CODE XREF: sub_103E9:loc_1042Fp
                    ; sub_1205E:loc_120ABp
        push    ax
        push    bx
        mov ah, 3Eh
        mov bx, word ptr unk_14502
        int 21h     ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                    ; BX = file handle
        jnb short loc_102E2
        push    dx
        mov dx, 3CB5h
        call    sub_10DA6
        pop dx
        stc

loc_102E2:              ; CODE XREF: sub_102CD+Aj
        pushf
        call    closewindow
        popf
        pop bx
        pop ax
        retn
sub_102CD   endp


; =============== S U B R O U T I N E =======================================


sub_102EA   proc near       ; CODE XREF: sub_1047B+7p sub_120C3+2p
        push    ax
        push    cx
        push    dx
        push    dx
        mov dx, 3B4Fh
        call    message
        pop dx
        mov ah, 3Ch
        xor cx, cx
        int 21h     ; DOS - 2+ - CREATE A FILE WITH HANDLE (CREAT)
                    ; CX = attributes for file
                    ; DS:DX -> ASCIZ filename (may include drive and path)
        jnb short loc_10309
        call    closewindow
        mov dx, 3CA2h
        call    sub_10DA6
        stc
        jmp short loc_10315
; ---------------------------------------------------------------------------

loc_10309:              ; CODE XREF: sub_102EA+11j
        mov word ptr unk_14502, ax
        xor ax, ax
        mov word ptr unk_1450A, ax
        mov word ptr unk_14508, ax
        clc

loc_10315:              ; CODE XREF: sub_102EA+1Dj
        pop dx
        pop cx
        pop ax
        retn
sub_102EA   endp


; =============== S U B R O U T I N E =======================================


sub_10319   proc near       ; CODE XREF: sub_10350+Ap
                    ; sub_10371+21p sub_103B9+2p
        push    ax
        push    bx
        push    cx
        push    dx
        mov ah, 40h
        mov bx, word ptr unk_14502
        mov cx, word ptr unk_14508
        xor dx, dx
        jcxz    short loc_10344
        push    ds
        mov ds, word ptr unk_14504
        int 21h     ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
        pop ds
        jb  short loc_1033B
        cmp ax, word ptr unk_14508
        jz  short loc_10344

loc_1033B:              ; CODE XREF: sub_10319+1Aj
        mov dx, 3C96h
        call    sub_10DA6
        stc
        jmp short loc_10345
; ---------------------------------------------------------------------------

loc_10344:              ; CODE XREF: sub_10319+10j
                    ; sub_10319+20j
        clc

loc_10345:              ; CODE XREF: sub_10319+29j
        mov word ptr unk_14508, 0
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10319   endp


; =============== S U B R O U T I N E =======================================


sub_10350   proc near       ; CODE XREF: sub_10371+38p
                    ; sub_10371+3Fp
        push    di
        push    es
        cmp word ptr unk_14508, 4000h
        jb  short loc_1035F
        call    sub_10319
        jb  short loc_1036E

loc_1035F:              ; CODE XREF: sub_10350+8j
        mov es, word ptr unk_14504
        mov di, word ptr unk_14508
        cld
        stosb
        mov word ptr unk_14508, di
        clc

loc_1036E:              ; CODE XREF: sub_10350+Dj
        pop es
        pop di
        retn
sub_10350   endp


; =============== S U B R O U T I N E =======================================


sub_10371   proc near       ; CODE XREF: sub_1047B+2Cp
                    ; sub_120C3:loc_120D2p
        push    ax
        push    bx
        push    di
        push    si
        push    es
        mov si, dx
        mov bx, ax
        mov es, word ptr unk_14504
        mov di, word ptr unk_14508
        cld

loc_10383:              ; CODE XREF: sub_10371+2Cj
        lodsb
        or  al, al
        jz  short loc_1039F
        cmp di, 4000h
        jb  short loc_1039C
        mov word ptr unk_14508, di
        call    sub_10319
        mov di, word ptr unk_14508
        jb  short loc_103B3
        cld

loc_1039C:              ; CODE XREF: sub_10371+1Bj
        stosb
        jmp short loc_10383
; ---------------------------------------------------------------------------

loc_1039F:              ; CODE XREF: sub_10371+15j
        mov word ptr unk_14508, di
        or  bx, bx
        jz  short loc_103B3
        mov al, 0Dh
        call    sub_10350
        jb  short loc_103B3
        mov al, 0Ah
        call    sub_10350

loc_103B3:              ; CODE XREF: sub_10371+28j
                    ; sub_10371+34j sub_10371+3Bj
        pop es
        pop si
        pop di
        pop bx
        pop ax
        retn
sub_10371   endp


; =============== S U B R O U T I N E =======================================


sub_103B9   proc near       ; CODE XREF: sub_1047B:loc_104AFp
                    ; sub_120C3:loc_120DCp
        push    ax
        push    bx
        call    sub_10319
        mov ah, 3Eh
        mov bx, word ptr unk_14502
        int 21h     ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                    ; BX = file handle
        jnb short loc_103D1
        push    dx
        mov dx, 3CB5h
        call    sub_10DA6
        pop dx
        stc

loc_103D1:              ; CODE XREF: sub_103B9+Dj
        pushf
        call    closewindow
        popf
        pop bx
        pop ax
        retn
sub_103B9   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_103DA   proc near       ; CODE XREF: start+57p
        push    ax
        xor al, al
        mov byte ptr unk_145FF, al
        mov byte ptr unk_1455D, al
        mov byte ptr unk_145AE, al
        pop ax
        retn
sub_103DA   endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_1. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B R O U T I N E =======================================


sub_103E9   proc near       ; CODE XREF: sub_10456:loc_10472p
                    ; sub_126A9+4Bp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        mov byte ptr unk_14AD1, 0
        push    ds
        pop es
        assume es:seg000
        mov di, 49BFh
        mov ax, 4300h
        mov dx, 450Ch
        int 21h     ; DOS - 2+ - GET FILE ATTRIBUTES
                    ; DS:DX -> ASCIZ file name or directory
                    ; name without trailing slash
        jnb short loc_10418
        cmp ax, 2
        jz  short loc_10436

loc_10408:              ; CODE XREF: sub_103E9+32j
        mov dx, 3CA2h
        call    sub_10DA6
        mov byte ptr unk_1450C, 0
        call    sub_1102A
        jmp short loc_10436
; ---------------------------------------------------------------------------

loc_10418:              ; CODE XREF: sub_103E9+18j
        call    sub_10214
        jb  short loc_10408
        mov dx, di
        mov cx, 0FFh
        mov ax, 1

loc_10425:              ; CODE XREF: sub_103E9+44j
        call    sub_1026A
        jb  short loc_1042F
        call    sub_10BDE
        jnb short loc_10425

loc_1042F:              ; CODE XREF: sub_103E9+3Fj
        call    sub_102CD
        or  ax, ax
        jz  short loc_1043C

loc_10436:              ; CODE XREF: sub_103E9+1Dj
                    ; sub_103E9+2Dj
        mov byte ptr [di], 0
        call    sub_10BDE

loc_1043C:              ; CODE XREF: sub_103E9+4Bj
        mov dx, 450Ch
        call    sub_1053D
        mov byte ptr unk_14AC9, 0
        call    sub_10FCC
        mov byte ptr unk_14AD1, 1
        pop es
        assume es:nothing
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_103E9   endp


; =============== S U B R O U T I N E =======================================


sub_10456   proc near       ; CODE XREF: start+7Ep sub_106F8+4Cp
        push    ax
        push    dx
        cmp word_13918, 0
        jz  short loc_10462
        call    sub_12606

loc_10462:              ; CODE XREF: sub_10456+7j
        mov dx, 450Ch
        call    sub_128EB
        cmp ax, 0FFFFh
        jz  short loc_10472
        call    sub_126A9
        jmp short loc_10478
; ---------------------------------------------------------------------------

loc_10472:              ; CODE XREF: sub_10456+15j
        call    sub_103E9
        call    sub_12676

loc_10478:              ; CODE XREF: sub_10456+1Aj
        pop dx
        pop ax
        retn
sub_10456   endp


; =============== S U B R O U T I N E =======================================


sub_1047B   proc near       ; CODE XREF: sub_10753+57p
                    ; sub_10753+65p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        call    sub_102EA
        jnb short loc_10491
        mov byte ptr unk_1450C, 0
        call    sub_1102A
        jmp short loc_104BA
; ---------------------------------------------------------------------------

loc_10491:              ; CODE XREF: sub_1047B+Aj
        push    ds
        pop es
        assume es:seg000
        mov di, 49BFh
        mov dx, di
        mov cx, word_13918
        xor ax, ax

loc_1049E:              ; CODE XREF: sub_1047B+32j
        call    sub_10895
        inc ax
        push    ax
        sub ax, word_13918
        call    sub_10371
        pop ax
        jb  short loc_104AF
        loop    loc_1049E

loc_104AF:              ; CODE XREF: sub_1047B+30j
        call    sub_103B9
        mov byte ptr unk_14AC9, 0
        call    sub_10FCC

loc_104BA:              ; CODE XREF: sub_1047B+14j
        pop es
        assume es:nothing
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_1047B   endp


; =============== S U B R O U T I N E =======================================


sub_104C2   proc near       ; CODE XREF: sub_10573+31p
                    ; sub_10688+2Ep sub_106F8+Dp
                    ; sub_10753+11p
        push    ax
        push    si
        call    strlen
        mov si, dx
        add si, ax
        dec si
        std

loc_104CD:              ; CODE XREF: sub_104C2+1Ej
        cmp si, dx
        jb  short loc_104E2
        lodsb
        cmp al, 3Fh
        jz  short loc_104E5
        cmp al, 2Ah
        jz  short loc_104E5
        cmp al, 2Fh
        jz  short loc_104E2
        cmp al, 5Ch
        jnz short loc_104CD

loc_104E2:              ; CODE XREF: sub_104C2+Dj
                    ; sub_104C2+1Aj
        clc
        jmp short loc_104E6
; ---------------------------------------------------------------------------

loc_104E5:              ; CODE XREF: sub_104C2+12j
                    ; sub_104C2+16j
        stc

loc_104E6:              ; CODE XREF: sub_104C2+21j
        pop si
        pop ax
        retn
sub_104C2   endp


; =============== S U B R O U T I N E =======================================


sub_104E9   proc near       ; CODE XREF: sub_10753+54p
                    ; sub_10753+62p sub_10802+27p
        push    ax
        push    bx
        push    dx
        push    si
        push    di
        push    es
        mov bx, dx
        push    ds
        pop es
        assume es:seg000
        mov di, offset unk_14650
        mov si, dx
        call    strcpy
        mov dx, di
        call    strlen
        add di, ax
        mov si, di

loc_10504:              ; CODE XREF: sub_104E9+2Ej
        dec di
        cmp di, 4650h
        jb  short loc_1051B
        mov al, [di]
        cmp al, 2Fh
        jz  short loc_1051B
        cmp al, 5Ch
        jz  short loc_1051B
        cmp al, 2Eh
        jnz short loc_10504
        jmp short loc_1051D
; ---------------------------------------------------------------------------

loc_1051B:              ; CODE XREF: sub_104E9+20j
                    ; sub_104E9+26j sub_104E9+2Aj
        mov di, si

loc_1051D:              ; CODE XREF: sub_104E9+30j
        cld
        mov ax, 422Eh
        stosw
        mov ax, 4B41h
        stosw
        xor al, al
        stosb
        mov ah, 41h
        int 21h     ; DOS - 2+ - DELETE A FILE (UNLINK)
                    ; DS:DX -> ASCIZ pathname of file to delete (no wildcards allowed)
        mov dx, bx
        mov di, 4650h
        mov ah, 56h
        int 21h     ; DOS - 2+ - RENAME A FILE
                    ; DS:DX -> ASCIZ old name (drive and path allowed, no wildcards)
                    ; ES:DI -> ASCIZ new name
        pop es
        assume es:nothing
        pop di
        pop si
        pop dx
        pop bx
        pop ax
        retn
sub_104E9   endp


; =============== S U B R O U T I N E =======================================


sub_1053D   proc near       ; CODE XREF: sub_103E9+56p
        push    ax
        push    cx
        push    di
        push    si
        push    es
        call    strlen
        mov si, dx
        add si, ax
        mov cx, 1

loc_1054C:              ; CODE XREF: sub_1053D+21j
        dec si
        inc cx
        cmp si, dx
        jb  short loc_1056D
        mov al, [si]
        cmp al, 2Fh
        jz  short loc_1056D
        cmp al, 5Ch
        jz  short loc_1056D
        cmp al, 2Eh
        jnz short loc_1054C
        cmp cx, 5
        ja  short loc_1056D
        push    ds
        pop es
        assume es:seg000
        mov di, 3912h
        cld
        rep movsb

loc_1056D:              ; CODE XREF: sub_1053D+13j
                    ; sub_1053D+19j sub_1053D+1Dj
                    ; sub_1053D+26j
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        pop ax
        retn
sub_1053D   endp


; =============== S U B R O U T I N E =======================================


sub_10573   proc near       ; CODE XREF: sub_10688:loc_106B3p
                    ; sub_106F8:loc_10710p
                    ; sub_10753:loc_1076Fp
                    ; sub_107C1:loc_107D4p
        push    ax
        push    cx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        call    strlen
        mov si, dx
        add si, ax
        mov di, si

loc_10583:              ; CODE XREF: sub_10573+21j
        dec si
        cmp si, dx
        jb  short loc_10596
        mov al, [si]
        cmp al, 2Eh
        jz  short loc_105B6
        cmp al, 2Fh
        jz  short loc_10596
        cmp al, 5Ch
        jnz short loc_10583

loc_10596:              ; CODE XREF: sub_10573+13j
                    ; sub_10573+1Dj
        mov si, 3912h
        cmp byte ptr [si], 0
        jz  short loc_105B6
        cmp byte ptr [si+1], 0
        jnz short loc_105B3
        call    sub_104C2
        jnb short loc_105B3
        mov ax, 2A2Eh
        cld
        stosw
        xor al, al
        stosb
        jmp short loc_105C6
; ---------------------------------------------------------------------------

loc_105B3:              ; CODE XREF: sub_10573+2Fj
                    ; sub_10573+34j
        call    strcpy

loc_105B6:              ; CODE XREF: sub_10573+19j
                    ; sub_10573+29j
        mov di, dx
        call    strlen
        add di, ax
        dec di
        cmp byte ptr [di], 2Eh
        jnz short loc_105C6
        mov byte ptr [di], 0

loc_105C6:              ; CODE XREF: sub_10573+3Ej
                    ; sub_10573+4Ej
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        pop ax
        retn
sub_10573   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

sub_105CC   proc near       ; CODE XREF: sub_127BA+2Ap
                    ; sub_127F4+21p choosefile+76p

var_50      = byte ptr -50h

        push    bp
        mov bp, sp
        sub sp, 50h
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov cx, ax
        push    di
        lea di, [bp+var_50]
        mov ah, 19h
        int 21h     ; DOS - GET DEFAULT DISK NUMBER
        mov dl, al
        inc dl
        add al, 41h
        cld
        stosb
        mov ax, 5C3Ah
        stosw
        push    si
        mov ah, 47h
        mov si, di
        int 21h     ; DOS - 2+ - GET CURRENT DIRECTORY
                    ; DL = drive (0=default, 1=A, etc.)
                    ; DS:SI points to 64-byte buffer area
        mov dx, si
        call    strlen
        add si, ax
        cmp byte ptr [si-1], 5Ch
        jz  short loc_10609
        mov word ptr [si], 5Ch

loc_10609:              ; CODE XREF: sub_105CC+37j
        pop si
        pop di
        lea bx, [bp+var_50]
        mov dx, si
        cld

loc_10611:              ; CODE XREF: sub_105CC+4Fj
        mov ah, [bx]
        or  ah, ah
        jz  short loc_10621
        inc bx
        lodsb
        cmp al, ah
        jz  short loc_10611
        mov si, dx
        jmp short loc_10635
; ---------------------------------------------------------------------------

loc_10621:              ; CODE XREF: sub_105CC+49j
        push    dx
        mov dx, si
        call    strlen
        pop dx
        cmp ax, cx
        jbe short loc_10630
        mov si, dx
        jmp short loc_10635
; ---------------------------------------------------------------------------

loc_10630:              ; CODE XREF: sub_105CC+5Ej
        call    strcpy
        jmp short loc_10661
; ---------------------------------------------------------------------------

loc_10635:              ; CODE XREF: sub_105CC+53j
                    ; sub_105CC+62j
        push    ds
        pop es
        call    strcpy
        mov dx, di
        call    strlen
        mov dx, ax
        cmp dx, cx
        jbe short loc_10661
        add di, 3
        mov ax, 2E2Eh
        cld
        stosw
        mov ah, 5Ch
        stosw
        mov si, di

loc_10652:              ; CODE XREF: sub_105CC+8Aj
        inc si
        dec dx
        cmp dx, cx
        ja  short loc_10652
        cld

loc_10659:              ; CODE XREF: sub_105CC+90j
        lodsb
        cmp al, 5Ch
        jnz short loc_10659
        call    strcpy

loc_10661:              ; CODE XREF: sub_105CC+67j
                    ; sub_105CC+77j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        add sp, 50h
        pop bp
        retn
sub_105CC   endp


; =============== S U B R O U T I N E =======================================


askoverwrite    proc near       ; CODE XREF: sub_10753+31p
                    ; sub_10802+17p
        push    dx
        mov ax, 4300h
        int 21h     ; DOS - 2+ - GET FILE ATTRIBUTES
                    ; DS:DX -> ASCIZ file name or directory
                    ; name without trailing slash
        jnb short loc_1067A
        mov ax, 'Y'
        jmp short loc_10686
; ---------------------------------------------------------------------------

loc_1067A:              ; CODE XREF: askoverwrite+6j
        mov dx, offset aFileExists_Ove ; "File exists. Overwrite? (Y/N) "
        call    message
        call    CHOICE
        call    closewindow

loc_10686:              ; CODE XREF: askoverwrite+Bj
        pop dx
        retn
askoverwrite    endp


; =============== S U B R O U T I N E =======================================


sub_10688   proc near       ; CODE XREF: start+79p sub_106C3+20p
        push    ax
        push    dx
        push    di
        push    si
        mov di, si
        call    mkfullpath
        or  ax, ax
        jz  short loc_106A1
        mov dx, 3CC9h
        call    sub_10DA6
        mov byte ptr [di], 0
        stc
        jmp short loc_106BE
; ---------------------------------------------------------------------------

loc_106A1:              ; CODE XREF: sub_10688+Bj
        mov dx, di
        call    strlen
        add di, ax
        dec di
        cmp byte ptr [di], 5Ch
        jnz short loc_106B3
        inc di
        mov word ptr [di], 2Ah

loc_106B3:              ; CODE XREF: sub_10688+24j
        call    sub_10573
        call    sub_104C2
        jnb short loc_106BE
        call    choosefile

loc_106BE:              ; CODE XREF: sub_10688+17j
                    ; sub_10688+31j
        pop si
        pop di
        pop dx
        pop ax
        retn
sub_10688   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

sub_106C3   proc near       ; CODE XREF: sub_106F8+21p
                    ; sub_10753+25p sub_107C1+1Cp
                    ; sub_10802+10p

var_50      = byte ptr -50h

        push    ax
        push    bp
        mov bp, sp
        sub sp, 50h
        push    bx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        lea di, [bp+var_50]
        call    strcpy
        xchg    si, di
        mov ax, 50h
        mov bx, 28h
        call    userinput
        jb  short loc_106EC
        call    sub_10688
        jb  short loc_106EC
        call    strcpy
        clc

loc_106EC:              ; CODE XREF: sub_106C3+1Ej
                    ; sub_106C3+23j
        pop es
        assume es:nothing
        pop si
        pop di
        pop bx
        lahf
        add sp, 50h
        sahf
        pop bp
        pop ax
        retn
sub_106C3   endp


; =============== S U B R O U T I N E =======================================


sub_106F8   proc near       ; CODE XREF: sub_126A9:loc_126C5p
        push    cx
        push    dx
        push    di
        push    si
        push    es
        call    sub_12606
        xor ax, ax
        mov dx, 455Dh
        call    sub_104C2
        jb  short loc_10710
        mov word ptr unk_1455D, 2Ah

loc_10710:              ; CODE XREF: sub_106F8+10j
        call    sub_10573
        mov dx, 3BB1h
        mov si, 455Dh
        call    sub_106C3
        jnb short loc_10723
        mov ax, 1Bh
        jmp short loc_1074D
; ---------------------------------------------------------------------------

loc_10723:              ; CODE XREF: sub_106F8+24j
        call    sub_110A9
        cmp ax, 1Bh
        jz  short loc_1074D
        call    sub_10C3B
        call    sub_111F3
        mov si, 455Dh
        push    ds
        pop es
        assume es:seg000
        mov di, 450Ch
        call    strcpy
        mov dx, di
        call    strupr
        call    sub_1102A
        call    sub_10456
        call    sub_112C3
        call    sub_111F3

loc_1074D:              ; CODE XREF: sub_106F8+29j
                    ; sub_106F8+31j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        retn
sub_106F8   endp


; =============== S U B R O U T I N E =======================================


sub_10753   proc near       ; CODE XREF: sub_110A9+1Bp
        push    cx
        push    dx
        push    di
        push    si
        push    es
        xor ax, ax
        cmp byte ptr unk_1450C, 0
        jnz short loc_107B2

loc_10761:              ; CODE XREF: sub_10753+37j
        mov dx, 45AEh
        call    sub_104C2
        jb  short loc_1076F
        mov word ptr unk_145AE, 2Ah

loc_1076F:              ; CODE XREF: sub_10753+14j
        call    sub_10573
        mov dx, 3BCDh
        mov si, 45AEh
        call    sub_106C3
        jnb short loc_10782
        mov ax, 1Bh
        jmp short loc_107BB
; ---------------------------------------------------------------------------

loc_10782:              ; CODE XREF: sub_10753+28j
        mov dx, si
        call    askoverwrite
        cmp ax, 4Eh
        jz  short loc_10761
        cmp ax, 1Bh
        jz  short loc_107BB
        mov si, 45AEh
        push    ds
        pop es
        assume es:seg000
        mov di, 450Ch
        call    strcpy
        mov dx, di
        call    strupr
        call    sub_1102A
        mov dx, 450Ch
        call    sub_104E9
        call    sub_1047B
        call    sub_12676
        jmp short loc_107BB
; ---------------------------------------------------------------------------

loc_107B2:              ; CODE XREF: sub_10753+Cj
        mov dx, 450Ch
        call    sub_104E9
        call    sub_1047B

loc_107BB:              ; CODE XREF: sub_10753+2Dj
                    ; sub_10753+3Cj sub_10753+5Dj
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        retn
sub_10753   endp


; =============== S U B R O U T I N E =======================================


sub_107C1   proc near       ; CODE XREF: sub_11AC6+9p
        push    ax
        push    dx
        push    si
        cmp byte ptr unk_145FF, 0
        jnz short loc_107D4
        mov dx, 45FFh
        mov word ptr unk_145FF, 2Ah

loc_107D4:              ; CODE XREF: sub_107C1+8j
        call    sub_10573
        mov dx, 3BDCh
        mov si, 45FFh
        call    sub_106C3
        jb  short loc_107FE
        push    ax
        mov ax, 4300h
        mov dx, 45FFh
        int 21h     ; DOS - 2+ - GET FILE ATTRIBUTES
                    ; DS:DX -> ASCIZ file name or directory
                    ; name without trailing slash
        pop ax
        jnb short loc_107F7
        mov dx, 3CA2h
        call    sub_10DA6
        stc
        jmp short loc_107FE
; ---------------------------------------------------------------------------

loc_107F7:              ; CODE XREF: sub_107C1+2Bj
        mov dx, 45FFh
        call    sub_1205E
        clc

loc_107FE:              ; CODE XREF: sub_107C1+1Fj
                    ; sub_107C1+34j
        pop si
        pop dx
        pop ax
        retn
sub_107C1   endp


; =============== S U B R O U T I N E =======================================


sub_10802   proc near       ; CODE XREF: seg000:1B92p
        push    ax
        push    dx
        push    si
        cmp byte ptr unk_14AD0, 0
        jz  short loc_1082F

loc_1080C:              ; CODE XREF: sub_10802+1Dj
        mov dx, 3BF3h
        mov si, 45FFh
        call    sub_106C3
        jb  short loc_1082F
        mov dx, si
        call    askoverwrite
        cmp ax, 4Eh
        jz  short loc_1080C
        cmp ax, 1Bh
        jz  short loc_1082F
        mov dx, 45FFh
        call    sub_104E9
        call    sub_120C3

loc_1082F:              ; CODE XREF: sub_10802+8j
                    ; sub_10802+13j sub_10802+22j
        pop si
        pop dx
        pop ax
        retn
sub_10802   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_10834   proc near       ; CODE XREF: start+5Ap
        push    ax
        push    es
        mov ax, 2710h
        shl ax, 1
        call    sub_13793
        or  ax, ax
        jnz short loc_1084D
        push    dx
        mov dx, 3C7Dh
        call    sub_10DA6
        pop dx
        jmp loc_101AB
; ---------------------------------------------------------------------------

loc_1084D:              ; CODE XREF: sub_10834+Cj
        mov word ptr unk_146A2, es
        mov word ptr unk_146A4, ax
        pop es
        pop ax
        retn
sub_10834   endp


; =============== S U B R O U T I N E =======================================


sub_10857   proc near       ; CODE XREF: start+9Fp
        push    ax
        push    es
        mov es, word ptr unk_146A2
        mov ax, word ptr unk_146A4
        call    sub_1381B
        pop es
        pop ax
        retn
sub_10857   endp


; =============== S U B R O U T I N E =======================================


chkmem      proc near       ; CODE XREF: sub_1090F+Dp sub_11239+9p
        push    ax
        call    memleft
        cmp ax, 600h
        pop ax
        jb  short loc_10872
        clc
        retn
; ---------------------------------------------------------------------------

loc_10872:              ; CODE XREF: chkmem+8j
        push    dx
        mov dx, 3C7Dh
        call    sub_10DA6
        pop dx
        stc
        retn
chkmem      endp


; =============== S U B R O U T I N E =======================================


sub_1087C   proc near       ; CODE XREF: sub_10973+35p
                    ; sub_10BEC+1Bp
        push    ax
        push    es

loc_1087E:              ; CODE XREF: sub_1087C+14j
        mov ax, es
        or  ax, ax
        jz  short loc_10892
        mov ax, es:0
        push    ax
        mov ax, 1
        call    sub_1381B
        pop es
        jmp short loc_1087E
; ---------------------------------------------------------------------------

loc_10892:              ; CODE XREF: sub_1087C+6j
        pop es
        pop ax
        retn
sub_1087C   endp


; =============== S U B R O U T I N E =======================================


sub_10895   proc near       ; CODE XREF: sub_1047B:loc_1049Ep
                    ; sub_108DD+9p sub_108F6+9p
                    ; sub_10E9B+21p sub_112C3+9p
                    ; seg000:12E2p sub_11F4C:loc_11F88p
        push    ax
        push    bx
        push    si
        push    di
        push    ds
        push    es
        cmp ax, word_13918
        jb  short loc_108A7
        mov byte ptr es:[di], 0
        jmp short loc_108D6
; ---------------------------------------------------------------------------

loc_108A7:              ; CODE XREF: sub_10895+Aj
        push    es
        mov es, word ptr unk_146A2
        mov bx, ax
        shl bx, 1
        cmp word ptr es:[bx], 0
        jnz short loc_108BD
        xor al, al
        pop es
        cld
        stosb
        jmp short loc_108D6
; ---------------------------------------------------------------------------

loc_108BD:              ; CODE XREF: sub_10895+1Fj
        mov ds, word ptr es:[bx]
        pop es

loc_108C1:              ; CODE XREF: sub_10895+3Fj
        mov si, 2
        cld

loc_108C5:              ; CODE XREF: sub_10895+39j
        lodsb
        stosb
        or  al, al
        jz  short loc_108D6
        cmp si, 10h
        jb  short loc_108C5
        mov ds, word ptr ds:0
        jmp short loc_108C1
; ---------------------------------------------------------------------------

loc_108D6:              ; CODE XREF: sub_10895+10j
                    ; sub_10895+26j sub_10895+34j
        pop es
        pop ds
        pop di
        pop si
        pop bx
        pop ax
        retn
sub_10895   endp


; =============== S U B R O U T I N E =======================================


sub_108DD   proc near       ; CODE XREF: sub_10A1A+1Bp
                    ; sub_10A7D+7p sub_10B4A+6p
                    ; sub_10B8F+7p sub_11EEE:loc_11F1Fp
                    ; sub_11EEE:loc_11F33p
                    ; sub_11F4C:loc_11F7Cp
                    ; sub_12026:loc_12048p findtext+2Ep
                    ; replacetext+31p
        push    ax
        push    dx
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        mov di, 46A6h
        call    sub_10895
        mov dx, di
        call    strlen
        mov word ptr unk_147A6, ax
        pop es
        assume es:nothing
        pop di
        pop dx
        pop ax
        retn
sub_108DD   endp


; =============== S U B R O U T I N E =======================================


sub_108F6   proc near       ; CODE XREF: sub_10B4A+2Bp
        push    ax
        push    dx
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        mov di, 47A8h
        call    sub_10895
        mov dx, di
        call    strlen
        mov word ptr unk_148A8, ax
        pop es
        assume es:nothing
        pop di
        pop dx
        pop ax
        retn
sub_108F6   endp


; =============== S U B R O U T I N E =======================================


sub_1090F   proc near       ; CODE XREF: sub_10973+39p
                    ; sub_10A1A+32p
        push    dx
        push    bp
        push    si
        push    di
        push    es
        xor bp, bp
        cmp byte ptr es:[di], 0
        jz  short loc_10963
        call    chkmem
        jb  short loc_1096D
        mov si, di
        mov dx, es
        mov ax, 10h
        call    sub_13793
        or  ax, ax
        jnz short loc_10938

loc_1092F:              ; CODE XREF: sub_1090F+48j
        mov dx, 3C7Dh
        call    sub_10DA6
        stc
        jmp short loc_1096D
; ---------------------------------------------------------------------------

loc_10938:              ; CODE XREF: sub_1090F+1Ej
        mov bp, es

loc_1093A:              ; CODE XREF: sub_1090F+52j
        mov di, 2

loc_1093D:              ; CODE XREF: sub_1090F+3Cj
        push    ds
        mov ds, dx
        cld
        lodsb
        pop ds
        stosb
        or  al, al
        jz  short loc_10963
        cmp di, 10h
        jb  short loc_1093D
        mov di, es
        mov ax, 10h
        call    sub_13793
        or  ax, ax
        jz  short loc_1092F
        push    ds
        mov ds, di
        mov word ptr ds:0, es
        pop ds
        jmp short loc_1093A
; ---------------------------------------------------------------------------

loc_10963:              ; CODE XREF: sub_1090F+Bj
                    ; sub_1090F+37j
        mov word ptr es:0, 0
        mov ax, bp
        clc

loc_1096D:              ; CODE XREF: sub_1090F+10j
                    ; sub_1090F+27j
        pop es
        pop di
        pop si
        pop bp
        pop dx
        retn
sub_1090F   endp


; =============== S U B R O U T I N E =======================================


sub_10973   proc near       ; CODE XREF: sub_10A1A+55p
                    ; sub_10A7D+B6p sub_10B8F+44p
                    ; sub_10BDE+9p sub_112A6+Ap
        push    ax
        push    bx
        push    cx
        push    dx
        cmp byte_1391A, 0
        jnz short loc_1099C
        push    ax
        push    ds
        push    es
        pop ds
        mov dx, di
        call    strlen
        call    strip
        mov bx, ax
        call    strlen
        pop ds
        mov dx, ax
        pop ax
        cmp dx, bx
        jz  short loc_1099C
        mov cx, ax
        call    sub_11E5A

loc_1099C:              ; CODE XREF: sub_10973+9j
                    ; sub_10973+22j
        mov bx, ax
        shl bx, 1
        push    es
        mov es, word ptr unk_146A2
        mov es, word ptr es:[bx]
        call    sub_1087C
        pop es
        call    sub_1090F
        jb  short loc_109BB
        push    es
        mov es, word ptr unk_146A2
        mov es:[bx], ax
        pop es
        clc

loc_109BB:              ; CODE XREF: sub_10973+3Cj
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10973   endp


; =============== S U B R O U T I N E =======================================


sub_109C0   proc near       ; CODE XREF: sub_10A1A+11p
                    ; sub_10BDE+4p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        mov cx, word_13918
        cmp cx, 2710h
        jb  short loc_109DA
        mov dx, 3D13h
        call    sub_10DA6

loc_109D7:              ; CODE XREF: sub_109C0+1Ej
        stc
        jmp short loc_10A12
; ---------------------------------------------------------------------------

loc_109DA:              ; CODE XREF: sub_109C0+Fj
        cmp ax, word_13918
        ja  short loc_109D7
        mov es, word ptr unk_146A2
        sub cx, ax
        jcxz    short loc_109FA
        mov di, word_13918
        shl di, 1
        mov si, di
        sub si, 2
        push    ds
        push    es
        pop ds
        std
        rep movsw
        pop ds

loc_109FA:              ; CODE XREF: sub_109C0+26j
        mov di, ax
        shl di, 1
        mov word ptr es:[di], 0
        inc word_13918
        xor bx, bx
        mov cx, ax
        inc cx
        xor dx, dx
        call    sub_11D9F
        clc

loc_10A12:              ; CODE XREF: sub_109C0+18j
        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_109C0   endp


; =============== S U B R O U T I N E =======================================


sub_10A1A   proc near       ; CODE XREF: sub_117B2+Cp
                    ; sub_1205E+43p sub_120E5+42p
                    ; sub_12162+89p sub_12162+D5p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        inc ax
        mov cl, byte ptr unk_14AD1
        mov byte ptr unk_14AD1, 0
        call    sub_109C0
        jb  short loc_10A75
        mov byte ptr unk_14AD1, cl
        dec ax
        call    sub_108DD
        mov di, bx
        cmp di, word ptr unk_147A6
        jb  short loc_10A44
        mov di, word ptr unk_147A6

loc_10A44:              ; CODE XREF: sub_10A1A+24j
        add di, 46A6h
        mov cx, ax
        push    ds
        pop es
        assume es:seg000
        call    sub_1090F
        jb  short loc_10A75
        mov es, word ptr unk_146A2
        assume es:nothing
        mov si, cx
        inc si
        shl si, 1
        mov es:[si], ax
        mov ax, cx
        mov cx, ax
        inc cx
        xor dx, dx
        call    sub_11D9F
        push    ds
        pop es
        assume es:seg000
        mov byte ptr [di], 0
        mov di, 46A6h
        call    sub_10973
        jb  short loc_10A75
        clc

loc_10A75:              ; CODE XREF: sub_10A1A+14j
                    ; sub_10A1A+35j sub_10A1A+58j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10A1A   endp


; =============== S U B R O U T I N E =======================================


sub_10A7D   proc near       ; CODE XREF: sub_10B4A+37p
                    ; sub_11239+48p sub_11FF0:loc_12019p
                    ; sub_1205E+35p sub_120E5:loc_12119p
                    ; sub_12162+4Fp sub_12162:loc_121DFp
                    ; sub_12162:loc_12226p sub_12162+D8p
                    ; replacetext+103p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        call    sub_108DD
        cmp bx, word ptr unk_147A6
        jbe short loc_10AAE
        push    ax
        push    di
        push    es
        mov cx, bx
        sub cx, word ptr unk_147A6
        push    ds
        pop es
        assume es:seg000
        mov di, 46A6h
        add di, word ptr unk_147A6
        add word ptr unk_147A6, cx
        mov al, 20h
        cld
        rep stosb
        xor al, al
        stosb
        pop es
        assume es:nothing
        pop di
        pop ax

loc_10AAE:              ; CODE XREF: sub_10A7D+Ej
        push    ax
        push    ds
        push    es
        pop ds
        mov dx, di
        call    strlen
        mov cx, ax
        pop ds
        pop ax
        mov dx, cx
        add dx, word ptr unk_147A6
        cmp dx, 0FFh
        jbe short loc_10ADD
        mov dx, 3CF8h
        call    sub_10DA6
        mov dx, bx
        add dx, cx
        cmp dx, 0FFh
        jbe short loc_10ADD
        sub dx, 0FFh
        sub cx, dx

loc_10ADD:              ; CODE XREF: sub_10A7D+48j
                    ; sub_10A7D+58j
        push    cx
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        mov si, word ptr unk_147A6
        mov di, si
        add di, cx
        mov cx, word ptr unk_147A6
        sub cx, bx
        inc cx
        cmp di, 0FFh
        jbe short loc_10B03
        mov dx, di
        sub dx, 0FFh
        sub si, dx
        sub di, dx
        sub cx, dx

loc_10B03:              ; CODE XREF: sub_10A7D+78j
        add si, 46A6h
        add di, 46A6h
        std
        rep movsb
        mov byte ptr unk_147A5, 0
        pop es
        assume es:nothing
        pop di
        pop cx
        push    cx
        push    di
        push    si
        push    ds
        mov si, es
        push    ds
        pop es
        assume es:seg000
        mov ds, si
        mov si, di
        mov di, 46A6h
        add di, bx
        cld
        rep movsb
        pop ds
        pop si
        pop di
        pop cx
        push    ds
        pop es
        mov di, 46A6h
        call    sub_10973
        jb  short loc_10B42
        mov dx, cx
        add dx, bx
        mov cx, ax
        call    sub_11D9F
        clc

loc_10B42:              ; CODE XREF: sub_10A7D+B9j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10A7D   endp


; =============== S U B R O U T I N E =======================================


sub_10B4A   proc near       ; CODE XREF: sub_116CC+1Fp
                    ; sub_11F94+54p sub_12162+9Ep
                    ; sub_12162+B5p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        call    sub_108DD
        cmp bx, word ptr unk_147A6
        jnb short loc_10B5D
        mov bx, word ptr unk_147A6

loc_10B5D:              ; CODE XREF: sub_10B4A+Dj
        push    ax
        push    bx
        mov cx, ax
        mov dx, bx
        inc ax
        xor bx, bx
        call    sub_11E5A
        pop bx
        pop ax
        mov cl, byte ptr unk_14AD1
        mov byte ptr unk_14AD1, 0
        inc ax
        call    sub_108F6
        call    sub_10BEC
        dec ax
        push    ds
        pop es
        assume es:seg000
        mov di, 47A8h
        call    sub_10A7D
        mov byte ptr unk_14AD1, cl
        pop es
        assume es:nothing
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10B4A   endp


; =============== S U B R O U T I N E =======================================


sub_10B8F   proc near       ; CODE XREF: sub_116CC+30p
                    ; sub_1178E+17p sub_11F94+26p
                    ; sub_11F94+37p sub_11F94+50p
                    ; sub_12026+2Cp sub_12162+45p
                    ; sub_12162+69p sub_12162+B1p
                    ; replacetext:loc_124FFp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        call    sub_108DD
        cmp bx, word ptr unk_147A6
        jnb short loc_10BD6
        mov dx, bx
        add dx, cx
        cmp dx, word ptr unk_147A6
        jbe short loc_10BAF
        sub dx, word ptr unk_147A6
        sub cx, dx

loc_10BAF:              ; CODE XREF: sub_10B8F+18j
        push    bx
        push    cx
        mov dx, bx
        add bx, cx
        mov cx, ax
        call    sub_11E5A
        pop cx
        pop bx
        push    ds
        pop es
        assume es:seg000
        mov di, 46A6h
        add di, bx
        mov si, cx
        mov cx, word ptr unk_147A6
        sub cx, bx
        add si, di
        cld
        rep movsb
        mov di, 46A6h
        call    sub_10973

loc_10BD6:              ; CODE XREF: sub_10B8F+Ej
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10B8F   endp


; =============== S U B R O U T I N E =======================================


sub_10BDE   proc near       ; CODE XREF: sub_103E9+41p
                    ; sub_103E9+50p
        push    ax
        mov ax, word_13918
        call    sub_109C0
        jb  short loc_10BEA
        call    sub_10973

loc_10BEA:              ; CODE XREF: sub_10BDE+7j
        pop ax
        retn
sub_10BDE   endp


; =============== S U B R O U T I N E =======================================


sub_10BEC   proc near       ; CODE XREF: sub_10B4A+2Ep
                    ; seg000:1776p sub_11F94+45p
                    ; sub_12162+CDp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        mov cx, word_13918
        cmp ax, cx
        jnb short loc_10C33
        mov bx, ax
        shl bx, 1
        mov es, word ptr unk_146A2
        push    es
        mov es, word ptr es:[bx]
        call    sub_1087C
        pop es
        mov word ptr es:[bx], 0
        sub cx, ax
        dec cx
        jcxz    short loc_10C2F
        mov di, ax
        shl di, 1
        mov si, di
        add si, 2
        push    ds
        push    es
        pop ds
        cld
        rep movsw
        pop ds
        mov cx, ax
        inc ax
        xor bx, bx
        xor dx, dx
        call    sub_11E5A

loc_10C2F:              ; CODE XREF: sub_10BEC+27j
        dec word_13918

loc_10C33:              ; CODE XREF: sub_10BEC+Dj
        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10BEC   endp


; =============== S U B R O U T I N E =======================================


sub_10C3B   proc near       ; CODE XREF: sub_106F8+33p
                    ; sub_126A9+38p
        push    ax
        push    bx
        push    cx
        push    es
        mov cx, word_13918
        jcxz    short loc_10C6F
        xor bx, bx

loc_10C47:              ; CODE XREF: sub_10C3B:loc_10C64j
        mov es, word ptr unk_146A2
        mov es, word ptr es:[bx]
        inc bx
        inc bx

loc_10C50:              ; CODE XREF: sub_10C3B+27j
        mov ax, es
        or  ax, ax
        jz  short loc_10C64
        mov ax, es:0
        push    ax
        mov ax, 1
        call    sub_1381B
        pop es
        jmp short loc_10C50
; ---------------------------------------------------------------------------

loc_10C64:              ; CODE XREF: sub_10C3B+19j
        loop    loc_10C47
        mov word_13918, 0
        call    sub_111DC

loc_10C6F:              ; CODE XREF: sub_10C3B+8j
        pop es
        pop cx
        pop bx
        pop ax
        retn
sub_10C3B   endp


; =============== S U B R O U T I N E =======================================


sub_10C74   proc near       ; CODE XREF: start:loc_10151p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        mov ah, 0Fh
        int 10h     ; - VIDEO - GET CURRENT VIDEO MODE
                    ; Return: AH = number of columns on screen
                    ; AL = current video mode
                    ; BH = current active display page
        cmp al, 3
        jbe short loc_10C94
        cmp al, 7
        jz  short loc_10C94
        mov dx, 3C42h

loc_10C8A:              ; CODE XREF: sub_10C74+2Bj
        mov ah, 9
        int 21h     ; DOS - PRINT STRING
                    ; DS:DX -> string terminated by "$"
        add sp, 2
        jmp loc_101AB
; ---------------------------------------------------------------------------

loc_10C94:              ; CODE XREF: sub_10C74+Dj
                    ; sub_10C74+11j
        call    screencols
        cmp ax, 50h
        jnb short loc_10CA1
        mov dx, 3C5Fh
        jmp short loc_10C8A
; ---------------------------------------------------------------------------

loc_10CA1:              ; CODE XREF: sub_10C74+26j
        mov ah, 0Fh
        int 10h     ; - VIDEO - GET CURRENT VIDEO MODE
                    ; Return: AH = number of columns on screen
                    ; AL = current video mode
                    ; BH = current active display page
        or  al, al
        jz  short loc_10CB1
        cmp al, 2
        jz  short loc_10CB1
        cmp al, 7
        jnz short loc_10CBF

loc_10CB1:              ; CODE XREF: sub_10C74+33j
                    ; sub_10C74+37j
        push    ds
        pop es
        assume es:seg000
        mov di, 392Ah
        mov si, 3939h
        mov cx, 0Ah
        cld
        rep movsb

loc_10CBF:              ; CODE XREF: sub_10C74+3Bj
        call    sub_10D4C
        jnb short loc_10CCD
        mov dx, 3C7Dh
        call    sub_10DA6
        jmp loc_101AB
; ---------------------------------------------------------------------------

loc_10CCD:              ; CODE XREF: sub_10C74+4Ej
        mov al, vx2
        sub al, vx1
        xor ah, ah
        inc ax
        mov word ptr cpl, ax
        mov al, vy2
        sub al, vy1
        dec al
        xor ah, ah
        mov word ptr unk_148AC, ax
        mov ax, 100h
        call    sub_13793
        or  ax, ax
        jnz short loc_10CFB
        mov dx, 3C7Dh
        call    sub_10DA6
        jmp loc_101AB
; ---------------------------------------------------------------------------

loc_10CFB:              ; CODE XREF: sub_10C74+7Cj
        mov word ptr unk_148AE, es
        mov word ptr unk_148B0, ax
        mov ax, 351Bh
        int 21h     ; DOS - 2+ - GET INTERRUPT VECTOR
                    ; AL = interrupt number
                    ; Return: ES:BX = value of interrupt vector
        mov word ptr unk_148B2, bx
        mov word ptr unk_148B4, es
        push    ds
        push    cs
        pop ds
        mov dx, 0D4Bh
        mov ax, 251Bh
        int 21h     ; DOS - SET INTERRUPT VECTOR
                    ; AL = interrupt number
                    ; DS:DX = new vector to be used for specified interrupt
        mov ax, 2523h
        int 21h     ; DOS - SET INTERRUPT VECTOR
                    ; AL = interrupt number
                    ; DS:DX = new vector to be used for specified interrupt
        pop ds
        pop es
        assume es:nothing
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10C74   endp


; =============== S U B R O U T I N E =======================================


sub_10D28   proc near       ; CODE XREF: start+A8p
        push    ax
        push    dx
        push    es
        mov es, word ptr unk_148AE
        mov ax, word ptr unk_148B0
        call    sub_1381B
        call    closewindow
        push    ds
        mov ax, 251Bh
        mov dx, word ptr unk_148B2
        mov ds, word ptr unk_148B4
        int 21h     ; DOS - SET INTERRUPT VECTOR
                    ; AL = interrupt number
                    ; DS:DX = new vector to be used for specified interrupt
        pop ds
        pop es
        pop dx
        pop ax
        retn
sub_10D28   endp

; ---------------------------------------------------------------------------
        db 0CFh

; =============== S U B R O U T I N E =======================================


sub_10D4C   proc near       ; CODE XREF: sub_10C74:loc_10CBFp
                    ; userscr:loc_11B38p
        push    ax
        push    bx
        push    cx
        push    dx
        call    screenrows
        mov dh, al
        dec dh
        call    screencols
        mov dl, al
        dec dl
        xor ax, ax
        xor bl, bl
        mov cl, sattr
        call    openwindow
        or  ax, ax
        jz  short loc_10D70
        stc
        jmp short loc_10DA1
; ---------------------------------------------------------------------------

loc_10D70:              ; CODE XREF: sub_10D4C+1Fj
        mov al, byte_1392C
        call    textattr
        mov dx, offset aLin0Col0 ; "    Lin 0     Col 0"
        call    outtext
        call    clreol
        call    screenrows
        mov ah, al
        dec ah
        xor al, al
        call    gotoxy
        mov dx, offset aShhEdV2_4F1Hel ; " SHH ED v2.4 º   F1-help    F2-save  F3-l"...
        call    outtext
        call    clreol
        mov al, sattr
        call    textattr
        mov ax, 100h
        call    gotoxy
        clc

loc_10DA1:              ; CODE XREF: sub_10D4C+22j
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10D4C   endp


; =============== S U B R O U T I N E =======================================


sub_10DA6   proc near       ; CODE XREF: sub_101BA+12p
                    ; sub_1023A+1Cp sub_1026A+4Fp
                    ; sub_102CD+10p sub_102EA+19p
                    ; sub_10319+25p sub_103B9+13p
                    ; sub_103E9+22p sub_10688+10p
                    ; sub_107C1+30p sub_10834+12p
                    ; chkmem+10p sub_1090F+23p
                    ; sub_109C0+14p sub_10A7D+4Dp
                    ; sub_10C74+53p sub_10C74+81p
                    ; sub_12279+42p
        push    ax
        push    bx
        push    cx
        push    dx
        cmp byte_13956, 0
        jz  short loc_10DB9
        mov dx, 3D4Fh
        mov byte_13956, 0

loc_10DB9:              ; CODE XREF: sub_10DA6+9j
        push    dx
        call    strlen
        mov dx, 0B12h
        add dl, al
        mov ax, 903h
        mov bl, 1
        mov cl, byte_1392E
        mov ch, byte_1392F
        call    openwindow
        mov dx, 3BA9h
        xor al, al
        call    sub_13526
        mov al, 20h
        call    outchar
        pop dx
        call    outtext
        mov al, 2Eh
        call    outchar
        mov al, 20h
        call    outchar
        call    outchar
        mov dx, 3AF4h
        call    outtext

loc_10DF6:              ; CODE XREF: sub_10DA6+56j
        call    getkey
        cmp ax, 1Bh
        jnz short loc_10DF6
        call    closewindow
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10DA6   endp


; =============== S U B R O U T I N E =======================================


message     proc near       ; CODE XREF: sub_10214+6p sub_102EA+7p
                    ; askoverwrite+10p sub_110A9+Dp
        push    ax
        push    bx
        push    cx
        push    dx
        push    dx
        call    strlen
        mov dx, 806h
        add dl, al
        mov ax, 603h
        mov bl, 1
        mov cl, byte_13932
        mov ch, byte_13933
        call    openwindow
        mov al, 20h
        call    outchar
        pop dx
        call    outtext
        pop dx
        pop cx
        pop bx
        pop ax
        retn
message     endp


; =============== S U B R O U T I N E =======================================


beep        proc near       ; CODE XREF: sub_11239+1Bp
                    ; sub_11914+Cp sub_1192B+Cp
                    ; seg000:1948p gotoline+29p
                    ; sub_120E5+Dp sub_12162+Dp
        push    ax
        push    bx
        mov ax, 0E07h
        int 10h     ; - VIDEO - WRITE CHARACTER AND ADVANCE CURSOR (TTY WRITE)
                    ; AL = character, BH = display page (alpha modes)
                    ; BL = foreground color (graphics modes)
        pop bx
        pop ax
        retn
beep        endp


; =============== S U B R O U T I N E =======================================


showline    proc near       ; CODE XREF: sub_10E9B+2Dp
                    ; sub_1120F+18p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        push    bp
        mov cx, bx
        mov bx, di
        mov si, ax
        jcxz    short loc_10E53
        cld
        xor al, al
        repne scasb
        jnz short loc_10E53
        dec di

loc_10E53:              ; CODE XREF: showline+Ej showline+15j
        mov ax, si
        mov si, di
        mov bp, es
        add al, vy1
        mov ah, al
        xor al, al
        call    addr_of_pos
        mov cx, word ptr cpl
        cld

loc_10E69:              ; CODE XREF: showline+4Fj
        mov ah, sattr
        push    ax
        push    dx
        mov ax, dx
        mov dx, si
        sub dx, bx
        call    sub_11D51
        pop dx
        pop ax
        jnb short loc_10E80
        mov ah, byte_1392B

loc_10E80:              ; CODE XREF: showline+3Fj
        push    ds
        mov ds, bp
        lodsb
        pop ds
        or  al, al
        jz  short loc_10E8C
        stosw
        loop    loc_10E69

loc_10E8C:              ; CODE XREF: showline+4Cj
        jcxz    short loc_10E92
        mov al, 20h
        rep stosw

loc_10E92:              ; CODE XREF: showline:loc_10E8Cj
        pop bp
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
showline    endp


; =============== S U B R O U T I N E =======================================


sub_10E9B   proc near       ; CODE XREF: sub_111F3p sub_112F2+84p
                    ; sub_11409+Dp sub_11409+2Ap
                    ; sub_11409+39p sub_11409+56p
                    ; sub_11464+13p sub_1147B:loc_1149Bp
                    ; seg000:162Ap seg000:1666p
                    ; sub_1166E+2Bp sub_116A2+21p
                    ; sub_116CC+25p seg000:loc_11783p
                    ; sub_117B2+12p sub_119AF+1Bp
                    ; sub_119CF+1Bp sub_11A1B+5p
                    ; sub_11A45+12p sub_11AC6+11p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        mov es, word ptr unk_148AE
        mov dx, 1
        mov cx, word ptr unk_148AC
        mov ax, word ptr unk_14AC1
        mov bx, word ptr unk_14AC3
        xor di, di

loc_10EB6:              ; CODE XREF: sub_10E9B+33j
        cmp ax, word_13918
        jnb short loc_10EC1
        call    sub_10895
        jmp short loc_10EC7
; ---------------------------------------------------------------------------

loc_10EC1:              ; CODE XREF: sub_10E9B+1Fj
        xor di, di
        mov byte ptr es:[di], 0

loc_10EC7:              ; CODE XREF: sub_10E9B+24j
        xchg    ax, dx
        call    showline
        xchg    ax, dx
        inc dx
        inc ax
        loop    loc_10EB6
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_10E9B   endp


; =============== S U B R O U T I N E =======================================


sub_10ED8   proc near       ; CODE XREF: sub_10EF4+28p
                    ; sub_10F21+28p sub_10F4E+24p
                    ; sub_10F78+24p sub_10FA2+24p
                    ; sub_10FCC+21p sub_11008+1Dp
                    ; sub_1102A+4Ep sub_111F3+3p
                    ; sub_112F2:loc_11304p replacetext+74p
        push    ax
        push    bx
        mov ax, word ptr curlin
        sub ax, word ptr unk_14AC1
        inc al
        mov bl, al
        mov ax, word ptr unk_14AC7
        sub ax, word ptr unk_14AC3
        mov ah, bl
        call    gotoxy
        pop bx
        pop ax
        retn
sub_10ED8   endp


; =============== S U B R O U T I N E =======================================


sub_10EF4   proc near       ; CODE XREF: sub_111F3+6p
                    ; sub_112F2+7Ep sub_11464+Ap
                    ; sub_115CE:loc_115DDp
                    ; sub_115E5:loc_115F6p
                    ; seg000:loc_11627p seg000:loc_11663p
                    ; sub_1166E:loc_11696p
                    ; sub_116A2:loc_116C0p seg000:18CCp
                    ; seg000:18E9p seg000:190Fp
        push    ax
        mov al, byte_1392C
        call    textattr
        mov ax, 8
        call    gotoxy
        mov ax, word ptr curlin
        inc ax
        call    outword

loc_10F08:              ; CODE XREF: sub_10EF4+20j
        cmp curx, 0Dh
        jnb short loc_10F16
        mov al, 20h
        call    outchar
        jmp short loc_10F08
; ---------------------------------------------------------------------------

loc_10F16:              ; CODE XREF: sub_10EF4+19j
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop ax
        retn
sub_10EF4   endp


; =============== S U B R O U T I N E =======================================


sub_10F21   proc near       ; CODE XREF: sub_111F3+9p
                    ; sub_11239+5Fp sub_112F2+81p
                    ; sub_11464+Dp seg000:1575p
                    ; seg000:15A0p sub_115A5:loc_115B4p
                    ; sub_115B9:loc_115C9p seg000:1719p
                    ; sub_117CA+7Cp sub_118A5+9p
                    ; sub_118B3+Ap
        push    ax
        mov al, byte_1392C
        call    textattr
        mov ax, 12h
        call    gotoxy
        mov ax, word ptr unk_14AC7
        inc ax
        call    outword

loc_10F35:              ; CODE XREF: sub_10F21+20j
        cmp curx, 15h
        jnb short loc_10F43
        mov al, 20h
        call    outchar
        jmp short loc_10F35
; ---------------------------------------------------------------------------

loc_10F43:              ; CODE XREF: sub_10F21+19j
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop ax
        retn
sub_10F21   endp


; =============== S U B R O U T I N E =======================================


sub_10F4E   proc near       ; CODE XREF: sub_111F3+Cp seg000:18A1p
        push    ax
        push    dx
        mov al, byte_1392C
        call    textattr
        mov ax, 16h
        call    gotoxy
        mov dx, 3AFEh
        cmp byte_13934, 0
        jnz short loc_10F69
        mov dx, 3B06h

loc_10F69:              ; CODE XREF: sub_10F4E+16j
        call    outtext
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop dx
        pop ax
        retn
sub_10F4E   endp


; =============== S U B R O U T I N E =======================================


sub_10F78   proc near       ; CODE XREF: sub_111F3+Fp seg000:1C1Ap
        push    ax
        push    dx
        mov al, byte_1392C
        call    textattr
        mov ax, 1Eh
        call    gotoxy
        mov dx, 3B0Eh
        cmp byte_13935, 0
        jnz short loc_10F93
        mov dx, 3B16h

loc_10F93:              ; CODE XREF: sub_10F78+16j
        call    outtext
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop dx
        pop ax
        retn
sub_10F78   endp


; =============== S U B R O U T I N E =======================================


sub_10FA2   proc near       ; CODE XREF: sub_111F3+12p
                    ; seg000:1C28p
        push    ax
        push    dx
        mov al, byte_1392C
        call    textattr
        mov ax, 26h
        call    gotoxy
        mov dx, 3B1Eh
        cmp byte_13936, 0
        jnz short loc_10FBD
        mov dx, 3B26h

loc_10FBD:              ; CODE XREF: sub_10FA2+16j
        call    outtext
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop dx
        pop ax
        retn
sub_10FA2   endp


; =============== S U B R O U T I N E =======================================


sub_10FCC   proc near       ; CODE XREF: sub_103E9+5Ep
                    ; sub_1047B+3Cp sub_110A9+23p
                    ; sub_111F3+15p sub_11230+5p
        push    ax
        mov al, byte_1392C
        call    textattr
        mov ax, 3Fh
        call    gotoxy
        mov al, 2Ah
        cmp byte ptr unk_14AC9, 0
        jnz short loc_10FE4
        mov al, 20h

loc_10FE4:              ; CODE XREF: sub_10FCC+14j
        call    outchar
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop ax
        retn
sub_10FCC   endp


; =============== S U B R O U T I N E =======================================


sub_10FF2   proc near       ; CODE XREF: sub_11524p
        push    ax
        mov al, byte_1392C
        call    textattr
        xor ax, ax
        call    gotoxy
        mov al, 5Eh
        call    outchar
        pop ax
        call    outchar
        retn
sub_10FF2   endp


; =============== S U B R O U T I N E =======================================


sub_11008   proc near       ; CODE XREF: seg000:loc_11965p
                    ; seg000:loc_11BB2p seg000:loc_11C06p
                    ; seg000:loc_11C2Dp
        push    ax
        mov al, byte_1392C
        call    textattr
        xor ax, ax
        call    gotoxy
        mov al, 20h
        call    outchar
        call    outchar
        call    outchar
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop ax
        retn
sub_11008   endp


; =============== S U B R O U T I N E =======================================


sub_1102A   proc near       ; CODE XREF: sub_103E9+2Ap
                    ; sub_1047B+11p sub_106F8+49p
                    ; sub_10753+4Ep sub_111F3+18p
                    ; sub_126A9+48p
        push    ax
        push    cx
        push    dx
        push    di
        push    si
        mov al, byte_1392C
        call    textattr
        mov ax, 41h
        call    gotoxy
        mov dx, 450Ch
        mov si, dx
        mov di, dx
        call    strlen
        mov cx, ax
        jcxz    short loc_1106F
        add si, cx
        inc cx
        cmp byte ptr [di+1], 3Ah
        jnz short loc_1105C
        mov al, [di]
        call    outchar
        mov al, 3Ah
        call    outchar

loc_1105C:              ; CODE XREF: sub_1102A+26j
                    ; sub_1102A+3Dj
        cmp byte ptr [si], 5Ch
        jz  short loc_11069
        cmp byte ptr [si], 3Ah
        jz  short loc_11069
        dec si
        loop    loc_1105C

loc_11069:              ; CODE XREF: sub_1102A+35j
                    ; sub_1102A+3Aj
        mov dx, si
        inc dx
        call    outtext

loc_1106F:              ; CODE XREF: sub_1102A+1Dj
        call    clreol
        mov al, sattr
        call    textattr
        call    sub_10ED8
        pop si
        pop di
        pop dx
        pop cx
        pop ax
        retn
sub_1102A   endp

; ---------------------------------------------------------------------------
        push    ax
        push    bx
        push    cx
        push    dx
        mov ax, 51Ah
        mov dx, 1135h
        mov bl, 2
        mov cl, byte_13930
        mov ch, byte_13931
        call    openwindow
        mov dx, 3A2Eh
        call    outtext
        call    getkey
        call    closewindow
        pop dx
        pop cx
        pop bx
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_110A9   proc near       ; CODE XREF: sub_106F8:loc_10723p
                    ; sub_111D3p sub_126A9:loc_126D9p
        push    dx
        xor ax, ax
        cmp byte ptr unk_14AC9, 0
        jz  short loc_110CF
        mov dx, 3B5Ch
        call    message
        call    CHOICE
        cmp ax, 59h
        jnz short loc_110C9
        call    closewindow
        call    sub_10753
        jmp short loc_110CF
; ---------------------------------------------------------------------------

loc_110C9:              ; CODE XREF: sub_110A9+16j
        call    closewindow
        call    sub_10FCC

loc_110CF:              ; CODE XREF: sub_110A9+8j
                    ; sub_110A9+1Ej
        pop dx
        retn
sub_110A9   endp

; ---------------------------------------------------------------------------
        push    ax
        push    bx
        push    cx
        push    dx
        mov byte_13943, 0
        mov ax, 310h
        mov dx, 153Fh
        mov bl, 1
        mov cl, byte_13930
        mov ch, byte_13931
        call    openwindow

loc_110ED:              ; CODE XREF: seg000:loc_1115Bj
        call    sub_12E2C
        call    drawborder
        mov dx, 3D6Fh
        xor al, al
        call    sub_13526
        mov bl, byte_13943
        xor bh, bh
        or  bl, bl
        jnz short loc_1110A
        mov dx, 3B3Dh
        jmp short loc_11117
; ---------------------------------------------------------------------------

loc_1110A:              ; CODE XREF: seg000:1103j
        cmp bl, 6
        jnz short loc_11114
        mov dx, 3B2Eh
        jmp short loc_11117
; ---------------------------------------------------------------------------

loc_11114:              ; CODE XREF: seg000:110Dj
        mov dx, 3B33h

loc_11117:              ; CODE XREF: seg000:1108j seg000:1112j
        mov al, 5
        call    sub_13526
        shl bx, 1
        mov dx, [bx+3944h]
        call    outtext

loc_11125:              ; CODE XREF: seg000:114Ej
        call    getkey
        cmp ax, 1Bh
        jz  short loc_1115D
        cmp ax, 0FFD3h
        jnz short loc_11139
        mov byte_148B6, 1
        jmp short loc_1115D
; ---------------------------------------------------------------------------

loc_11139:              ; CODE XREF: seg000:1130j
        cmp ax, 0FFB7h
        jnz short loc_1114B
        cmp byte_13943, 0
        jz  short loc_1115B
        dec byte_13943
        jmp short loc_1115B
; ---------------------------------------------------------------------------

loc_1114B:              ; CODE XREF: seg000:113Cj
        cmp ax, 0FFAFh
        jnz short loc_11125
        cmp byte_13943, 6
        jz  short loc_1115B
        inc byte_13943

loc_1115B:              ; CODE XREF: seg000:1143j seg000:1149j
                    ; seg000:1155j
        jmp short loc_110ED
; ---------------------------------------------------------------------------

loc_1115D:              ; CODE XREF: seg000:112Bj seg000:1137j
        call    closewindow
        pop dx
        pop cx
        pop bx
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


userinput   proc near       ; CODE XREF: sub_106C3+1Bp
                    ; gotoline+13p sub_12279+11p
                    ; sub_122C9+26p sub_123A5+28p
                    ; sub_123A5+44p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ax
        push    bx
        push    dx
        mov ax, 303h
        mov dx, 506h
        add dl, bl
        mov bl, 1
        mov cl, byte_13932
        mov ch, byte_13933
        call    openwindow
        pop dx
        pop bx
        xor al, al
        call    sub_13526
        mov ax, 1
        call    gotoxy
        pop ax
        mov di, 3952h
        mov cl, byte_1392D
        mov ch, byte_13932
        cmp byte ptr [si], 0
        jnz short loc_111A4
        mov cl, ch

loc_111A4:              ; CODE XREF: userinput+3Bj
        call    lineinput
        call    closewindow
        cmp ax, 0FFD3h
        jnz short loc_111B7
        mov byte_148B6, 1
        stc
        jmp short loc_111C0
; ---------------------------------------------------------------------------

loc_111B7:              ; CODE XREF: userinput+48j
        cmp ax, 1Bh
        jnz short loc_111BF
        stc
        jmp short loc_111C0
; ---------------------------------------------------------------------------

loc_111BF:              ; CODE XREF: userinput+55j
        clc

loc_111C0:              ; CODE XREF: userinput+50j
                    ; userinput+58j
        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
userinput   endp


; =============== S U B R O U T I N E =======================================


sub_111C8   proc near       ; CODE XREF: start+5Dp
        mov byte_148B6, 0
        call    sub_111DC
        retn
sub_111C8   endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_2. PRESS KEYPAD CTRL-"+" TO EXPAND]
; ---------------------------------------------------------------------------
        retn

; =============== S U B R O U T I N E =======================================


sub_111D3   proc near       ; CODE XREF: sub_112F2:loc_113DBp
        call    sub_110A9
        mov byte_148B6, 0
        retn
sub_111D3   endp


; =============== S U B R O U T I N E =======================================


sub_111DC   proc near       ; CODE XREF: sub_10C3B+31p
                    ; sub_111C8+5p
        push    ax
        xor ax, ax
        mov word ptr unk_14AC1, ax
        mov word ptr unk_14AC3, ax
        mov word ptr curlin, ax
        mov word ptr unk_14AC7, ax
        mov byte ptr unk_14AC9, al
        call    sub_11D26
        pop ax
        retn
sub_111DC   endp


; =============== S U B R O U T I N E =======================================


sub_111F3   proc near       ; CODE XREF: sub_106F8+36p
                    ; sub_106F8+52p sub_112F2+5p
                    ; userscr+14p sub_126A9+3Bp
                    ; sub_126A9+EFp
        call    sub_10E9B
        call    sub_10ED8
        call    sub_10EF4
        call    sub_10F21
        call    sub_10F4E
        call    sub_10F78
        call    sub_10FA2
        call    sub_10FCC
        call    sub_1102A
        retn
sub_111F3   endp


; =============== S U B R O U T I N E =======================================


sub_1120F   proc near       ; CODE XREF: sub_11239:loc_1129Bp
                    ; sub_116CC+36p sub_1178E+1Dp
        push    ax
        push    bx
        push    dx
        push    di
        push    es
        mov bx, word ptr unk_14AC3
        mov ax, word ptr curlin
        mov dx, ax
        sub ax, word ptr unk_14AC1
        inc ax
        push    ds
        pop es
        assume es:seg000
        mov di, 48BDh
        call    showline
        pop es
        assume es:nothing
        pop di
        pop dx
        pop bx
        pop ax
        retn
sub_1120F   endp


; =============== S U B R O U T I N E =======================================


sub_11230   proc near       ; CODE XREF: sub_11239+Ep sub_112A6+Dp
                    ; sub_116CC+7p seg000:1770p
                    ; sub_1178E+3p sub_117B2+2p
                    ; sub_11A24+2p sub_11A45+2p
                    ; sub_11A5D+2p sub_11A80+2p
                    ; sub_11AA3+2p sub_11AC6+14p
                    ; replacetext+11Dp
        mov byte ptr unk_14AC9, 1
        call    sub_10FCC
        retn
sub_11230   endp


; =============== S U B R O U T I N E =======================================


sub_11239   proc near       ; CODE XREF: sub_112F2+98p
                    ; sub_112F2+BFp sub_117CA+6Dp
                    ; seg000:1962p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        call    chkmem
        jb  short loc_1129E
        call    sub_11230
        mov cx, word ptr unk_14AC7
        cmp cx, 0FFh
        jb  short loc_11259
        call    beep
        jmp short loc_1129E
; ---------------------------------------------------------------------------

loc_11259:              ; CODE XREF: sub_11239+19j
        cmp byte_13934, 0
        jnz short loc_11274
        cmp cx, word ptr unk_149BD
        jnb short loc_11274
        mov di, 48BDh
        add di, word ptr unk_14AC7
        mov [di], al
        call    sub_112A6
        jmp short loc_11289
; ---------------------------------------------------------------------------

loc_11274:              ; CODE XREF: sub_11239+25j
                    ; sub_11239+2Bj
        mov byte_13958, al
        mov ax, word ptr curlin
        mov bx, word ptr unk_14AC7
        mov di, 3958h
        call    sub_10A7D
        jb  short loc_1129E
        call    sub_112C3

loc_11289:              ; CODE XREF: sub_11239+39j
        cmp word ptr unk_14AC7, 0FFh
        ja  short loc_1129B
        inc word ptr unk_14AC7
        call    sub_11409
        call    sub_10F21

loc_1129B:              ; CODE XREF: sub_11239+56j
        call    sub_1120F

loc_1129E:              ; CODE XREF: sub_11239+Cj
                    ; sub_11239+1Ej sub_11239+4Bj
        pop es
        assume es:nothing
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_11239   endp


; =============== S U B R O U T I N E =======================================


sub_112A6   proc near       ; CODE XREF: sub_11239+36p
        push    ax
        push    dx
        push    di
        push    es
        mov ax, word ptr curlin
        mov di, 48BDh
        call    sub_10973
        call    sub_11230
        mov dx, di
        call    strlen
        mov word ptr unk_149BD, ax
        pop es
        pop di
        pop dx
        pop ax
        retn
sub_112A6   endp


; =============== S U B R O U T I N E =======================================


sub_112C3   proc near       ; CODE XREF: sub_106F8+4Fp
                    ; sub_11239+4Dp sub_112F2+2p
                    ; sub_112F2+87p sub_11464+7p
                    ; sub_115CE+12p sub_115E5+14p
                    ; seg000:162Dp seg000:1669p
                    ; sub_1166E+2Ep sub_116A2+24p
                    ; sub_116CC+22p sub_116CC+33p
                    ; seg000:1786p sub_1178E+1Ap
                    ; sub_117B2+Fp sub_117CA+1Ap
                    ; sub_117CA+5Bp seg000:18C9p
                    ; seg000:18E6p seg000:1909p
                    ; sub_11A45+Fp sub_11AC6+Ep
                    ; sub_126A9+ECp
        push    ax
        push    dx
        push    di
        mov ax, word ptr curlin
        mov di, 48BDh
        call    sub_10895
        mov dx, 48BDh
        call    strlen
        mov word ptr unk_149BD, ax
        pop di
        pop dx
        pop ax
        retn
sub_112C3   endp

; ---------------------------------------------------------------------------
        push    ax
        push    dx
        push    di
        mov di, 49BFh
        call    sub_10895
        mov dx, 49BFh
        call    strlen
        mov word ptr unk_14ABF, ax
        pop di
        pop dx
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_112F2   proc near       ; CODE XREF: start:loc_1018Ap
        push    ds
        pop es
        assume es:seg000
        call    sub_112C3
        call    sub_111F3

loc_112FA:              ; CODE XREF: sub_112F2+44j
                    ; sub_112F2+4Bj sub_112F2+50j
                    ; sub_112F2+57j sub_112F2+8Aj
                    ; sub_112F2:loc_113B7j sub_112F2+E0j
                    ; sub_112F2:loc_113E3j sub_112F2+113j
        cmp byte_148B6, 0
        jz  short loc_11304
        jmp loc_113DB
; ---------------------------------------------------------------------------

loc_11304:              ; CODE XREF: sub_112F2+Dj
        call    sub_10ED8
        call    sub_11CFF

loc_1130A:              ; CODE XREF: sub_112F2+24j
        mov ah, 1
        int 16h     ; KEYBOARD - CHECK BUFFER, DO NOT CLEAR
                    ; Return: ZF clear if character in buffer
                    ; AH = scan code, AL = character
                    ; ZF set if no character in buffer
        jnz short loc_1137F
        int 28h     ; DOS 2+ internal - KEYBOARD BUSY LOOP
        stc
        call    sub_11CC6
        jb  short loc_1130A
        call    sub_11D0E
        cmp word ptr unk_14ACC, 0
        jz  short loc_1132C
        call    screenrows
        dec ax
        cmp word ptr unk_14ACC, ax
        jb  short loc_11344

loc_1132C:              ; CODE XREF: sub_112F2+2Ej
        test    byte ptr unk_14ACE, 1
        jz  short loc_11338
        call    sub_116A2
        jmp short loc_112FA
; ---------------------------------------------------------------------------

loc_11338:              ; CODE XREF: sub_112F2+3Fj
        test    byte ptr unk_14ACE, 2
        jz  short loc_112FA
        call    sub_1166E
        jmp short loc_112FA
; ---------------------------------------------------------------------------

loc_11344:              ; CODE XREF: sub_112F2+38j
        test    byte ptr unk_14ACE, 1
        jz  short loc_112FA
        mov ax, word ptr unk_14ACC
        dec ax
        add ax, word ptr unk_14AC1
        mov word ptr curlin, ax
        cmp ax, word_13918
        jbe short loc_11363
        mov ax, word_13918
        dec ax
        mov word ptr curlin, ax

loc_11363:              ; CODE XREF: sub_112F2+68j
        mov ax, word ptr unk_14ACA
        add ax, word ptr unk_14AC3
        mov word ptr unk_14AC7, ax
        call    sub_11409
        call    sub_10EF4
        call    sub_10F21
        call    sub_10E9B
        call    sub_112C3
        jmp loc_112FA
; ---------------------------------------------------------------------------

loc_1137F:              ; CODE XREF: sub_112F2+1Cj
        call    sub_11D0E
        call    getkey
        cmp ax, 20h
        jl  short loc_113BA
        call    sub_11239
        cmp byte_13936, 0
        jz  short loc_113B7
        cmp byte_13934, 0
        jz  short loc_113B7
        mov di, 395Ah
        mov cx, 4
        cld
        repne scasb
        jnz short loc_113B7
        dec di
        sub di, 395Ah
        add di, 395Eh
        mov al, [di]
        call    sub_11239
        call    sub_115A5

loc_113B7:              ; CODE XREF: sub_112F2+A0j
                    ; sub_112F2+A7j sub_112F2+B2j
        jmp loc_112FA
; ---------------------------------------------------------------------------

loc_113BA:              ; CODE XREF: sub_112F2+96j
        cmp ax, 1Ah
        jg  short loc_113E3
        or  ax, ax
        jz  short loc_113E3
        js  short loc_113D5
        xor ah, ah
        mov bx, 3962h
        dec al
        shl ax, 1
        add bx, ax
        call    word ptr [bx]
        jmp loc_112FA
; ---------------------------------------------------------------------------

loc_113D5:              ; CODE XREF: sub_112F2+D1j
        neg ax
        cmp al, 2Dh
        jnz short loc_113E6

loc_113DB:              ; CODE XREF: sub_112F2+Fj
        call    sub_111D3
        cmp ax, 1Bh
        jnz short locret_11408

loc_113E3:              ; CODE XREF: sub_112F2+CBj
                    ; sub_112F2+CFj sub_112F2+F6j
                    ; sub_112F2+FAj sub_112F2+102j
        jmp loc_112FA
; ---------------------------------------------------------------------------

loc_113E6:              ; CODE XREF: sub_112F2+E7j
        cmp al, 3Bh
        jb  short loc_113E3
        cmp al, 84h
        ja  short loc_113E3
        cmp al, 77h
        jbe short loc_113F8
        cmp al, 84h
        jnz short loc_113E3
        sub al, 0Ch

loc_113F8:              ; CODE XREF: sub_112F2+FEj
        sub al, 3Bh
        xor ah, ah
        mov bx, 3996h
        shl ax, 1
        add bx, ax
        call    word ptr [bx]
        jmp loc_112FA
; ---------------------------------------------------------------------------

locret_11408:               ; CODE XREF: sub_112F2+EFj
        retn
sub_112F2   endp


; =============== S U B R O U T I N E =======================================


sub_11409   proc near       ; CODE XREF: sub_11239+5Cp
                    ; sub_112F2+7Bp sub_11464+10p
                    ; seg000:loc_11572p seg000:loc_1159Dp
                    ; sub_115A5+Cp sub_115B9+Dp
                    ; sub_115CE+Cp sub_115E5+Ep
                    ; seg000:1716p sub_117CA:loc_11843p
                    ; sub_118A5+6p sub_118B3+7p
                    ; seg000:1906p sub_126A9+E9p
        push    ax
        mov ax, word ptr unk_14AC7
        cmp ax, word ptr unk_14AC3
        jnb short loc_1141B
        mov word ptr unk_14AC3, ax
        call    sub_10E9B
        jmp short loc_11436
; ---------------------------------------------------------------------------

loc_1141B:              ; CODE XREF: sub_11409+8j
        mov ax, word ptr unk_14AC3
        add ax, word ptr cpl
        cmp ax, word ptr unk_14AC7
        ja  short loc_11436
        mov ax, word ptr unk_14AC7
        sub ax, word ptr cpl
        inc ax
        mov word ptr unk_14AC3, ax
        call    sub_10E9B

loc_11436:              ; CODE XREF: sub_11409+10j
                    ; sub_11409+1Dj
        mov ax, word ptr curlin
        cmp ax, word ptr unk_14AC1
        jnb short loc_11447
        mov word ptr unk_14AC1, ax
        call    sub_10E9B
        jmp short loc_11462
; ---------------------------------------------------------------------------

loc_11447:              ; CODE XREF: sub_11409+34j
        mov ax, word ptr unk_14AC1
        add ax, word ptr unk_148AC
        cmp ax, word ptr curlin
        ja  short loc_11462
        mov ax, word ptr curlin
        sub ax, word ptr unk_148AC
        inc ax
        mov word ptr unk_14AC1, ax
        call    sub_10E9B

loc_11462:              ; CODE XREF: sub_11409+3Cj
                    ; sub_11409+49j
        pop ax
        retn
sub_11409   endp


; =============== S U B R O U T I N E =======================================


sub_11464   proc near       ; CODE XREF: sub_1147B+2p seg000:18F4p
                    ; sub_11A24+1Bp sub_11A5D+1Dp
                    ; sub_11A80+1Dp sub_11AA3+1Dp
        mov word ptr curlin, ax
        mov word ptr unk_14AC7, bx
        call    sub_112C3
        call    sub_10EF4
        call    sub_10F21
        call    sub_11409
        call    sub_10E9B
        retn
sub_11464   endp


; =============== S U B R O U T I N E =======================================


sub_1147B   proc near       ; CODE XREF: sub_11914:loc_11925p
                    ; sub_1192B:loc_1193Cp
                    ; seg000:loc_1194Dp sub_1198E+19p
                    ; sub_119EF+10p sub_11A05+10p
                    ; gotoline+32p replacetext+71p
        push    ax
        push    bx
        call    sub_11464
        mov ax, word ptr curlin
        sub ax, word ptr unk_14AC1
        mov bx, word ptr unk_148AC
        shr bx, 1
        sub ax, bx
        add word ptr unk_14AC1, ax
        jns short loc_1149B
        mov word ptr unk_14AC1, 0

loc_1149B:              ; CODE XREF: sub_1147B+18j
        call    sub_10E9B
        pop bx
        pop ax
        retn
sub_1147B   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_114A2   proc near       ; CODE XREF: seg000:loc_11555p
                    ; seg000:loc_11562p seg000:1711p
        push    ax
        mov ax, word ptr unk_14AC7
        or  ax, ax
        jz  short loc_114B1
        dec ax
        mov word ptr unk_14AC7, ax
        stc
        jmp short loc_114C2
; ---------------------------------------------------------------------------

loc_114B1:              ; CODE XREF: sub_114A2+6j
        cmp word ptr curlin, 0
        jz  short loc_114C1
        call    sub_115CE
        call    sub_118B3
        stc
        jmp short loc_114C2
; ---------------------------------------------------------------------------

loc_114C1:              ; CODE XREF: sub_114A2+14j
        clc

loc_114C2:              ; CODE XREF: sub_114A2+Dj
                    ; sub_114A2+1Dj
        pop ax
        retn
sub_114A2   endp


; =============== S U B R O U T I N E =======================================


sub_114C4   proc near       ; CODE XREF: seg000:156Fp
                    ; seg000:loc_11583p seg000:loc_11590p
                    ; sub_117CA:loc_11800p sub_117CA+48p
        push    ax
        mov ax, word ptr unk_14AC7
        inc ax
        cmp ax, word ptr unk_149BD
        ja  short loc_114D5
        mov word ptr unk_14AC7, ax
        stc
        jmp short loc_114EB
; ---------------------------------------------------------------------------

loc_114D5:              ; CODE XREF: sub_114C4+9j
        push    ax
        mov ax, word ptr curlin
        inc ax
        cmp ax, word_13918
        pop ax
        jnb short loc_114EA
        call    sub_115E5
        call    sub_118A5
        stc
        jmp short loc_114EB
; ---------------------------------------------------------------------------

loc_114EA:              ; CODE XREF: sub_114C4+1Bj
        clc

loc_114EB:              ; CODE XREF: sub_114C4+Fj
                    ; sub_114C4+24j
        pop ax
        retn
sub_114C4   endp


; =============== S U B R O U T I N E =======================================


sub_114ED   proc near       ; CODE XREF: seg000:155Dp seg000:156Ap
                    ; seg000:157Ep seg000:158Bp
                    ; seg000:1598p seg000:1740p
                    ; seg000:1752p
        push    cx
        push    di
        push    es
        push    ds
        pop es
        mov di, 3A12h
        mov cx, 19h
        cld
        repne scasb
        pop es
        assume es:nothing
        pop di
        pop cx
        retn
sub_114ED   endp


; =============== S U B R O U T I N E =======================================


sub_114FF   proc near       ; CODE XREF: seg000:1745p seg000:1763p
                    ; sub_117CA+26p sub_117CA+3Fp
                    ; sub_117CA+51p
        push    cx
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        mov di, 3A2Bh
        mov cx, 3
        cld
        repne scasb
        pop es
        assume es:nothing
        pop di
        pop cx
        retn
sub_114FF   endp


; =============== S U B R O U T I N E =======================================


sub_11511   proc near       ; CODE XREF: seg000:155Ap seg000:1567p
                    ; seg000:157Bp seg000:1588p
                    ; seg000:1595p seg000:1731p
                    ; seg000:loc_1173Dp seg000:loc_1174Fp
                    ; seg000:loc_1175Cp sub_117CA+23p
                    ; sub_117CA+3Cp sub_117CA+4Ep
        push    si
        xor al, al
        mov si, word ptr unk_14AC7
        cmp si, word ptr unk_149BD
        jnb short loc_11522
        mov al, [si+48BDh]

loc_11522:              ; CODE XREF: sub_11511+Bj
        pop si
        retn
sub_11511   endp


; =============== S U B R O U T I N E =======================================


sub_11524   proc near       ; CODE XREF: seg000:1955p seg000:1B43p
                    ; seg000:1BBBp seg000:1C0Ep
        call    sub_10FF2
        call    getkey
        cmp al, 1
        jl  short locret_11553
        cmp al, 20h
        jg  short loc_11539
        add al, 40h
        call    outchar
        jmp short locret_11553
; ---------------------------------------------------------------------------

loc_11539:              ; CODE XREF: sub_11524+Cj
        cmp al, 61h
        jl  short loc_11548
        cmp al, 7Ah
        jg  short locret_11553
        sub al, 20h
        call    outchar
        jmp short locret_11553
; ---------------------------------------------------------------------------

loc_11548:              ; CODE XREF: sub_11524+17j
        cmp al, 41h
        jl  short locret_11553
        cmp al, 5Ah
        jg  short locret_11553
        call    outchar

locret_11553:               ; CODE XREF: sub_11524+8j
                    ; sub_11524+13j sub_11524+1Bj
                    ; sub_11524+22j sub_11524+26j
                    ; sub_11524+2Aj
        retn
sub_11524   endp

; ---------------------------------------------------------------------------
        push    ax

loc_11555:              ; CODE XREF: seg000:1560j
        call    sub_114A2
        jnb short loc_11572
        call    sub_11511
        call    sub_114ED
        jz  short loc_11555

loc_11562:              ; CODE XREF: seg000:156Dj
        call    sub_114A2
        jnb short loc_11572
        call    sub_11511
        call    sub_114ED
        jnz short loc_11562
        call    sub_114C4

loc_11572:              ; CODE XREF: seg000:1558j seg000:1565j
        call    sub_11409
        call    sub_10F21
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        call    sub_11511
        call    sub_114ED
        jz  short loc_11590

loc_11583:              ; CODE XREF: seg000:158Ej
        call    sub_114C4
        jnb short loc_1159D
        call    sub_11511
        call    sub_114ED
        jnz short loc_11583

loc_11590:              ; CODE XREF: seg000:1581j seg000:159Bj
        call    sub_114C4
        jnb short loc_1159D
        call    sub_11511
        call    sub_114ED
        jz  short loc_11590

loc_1159D:              ; CODE XREF: seg000:1586j seg000:1593j
        call    sub_11409
        call    sub_10F21
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_115A5   proc near       ; CODE XREF: sub_112F2+C2p
        push    ax
        mov ax, word ptr unk_14AC7
        or  ax, ax
        jz  short loc_115B4
        dec ax
        mov word ptr unk_14AC7, ax
        call    sub_11409

loc_115B4:              ; CODE XREF: sub_115A5+6j
        call    sub_10F21
        pop ax
        retn
sub_115A5   endp


; =============== S U B R O U T I N E =======================================


sub_115B9   proc near       ; CODE XREF: sub_117CA:loc_1183Ep
        push    ax
        mov ax, word ptr unk_14AC7
        inc ax
        cmp ax, 0FFh
        ja  short loc_115C9
        mov word ptr unk_14AC7, ax
        call    sub_11409

loc_115C9:              ; CODE XREF: sub_115B9+8j
        call    sub_10F21
        pop ax
        retn
sub_115B9   endp


; =============== S U B R O U T I N E =======================================


sub_115CE   proc near       ; CODE XREF: sub_114A2+16p
        push    ax
        mov ax, word ptr curlin
        or  ax, ax
        jz  short loc_115DD
        dec ax
        mov word ptr curlin, ax
        call    sub_11409

loc_115DD:              ; CODE XREF: sub_115CE+6j
        call    sub_10EF4
        call    sub_112C3
        pop ax
        retn
sub_115CE   endp


; =============== S U B R O U T I N E =======================================


sub_115E5   proc near       ; CODE XREF: sub_114C4+1Dp
                    ; seg000:loc_11870p
        push    ax
        mov ax, word ptr curlin
        inc ax
        cmp ax, word_13918
        jz  short loc_115F6
        mov word ptr curlin, ax
        call    sub_11409

loc_115F6:              ; CODE XREF: sub_115E5+9j
        call    sub_10EF4
        call    sub_112C3
        pop ax
        retn
sub_115E5   endp

; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr unk_148AC
        dec ax
        cmp word ptr unk_14AC1, ax
        jnb short loc_11611
        mov word ptr unk_14AC1, 0
        jmp short loc_11615
; ---------------------------------------------------------------------------

loc_11611:              ; CODE XREF: seg000:1607j
        sub word ptr unk_14AC1, ax

loc_11615:              ; CODE XREF: seg000:160Fj
        cmp word ptr curlin, ax
        jnb short loc_11623
        mov word ptr curlin, 0
        jmp short loc_11627
; ---------------------------------------------------------------------------

loc_11623:              ; CODE XREF: seg000:1619j
        sub word ptr curlin, ax

loc_11627:              ; CODE XREF: seg000:1621j
        call    sub_10EF4
        call    sub_10E9B
        call    sub_112C3
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr unk_148AC
        dec ax
        add ax, word ptr unk_14AC1
        mov word ptr unk_14AC1, ax
        cmp ax, word_13918
        jbe short loc_1164B
        mov ax, word_13918
        dec ax
        mov word ptr unk_14AC1, ax

loc_1164B:              ; CODE XREF: seg000:1642j
        mov ax, word ptr unk_148AC
        dec ax
        add ax, word ptr curlin
        mov word ptr curlin, ax
        cmp ax, word_13918
        jbe short loc_11663
        mov ax, word_13918
        dec ax
        mov word ptr curlin, ax

loc_11663:              ; CODE XREF: seg000:165Aj
        call    sub_10EF4
        call    sub_10E9B
        call    sub_112C3
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_1166E   proc near       ; CODE XREF: sub_112F2+4Dp
        push    ax
        push    bx
        mov bx, word_13918
        cmp bx, word ptr unk_148AC
        jbe short loc_11696
        sub bx, word ptr unk_148AC
        mov ax, word ptr unk_14AC1
        cmp ax, bx
        jnb short loc_11696
        inc ax
        mov word ptr unk_14AC1, ax
        mov ax, word ptr curlin
        cmp ax, word ptr unk_14AC1
        jnb short loc_11696
        inc ax
        mov word ptr curlin, ax

loc_11696:              ; CODE XREF: sub_1166E+Aj
                    ; sub_1166E+15j sub_1166E+22j
        call    sub_10EF4
        call    sub_10E9B
        call    sub_112C3
        pop bx
        pop ax
        retn
sub_1166E   endp


; =============== S U B R O U T I N E =======================================


sub_116A2   proc near       ; CODE XREF: sub_112F2+41p
        push    ax
        push    bx
        mov ax, word ptr unk_14AC1
        or  ax, ax
        jz  short loc_116C0
        dec ax
        mov word ptr unk_14AC1, ax
        mov bx, ax
        add bx, word ptr unk_148AC
        mov ax, word ptr curlin
        cmp ax, bx
        jb  short loc_116C0
        dec ax
        mov word ptr curlin, ax

loc_116C0:              ; CODE XREF: sub_116A2+7j
                    ; sub_116A2+18j
        call    sub_10EF4
        call    sub_10E9B
        call    sub_112C3
        pop bx
        pop ax
        retn
sub_116A2   endp


; =============== S U B R O U T I N E =======================================


sub_116CC   proc near       ; CODE XREF: seg000:loc_1172Bp
                    ; seg000:1738p seg000:174Ap
                    ; seg000:1757p seg000:1768p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        call    sub_11230
        mov bx, word ptr unk_14AC7
        cmp bx, word ptr unk_149BD
        jb  short loc_116F6
        mov ax, word ptr curlin
        inc ax
        cmp ax, word_13918
        jnb short loc_11705
        dec ax
        call    sub_10B4A
        call    sub_112C3
        call    sub_10E9B
        jmp short loc_11705
; ---------------------------------------------------------------------------

loc_116F6:              ; CODE XREF: sub_116CC+12j
        mov ax, word ptr curlin
        mov cx, 1
        call    sub_10B8F
        call    sub_112C3
        call    sub_1120F

loc_11705:              ; CODE XREF: sub_116CC+1Cj
                    ; sub_116CC+28j
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_116CC   endp

; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr curlin
        call    sub_114A2
        jnb short loc_1172E
        call    sub_11409
        call    sub_10F21
        cmp ax, word ptr curlin
        jnz short loc_1172B
        mov ax, word ptr unk_14AC7
        cmp ax, word ptr unk_149BD
        jnb short loc_1172E

loc_1172B:              ; CODE XREF: seg000:1720j
        call    sub_116CC

loc_1172E:              ; CODE XREF: seg000:1714j seg000:1729j
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        call    sub_11511
        or  al, al
        jnz short loc_1173D
        call    sub_116CC
        jmp short loc_1176D
; ---------------------------------------------------------------------------

loc_1173D:              ; CODE XREF: seg000:1736j
        call    sub_11511
        call    sub_114ED
        jnz short loc_1174F
        call    sub_114FF
        jz  short loc_1174F
        call    sub_116CC
        jmp short loc_1176D
; ---------------------------------------------------------------------------

loc_1174F:              ; CODE XREF: seg000:1743j seg000:1748j
                    ; seg000:175Aj
        call    sub_11511
        call    sub_114ED
        jz  short loc_1175C
        call    sub_116CC
        jmp short loc_1174F
; ---------------------------------------------------------------------------

loc_1175C:              ; CODE XREF: seg000:1755j seg000:176Bj
        call    sub_11511
        or  al, al
        jz  short loc_1176D
        call    sub_114FF
        jnz short loc_1176D
        call    sub_116CC
        jmp short loc_1175C
; ---------------------------------------------------------------------------

loc_1176D:              ; CODE XREF: seg000:173Bj seg000:174Dj
                    ; seg000:1761j seg000:1766j
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        call    sub_11230
        mov ax, word ptr curlin
        call    sub_10BEC
        cmp ax, word_13918
        jb  short loc_11783
        inc word_13918

loc_11783:              ; CODE XREF: seg000:177Dj
        call    sub_10E9B
        call    sub_112C3
        call    sub_118A5
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_1178E   proc near       ; CODE XREF: seg000:1BC2p
        push    ax
        push    bx
        push    cx
        call    sub_11230
        mov ax, word ptr curlin
        mov bx, word ptr unk_14AC7
        mov cx, word ptr unk_149BD
        cmp bx, cx
        jnb short loc_117AE
        sub cx, bx
        call    sub_10B8F
        call    sub_112C3
        call    sub_1120F

loc_117AE:              ; CODE XREF: sub_1178E+13j
        pop cx
        pop bx
        pop ax
        retn
sub_1178E   endp


; =============== S U B R O U T I N E =======================================


sub_117B2   proc near       ; CODE XREF: seg000:loc_1186Dp
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov bx, word ptr unk_14AC7
        call    sub_10A1A
        call    sub_112C3
        call    sub_10E9B
        pop bx
        pop ax
        retn
sub_117B2   endp


; =============== S U B R O U T I N E =======================================


sub_117CA   proc near       ; CODE XREF: seg000:1883p seg000:1897p
        push    ax
        push    bx
        push    cx
        push    dx
        push    bp
        mov dl, al
        xor cx, cx
        mov ax, word ptr curlin
        mov bp, ax
        mov bx, word ptr unk_14AC7

loc_117DC:              ; CODE XREF: sub_117CA+21j
        sub ax, 1
        jb  short loc_11820
        mov word ptr curlin, ax
        call    sub_112C3
        cmp word ptr unk_149BD, bx
        jbe short loc_117DC
        call    sub_11511
        call    sub_114FF
        jz  short loc_1180E
        or  dl, dl
        jz  short loc_11800
        cmp word ptr unk_14AC7, 0
        jz  short loc_11820

loc_11800:              ; CODE XREF: sub_117CA+2Dj
                    ; sub_117CA+42j
        call    sub_114C4
        jnb short loc_11820
        inc cx
        call    sub_11511
        call    sub_114FF
        jnz short loc_11800

loc_1180E:              ; CODE XREF: sub_117CA+29j
                    ; sub_117CA+54j
        or  al, al
        jz  short loc_11820
        call    sub_114C4
        jnb short loc_11820
        inc cx
        call    sub_11511
        call    sub_114FF
        jz  short loc_1180E

loc_11820:              ; CODE XREF: sub_117CA+15j
                    ; sub_117CA+34j sub_117CA+39j
                    ; sub_117CA+46j sub_117CA+4Bj
        mov ax, bp
        mov word ptr curlin, ax
        call    sub_112C3
        mov word ptr unk_14AC7, bx
        jcxz    short loc_11843
        cmp byte_13934, 0
        jz  short loc_1183E

loc_11835:              ; CODE XREF: sub_117CA+70j
        mov al, 20h
        call    sub_11239
        loop    loc_11835
        jmp short loc_11843
; ---------------------------------------------------------------------------

loc_1183E:              ; CODE XREF: sub_117CA+69j
                    ; sub_117CA+77j
        call    sub_115B9
        loop    loc_1183E

loc_11843:              ; CODE XREF: sub_117CA+62j
                    ; sub_117CA+72j
        call    sub_11409
        call    sub_10F21
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_117CA   endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_7. PRESS KEYPAD CTRL-"+" TO EXPAND]
; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr curlin
        inc ax
        cmp ax, word_13918
        jz  short loc_11862
        cmp byte_13934, 0
        jz  short loc_11870

loc_11862:              ; CODE XREF: seg000:1859j
        mov al, 1
        cmp word ptr unk_14AC7, 0
        jnz short loc_1186D
        xor al, al

loc_1186D:              ; CODE XREF: seg000:1869j
        call    sub_117B2

loc_11870:              ; CODE XREF: seg000:1860j
        call    sub_115E5
        call    sub_118A5
        or  al, al
        jz  short loc_11886
        cmp byte_13935, 0
        jz  short loc_11886
        mov al, 1
        call    sub_117CA

loc_11886:              ; CODE XREF: seg000:1878j seg000:187Fj
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        cmp byte_13937, 0
        jz  short loc_11895
        call    nullsub_7
        jmp short loc_1189A
; ---------------------------------------------------------------------------

loc_11895:              ; CODE XREF: seg000:188Ej
        xor al, al
        call    sub_117CA

loc_1189A:              ; CODE XREF: seg000:1893j
        pop ax
        retn
; ---------------------------------------------------------------------------
        xor byte_13934, 1
        call    sub_10F4E
        retn

; =============== S U B R O U T I N E =======================================


sub_118A5   proc near       ; CODE XREF: sub_114C4+20p
                    ; seg000:1789p seg000:1873p
        push    ax
        xor ax, ax
        mov word ptr unk_14AC7, ax
        call    sub_11409
        call    sub_10F21
        pop ax
        retn
sub_118A5   endp


; =============== S U B R O U T I N E =======================================


sub_118B3   proc near       ; CODE XREF: sub_114A2+19p
                    ; seg000:190Cp
        push    ax
        mov ax, word ptr unk_149BD
        mov word ptr unk_14AC7, ax
        call    sub_11409
        call    sub_10F21
        pop ax
        retn
sub_118B3   endp

; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr unk_14AC1
        mov word ptr curlin, ax
        call    sub_112C3
        call    sub_10EF4
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov ax, word ptr unk_14AC1
        add ax, word ptr unk_148AC
        cmp ax, word_13918
        jbe short loc_118E2
        mov ax, word_13918

loc_118E2:              ; CODE XREF: seg000:18DDj
        dec ax
        mov word ptr curlin, ax
        call    sub_112C3
        call    sub_10EF4
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        push    bx
        xor ax, ax
        xor bx, bx
        call    sub_11464
        pop bx
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov ax, word_13918
        or  ax, ax
        jz  short loc_11903
        dec ax

loc_11903:              ; CODE XREF: seg000:1900j
        mov word ptr curlin, ax
        call    sub_11409
        call    sub_112C3
        call    sub_118B3
        call    sub_10EF4
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_11914   proc near       ; CODE XREF: seg000:1BEFp
        push    ax
        push    bx
        call    sub_122C9
        jb  short loc_11928
        call    findtext
        jnb short loc_11925
        call    beep
        jmp short loc_11928
; ---------------------------------------------------------------------------

loc_11925:              ; CODE XREF: sub_11914+Aj
        call    sub_1147B

loc_11928:              ; CODE XREF: sub_11914+5j sub_11914+Fj
        pop bx
        pop ax
        retn
sub_11914   endp


; =============== S U B R O U T I N E =======================================


sub_1192B   proc near       ; CODE XREF: seg000:1BF8p
        push    ax
        push    bx
        call    sub_123A5
        jb  short loc_1193F
        call    replacetext
        jnb short loc_1193C
        call    beep
        jmp short loc_1193F
; ---------------------------------------------------------------------------

loc_1193C:              ; CODE XREF: sub_1192B+Aj
        call    sub_1147B

loc_1193F:              ; CODE XREF: sub_1192B+5j sub_1192B+Fj
        pop bx
        pop ax
        retn
sub_1192B   endp

; ---------------------------------------------------------------------------
        push    ax
        call    sub_12553
        jnb short loc_1194D
        call    beep
        jmp short loc_11950
; ---------------------------------------------------------------------------

loc_1194D:              ; CODE XREF: seg000:1946j
        call    sub_1147B

loc_11950:              ; CODE XREF: seg000:194Bj
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov al, 50h
        call    sub_11524
        cmp al, 41h
        jb  short loc_11965
        cmp al, 5Fh
        ja  short loc_11965
        sub al, 40h
        call    sub_11239

loc_11965:              ; CODE XREF: seg000:195Aj seg000:195Ej
        call    sub_11008
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_1196A   proc near       ; CODE XREF: seg000:1B65p seg000:1B6Ep
        push    bx
        push    cx
        mov bx, word ptr curlin
        mov cx, word ptr unk_14AC7
        cmp al, 31h
        jnz short loc_11982
        mov word ptr unk_14AE4, bx
        mov word ptr unk_14AE6, cx
        jmp short loc_1198A
; ---------------------------------------------------------------------------

loc_11982:              ; CODE XREF: sub_1196A+Cj
        mov word ptr unk_14AE8, bx
        mov word ptr unk_14AEA, cx

loc_1198A:              ; CODE XREF: sub_1196A+16j
        pop cx
        pop bx
        retn
sub_1196A   endp

; ---------------------------------------------------------------------------
        retn

; =============== S U B R O U T I N E =======================================


sub_1198E   proc near       ; CODE XREF: seg000:1BDDp seg000:1BE6p
        push    ax
        push    bx
        push    cx
        mov cx, word ptr unk_14AE4
        mov bx, word ptr unk_14AE6
        cmp al, 31h
        jz  short loc_119A5
        mov cx, word ptr unk_14AE8
        mov bx, word ptr unk_14AEA

loc_119A5:              ; CODE XREF: sub_1198E+Dj
        mov ax, cx
        call    sub_1147B
        pop cx
        pop bx
        pop ax
        retn
sub_1198E   endp

; ---------------------------------------------------------------------------
        retn

; =============== S U B R O U T I N E =======================================


sub_119AF   proc near       ; CODE XREF: seg000:1B4Ap
        push    ax
        mov ax, word ptr unk_14AC7
        cmp ax, word ptr unk_149BD
        jb  short loc_119BC
        mov ax, word ptr unk_149BD

loc_119BC:              ; CODE XREF: sub_119AF+8j
        mov word ptr unk_14AD6, ax
        mov ax, word ptr curlin
        mov word ptr unk_14AD4, ax
        mov byte ptr unk_14AD0, 1
        call    sub_10E9B
        pop ax
        retn
sub_119AF   endp


; =============== S U B R O U T I N E =======================================


sub_119CF   proc near       ; CODE XREF: seg000:1B53p
        push    ax
        mov ax, word ptr unk_14AC7
        cmp ax, word ptr unk_149BD
        jb  short loc_119DC
        mov ax, word ptr unk_149BD

loc_119DC:              ; CODE XREF: sub_119CF+8j
        mov word ptr unk_14ADA, ax
        mov ax, word ptr curlin
        mov word ptr unk_14AD8, ax
        mov byte ptr unk_14AD0, 1
        call    sub_10E9B
        pop ax
        retn
sub_119CF   endp


; =============== S U B R O U T I N E =======================================


sub_119EF   proc near       ; CODE XREF: seg000:1BCBp
        push    ax
        push    bx
        cmp byte ptr unk_14AD0, 0
        jz  short loc_11A02
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6
        call    sub_1147B

loc_11A02:              ; CODE XREF: sub_119EF+7j
        pop bx
        pop ax
        retn
sub_119EF   endp


; =============== S U B R O U T I N E =======================================


sub_11A05   proc near       ; CODE XREF: seg000:1BD4p
        push    ax
        push    bx
        cmp byte ptr unk_14AD0, 0
        jz  short loc_11A18
        mov ax, word ptr unk_14AD8
        mov bx, word ptr unk_14ADA
        call    sub_1147B

loc_11A18:              ; CODE XREF: sub_11A05+7j
        pop bx
        pop ax
        retn
sub_11A05   endp


; =============== S U B R O U T I N E =======================================


sub_11A1B   proc near       ; CODE XREF: seg000:1B5Cp
        xor byte ptr unk_14AD0, 1
        call    sub_10E9B
        retn
sub_11A1B   endp


; =============== S U B R O U T I N E =======================================


sub_11A24   proc near       ; CODE XREF: seg000:1B77p
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov word ptr unk_14AEC, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AEE, ax
        call    sub_11F94
        mov ax, word ptr unk_14AEC
        mov bx, word ptr unk_14AEE
        call    sub_11464
        pop bx
        pop ax
        retn
sub_11A24   endp


; =============== S U B R O U T I N E =======================================


sub_11A45   proc near       ; CODE XREF: seg000:1B80p
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov bx, word ptr unk_14AC7
        call    sub_120E5
        call    sub_112C3
        call    sub_10E9B
        pop bx
        pop ax
        retn
sub_11A45   endp


; =============== S U B R O U T I N E =======================================


sub_11A5D   proc near       ; CODE XREF: seg000:1B89p
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov word ptr unk_14AEC, ax
        mov bx, word ptr unk_14AC7
        mov word ptr unk_14AEE, bx
        call    sub_12162
        mov ax, word ptr unk_14AEC
        mov bx, word ptr unk_14AEE
        call    sub_11464
        pop bx
        pop ax
        retn
sub_11A5D   endp


; =============== S U B R O U T I N E =======================================


sub_11A80   proc near       ; CODE XREF: seg000:1BA4p
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov word ptr unk_14AEC, ax
        mov bx, word ptr unk_14AC7
        mov word ptr unk_14AEE, bx
        call    sub_11FF0
        mov ax, word ptr unk_14AEC
        mov bx, word ptr unk_14AEE
        call    sub_11464
        pop bx
        pop ax
        retn
sub_11A80   endp


; =============== S U B R O U T I N E =======================================


sub_11AA3   proc near       ; CODE XREF: seg000:1BADp
        push    ax
        push    bx
        call    sub_11230
        mov ax, word ptr curlin
        mov word ptr unk_14AEC, ax
        mov bx, word ptr unk_14AC7
        mov word ptr unk_14AEE, bx
        call    sub_12026
        mov ax, word ptr unk_14AEC
        mov bx, word ptr unk_14AEE
        call    sub_11464
        pop bx
        pop ax
        retn
sub_11AA3   endp


; =============== S U B R O U T I N E =======================================


sub_11AC6   proc near       ; CODE XREF: seg000:1B9Bp
        push    ax
        push    bx
        mov ax, word ptr curlin
        mov bx, word ptr unk_14AC7
        call    sub_107C1
        jb  short loc_11ADD
        call    sub_112C3
        call    sub_10E9B
        call    sub_11230

loc_11ADD:              ; CODE XREF: sub_11AC6+Cj
        pop bx
        pop ax
        retn
sub_11AC6   endp


; =============== S U B R O U T I N E =======================================


gotoline    proc near       ; CODE XREF: seg000:1C01p
        push    ax
        push    bx
        push    dx
        push    si
        mov ax, 5
        mov bx, 5
        mov dx, offset aLine ; " Line "
        mov si, offset unk_148B7
        mov byte ptr [si], 0
        call    userinput
        jb  short loc_11B15
        mov dx, offset unk_148B7
        call    atoui
        or  ax, ax
        jz  short loc_11B15
        dec ax
        cmp ax, word_13918
        jb  short loc_11B0E
        call    beep
        jmp short loc_11B15
; ---------------------------------------------------------------------------

loc_11B0E:              ; CODE XREF: gotoline+27j
        mov bx, word ptr unk_14AC7
        call    sub_1147B

loc_11B15:              ; CODE XREF: gotoline+16j gotoline+20j
                    ; gotoline+2Cj
        pop si
        pop dx
        pop bx
        pop ax
        retn
gotoline    endp


; =============== S U B R O U T I N E =======================================


pick        proc near
        call    sub_127F4
        retn
pick        endp


; =============== S U B R O U T I N E =======================================


mkpick      proc near
        mov byte_15148, 1
        call    sub_125D6
        retn
mkpick      endp


; =============== S U B R O U T I N E =======================================


userscr     proc near
        push    ax
        call    closewindow
        call    getkey
        cmp ax, 0FFD3h
        jnz short loc_11B38
        mov byte_148B6, 1

loc_11B38:              ; CODE XREF: userscr+Aj
        call    sub_10D4C
        call    sub_111F3
        pop ax
        retn
userscr     endp

; ---------------------------------------------------------------------------
        push    ax
        mov al, 4Bh
        call    sub_11524
        cmp al, 42h
        jnz short loc_11B4F
        call    sub_119AF
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B4F:              ; CODE XREF: seg000:1B48j
        cmp al, 4Bh
        jnz short loc_11B58
        call    sub_119CF
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B58:              ; CODE XREF: seg000:1B51j
        cmp al, 48h
        jnz short loc_11B61
        call    sub_11A1B
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B61:              ; CODE XREF: seg000:1B5Aj
        cmp al, 31h
        jnz short loc_11B6A
        call    sub_1196A
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B6A:              ; CODE XREF: seg000:1B63j
        cmp al, 32h
        jnz short loc_11B73
        call    sub_1196A
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B73:              ; CODE XREF: seg000:1B6Cj
        cmp al, 59h
        jnz short loc_11B7C
        call    sub_11A24
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B7C:              ; CODE XREF: seg000:1B75j
        cmp al, 43h
        jnz short loc_11B85
        call    sub_11A45
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B85:              ; CODE XREF: seg000:1B7Ej
        cmp al, 56h
        jnz short loc_11B8E
        call    sub_11A5D
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B8E:              ; CODE XREF: seg000:1B87j
        cmp al, 57h
        jnz short loc_11B97
        call    sub_10802
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11B97:              ; CODE XREF: seg000:1B90j
        cmp al, 52h
        jnz short loc_11BA0
        call    sub_11AC6
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11BA0:              ; CODE XREF: seg000:1B99j
        cmp al, 49h
        jnz short loc_11BA9
        call    sub_11A80
        jmp short loc_11BB2
; ---------------------------------------------------------------------------

loc_11BA9:              ; CODE XREF: seg000:1BA2j
        cmp al, 55h
        jnz short loc_11BB2
        call    sub_11AA3
        jmp short $+2
; ---------------------------------------------------------------------------

loc_11BB2:              ; CODE XREF: seg000:1B4Dj seg000:1B56j
                    ; seg000:1B5Fj seg000:1B68j
                    ; seg000:1B71j seg000:1B7Aj
                    ; seg000:1B83j seg000:1B8Cj
                    ; seg000:1B95j seg000:1B9Ej
                    ; seg000:1BA7j seg000:1BABj
                    ; seg000:1BB0j
        call    sub_11008
        pop ax
        retn
; ---------------------------------------------------------------------------
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov al, 51h
        call    sub_11524
        cmp al, 59h
        jnz short loc_11BC7
        call    sub_1178E
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BC7:              ; CODE XREF: seg000:1BC0j
        cmp al, 42h
        jnz short loc_11BD0
        call    sub_119EF
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BD0:              ; CODE XREF: seg000:1BC9j
        cmp al, 4Bh
        jnz short loc_11BD9
        call    sub_11A05
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BD9:              ; CODE XREF: seg000:1BD2j
        cmp al, 31h
        jnz short loc_11BE2
        call    sub_1198E
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BE2:              ; CODE XREF: seg000:1BDBj
        cmp al, 32h
        jnz short loc_11BEB
        call    sub_1198E
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BEB:              ; CODE XREF: seg000:1BE4j
        cmp al, 46h
        jnz short loc_11BF4
        call    sub_11914
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BF4:              ; CODE XREF: seg000:1BEDj
        cmp al, 41h
        jnz short loc_11BFD
        call    sub_1192B
        jmp short loc_11C06
; ---------------------------------------------------------------------------

loc_11BFD:              ; CODE XREF: seg000:1BF6j
        cmp al, 47h
        jnz short loc_11C06
        call    gotoline
        jmp short $+2
; ---------------------------------------------------------------------------

loc_11C06:              ; CODE XREF: seg000:1BC5j seg000:1BCEj
                    ; seg000:1BD7j seg000:1BE0j
                    ; seg000:1BE9j seg000:1BF2j
                    ; seg000:1BFBj seg000:1BFFj
                    ; seg000:1C04j
        call    sub_11008
        pop ax
        retn
; ---------------------------------------------------------------------------
        push    ax
        mov al, 4Fh
        call    sub_11524
        cmp al, 49h
        jnz short loc_11C1F
        xor byte_13935, 1
        call    sub_10F78
        jmp short loc_11C2D
; ---------------------------------------------------------------------------

loc_11C1F:              ; CODE XREF: seg000:1C13j
        cmp al, 50h
        jnz short loc_11C2D
        xor byte_13936, 1
        call    sub_10FA2
        jmp short $+2
; ---------------------------------------------------------------------------

loc_11C2D:              ; CODE XREF: seg000:1C1Dj seg000:1C21j
                    ; seg000:1C2Bj
        call    sub_11008
        pop ax
        retn

; =============== S U B R O U T I N E =======================================


sub_11C32   proc near       ; CODE XREF: start+60p
        cmp byte_13938, 0
        jz  short loc_11C44
        xor ax, ax
        int 33h     ; - MS MOUSE - RESET DRIVER AND READ STATUS
                    ; Return: AX = status
                    ; BX = number of buttons
        cmp ax, 0FFFFh
        jnz short locret_11CB8
        jmp short loc_11C51
; ---------------------------------------------------------------------------

loc_11C44:              ; CODE XREF: sub_11C32+5j
        mov ax, 3
        mov bx, 0FFFFh
        int 33h     ; - MS MOUSE - RETURN POSITION AND BUTTON STATUS
                    ; Return: BX = button status, CX = column, DX = row
        cmp bx, 0FFFFh
        jz  short locret_11CB8

loc_11C51:              ; CODE XREF: sub_11C32+10j
        mov byte_144CA, 1
        mov ah, 12h
        mov bl, 10h
        int 10h     ; - VIDEO - ALTERNATE FUNCTION SELECT (PS, EGA, VGA, MCGA) - GET EGA INFO
                    ; Return: BH = 00h color mode in effect CH = feature bits, CL = switch settings
        cmp bl, 10h
        jz  short loc_11C6D
        mov cl, byte_144D0
        call    screenrows
        mul cl
        mov word_144CD, ax

loc_11C6D:              ; CODE XREF: sub_11C32+2Dj
        mov dx, word_144CD
        dec dx
        xor cx, cx
        mov ax, 8
        int 33h     ; - MS MOUSE - DEFINE VERTICAL CURSOR RANGE
                    ; CX = minimum row, DX = maximum row
        mov dx, word_144CB
        dec dx
        xor cx, cx
        mov ax, 7
        int 33h     ; - MS MOUSE - DEFINE HORIZONTAL CURSOR RANGE
                    ; CX = minimum column, DX = maximum column
        mov ax, 0Ah
        xor bx, bx
        mov cx, 77FFh
        mov dx, 7700h
        int 33h     ; - MS MOUSE - DEFINE TEXT CURSOR
                    ; BX = hardware/software text cursor
                    ; 0000h software, CX = screen mask, DX = cursor mask
                    ; 0001h hardware, CX = start scan line, DX = end scan line
        cmp byte_13938, 0
        jnz short locret_11CB8
        call    sub_11D0E
        mov cx, 0Ah

loc_11C9F:              ; CODE XREF: sub_11C32+70j
        call    sub_11CFF
        loop    loc_11C9F
        call    sub_11D0E
        mov cx, word_144CB
        shr cx, 1
        mov dx, word_144CD
        shr dx, 1
        mov ax, 4
        int 33h     ; - MS MOUSE - POSITION MOUSE CURSOR
                    ; CX = column, DX = row

locret_11CB8:               ; CODE XREF: sub_11C32+Ej
                    ; sub_11C32+1Dj sub_11C32+65j
        retn
sub_11C32   endp


; =============== S U B R O U T I N E =======================================


sub_11CB9   proc near       ; CODE XREF: start+99p
        cmp byte_144CA, 0
        jz  short locret_11CC5
        mov ax, 2
        int 33h     ; - MS MOUSE - HIDE MOUSE CURSOR
                    ; SeeAlso: AX=0001h, INT 16/AX=FFFFh

locret_11CC5:               ; CODE XREF: sub_11CB9+5j
        retn
sub_11CB9   endp


; =============== S U B R O U T I N E =======================================


sub_11CC6   proc near       ; CODE XREF: sub_112F2+21p
        push    ax
        push    bx
        push    cx
        push    dx
        cmp byte_144CA, 0
        jz  short loc_11CF9
        mov ax, 3
        int 33h     ; - MS MOUSE - RETURN POSITION AND BUTTON STATUS
                    ; Return: BX = button status, CX = column, DX = row
        mov ax, dx
        div byte_144D0
        mov word ptr unk_14ACC, ax
        mov ax, cx
        div byte_144CF
        mov word ptr unk_14ACA, ax
        and bl, 7
        mov byte ptr unk_14ACE, bl
        or  bl, bl
        jz  short loc_11CF9
        pop dx
        pop cx
        pop bx
        pop ax
        clc
        retn
; ---------------------------------------------------------------------------

loc_11CF9:              ; CODE XREF: sub_11CC6+9j
                    ; sub_11CC6+2Bj
        pop dx
        pop cx
        pop bx
        pop ax
        stc
        retn
sub_11CC6   endp


; =============== S U B R O U T I N E =======================================


sub_11CFF   proc near       ; CODE XREF: sub_112F2+15p
                    ; sub_11C32:loc_11C9Fp
        cmp byte_144CA, 0
        jz  short locret_11D0D
        push    ax
        mov ax, 1
        int 33h     ; - MS MOUSE - SHOW MOUSE CURSOR
                    ; SeeAlso: AX=0002h, INT 16/AX=FFFEh
        pop ax

locret_11D0D:               ; CODE XREF: sub_11CFF+5j
        retn
sub_11CFF   endp


; =============== S U B R O U T I N E =======================================


sub_11D0E   proc near       ; CODE XREF: sub_112F2+26p
                    ; sub_112F2:loc_1137Fp sub_11C32+67p
                    ; sub_11C32+72p
        cmp byte_144CA, 0
        jz  short locret_11D1C
        push    ax
        mov ax, 2
        int 33h     ; - MS MOUSE - HIDE MOUSE CURSOR
                    ; SeeAlso: AX=0001h, INT 16/AX=FFFFh
        pop ax

locret_11D1C:               ; CODE XREF: sub_11D0E+5j
        retn
sub_11D0E   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_11D1E   proc near       ; CODE XREF: start+63p
        call    sub_11D26
        retn
sub_11D1E   endp


; =============== S U B R O U T I N E =======================================


sub_11D22   proc near       ; CODE XREF: start+96p
        call    sub_11D26
        retn
sub_11D22   endp


; =============== S U B R O U T I N E =======================================


sub_11D26   proc near       ; CODE XREF: sub_111DC+12p sub_11D1Ep
                    ; sub_11D22p
        push    ax
        xor ax, ax
        mov byte ptr unk_14AD0, al
        mov word ptr unk_14AD4, ax
        mov word ptr unk_14AD6, ax
        mov word ptr unk_14AD8, ax
        mov word ptr unk_14ADA, ax
        mov word ptr unk_14AE4, ax
        mov word ptr unk_14AE6, ax
        mov word ptr unk_14AE8, ax
        mov word ptr unk_14AEA, ax
        mov word ptr unk_14AEC, ax
        mov word ptr unk_14AEE, ax
        mov byte ptr unk_14AD1, 1
        pop ax
        retn
sub_11D26   endp


; =============== S U B R O U T I N E =======================================


sub_11D51   proc near       ; CODE XREF: showline+3Ap sub_120E5+8p
                    ; sub_12162+8p
        cmp byte ptr unk_14AD0, 0
        jnz short loc_11D5A

loc_11D58:              ; CODE XREF: sub_11D51+Dj
                    ; sub_11D51+13j sub_11D51+1Fj
                    ; sub_11D51+2Bj
        clc
        retn
; ---------------------------------------------------------------------------

loc_11D5A:              ; CODE XREF: sub_11D51+5j
        cmp ax, word ptr unk_14AD4
        jb  short loc_11D58
        cmp ax, word ptr unk_14AD8
        ja  short loc_11D58
        cmp ax, word ptr unk_14AD4
        ja  short loc_11D72
        cmp dx, word ptr unk_14AD6
        jb  short loc_11D58

loc_11D72:              ; CODE XREF: sub_11D51+19j
        cmp ax, word ptr unk_14AD8
        jb  short loc_11D7E
        cmp dx, word ptr unk_14ADA
        jnb short loc_11D58

loc_11D7E:              ; CODE XREF: sub_11D51+25j
        stc
        retn
sub_11D51   endp


; =============== S U B R O U T I N E =======================================


sub_11D80   proc near       ; CODE XREF: sub_11D9F+14p
                    ; sub_11D9F+27p sub_11D9F+3Ap
                    ; sub_11D9F+4Dp sub_11D9F+60p
                    ; sub_11D9F+73p sub_11D9F+86p
        cmp si, ax
        jb  short locret_11D9E
        ja  short loc_11D8A
        cmp di, bx
        jbe short locret_11D9E

loc_11D8A:              ; CODE XREF: sub_11D80+4j
        cmp si, ax
        jz  short loc_11D96
        cmp si, cx
        jnz short loc_11D9A
        add di, dx
        jmp short loc_11D9A
; ---------------------------------------------------------------------------

loc_11D96:              ; CODE XREF: sub_11D80+Cj
        sub di, bx
        add di, dx

loc_11D9A:              ; CODE XREF: sub_11D80+10j
                    ; sub_11D80+14j
        sub si, ax
        add si, cx

locret_11D9E:               ; CODE XREF: sub_11D80+2j sub_11D80+8j
        retn
sub_11D80   endp


; =============== S U B R O U T I N E =======================================


sub_11D9F   proc near       ; CODE XREF: sub_109C0+4Ep
                    ; sub_10A1A+4Ap sub_10A7D+C1p
        push    di
        push    si
        cmp byte ptr unk_14AD1, 0
        jnz short loc_11DAB
        jmp loc_11E30
; ---------------------------------------------------------------------------

loc_11DAB:              ; CODE XREF: sub_11D9F+7j
        mov si, word ptr unk_14AD4
        mov di, word ptr unk_14AD6
        call    sub_11D80
        mov word ptr unk_14AD4, si
        mov word ptr unk_14AD6, di
        mov si, word ptr unk_14AD8
        mov di, word ptr unk_14ADA
        call    sub_11D80
        mov word ptr unk_14AD8, si
        mov word ptr unk_14ADA, di
        mov si, word ptr unk_14ADC
        mov di, word ptr unk_14ADE
        call    sub_11D80
        mov word ptr unk_14ADC, si
        mov word ptr unk_14ADE, di
        mov si, word ptr unk_14AE0
        mov di, word ptr unk_14AE2
        call    sub_11D80
        mov word ptr unk_14AE0, si
        mov word ptr unk_14AE2, di
        mov si, word ptr unk_14AE4
        mov di, word ptr unk_14AE6
        call    sub_11D80
        mov word ptr unk_14AE4, si
        mov word ptr unk_14AE6, di
        mov si, word ptr unk_14AE8
        mov di, word ptr unk_14AEA
        call    sub_11D80
        mov word ptr unk_14AE8, si
        mov word ptr unk_14AEA, di
        mov si, word ptr unk_14AEC
        mov di, word ptr unk_14AEE
        call    sub_11D80
        mov word ptr unk_14AEC, si
        mov word ptr unk_14AEE, di

loc_11E30:              ; CODE XREF: sub_11D9F+9j
        pop si
        pop di
        retn
sub_11D9F   endp


; =============== S U B R O U T I N E =======================================


sub_11E33   proc near       ; CODE XREF: sub_11E5A+14p
                    ; sub_11E5A+27p sub_11E5A+3Ap
                    ; sub_11E5A+4Dp sub_11E5A+60p
                    ; sub_11E5A+73p sub_11E5A+86p
        cmp si, cx
        jb  short locret_11E59
        ja  short loc_11E3D
        cmp di, dx
        jbe short locret_11E59

loc_11E3D:              ; CODE XREF: sub_11E33+4j
        cmp si, ax
        jb  short loc_11E47
        ja  short loc_11E4D
        cmp di, bx
        jnb short loc_11E4D

loc_11E47:              ; CODE XREF: sub_11E33+Cj
        mov si, cx
        mov di, dx
        jmp short locret_11E59
; ---------------------------------------------------------------------------

loc_11E4D:              ; CODE XREF: sub_11E33+Ej
                    ; sub_11E33+12j
        cmp si, ax
        jnz short loc_11E55
        sub di, bx
        add di, dx

loc_11E55:              ; CODE XREF: sub_11E33+1Cj
        sub si, ax
        add si, cx

locret_11E59:               ; CODE XREF: sub_11E33+2j sub_11E33+8j
                    ; sub_11E33+18j
        retn
sub_11E33   endp


; =============== S U B R O U T I N E =======================================


sub_11E5A   proc near       ; CODE XREF: sub_10973+26p
                    ; sub_10B4A+1Cp sub_10B8F+28p
                    ; sub_10BEC+40p
        push    di
        push    si
        cmp byte ptr unk_14AD1, 0
        jnz short loc_11E66
        jmp loc_11EEB
; ---------------------------------------------------------------------------

loc_11E66:              ; CODE XREF: sub_11E5A+7j
        mov si, word ptr unk_14AD4
        mov di, word ptr unk_14AD6
        call    sub_11E33
        mov word ptr unk_14AD4, si
        mov word ptr unk_14AD6, di
        mov si, word ptr unk_14AD8
        mov di, word ptr unk_14ADA
        call    sub_11E33
        mov word ptr unk_14AD8, si
        mov word ptr unk_14ADA, di
        mov si, word ptr unk_14ADC
        mov di, word ptr unk_14ADE
        call    sub_11E33
        mov word ptr unk_14ADC, si
        mov word ptr unk_14ADE, di
        mov si, word ptr unk_14AE0
        mov di, word ptr unk_14AE2
        call    sub_11E33
        mov word ptr unk_14AE0, si
        mov word ptr unk_14AE2, di
        mov si, word ptr unk_14AE4
        mov di, word ptr unk_14AE6
        call    sub_11E33
        mov word ptr unk_14AE4, si
        mov word ptr unk_14AE6, di
        mov si, word ptr unk_14AE8
        mov di, word ptr unk_14AEA
        call    sub_11E33
        mov word ptr unk_14AE8, si
        mov word ptr unk_14AEA, di
        mov si, word ptr unk_14AEC
        mov di, word ptr unk_14AEE
        call    sub_11E33
        mov word ptr unk_14AEC, si
        mov word ptr unk_14AEE, di

loc_11EEB:              ; CODE XREF: sub_11E5A+9j
        pop si
        pop di
        retn
sub_11E5A   endp


; =============== S U B R O U T I N E =======================================


sub_11EEE   proc near       ; CODE XREF: sub_120C3+Ap
                    ; sub_120E5+2Cp sub_12162+2Cp
        push    bx
        push    cx
        push    di
        push    si
        push    es
        mov word ptr unk_14AD2, 0
        push    ds
        pop es
        assume es:seg000
        mov di, dx
        mov si, 46A6h
        mov bx, word ptr unk_14AD6
        cmp byte ptr unk_14AD0, 0
        jz  short loc_11F1C
        mov ax, word ptr unk_14AD4
        cmp ax, word ptr unk_14AD8
        ja  short loc_11F1C
        jb  short loc_11F33
        cmp bx, word ptr unk_14ADA
        jb  short loc_11F1F

loc_11F1C:              ; CODE XREF: sub_11EEE+1Bj
                    ; sub_11EEE+24j
        stc
        jmp short loc_11F46
; ---------------------------------------------------------------------------

loc_11F1F:              ; CODE XREF: sub_11EEE+2Cj
        call    sub_108DD
        mov cx, word ptr unk_14ADA
        sub cx, bx
        add si, bx
        cld
        rep movsb
        xor ax, ax
        stosb
        clc
        jmp short loc_11F46
; ---------------------------------------------------------------------------

loc_11F33:              ; CODE XREF: sub_11EEE+26j
        call    sub_108DD
        mov cx, word ptr unk_147A6
        sub cx, bx
        inc cx
        add si, bx
        cld
        rep movsb
        mov ax, 1
        clc

loc_11F46:              ; CODE XREF: sub_11EEE+2Fj
                    ; sub_11EEE+43j
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        pop bx
        retn
sub_11EEE   endp


; =============== S U B R O U T I N E =======================================


sub_11F4C   proc near       ; CODE XREF: sub_120C3+14p
                    ; sub_120E5+4Bp sub_12162+94p
        push    cx
        push    di
        push    si
        push    es
        inc word ptr unk_14AD2
        push    ds
        pop es
        assume es:seg000
        mov di, dx
        mov si, 46A6h
        mov cx, word ptr unk_14ADA
        cmp byte ptr unk_14AD0, 0
        jz  short loc_11F79
        mov ax, word ptr unk_14AD4
        add ax, word ptr unk_14AD2
        cmp ax, word ptr unk_14AD8
        ja  short loc_11F79
        jb  short loc_11F88
        or  cx, cx
        jnz short loc_11F7C

loc_11F79:              ; CODE XREF: sub_11F4C+18j
                    ; sub_11F4C+25j
        stc
        jmp short loc_11F8F
; ---------------------------------------------------------------------------

loc_11F7C:              ; CODE XREF: sub_11F4C+2Bj
        call    sub_108DD
        cld
        rep movsb
        xor ax, ax
        stosb
        clc
        jmp short loc_11F8F
; ---------------------------------------------------------------------------

loc_11F88:              ; CODE XREF: sub_11F4C+27j
        call    sub_10895
        mov ax, 1
        clc

loc_11F8F:              ; CODE XREF: sub_11F4C+2Ej
                    ; sub_11F4C+3Aj
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        retn
sub_11F4C   endp


; =============== S U B R O U T I N E =======================================


sub_11F94   proc near       ; CODE XREF: sub_11A24+11p
        push    ax
        push    bx
        push    cx
        push    dx
        cmp byte ptr unk_14AD0, 0
        jz  short loc_11FEB
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6
        cmp ax, word ptr unk_14AD8
        ja  short loc_11FEB
        jb  short loc_11FBF
        cmp bx, word ptr unk_14ADA
        jnb short loc_11FEB
        mov cx, word ptr unk_14ADA
        sub cx, bx
        call    sub_10B8F
        jmp short loc_11FEB
; ---------------------------------------------------------------------------

loc_11FBF:              ; CODE XREF: sub_11F94+18j
        mov dl, byte_1391A
        mov byte_1391A, 1
        mov cx, 0FFh
        call    sub_10B8F
        mov byte_1391A, dl
        inc ax

loc_11FD3:              ; CODE XREF: sub_11F94+48j
        cmp ax, word ptr unk_14AD8
        jz  short loc_11FDE
        call    sub_10BEC
        jmp short loc_11FD3
; ---------------------------------------------------------------------------

loc_11FDE:              ; CODE XREF: sub_11F94+43j
        xor bx, bx
        mov cx, word ptr unk_14ADA
        call    sub_10B8F
        dec ax
        call    sub_10B4A

loc_11FEB:              ; CODE XREF: sub_11F94+9j
                    ; sub_11F94+16j sub_11F94+1Ej
                    ; sub_11F94+29j
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_11F94   endp


; =============== S U B R O U T I N E =======================================


sub_11FF0   proc near       ; CODE XREF: sub_11A80+13p
        push    ax
        push    bx
        push    di
        push    es
        cmp byte ptr unk_14AD0, 0
        jz  short loc_12021
        push    ds
        pop es
        assume es:seg000
        mov di, 49BFh
        mov word ptr [di], 20h
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6

loc_1200B:              ; CODE XREF: sub_11FF0+2Fj
        cmp ax, word ptr unk_14AD8
        ja  short loc_12021
        jb  short loc_12019
        cmp bx, word ptr unk_14ADA
        jnb short loc_12021

loc_12019:              ; CODE XREF: sub_11FF0+21j
        call    sub_10A7D
        xor bx, bx
        inc ax
        jmp short loc_1200B
; ---------------------------------------------------------------------------

loc_12021:              ; CODE XREF: sub_11FF0+9j
                    ; sub_11FF0+1Fj sub_11FF0+27j
        pop es
        assume es:nothing
        pop di
        pop bx
        pop ax
        retn
sub_11FF0   endp


; =============== S U B R O U T I N E =======================================


sub_12026   proc near       ; CODE XREF: sub_11AA3+13p
        push    ax
        push    bx
        push    cx
        cmp byte ptr unk_14AD0, 0
        jz  short loc_1205A
        mov cx, 1
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6

loc_1203A:              ; CODE XREF: sub_12026+32j
        cmp ax, word ptr unk_14AD8
        ja  short loc_1205A
        jb  short loc_12048
        cmp bx, word ptr unk_14ADA
        jnb short loc_1205A

loc_12048:              ; CODE XREF: sub_12026+1Aj
        call    sub_108DD
        cmp byte ptr [bx+46A6h], 20h
        jnz short loc_12055
        call    sub_10B8F

loc_12055:              ; CODE XREF: sub_12026+2Aj
        xor bx, bx
        inc ax
        jmp short loc_1203A
; ---------------------------------------------------------------------------

loc_1205A:              ; CODE XREF: sub_12026+8j
                    ; sub_12026+18j sub_12026+20j
        pop cx
        pop bx
        pop ax
        retn
sub_12026   endp


; =============== S U B R O U T I N E =======================================


sub_1205E   proc near       ; CODE XREF: sub_107C1+39p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        call    sub_10214
        jb  short loc_120BC
        mov word ptr unk_14AD4, ax
        mov word ptr unk_14AD6, bx
        mov word ptr unk_14AD8, ax
        mov word ptr unk_14ADA, bx
        mov byte ptr unk_14AD0, 1
        inc word ptr unk_14ADA
        mov dx, 49BFh
        push    ds
        pop es
        assume es:seg000
        mov di, dx

loc_12087:              ; CODE XREF: sub_1205E+4Bj
        push    ax
        mov cx, 0FFh
        call    sub_1026A
        mov cx, ax
        pop ax
        jb  short loc_120AB
        call    sub_10A7D
        jb  short loc_120AB
        jcxz    short loc_120AB
        push    ax
        call    strlen
        add bx, ax
        pop ax
        call    sub_10A1A
        jb  short loc_120AB
        inc ax
        xor bx, bx
        jmp short loc_12087
; ---------------------------------------------------------------------------

loc_120AB:              ; CODE XREF: sub_1205E+33j
                    ; sub_1205E+38j sub_1205E+3Aj
                    ; sub_1205E+46j
        call    sub_102CD
        jb  short loc_120BC
        cmp word ptr unk_14ADA, 0
        jz  short loc_120BB
        dec word ptr unk_14ADA

loc_120BB:              ; CODE XREF: sub_1205E+57j
        clc

loc_120BC:              ; CODE XREF: sub_1205E+9j
                    ; sub_1205E+50j
        pop es
        assume es:nothing
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_1205E   endp


; =============== S U B R O U T I N E =======================================


sub_120C3   proc near       ; CODE XREF: sub_10802+2Ap
        push    ax
        push    dx
        call    sub_102EA
        jb  short loc_120E2
        mov dx, 49BFh
        call    sub_11EEE
        jb  short loc_120E1

loc_120D2:              ; CODE XREF: sub_120C3+17j
        call    sub_10371
        jb  short loc_120DC
        call    sub_11F4C
        jnb short loc_120D2

loc_120DC:              ; CODE XREF: sub_120C3+12j
        call    sub_103B9
        jb  short loc_120E2

loc_120E1:              ; CODE XREF: sub_120C3+Dj
        clc

loc_120E2:              ; CODE XREF: sub_120C3+5j
                    ; sub_120C3+1Cj
        pop dx
        pop ax
        retn
sub_120C3   endp


; =============== S U B R O U T I N E =======================================


sub_120E5   proc near       ; CODE XREF: sub_11A45+Cp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        mov dx, bx
        call    sub_11D51
        jnb short loc_120F7
        call    beep
        jmp short loc_1215B
; ---------------------------------------------------------------------------

loc_120F7:              ; CODE XREF: sub_120E5+Bj
        mov word ptr unk_14ADC, ax
        mov word ptr unk_14ADE, bx
        mov word ptr unk_14AE0, ax
        mov word ptr unk_14AE2, bx
        inc word ptr unk_14AE2
        mov dx, 49BFh
        push    ds
        pop es
        assume es:seg000
        mov di, dx
        push    ax
        call    sub_11EEE
        mov cx, ax
        pop ax
        jb  short loc_1215B

loc_12119:              ; CODE XREF: sub_120E5+51j
        call    sub_10A7D
        jb  short loc_12138
        jcxz    short loc_12138
        push    ax
        call    strlen
        add bx, ax
        pop ax
        call    sub_10A1A
        jb  short loc_12138
        inc ax
        xor bx, bx
        push    ax
        call    sub_11F4C
        mov cx, ax
        pop ax
        jnb short loc_12119

loc_12138:              ; CODE XREF: sub_120E5+37j
                    ; sub_120E5+39j sub_120E5+45j
        cmp word ptr unk_14AE2, 0
        jz  short loc_12143
        dec word ptr unk_14AE2

loc_12143:              ; CODE XREF: sub_120E5+58j
        mov ax, word ptr unk_14ADC
        mov word ptr unk_14AD4, ax
        mov ax, word ptr unk_14ADE
        mov word ptr unk_14AD6, ax
        mov ax, word ptr unk_14AE0
        mov word ptr unk_14AD8, ax
        mov ax, word ptr unk_14AE2
        mov word ptr unk_14ADA, ax

loc_1215B:              ; CODE XREF: sub_120E5+10j
                    ; sub_120E5+32j
        pop es
        assume es:nothing
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_120E5   endp


; =============== S U B R O U T I N E =======================================


sub_12162   proc near       ; CODE XREF: sub_11A5D+13p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        mov dx, bx
        call    sub_11D51
        jnb short loc_12175
        call    beep
        jmp loc_12262
; ---------------------------------------------------------------------------

loc_12175:              ; CODE XREF: sub_12162+Bj
        mov word ptr unk_14ADC, ax
        mov word ptr unk_14ADE, bx
        mov word ptr unk_14AE0, ax
        mov word ptr unk_14AE2, bx
        inc word ptr unk_14AE2
        mov dx, 49BFh
        push    ds
        pop es
        assume es:seg000
        mov di, dx
        call    sub_11EEE
        jnb short loc_12196
        jmp loc_12262
; ---------------------------------------------------------------------------

loc_12196:              ; CODE XREF: sub_12162+2Fj
        or  ax, ax
        jnz short loc_121B7
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6
        mov cx, word ptr unk_14ADA
        sub cx, bx
        call    sub_10B8F
        mov ax, word ptr unk_14ADC
        mov bx, word ptr unk_14ADE
        call    sub_10A7D
        jmp loc_1223F
; ---------------------------------------------------------------------------

loc_121B7:              ; CODE XREF: sub_12162+36j
        push    dx
        mov dl, byte_1391A
        mov byte_1391A, 1
        mov ax, word ptr unk_14AD4
        mov bx, word ptr unk_14AD6
        mov cx, 0FFh
        call    sub_10B8F
        mov byte_1391A, dl
        pop dx
        mov ax, word ptr unk_14AE0
        mov bx, word ptr unk_14AE2
        or  bx, bx
        jz  short loc_121DF
        dec bx

loc_121DF:              ; CODE XREF: sub_12162+7Aj
        call    sub_10A7D
        jb  short loc_1223F
        push    ax
        call    strlen
        add bx, ax
        pop ax
        call    sub_10A1A
        jb  short loc_1223F

loc_121F0:              ; CODE XREF: sub_12162+DBj
        mov word ptr unk_14AD2, 0
        call    sub_11F4C
        jnb short loc_12205
        mov ax, word ptr unk_14AD4
        xor bx, bx
        call    sub_10B4A
        jmp short loc_1223F
; ---------------------------------------------------------------------------

loc_12205:              ; CODE XREF: sub_12162+97j
        or  ax, ax
        jnz short loc_1222B
        mov ax, word ptr unk_14AD4
        inc ax
        xor bx, bx
        mov cx, word ptr unk_14ADA
        call    sub_10B8F
        dec ax
        call    sub_10B4A
        mov ax, word ptr unk_14AE0
        mov bx, word ptr unk_14AE2
        or  bx, bx
        jz  short loc_12226
        dec bx

loc_12226:              ; CODE XREF: sub_12162+C1j
        call    sub_10A7D
        jmp short loc_1223F
; ---------------------------------------------------------------------------

loc_1222B:              ; CODE XREF: sub_12162+A5j
        mov ax, word ptr unk_14AD4
        inc ax
        call    sub_10BEC
        mov ax, word ptr unk_14AE0
        xor bx, bx
        call    sub_10A1A
        call    sub_10A7D
        jmp short loc_121F0
; ---------------------------------------------------------------------------

loc_1223F:              ; CODE XREF: sub_12162+52j
                    ; sub_12162+80j sub_12162+8Cj
                    ; sub_12162+A1j sub_12162+C7j
        cmp word ptr unk_14AE2, 0
        jz  short loc_1224A
        dec word ptr unk_14AE2

loc_1224A:              ; CODE XREF: sub_12162+E2j
        mov ax, word ptr unk_14ADC
        mov word ptr unk_14AD4, ax
        mov ax, word ptr unk_14ADE
        mov word ptr unk_14AD6, ax
        mov ax, word ptr unk_14AE0
        mov word ptr unk_14AD8, ax
        mov ax, word ptr unk_14AE2
        mov word ptr unk_14ADA, ax

loc_12262:              ; CODE XREF: sub_12162+10j
                    ; sub_12162+31j
        pop es
        assume es:nothing
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_12162   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_1226A   proc near       ; CODE XREF: start+66p
        push    ax
        xor ax, ax
        mov byte ptr findtxt, al
        mov byte ptr unk_14B26, al
        mov byte ptr unk_14B47, al
        pop ax
        retn
sub_1226A   endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_3. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B R O U T I N E =======================================


sub_12279   proc near       ; CODE XREF: sub_122C9+43p
                    ; sub_123A5+55p
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        mov ax, 0Ah
        mov bx, ax
        mov dx, 3C38h
        mov si, 4B47h
        call    userinput
        jb  short loc_122C2
        mov dx, si
        call    strupr

loc_12294:              ; CODE XREF: sub_12279+2Aj
                    ; sub_12279+3Dj
        cld
        lodsb
        or  al, al
        jz  short loc_122C1
        cmp al, 4Eh
        jnz short loc_122A5
        mov byte ptr unk_14AF6, 1
        jmp short loc_12294
; ---------------------------------------------------------------------------

loc_122A5:              ; CODE XREF: sub_12279+23j
        cmp al, 47h
        jnz short loc_122B8
        mov byte ptr unk_14AF1, 1
        xor ax, ax
        mov word ptr unk_14AF7, ax
        mov word ptr unk_14AF9, ax
        jmp short loc_12294
; ---------------------------------------------------------------------------

loc_122B8:              ; CODE XREF: sub_12279+2Ej
        mov dx, 3D3Ah
        call    sub_10DA6
        stc
        jmp short loc_122C2
; ---------------------------------------------------------------------------

loc_122C1:              ; CODE XREF: sub_12279+1Fj
        clc

loc_122C2:              ; CODE XREF: sub_12279+14j
                    ; sub_12279+46j
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_12279   endp


; =============== S U B R O U T I N E =======================================


sub_122C9   proc near       ; CODE XREF: sub_11914+2p
        push    ax
        push    bx
        push    dx
        push    si
        xor ax, ax
        mov byte ptr unk_14AF0, al
        mov byte ptr unk_14AF1, al
        mov byte ptr unk_14AF2, al
        mov byte ptr unk_14AF3, al
        mov byte ptr unk_14AF4, al
        mov byte ptr unk_14AF5, al
        mov byte ptr unk_14AF6, al
        mov ax, 20h
        mov bx, ax
        mov dx, 3C1Ch
        mov si, 4B05h
        call    userinput
        jb  short loc_1230F
        mov dx, si
        call    strlen
        or  ax, ax
        jnz short loc_12300
        stc
        jmp short loc_1230F
; ---------------------------------------------------------------------------

loc_12300:              ; CODE XREF: sub_122C9+32j
        mov ax, word ptr curlin
        mov word ptr unk_14AF7, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AF9, ax
        call    sub_12279

loc_1230F:              ; CODE XREF: sub_122C9+29j
                    ; sub_122C9+35j
        pop si
        pop dx
        pop bx
        pop ax
        retn
sub_122C9   endp


; =============== S U B R O U T I N E =======================================


findtext    proc near       ; CODE XREF: sub_11914+7p
                    ; sub_12553+13p
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov word ptr matches, 0
        mov ax, word ptr curlin
        mov word ptr unk_14AFB, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AFD, ax
        mov si, 4B05h
        cmp byte ptr [si], 0
        jz  short loc_1238D
        mov ax, word ptr unk_14AF7
        mov bx, word ptr unk_14AF9

loc_1233C:              ; CODE XREF: findtext+69j findtext+77j
        cmp ax, word_13918
        jnb short loc_1238D
        call    sub_108DD
        mov di, 46A6h
        cmp bx, word ptr unk_147A6
        jnb short loc_12381
        add di, bx
        push    ax
        call    strstr
        mov cx, ax
        pop ax
        jcxz    short loc_12381
        inc word ptr matches
        mov bx, cx
        sub bx, 46A6h
        push    ax
        mov dx, offset findtxt
        call    strlen
        add bx, ax
        pop ax
        mov word ptr unk_14AF9, bx
        mov word ptr unk_14AFB, ax
        mov word ptr unk_14AFD, bx
        cmp byte ptr unk_14AF1, 0
        jnz short loc_1233C
        jmp short loc_1238D
; ---------------------------------------------------------------------------

loc_12381:              ; CODE XREF: findtext+38j findtext+43j
        inc ax
        mov word ptr unk_14AF7, ax
        xor bx, bx
        mov word ptr unk_14AF9, bx
        jmp short loc_1233C
; ---------------------------------------------------------------------------

loc_1238D:              ; CODE XREF: findtext+1Fj findtext+2Cj
                    ; findtext+6Bj
        cmp word ptr matches, 0
        jnz short loc_12397
        stc
        jmp short loc_12398
; ---------------------------------------------------------------------------

loc_12397:              ; CODE XREF: findtext+7Ej
        clc

loc_12398:              ; CODE XREF: findtext+81j
        mov ax, word ptr unk_14AFB
        mov bx, word ptr unk_14AFD
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        retn
findtext    endp


; =============== S U B R O U T I N E =======================================


sub_123A5   proc near       ; CODE XREF: sub_1192B+2p
        push    ax
        push    bx
        push    dx
        push    si
        xor ax, ax
        mov byte ptr unk_14AF0, 1
        mov byte ptr unk_14AF1, al
        mov byte ptr unk_14AF2, al
        mov byte ptr unk_14AF3, al
        mov byte ptr unk_14AF4, al
        mov byte ptr unk_14AF5, al
        mov byte ptr unk_14AF6, al
        mov ax, 20h
        mov bx, ax
        mov dx, 3C1Ch
        mov si, 4B05h
        call    userinput
        jb  short loc_123FD
        mov dx, si
        call    strlen
        or  ax, ax
        jnz short loc_123DE
        stc
        jmp short loc_123FD
; ---------------------------------------------------------------------------

loc_123DE:              ; CODE XREF: sub_123A5+34j
        mov ax, 20h
        mov bx, ax
        mov dx, 3C29h
        mov si, 4B26h
        call    userinput
        jb  short loc_123FD
        mov ax, word ptr curlin
        mov word ptr unk_14AF7, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AF9, ax
        call    sub_12279

loc_123FD:              ; CODE XREF: sub_123A5+2Bj
                    ; sub_123A5+37j sub_123A5+47j
        pop si
        pop dx
        pop bx
        pop ax
        retn
sub_123A5   endp


; =============== S U B R O U T I N E =======================================


replacetext proc near       ; CODE XREF: sub_1192B+7p
                    ; sub_12553:loc_1256Bp
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov word ptr matches, 0
        mov ax, word ptr curlin
        mov word ptr unk_14AFB, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AFD, ax
        mov si, offset findtxt
        cmp byte ptr [si], 0
        jnz short loc_12426

loc_12423:              ; CODE XREF: replacetext+2Fj
        jmp loc_1253B
; ---------------------------------------------------------------------------

loc_12426:              ; CODE XREF: replacetext+1Fj
                    ; replacetext+127j
        mov ax, word ptr unk_14AF7
        mov bx, word ptr unk_14AF9

loc_1242D:              ; CODE XREF: replacetext+136j
        cmp ax, word_13918
        jnb short loc_12423
        call    sub_108DD
        mov di, 46A6h
        cmp bx, word ptr unk_147A6
        jb  short loc_12442

loc_1243F:              ; CODE XREF: replacetext+49j
        jmp loc_1252E
; ---------------------------------------------------------------------------

loc_12442:              ; CODE XREF: replacetext+3Bj
        add di, bx
        push    ax
        call    strstr
        mov cx, ax
        pop ax
        jcxz    short loc_1243F
        inc word ptr matches
        mov bx, cx
        sub bx, 46A6h
        push    ax
        mov dx, 4B05h
        call    strlen
        mov cx, ax
        pop ax
        cmp byte ptr unk_14AF6, 0
        jz  short loc_1246B
        jmp loc_124FF
; ---------------------------------------------------------------------------

loc_1246B:              ; CODE XREF: replacetext+64j
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        add bx, cx
        call    sub_1147B
        call    sub_10ED8
        mov word ptr unk_14AF7, ax
        mov word ptr unk_14AF9, bx
        mov word ptr unk_14AFB, ax
        mov word ptr unk_14AFD, bx
        push    ax
        call    wherex
        call    wherey
        mov curspos, ax
        pop ax
        sub ax, word ptr unk_14AC1
        inc ax
        mov cx, ax
        mov dx, 3B99h
        call    strlen
        mov dx, 806h
        add dl, al
        mov ax, 603h
        cmp cl, dh
        ja  short loc_124B1
        add ah, 3
        add dh, 3

loc_124B1:              ; CODE XREF: replacetext+A7j
        mov bl, 1
        mov cl, byte_13932
        mov ch, byte_13933
        call    openwindow
        mov al, 20h
        call    outchar
        mov dx, offset aReplace?YN ; "Replace? (Y/N) "
        call    outtext
        call    screencols
        dec al
        mov dl, al
        call    screenrows
        dec al
        mov dh, al
        xor ax, ax
        call    window
        mov ax, curspos
        call    gotoxy
        call    CHOICE
        mov word ptr unk_14AFF, ax
        call    closewindow
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        cmp word ptr unk_14AFF, 1Bh
        jz  short loc_1253B
        cmp word ptr unk_14AFF, 59h
        jnz short loc_12522

loc_124FF:              ; CODE XREF: replacetext+66j
        call    sub_10B8F
        mov di, 4B26h
        call    sub_10A7D
        jb  short loc_1253B
        push    ax
        mov dx, offset unk_14B26
        call    strlen
        add bx, ax
        pop ax
        mov word ptr unk_14AF9, bx
        mov word ptr unk_14AFB, ax
        mov word ptr unk_14AFD, bx
        call    sub_11230

loc_12522:              ; CODE XREF: replacetext+FBj
        cmp byte ptr unk_14AF1, 0
        jz  short loc_1252C
        jmp loc_12426
; ---------------------------------------------------------------------------

loc_1252C:              ; CODE XREF: replacetext+125j
        jmp short loc_1253B
; ---------------------------------------------------------------------------

loc_1252E:              ; CODE XREF: replacetext:loc_1243Fj
        inc ax
        mov word ptr unk_14AF7, ax
        xor bx, bx
        mov word ptr unk_14AF9, bx
        jmp loc_1242D
; ---------------------------------------------------------------------------

loc_1253B:              ; CODE XREF: replacetext:loc_12423j
                    ; replacetext+F4j replacetext+106j
                    ; replacetext:loc_1252Cj
        cmp word ptr matches, 0
        jnz short loc_12545
        stc
        jmp short loc_12546
; ---------------------------------------------------------------------------

loc_12545:              ; CODE XREF: replacetext+13Ej
        clc

loc_12546:              ; CODE XREF: replacetext+141j
        mov ax, word ptr unk_14AFB
        mov bx, word ptr unk_14AFD
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        retn
replacetext endp


; =============== S U B R O U T I N E =======================================


sub_12553   proc near       ; CODE XREF: seg000:1943p
        mov ax, word ptr curlin
        mov word ptr unk_14AF7, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14AF9, ax
        cmp byte ptr unk_14AF0, 0
        jnz short loc_1256B
        call    findtext
        jmp short locret_1256E
; ---------------------------------------------------------------------------

loc_1256B:              ; CODE XREF: sub_12553+11j
        call    replacetext

locret_1256E:               ; CODE XREF: sub_12553+16j
        retn
sub_12553   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


sub_12570   proc near       ; CODE XREF: start+69p
        mov byte_15148, 0
        call    sub_1257A
        retn
sub_12570   endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_4. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B R O U T I N E =======================================


sub_1257A   proc near       ; CODE XREF: sub_12570+5p
                    ; sub_1259D:loc_125ABp
        push    ax
        push    cx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov di, 4B52h
        mov cx, 5148h
        sub cx, di
        xor al, al
        cld
        rep stosb
        mov di, 4B52h
        mov si, 44D2h
        call    strcpy
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        pop ax
        retn
sub_1257A   endp


; =============== S U B R O U T I N E =======================================


sub_1259D   proc near       ; CODE XREF: start+6Cp
        push    ax
        push    bx
        push    cx
        push    dx
        mov ax, 3D00h
        mov dx, 44E6h
        int 21h     ; DOS - 2+ - OPEN DISK FILE WITH HANDLE
                    ; DS:DX -> ASCIZ filename
                    ; AL = access mode
                    ; 0 - read
        jnb short loc_125B0

loc_125AB:              ; CODE XREF: sub_1259D+29j
                    ; sub_1259D+2Dj
        call    sub_1257A
        jmp short loc_125D1
; ---------------------------------------------------------------------------

loc_125B0:              ; CODE XREF: sub_1259D+Cj
        mov bx, ax
        mov ah, 3Fh
        mov dx, 4B52h
        mov cx, 5148h
        sub cx, dx
        int 21h     ; DOS - 2+ - READ FROM FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to read
                    ; DS:DX -> buffer
        pushf
        push    ax
        mov ah, 3Eh
        int 21h     ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                    ; BX = file handle
        pop ax
        popf
        jb  short loc_125AB
        cmp ax, cx
        jnz short loc_125AB
        mov byte_15148, 1

loc_125D1:              ; CODE XREF: sub_1259D+11j
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_1259D   endp


; =============== S U B R O U T I N E =======================================


sub_125D6   proc near       ; CODE XREF: start+8Dp mkpick+5p
        push    ax
        push    bx
        push    cx
        push    dx
        cmp byte_15148, 0
        jz  short loc_12601
        call    sub_12606
        mov ah, 3Ch
        xor cx, cx
        mov dx, 44E6h
        int 21h     ; DOS - 2+ - CREATE A FILE WITH HANDLE (CREAT)
                    ; CX = attributes for file
                    ; DS:DX -> ASCIZ filename (may include drive and path)
        jb  short loc_12601
        mov bx, ax
        mov ah, 40h
        mov dx, 4B52h
        mov cx, 5148h
        sub cx, dx
        int 21h     ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
        mov ah, 3Eh
        int 21h     ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                    ; BX = file handle

loc_12601:              ; CODE XREF: sub_125D6+9j
                    ; sub_125D6+17j
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_125D6   endp


; =============== S U B R O U T I N E =======================================


sub_12606   proc near       ; CODE XREF: sub_10456+9p sub_106F8+5p
                    ; sub_125D6+Bp sub_12676:loc_126A1p
                    ; sub_127F4+E8p
        push    ax
        push    di
        push    si
        push    es
        cmp byte ptr unk_1450C, 0
        jz  short loc_12671
        cmp word ptr unk_14B7A, 0
        jz  short loc_12671
        mov si, 450Ch
        push    ds
        pop es
        assume es:seg000
        mov di, 4B7Ch
        call    strcpy
        mov ax, word ptr unk_14AC1
        mov word ptr unk_14BCD, ax
        mov ax, word ptr unk_14AC3
        mov word ptr unk_14BCF, ax
        mov ax, word ptr curlin
        mov word ptr unk_14BD1, ax
        mov ax, word ptr unk_14AC7
        mov word ptr unk_14BD3, ax
        mov ax, word ptr unk_14AD4
        mov word ptr unk_14BD6, ax
        mov ax, word ptr unk_14AD6
        mov word ptr unk_14BD8, ax
        mov ax, word ptr unk_14AD8
        mov word ptr unk_14BDA, ax
        mov ax, word ptr unk_14ADA
        mov word ptr unk_14BDC, ax
        mov ax, word ptr unk_14AE4
        mov word ptr unk_14BDE, ax
        mov ax, word ptr unk_14AE6
        mov word ptr unk_14BE0, ax
        mov ax, word ptr unk_14AE8
        mov word ptr unk_14BE2, ax
        mov ax, word ptr unk_14AEA
        mov word ptr unk_14BE4, ax
        mov al, byte ptr unk_14AD0
        mov byte ptr unk_14BD5, al

loc_12671:              ; CODE XREF: sub_12606+9j
                    ; sub_12606+10j
        pop es
        assume es:nothing
        pop si
        pop di
        pop ax
        retn
sub_12606   endp


; =============== S U B R O U T I N E =======================================


sub_12676   proc near       ; CODE XREF: sub_10456+1Fp
                    ; sub_10753+5Ap sub_126A9+105p
        push    cx
        push    di
        push    si
        push    es
        cmp byte ptr unk_1450C, 0
        jz  short loc_126A4
        push    ds
        pop es
        assume es:seg000
        mov di, 5148h
        dec di
        mov si, di
        sub si, 6Ah
        mov cx, si
        inc cx
        sub cx, 4B7Ch
        std
        rep movsb
        cmp word ptr unk_14B7A, 0Eh
        jnb short loc_126A1
        inc word ptr unk_14B7A

loc_126A1:              ; CODE XREF: sub_12676+25j
        call    sub_12606

loc_126A4:              ; CODE XREF: sub_12676+9j
        pop es
        assume es:nothing
        pop si
        pop di
        pop cx
        retn
sub_12676   endp


; =============== S U B R O U T I N E =======================================


sub_126A9   proc near       ; CODE XREF: start+85p sub_10456+17p
                    ; sub_127F4+EBp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        cmp word ptr unk_14B7A, 0
        jz  short loc_126C5
        mov bl, 6Ah
        mul bl
        mov bx, 4B7Ch
        add bx, ax
        cmp byte ptr [bx], 0
        jnz short loc_126D9

loc_126C5:              ; CODE XREF: sub_126A9+Cj
        call    sub_106F8
        cmp ax, 1Bh
        jz  short loc_126D5
        cmp ax, 0FFD3h
        jz  short loc_126D5
        jmp loc_127B1
; ---------------------------------------------------------------------------

loc_126D5:              ; CODE XREF: sub_126A9+22j
                    ; sub_126A9+27j sub_126A9+36j
        stc
        jmp loc_127B2
; ---------------------------------------------------------------------------

loc_126D9:              ; CODE XREF: sub_126A9+1Aj
        call    sub_110A9
        cmp ax, 1Bh
        jz  short loc_126D5
        call    sub_10C3B
        call    sub_111F3
        lea si, [bx]
        push    ds
        pop es
        assume es:seg000
        mov di, 450Ch
        call    strcpy
        call    sub_1102A
        call    sub_103E9
        mov al, [bx+59h]
        mov byte ptr unk_14AD0, al
        mov dx, word_13918
        dec dx
        mov ax, [bx+53h]
        mov word ptr unk_14AC3, ax
        mov ax, [bx+57h]
        mov word ptr unk_14AC7, ax
        mov ax, [bx+5Ch]
        mov word ptr unk_14AD6, ax
        mov ax, [bx+60h]
        mov word ptr unk_14ADA, ax
        mov ax, [bx+64h]
        mov word ptr unk_14AE6, ax
        mov ax, [bx+68h]
        mov word ptr unk_14AEA, ax
        mov ax, [bx+51h]
        cmp ax, dx
        jbe short loc_12735
        mov ax, dx
        mov word ptr unk_14AC3, 0

loc_12735:              ; CODE XREF: sub_126A9+82j
        mov word ptr unk_14AC1, ax
        mov ax, [bx+55h]
        cmp ax, dx
        jbe short loc_12747
        mov ax, dx
        mov word ptr unk_14AC7, 0

loc_12747:              ; CODE XREF: sub_126A9+94j
        mov word ptr curlin, ax
        mov ax, [bx+5Ah]
        cmp ax, dx
        jbe short loc_12759
        mov ax, dx
        mov word ptr unk_14AD6, 0

loc_12759:              ; CODE XREF: sub_126A9+A6j
        mov word ptr unk_14AD4, ax
        mov ax, [bx+5Eh]
        cmp ax, dx
        jbe short loc_1276B
        mov ax, dx
        mov word ptr unk_14ADA, 0

loc_1276B:              ; CODE XREF: sub_126A9+B8j
        mov word ptr unk_14AD8, ax
        mov ax, [bx+62h]
        cmp ax, dx
        jbe short loc_1277D
        mov ax, dx
        mov word ptr unk_14AE6, 0

loc_1277D:              ; CODE XREF: sub_126A9+CAj
        mov word ptr unk_14AE4, ax
        mov ax, [bx+66h]
        cmp ax, dx
        jbe short loc_1278F
        mov ax, dx
        mov word ptr unk_14AEA, 0

loc_1278F:              ; CODE XREF: sub_126A9+DCj
        mov word ptr unk_14AE8, ax
        call    sub_11409
        call    sub_112C3
        call    sub_111F3
        mov di, bx
        mov si, di
        add si, 6Ah
        mov cx, 5148h
        sub cx, si
        cld
        rep movsb
        dec word ptr unk_14B7A
        call    sub_12676

loc_127B1:              ; CODE XREF: sub_126A9+29j
        clc

loc_127B2:              ; CODE XREF: sub_126A9+2Dj
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_126A9   endp


; =============== S U B R O U T I N E =======================================


sub_127BA   proc near       ; CODE XREF: sub_127F4:loc_1285Cp
                    ; sub_127F4+80p sub_127F4+90p
        push    ax
        push    dx
        push    di
        push    si
        push    ax
        mov al, ah
        call    textattr
        pop ax
        push    ax
        mov ah, al
        xor al, al
        call    gotoxy
        mov al, 20h
        call    outchar
        pop ax
        xor ah, ah
        mov dl, 6Ah
        mul dl
        mov si, 4B7Ch
        add si, ax
        mov ax, 32h
        mov di, 4650h
        call    sub_105CC
        mov dx, di
        call    outtext
        call    clreol
        pop si
        pop di
        pop dx
        pop ax
        retn
sub_127BA   endp


; =============== S U B R O U T I N E =======================================


sub_127F4   proc near       ; CODE XREF: pickp
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        mov cx, word ptr unk_14B7A
        or  cx, cx
        jnz short loc_12806
        jmp loc_128E3
; ---------------------------------------------------------------------------

loc_12806:              ; CODE XREF: sub_127F4+Dj
        xor bx, bx
        mov si, 4B7Ch
        push    ds
        pop es
        assume es:seg000
        mov di, 4650h
        mov dx, di

loc_12812:              ; CODE XREF: sub_127F4+30j
        mov ax, 32h
        call    sub_105CC
        call    strlen
        cmp ax, bx
        jbe short loc_12821
        mov bx, ax

loc_12821:              ; CODE XREF: sub_127F4+29j
        add si, 6Ah
        loop    loc_12812
        cmp bx, 0Ch
        jnb short loc_1282E
        mov bx, 0Ch

loc_1282E:              ; CODE XREF: sub_127F4+35j
        mov ax, 505h
        mov dx, ax
        add dx, 103h
        add dl, bl
        add dh, byte ptr unk_14B7A
        mov cl, byte_13932
        mov ch, byte_13933
        mov bl, 1
        call    openwindow
        mov dx, 3C09h
        xor ah, ah
        call    sub_13526
        mov ah, byte_13932
        xor al, al
        mov cx, word ptr unk_14B7A

loc_1285C:              ; CODE XREF: sub_127F4+6Dj
        call    sub_127BA
        inc al
        loop    loc_1285C

loc_12863:              ; CODE XREF: sub_127F4+B1j
                    ; sub_127F4+B6j
        mov ax, 1
        cmp word ptr unk_14B7A, 1
        ja  short loc_1286F
        xor ax, ax

loc_1286F:              ; CODE XREF: sub_127F4+77j
                    ; sub_127F4+CCj sub_127F4+D6j
                    ; sub_127F4:loc_128D1j sub_127F4+E3j
        push    ax
        mov ah, byte_1392D
        call    sub_127BA
        pop ax
        push    ax
        call    getkey
        mov bx, ax
        pop ax
        push    ax
        mov ah, byte_13932
        call    sub_127BA
        pop ax
        cmp bx, 1Bh
        jz  short loc_12897
        cmp bx, 0FFD3h
        jnz short loc_1289D
        mov byte_148B6, 1

loc_12897:              ; CODE XREF: sub_127F4+97j
        call    closewindow
        clc
        jmp short loc_128E3
; ---------------------------------------------------------------------------

loc_1289D:              ; CODE XREF: sub_127F4+9Cj
        cmp bx, 0Dh
        jz  short loc_128D9
        cmp bx, 0FFB9h
        jz  short loc_12863
        cmp bx, 0FFB7h
        jz  short loc_12863
        cmp bx, 0FFB1h
        jz  short loc_128D3
        cmp bx, 0FFAFh
        jz  short loc_128D3
        cmp bx, 0FFB8h
        jz  short loc_128CC
        cmp bx, 0FFB0h
        jz  short loc_128C2
        jmp short loc_1286F
; ---------------------------------------------------------------------------

loc_128C2:              ; CODE XREF: sub_127F4+CAj
        inc ax
        cmp ax, word ptr unk_14B7A
        jb  short loc_128D1
        dec ax
        jmp short loc_1286F
; ---------------------------------------------------------------------------

loc_128CC:              ; CODE XREF: sub_127F4+C5j
        or  ax, ax
        jz  short loc_128D1
        dec ax

loc_128D1:              ; CODE XREF: sub_127F4+D3j
                    ; sub_127F4+DAj
        jmp short loc_1286F
; ---------------------------------------------------------------------------

loc_128D3:              ; CODE XREF: sub_127F4+BBj
                    ; sub_127F4+C0j
        mov ax, word ptr unk_14B7A
        dec ax
        jmp short loc_1286F
; ---------------------------------------------------------------------------

loc_128D9:              ; CODE XREF: sub_127F4+ACj
        call    closewindow
        call    sub_12606
        call    sub_126A9
        clc

loc_128E3:              ; CODE XREF: sub_127F4+Fj
                    ; sub_127F4+A7j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_127F4   endp


; =============== S U B R O U T I N E =======================================


sub_128EB   proc near       ; CODE XREF: sub_10456+Fp
        push    bx
        push    cx
        push    dx
        push    bp
        push    di
        push    si
        push    es
        call    strlen
        inc ax
        mov bx, ax
        xor ax, ax
        mov bp, 4B7Ch
        push    ds
        pop es
        assume es:seg000
        mov cx, word ptr unk_14B7A
        jcxz    short loc_12918

loc_12905:              ; CODE XREF: sub_128EB+2Bj
        mov di, dx
        mov si, bp
        push    cx
        mov cx, bx
        cld
        repe cmpsb
        pop cx
        jz  short loc_1291B
        inc ax
        add bp, 6Ah
        loop    loc_12905

loc_12918:              ; CODE XREF: sub_128EB+18j
        mov ax, 0FFFFh

loc_1291B:              ; CODE XREF: sub_128EB+25j
        pop es
        assume es:nothing
        pop si
        pop di
        pop bp
        pop dx
        pop cx
        pop bx
        retn
sub_128EB   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

choosefile  proc near       ; CODE XREF: sub_10688+33p

var_AD      = byte ptr -0ADh
var_5D      = byte ptr -5Dh
var_50      = byte ptr -50h

        push    ax
        push    bp
        mov bp, sp
        sub sp, 0ADh
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        lea di, [bp+var_50]
        mov si, dx
        call    strcpy
        mov si, di
        call    strlen
        add si, ax
        std

loc_12944:              ; CODE XREF: choosefile+23j
        lodsb
        cmp al, 5Ch
        jnz short loc_12944
        add si, 2
        lea di, [bp+var_5D]
        call    strcpy
        mov byte ptr [si], 0
        push    dx
        mov al, 3
        mov ah, 5
        mov dx, ax
        add dl, 48h
        add dh, 0Dh
        mov bl, 1
        mov cl, byte_13932
        mov ch, byte_13933
        call    openwindow
        pop dx

loc_12970:              ; CODE XREF: choosefile+1D3j
        push    dx
        call    drawborder
        lea si, [bp+var_50]
        lea di, [bp+var_AD]
        mov word ptr [di], 20h
        call    strcat
        lea si, [bp+var_5D]
        call    strcat
        mov dx, di
        call    strlen
        push    di
        add di, ax
        mov word ptr [di], 20h
        pop di
        mov si, di
        mov ax, 47h
        call    sub_105CC
        mov dx, di
        xor al, al
        mov ch, byte_13933
        call    sub_13526
        lea di, [bp+var_50]
        lea si, [bp+var_5D]
        call    sub_12B12
        cmp byte ptr unk_1514C, 0
        jz  short loc_129C4
        mov dx, 3D2Bh
        mov al, 5
        mov ch, byte_13933
        call    sub_13526

loc_129C4:              ; CODE XREF: choosefile+92j
        mov word ptr unk_1514D, 0
        mov word ptr unk_1514F, 0
        call    sub_12C49
        pop dx

loc_129D4:              ; CODE XREF: choosefile+ECj
                    ; choosefile:loc_12A73j
                    ; choosefile:loc_12AC2j
        mov al, byte ptr unk_1514F
        mov ah, byte_1392D
        call    sub_12BDA
        call    getkey
        push    ax
        mov al, byte ptr unk_1514F
        mov ah, byte_13932
        call    sub_12BDA
        pop ax
        cmp ax, 1Bh
        jz  short loc_129FC
        cmp ax, 0FFD3h
        jnz short loc_12A03
        mov byte_148B6, 1

loc_129FC:              ; CODE XREF: choosefile+CCj
                    ; choosefile+1A8j
        call    closewindow
        stc
        jmp loc_12B03
; ---------------------------------------------------------------------------

loc_12A03:              ; CODE XREF: choosefile+D1j
        cmp ax, 0Dh
        jnz short loc_12A0B
        jmp loc_12AC5
; ---------------------------------------------------------------------------

loc_12A0B:              ; CODE XREF: choosefile+E2j
        cmp word ptr unk_1514A, 0
        jz  short loc_129D4
        cmp ax, 0FFB9h
        jnz short loc_12A1F
        mov word ptr unk_1514F, 0
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A1F:              ; CODE XREF: choosefile+F1j
        cmp ax, 0FFB7h
        jnz short loc_12A2B
        sub word ptr unk_1514F, 3Ch
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A2B:              ; CODE XREF: choosefile+FEj
        cmp ax, 0FFB1h
        jnz short loc_12A39
        mov ax, word ptr unk_1514A
        dec ax
        mov word ptr unk_1514F, ax
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A39:              ; CODE XREF: choosefile+10Aj
        cmp ax, 0FFAFh
        jnz short loc_12A45
        add word ptr unk_1514F, 3Ch
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A45:              ; CODE XREF: choosefile+118j
        cmp ax, 0FFB8h
        jnz short loc_12A51
        sub word ptr unk_1514F, 5
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A51:              ; CODE XREF: choosefile+124j
        cmp ax, 0FFB0h
        jnz short loc_12A5D
        add word ptr unk_1514F, 5
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A5D:              ; CODE XREF: choosefile+130j
        cmp ax, 0FFB5h
        jnz short loc_12A68
        dec word ptr unk_1514F
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A68:              ; CODE XREF: choosefile+13Cj
        cmp ax, 0FFB3h
        jnz short loc_12A73
        inc word ptr unk_1514F
        jmp short loc_12A76
; ---------------------------------------------------------------------------

loc_12A73:              ; CODE XREF: choosefile+147j
        jmp loc_129D4
; ---------------------------------------------------------------------------

loc_12A76:              ; CODE XREF: choosefile+F9j
                    ; choosefile+105j choosefile+113j
                    ; choosefile+11Fj choosefile+12Bj
                    ; choosefile+137j choosefile+142j
                    ; choosefile+14Dj
        mov bx, word ptr unk_1514D
        cmp word ptr unk_1514F, 0
        jge short loc_12A89
        mov word ptr unk_1514F, 0
        jmp short loc_12A96
; ---------------------------------------------------------------------------

loc_12A89:              ; CODE XREF: choosefile+15Bj
        mov ax, word ptr unk_1514A
        dec ax
        cmp word ptr unk_1514F, ax
        jle short loc_12A96
        mov word ptr unk_1514F, ax

loc_12A96:              ; CODE XREF: choosefile+163j
                    ; choosefile+16Dj choosefile+183j
        mov ax, word ptr unk_1514D
        add ax, 3Ch
        cmp ax, word ptr unk_1514F
        jg  short loc_12AA9
        add word ptr unk_1514D, 5
        jmp short loc_12A96
; ---------------------------------------------------------------------------

loc_12AA9:              ; CODE XREF: choosefile+17Cj
                    ; choosefile+193j
        mov ax, word ptr unk_1514F
        cmp word ptr unk_1514D, ax
        jle short loc_12AB9
        sub word ptr unk_1514D, 5
        jmp short loc_12AA9
; ---------------------------------------------------------------------------

loc_12AB9:              ; CODE XREF: choosefile+18Cj
        cmp word ptr unk_1514D, bx
        jz  short loc_12AC2
        call    sub_12C49

loc_12AC2:              ; CODE XREF: choosefile+199j
        jmp loc_129D4
; ---------------------------------------------------------------------------

loc_12AC5:              ; CODE XREF: choosefile+E4j
        cmp word ptr unk_1514A, 0
        jnz short loc_12ACF
        jmp loc_129FC
; ---------------------------------------------------------------------------

loc_12ACF:              ; CODE XREF: choosefile+1A6j
        mov ax, word ptr unk_1514F
        mov bl, 0Eh
        mul bl
        mov si, 5151h
        add si, ax
        lea di, [bp+var_50]
        call    strcat
        push    dx
        mov dx, di
        call    strlen
        pop dx
        mov si, di
        add di, ax
        dec di
        cmp byte ptr [di], 5Ch
        jnz short loc_12AFA
        mov di, si
        call    mkfullpath
        jmp loc_12970
; ---------------------------------------------------------------------------

loc_12AFA:              ; CODE XREF: choosefile+1CCj
        mov di, dx
        call    strcpy
        call    closewindow
        clc

loc_12B03:              ; CODE XREF: choosefile+DCj
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        lahf
        add sp, 0ADh
        sahf
        pop bp
        pop ax
        retn
choosefile  endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

sub_12B12   proc near       ; CODE XREF: choosefile+8Ap

var_50      = byte ptr -50h

        push    bp
        mov bp, sp
        sub sp, 50h
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov word ptr unk_1514A, 0
        mov byte ptr unk_1514C, 0
        push    di
        push    si
        mov si, di
        lea di, [bp+var_50]
        call    strcpy
        pop si
        lea di, [bp+var_50]
        call    strcat
        pop di
        mov bx, 5151h
        mov ah, 4Eh
        xor cx, cx
        lea dx, [bp+var_50]
        int 21h     ; DOS - 2+ - FIND FIRST ASCIZ (FINDFIRST)
                    ; CX = search attributes
                    ; DS:DX -> ASCIZ filespec
                    ; (drive, path, and wildcards allowed)
        jb  short loc_12B74

loc_12B4C:              ; CODE XREF: sub_12B12+58j
        cmp word ptr unk_1514A, 64h
        jnb short loc_12B6E
        push    di
        push    si
        mov di, bx
        mov si, 9Eh
        call    strcpy
        pop si
        pop di
        inc word ptr unk_1514A
        add bx, 0Eh
        mov ah, 4Fh
        int 21h     ; DOS - 2+ - FIND NEXT ASCIZ (FINDNEXT)
                    ; [DTA] = data block from
                    ; last AH = 4Eh/4Fh call
        jnb short loc_12B4C
        jmp short loc_12B74
; ---------------------------------------------------------------------------

loc_12B6E:              ; CODE XREF: sub_12B12+3Fj
                    ; sub_12B12+96j
        inc byte ptr unk_1514C
        jmp short loc_12BCE
; ---------------------------------------------------------------------------

loc_12B74:              ; CODE XREF: sub_12B12+38j
                    ; sub_12B12+5Aj
        push    di
        push    si
        mov si, di
        lea di, [bp+var_50]
        call    strcpy
        mov si, 44EEh
        lea di, [bp+var_50]
        call    strcat
        pop si
        pop di
        mov ah, 4Eh
        mov cx, 10h
        lea dx, [bp+var_50]
        int 21h     ; DOS - 2+ - FIND FIRST ASCIZ (FINDFIRST)
                    ; CX = search attributes
                    ; DS:DX -> ASCIZ filespec
                    ; (drive, path, and wildcards allowed)
        jb  short loc_12BCE

loc_12B95:              ; CODE XREF: sub_12B12+BAj
        test    byte ptr ds:95h, 10h
        jz  short loc_12BC8
        cmp word ptr ds:9Eh, 2Eh
        jz  short loc_12BC8
        cmp word ptr unk_1514A, 64h
        jnb short loc_12B6E
        push    si
        push    di
        mov di, bx
        mov si, 9Eh
        call    strcpy
        mov dx, di
        call    strlen
        add di, ax
        mov word ptr [di], 5Ch
        pop di
        pop si
        inc word ptr unk_1514A
        add bx, 0Eh

loc_12BC8:              ; CODE XREF: sub_12B12+88j
                    ; sub_12B12+8Fj
        mov ah, 4Fh
        int 21h     ; DOS - 2+ - FIND NEXT ASCIZ (FINDNEXT)
                    ; [DTA] = data block from
                    ; last AH = 4Eh/4Fh call
        jnb short loc_12B95

loc_12BCE:              ; CODE XREF: sub_12B12+60j
                    ; sub_12B12+81j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        add sp, 50h
        pop bp
        retn
sub_12B12   endp


; =============== S U B R O U T I N E =======================================


sub_12BDA   proc near       ; CODE XREF: choosefile+B7p
                    ; choosefile+C5p sub_12C49:loc_12C55p
        push    ax
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        push    ax
        mov di, 56C9h
        mov cx, 7
        mov ax, 2020h
        cld
        rep stosw
        xor al, al
        stosb
        pop ax
        mov cx, ax
        mov al, ah
        call    textattr
        mov ax, cx
        xor ah, ah
        sub ax, word ptr unk_1514D
        js  short loc_12C42
        mov dl, 5
        div dl
        xchg    al, ah
        cmp ah, 0Ch
        jnb short loc_12C42
        mov ch, ah
        mov dl, 0Eh
        mul dl
        mov ah, ch
        call    gotoxy
        push    ax
        mov al, cl
        cmp al, byte ptr unk_1514A
        jnb short loc_12C36
        mul dl
        add ax, 5151h
        mov si, ax
        mov di, 56CAh
        cld

loc_12C2E:              ; CODE XREF: sub_12BDA+5Aj
        lodsb
        or  al, al
        jz  short loc_12C36
        stosb
        jmp short loc_12C2E
; ---------------------------------------------------------------------------

loc_12C36:              ; CODE XREF: sub_12BDA+47j
                    ; sub_12BDA+57j
        mov dx, 56C9h
        call    outtext
        pop ax
        inc al
        call    gotoxy

loc_12C42:              ; CODE XREF: sub_12BDA+28j
                    ; sub_12BDA+33j
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop ax
        retn
sub_12BDA   endp


; =============== S U B R O U T I N E =======================================


sub_12C49   proc near       ; CODE XREF: choosefile+ACp
                    ; choosefile+19Bp
        push    ax
        push    cx
        mov cx, 3Ch
        mov al, byte ptr unk_1514D
        mov ah, byte_13932

loc_12C55:              ; CODE XREF: sub_12C49+11j
        call    sub_12BDA
        inc al
        loop    loc_12C55
        pop cx
        pop ax
        retn
sub_12C49   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


setcurs     proc near       ; CODE XREF: outchar+3p
                    ; outtext:loc_12DE3p
                    ; outword:loc_12E24p sub_12E2C+29p
                    ; window+16p gotoxy+1Cp
                    ; openwindow+D7p closewindow+58p
        push    ax
        push    bx
        push    dx
        push    es
        mov dl, curx
        mov dh, cury
        xor ax, ax
        mov es, ax
        assume es:nothing
        mov bh, es:462h
        mov ah, 2
        int 10h     ; - VIDEO - SET CURSOR POSITION
                    ; DH,DL = row, column (0,0 = upper left)
                    ; BH = page number
        pop es
        assume es:nothing
        pop dx
        pop bx
        pop ax
        retn
setcurs     endp


; =============== S U B R O U T I N E =======================================


sub_12C7E   proc near       ; CODE XREF: initscreen+64p
        push    ax
        push    bx
        push    es
        xor ax, ax
        mov es, ax
        assume es:nothing
        mov bl, es:462h
        xor bh, bh
        shl bx, 1
        mov ax, es:[bx+450h]
        mov curx, al
        mov cury, ah
        pop es
        assume es:nothing
        pop bx
        pop ax
        retn
sub_12C7E   endp


; =============== S U B R O U T I N E =======================================


screencols  proc near       ; CODE XREF: sub_10C74:loc_10C94p
                    ; sub_10D4C+Bp replacetext+C7p
                    ; initscreen+4Dp
        push    es
        xor ax, ax
        mov es, ax
        assume es:nothing
        mov ax, es:44Ah
        pop es
        assume es:nothing
        retn
screencols  endp


; =============== S U B R O U T I N E =======================================


screenrows  proc near       ; CODE XREF: sub_10D4C+4p
                    ; sub_10D4C+33p sub_112F2+30p
                    ; sub_11C32+33p replacetext+CEp
                    ; initscreen+5Cp
        push    bx
        push    cx
        mov ah, 12h
        mov bl, 10h
        int 10h     ; - VIDEO - ALTERNATE FUNCTION SELECT (PS, EGA, VGA, MCGA) - GET EGA INFO
                    ; Return: BH = 00h color mode in effect CH = feature bits, CL = switch settings
        cmp bl, 10h
        pop cx
        pop bx
        jz  short loc_12CC5
        xor ax, ax
        push    es
        mov es, ax
        assume es:nothing
        mov al, es:484h
        pop es
        assume es:nothing
        inc al
        retn
; ---------------------------------------------------------------------------

loc_12CC5:              ; CODE XREF: screenrows+Dj
        mov ax, 19h
        retn
screenrows  endp


; =============== S U B R O U T I N E =======================================


initscreen  proc near       ; CODE XREF: start+Bp
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        xor ax, ax
        mov es, ax
        assume es:nothing
        mov ax, 0B000h
        cmp byte ptr es:449h, 7
        jz  short loc_12CE0
        mov ax, 0B800h

loc_12CE0:              ; CODE XREF: initscreen+12j
        mov word ptr sadr+2, ax
        mov ax, es:44Eh
        mov bx, ax
        mov cl, 4
        shr ax, cl
        add word ptr sadr+2, ax
        shl ax, cl
        sub bx, ax
        mov word ptr sadr, bx
        xor ax, ax
        mov es, ax
        mov bh, es:462h
        mov ah, 8
        int 10h     ; - VIDEO - READ ATTRIBUTES/CHARACTER AT CURSOR POSITION
                    ; BH = display page
                    ; Return: AL = character
                    ; AH = attribute of character (alpha modes)
        mov byte ptr stdattr, ah
        mov txtattr, ah
        xor al, al
        mov vx1, al
        mov vy1, al
        call    screencols
        dec al
        mov vx2, al
        inc al
        shl ax, 1
        mov antkol2, ax
        call    screenrows
        dec al
        mov vy2, al
        call    sub_12C7E
        pop es
        assume es:nothing
        pop dx
        pop cx
        pop bx
        pop ax
        retn
initscreen  endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_5. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B R O U T I N E =======================================


addr_of_pos proc near       ; CODE XREF: showline+26p vistegn+48p
                    ; drawborders:loc_13359p
                    ; drawborders+3Fp drawborders+59p
        push    ax
        push    bx
        push    cx
        push    dx
        mov cx, ax
        mov al, ah
        xor ah, ah
        mov bx, antkol2
        mul bx
        mov bl, cl
        shl bl, 1
        xor bh, bh
        add ax, bx
        les di, sadr
        add di, ax
        pop dx
        pop cx
        pop bx
        pop ax
        retn
addr_of_pos endp


; =============== S U B R O U T I N E =======================================


vistegn     proc near       ; CODE XREF: outcharp outtext+Ap
                    ; outword+Ap outword+22p
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    di
        cmp al, 0Ah
        jnz short loc_12D90

loc_12D64:              ; CODE XREF: vistegn+65j
        mov al, cury
        inc al
        cmp al, vy2
        jbe short loc_12D8B
        mov ax, 601h
        mov bh, txtattr
        mov cl, vx1
        mov ch, vy1
        mov dl, vx2
        mov dh, vy2
        int 10h     ; - VIDEO - SCROLL PAGE UP
                    ; AL = number of lines to scroll window (0 = blank whole window)
                    ; BH = attributes to be used on blanked lines
                    ; CH,CL = row,column of upper left corner of window to scroll
                    ; DH,DL = row,column of lower right corner of window
        mov al, vy2

loc_12D8B:              ; CODE XREF: vistegn+13j
        mov cury, al
        jmp short loc_12DC4
; ---------------------------------------------------------------------------

loc_12D90:              ; CODE XREF: vistegn+8j
        cmp al, 0Dh
        jnz short loc_12D99
        mov al, vx1
        jmp short loc_12DC1
; ---------------------------------------------------------------------------

loc_12D99:              ; CODE XREF: vistegn+38j
        mov cx, ax
        mov al, curx
        mov ah, cury
        call    addr_of_pos
        mov ax, cx
        mov ah, txtattr
        mov es:[di], ax
        mov al, curx
        inc al
        cmp al, vx2
        jbe short loc_12DC1
        mov al, vx1
        mov curx, al
        jmp short loc_12D64
; ---------------------------------------------------------------------------

loc_12DC1:              ; CODE XREF: vistegn+3Dj vistegn+5Dj
        mov curx, al

loc_12DC4:              ; CODE XREF: vistegn+34j
        pop di
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        retn
vistegn     endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


outchar     proc near       ; CODE XREF: sub_10DA6+36p
                    ; sub_10DA6+3Fp sub_10DA6+44p
                    ; sub_10DA6+47p message+1Fp
                    ; sub_10EF4+1Dp sub_10F21+1Dp
                    ; sub_10FCC:loc_10FE4p sub_10FF2+Ep
                    ; sub_10FF2+12p sub_11008+Ep
                    ; sub_11008+11p sub_11008+14p
                    ; sub_1102A+2Ap sub_1102A+2Fp
                    ; sub_11524+10p sub_11524+1Fp
                    ; sub_11524+2Cp replacetext+BEp
                    ; sub_127BA+15p outline+28p
                    ; outline:loc_13036p
        call    vistegn
        call    setcurs
        retn
outchar     endp


; =============== S U B R O U T I N E =======================================


outtext     proc near       ; CODE XREF: sub_10D4C+2Dp
                    ; sub_10D4C+42p sub_10DA6+3Ap
                    ; sub_10DA6+4Dp message+23p
                    ; sub_10F4E:loc_10F69p
                    ; sub_10F78:loc_10F93p
                    ; sub_10FA2:loc_10FBDp sub_1102A+42p
                    ; seg000:109Bp seg000:1122p
                    ; replacetext+C4p sub_127BA+2Fp
                    ; sub_12BDA+5Fp sub_13526+7Cp
        push    ax
        push    bx
        mov bx, dx

loc_12DD7:              ; CODE XREF: outtext+Ej
        mov al, [bx]
        or  al, al
        jz  short loc_12DE3
        call    vistegn
        inc bx
        jmp short loc_12DD7
; ---------------------------------------------------------------------------

loc_12DE3:              ; CODE XREF: outtext+8j
        call    setcurs
        pop bx
        pop ax
        retn
outtext     endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


outword     proc near       ; CODE XREF: sub_10EF4+11p
                    ; sub_10F21+11p
        push    ax
        push    bx
        push    cx
        push    dx
        or  ax, ax
        jnz short loc_12DF9
        mov al, '0'
        call    vistegn
        jmp short loc_12E24
; ---------------------------------------------------------------------------

loc_12DF9:              ; CODE XREF: outword+6j
        mov cx, 2710h
        xor bl, bl

loc_12DFE:              ; CODE XREF: outword+38j
        xor dx, dx
        div cx
        or  ax, ax
        jnz short loc_12E0A
        or  bl, bl
        jz  short loc_12E11

loc_12E0A:              ; CODE XREF: outword+1Aj
        add al, '0'
        call    vistegn
        mov bl, 1

loc_12E11:              ; CODE XREF: outword+1Ej
        mov ax, dx
        push    ax
        mov ax, cx
        mov cx, 0Ah
        xor dx, dx
        div cx
        mov cx, ax
        pop ax
        jcxz    short loc_12E24
        jmp short loc_12DFE
; ---------------------------------------------------------------------------

loc_12E24:              ; CODE XREF: outword+Dj outword+36j
        call    setcurs
        pop dx
        pop cx
        pop bx
        pop ax
        retn
outword     endp


; =============== S U B R O U T I N E =======================================


sub_12E2C   proc near       ; CODE XREF: seg000:loc_110EDp
        push    ax
        push    bx
        push    cx
        push    dx
        mov ax, 600h
        mov bh, txtattr
        mov cl, vx1
        mov ch, vy1
        mov dl, vx2
        mov dh, vy2
        int 10h     ; - VIDEO - SCROLL PAGE UP
                    ; AL = number of lines to scroll window (0 = blank whole window)
                    ; BH = attributes to be used on blanked lines
                    ; CH,CL = row,column of upper left corner of window to scroll
                    ; DH,DL = row,column of lower right corner of window
        mov al, vx1
        mov curx, al
        mov al, vy1
        mov cury, al
        call    setcurs
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_12E2C   endp


; =============== S U B R O U T I N E =======================================


window      proc near       ; CODE XREF: replacetext+D7p
                    ; openwindow+D4p closewindow+45p
                    ; sub_13526+2Ap sub_13526+8Bp
        mov vx1, al
        mov curx, al
        mov vy1, ah
        mov cury, ah
        mov vx2, dl
        mov vy2, dh
        call    setcurs
        retn
window      endp


; =============== S U B R O U T I N E =======================================


gotoxy      proc near       ; CODE XREF: sub_10D4C+3Cp
                    ; sub_10D4C+51p sub_10ED8+16p
                    ; sub_10EF4+Ap sub_10F21+Ap
                    ; sub_10F4E+Bp sub_10F78+Bp
                    ; sub_10FA2+Bp sub_10FCC+Ap
                    ; sub_10FF2+9p sub_11008+9p
                    ; sub_1102A+Ep userinput+29p
                    ; replacetext+DDp sub_127BA+10p
                    ; sub_12BDA+3Dp sub_12BDA+65p
                    ; outline+Dp outline+3Cp
                    ; lineinput+83p lineinput+1C4p
                    ; sub_13526:loc_1359Fp sub_13526+8Fp
        push    ax
        add al, vx1
        cmp al, vx2
        ja  short loc_12E96
        add ah, vy1
        cmp ah, vy2
        ja  short loc_12E96
        mov curx, al
        mov cury, ah
        call    setcurs

loc_12E96:              ; CODE XREF: gotoxy+9j gotoxy+13j
        pop ax
        retn
gotoxy      endp


; =============== S U B R O U T I N E =======================================


wherex      proc near       ; CODE XREF: replacetext+86p
                    ; outline+1p lineinput+49p
                    ; sub_13526+10p
        mov al, curx
        sub al, vx1
        retn
wherex      endp


; =============== S U B R O U T I N E =======================================


wherey      proc near       ; CODE XREF: replacetext+89p
                    ; outline+4p lineinput+4Cp
                    ; sub_13526+13p
        mov ah, cury
        sub ah, vy1
        retn
wherey      endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


textattr    proc near       ; CODE XREF: sub_10D4C+27p
                    ; sub_10D4C+4Bp sub_10EF4+4p
                    ; sub_10EF4+25p sub_10F21+4p
                    ; sub_10F21+25p sub_10F4E+5p
                    ; sub_10F4E+21p sub_10F78+5p
                    ; sub_10F78+21p sub_10FA2+5p
                    ; sub_10FA2+21p sub_10FCC+4p
                    ; sub_10FCC+1Ep sub_10FF2+4p
                    ; sub_11008+4p sub_11008+1Ap
                    ; sub_1102A+8p sub_1102A+4Bp
                    ; sub_127BA+7p sub_12BDA+1Dp
                    ; lineinput+21p lineinput+D7p
                    ; lineinput+1CAp
        mov txtattr, al
        retn
textattr    endp


; =============== S U B R O U T I N E =======================================


sub_12EAE   proc near
        push    ax
        and al, 0Fh
        and txtattr, 0F0h
        or  txtattr, al
        pop ax
        retn
sub_12EAE   endp


; =============== S U B R O U T I N E =======================================


sub_12EBC   proc near
        push    ax
        push    cx
        mov cl, 4
        shl al, cl
        and txtattr, 0Fh
        or  txtattr, al
        pop cx
        pop ax
        retn
sub_12EBC   endp


; =============== S U B R O U T I N E =======================================


sub_12ECE   proc near       ; CODE XREF: openwindow+85p
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    ds
        push    si
        push    di
        mov cx, ax
        mov al, ah
        xor ah, ah
        mov bx, antkol2
        push    dx
        mul bx
        pop dx
        mov bl, cl
        xor bh, bh
        shl bx, 1
        add ax, bx
        mov bx, antkol2
        lds si, sadr
        add si, ax
        mov ax, bx
        sub dl, cl
        mov cl, dh
        xor dh, dh
        inc dx
        sub cl, ch
        xor ch, ch
        inc cx

loc_12F04:              ; CODE XREF: sub_12ECE+41j
        push    cx
        mov cx, dx
        push    si
        cld
        rep movsw
        pop si
        add si, ax
        pop cx
        loop    loc_12F04
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_12ECE   endp


; =============== S U B R O U T I N E =======================================


sub_12F1A   proc near       ; CODE XREF: closewindow+2Fp
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    ds
        push    si
        push    di
        mov cx, ax
        mov al, ah
        xor ah, ah
        mov bx, antkol2
        push    dx
        mul bx
        pop dx
        mov bl, cl
        xor bh, bh
        shl bx, 1
        add ax, bx
        mov bx, antkol2
        push    es
        push    di
        les di, sadr
        add di, ax
        mov ax, bx
        pop si
        pop ds
        sub dl, cl
        mov cl, dh
        xor dh, dh
        inc dx
        sub cl, ch
        xor ch, ch
        inc cx

loc_12F54:              ; CODE XREF: sub_12F1A+45j
        push    cx
        mov cx, dx
        push    di
        cld
        rep movsw
        pop di
        add di, ax
        pop cx
        loop    loc_12F54
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_12F1A   endp

; ---------------------------------------------------------------------------
        db 50h, 53h, 51h, 52h, 0B8h, 1, 7, 8Ah, 3Eh, 0E4h, 56h
        db 8Ah, 0Eh, 0D8h, 56h, 8Ah, 2Eh, 0DFh, 56h, 8Ah, 16h
        db 0DAh, 56h, 8Ah, 36h, 0DBh, 56h, 0CDh, 10h, 5Ah, 59h
        db 5Bh, 58h, 0C3h, 50h, 53h, 51h, 52h, 0B8h, 1, 6, 8Ah
        db 3Eh, 0E4h, 56h, 8Ah, 0Eh, 0D8h, 56h, 8Ah, 2Eh, 0DFh
        db 56h, 8Ah, 16h, 0DAh, 56h, 8Ah, 36h, 0DBh, 56h, 0CDh
        db 10h, 5Ah, 59h, 5Bh, 58h, 0C3h

; =============== S U B R O U T I N E =======================================


clreol      proc near       ; CODE XREF: sub_10D4C+30p
                    ; sub_10D4C+45p sub_1102A:loc_1106Fp
                    ; sub_127BA+32p
        push    ax
        push    bx
        push    cx
        push    dx
        mov ax, 600h
        mov bh, txtattr
        mov cl, curx
        mov ch, cury
        mov dl, vx2
        mov dh, cury
        int 10h     ; - VIDEO - SCROLL PAGE UP
                    ; AL = number of lines to scroll window (0 = blank whole window)
                    ; BH = attributes to be used on blanked lines
                    ; CH,CL = row,column of upper left corner of window to scroll
                    ; DH,DL = row,column of lower right corner of window
        pop dx
        pop cx
        pop bx
        pop ax
        retn
clreol      endp


; =============== S U B R O U T I N E =======================================


getkey      proc near       ; CODE XREF: sub_10DA6:loc_10DF6p
                    ; seg000:109Ep seg000:loc_11125p
                    ; sub_112F2+90p sub_11524+3p
                    ; userscr+4p sub_127F4+85p
                    ; choosefile+BAp getkey+6j CHOICEp
                    ; lineinput+86p
        int 28h     ; DOS 2+ internal - KEYBOARD BUSY LOOP
        mov ah, 1
        int 16h     ; KEYBOARD - CHECK BUFFER, DO NOT CLEAR
                    ; Return: ZF clear if character in buffer
                    ; AH = scan code, AL = character
                    ; ZF set if no character in buffer
        jz  short getkey
        xor ah, ah
        int 16h     ; KEYBOARD - READ CHAR FROM BUFFER, WAIT IF EMPTY
                    ; Return: AH = scan code, AL = character
        or  al, al
        jnz short loc_12FE7
        mov al, ah
        xor ah, ah
        neg ax
        retn
; ---------------------------------------------------------------------------

loc_12FE7:              ; CODE XREF: getkey+Ej
        xor ah, ah
        retn
getkey      endp


; =============== S U B R O U T I N E =======================================


CHOICE      proc near       ; CODE XREF: askoverwrite+13p
                    ; sub_110A9+10p replacetext+E0p
                    ; CHOICE+13j
        call    getkey
        cmp ax, 27
        jz  short locret_12FFF
        and ax, 0DFh
        cmp ax, 'Y'
        jz  short locret_12FFF
        cmp ax, 'N'
        jnz short CHOICE

locret_12FFF:               ; CODE XREF: CHOICE+6j CHOICE+Ej
        retn
CHOICE      endp

; ---------------------------------------------------------------------------
        retn
; ---------------------------------------------------------------------------
        retn

; =============== S U B R O U T I N E =======================================


outline     proc near       ; CODE XREF: lineinput:loc_130B8p
        push    ax
        call    wherex
        call    wherey
        mov saved_curspos2, ax
        mov ax, saved_curspos
        call    gotoxy
        mov cx, input_box_length
        mov bx, string_offset
        cmp bx, curs_end_pos
        jnb short loc_13032
        add bx, offset buff

loc_13024:              ; CODE XREF: outline+2Cj
        mov al, [bx]
        or  al, al
        jz  short loc_13032
        call    outchar
        inc bx
        loop    loc_13024
        jmp short loc_1303B
; ---------------------------------------------------------------------------

loc_13032:              ; CODE XREF: outline+1Cj outline+26j
        jcxz    short loc_1303B
        mov al, ' '

loc_13036:              ; CODE XREF: outline+37j
        call    outchar
        loop    loc_13036

loc_1303B:              ; CODE XREF: outline+2Ej
                    ; outline:loc_13032j
        mov ax, saved_curspos2
        call    gotoxy
        pop ax
        retn
outline     endp


; =============== S U B R O U T I N E =======================================


lineinput   proc near       ; CODE XREF: userinput:loc_111A4p
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        mov input_text, si
        mov quit_keys, di
        mov intput_max_len, ax
        mov input_box_length, bx
        mov mtattr, ch
        mov al, txtattr
        mov saved_txtattr, al
        mov al, cl      ; CL = uattr
        call    textattr
        mov di, offset buff
        push    ds
        pop es
        assume es:seg000
        call    strcpy      ; SI = input text
        mov si, intput_max_len
        mov buff[si], 0
        xor ax, ax
        mov string_offset, ax
        mov flag, al
        mov dx, offset buff
        call    strlen
        mov curs_end_pos, ax
        mov curs_curr_pos, ax
        call    wherex
        call    wherey
        mov saved_curspos, ax

beg_loop:               ; CODE XREF: lineinput:press_spacej
                    ; lineinput+11Bj lineinput+12Bj
                    ; lineinput+134j lineinput+13Dj
                    ; lineinput+15Cj lineinput+1AFj
        mov ax, curs_curr_pos
        cmp string_offset, ax
        jbe short loc_130A3
        mov string_offset, ax
        jmp short loc_130B8
; ---------------------------------------------------------------------------

loc_130A3:              ; CODE XREF: lineinput+59j
        sub ax, string_offset
        cmp ax, input_box_length
        jb  short loc_130B8
        mov ax, curs_curr_pos
        sub ax, input_box_length
        inc ax
        mov string_offset, ax

loc_130B8:              ; CODE XREF: lineinput+5Ej
                    ; lineinput+68j
        call    outline
        mov ax, saved_curspos
        add al, byte ptr curs_curr_pos
        sub al, byte ptr string_offset
        call    gotoxy
        call    getkey
        mov input_key, ax
        cmp ax, 1Bh
        jz  short esc
        cmp ax, 0Dh
        jnz short check_quit_keys

esc:                    ; CODE XREF: lineinput+8Fj
        jmp exit0
; ---------------------------------------------------------------------------

check_quit_keys:            ; CODE XREF: lineinput+94j
        mov di, quit_keys
        or  di, di
        jz  short check_other_keys

loc_130E4:              ; CODE XREF: lineinput+ABj
        mov bx, [di]
        inc di
        inc di
        or  bx, bx
        jz  short check_other_keys
        cmp ax, bx
        jnz short loc_130E4
        jmp exit0
; ---------------------------------------------------------------------------

check_other_keys:           ; CODE XREF: lineinput+9Fj
                    ; lineinput+A7j
        cmp flag, 0
        jnz short loc_13111
        cmp ax, 20h
        jl  short loc_13111
        xor bx, bx      ; clear input
        mov buff, bl
        mov string_offset, bx
        mov curs_end_pos, bx
        mov curs_curr_pos, bx

loc_13111:              ; CODE XREF: lineinput+B5j
                    ; lineinput+BAj
        mov flag, 1
        push    ax
        mov al, mtattr
        call    textattr
        pop ax
        cmp ax, 4
        jz  short move_right
        cmp ax, 7
        jz  short press_del
        cmp ax, 8
        jz  short press_backup
        cmp ax, 19
        jz  short move_left
        cmp ax, -71
        jz  short move_home
        cmp ax, -75
        jz  short move_left
        cmp ax, -77
        jz  short move_right
        cmp ax, -79
        jz  short move_end
        cmp ax, -83
        jz  short press_del
        cmp ax, 20h
        jge short add_char_to_buff

press_space:                ; CODE XREF: lineinput+115j
                    ; lineinput+125j lineinput+147j
                    ; lineinput+164j lineinput+173j
        jmp beg_loop
; ---------------------------------------------------------------------------

move_left:              ; CODE XREF: lineinput+EDj
                    ; lineinput+F7j
        cmp curs_curr_pos, 0
        jz  short press_space
        dec curs_curr_pos
        jmp beg_loop
; ---------------------------------------------------------------------------

move_right:             ; CODE XREF: lineinput+DEj
                    ; lineinput+FCj
        mov ax, curs_curr_pos
        cmp ax, curs_end_pos
        jnb short press_space
        inc curs_curr_pos
        jmp beg_loop
; ---------------------------------------------------------------------------

move_home:              ; CODE XREF: lineinput+F2j
        mov curs_curr_pos, 0
        jmp beg_loop
; ---------------------------------------------------------------------------

move_end:               ; CODE XREF: lineinput+101j
        mov ax, curs_end_pos
        mov curs_curr_pos, ax
        jmp beg_loop
; ---------------------------------------------------------------------------

press_del:              ; CODE XREF: lineinput+E3j
                    ; lineinput+106j lineinput+16Aj
        mov ax, curs_end_pos
        sub ax, curs_curr_pos
        jle short press_space
        mov cx, ax
        mov di, offset buff
        add di, curs_curr_pos
        mov si, di
        inc si
        cld
        rep movsb
        dec curs_end_pos
        jmp beg_loop
; ---------------------------------------------------------------------------

press_backup:               ; CODE XREF: lineinput+E8j
        cmp curs_curr_pos, 0
        jz  short press_space
        dec curs_curr_pos
        jmp short press_del
; ---------------------------------------------------------------------------

add_char_to_buff:           ; CODE XREF: lineinput+10Bj
        mov ax, curs_curr_pos
        cmp ax, intput_max_len
        jnb short press_space
        mov cx, curs_end_pos
        cmp cx, intput_max_len
        jb  short loc_131C7
        mov cx, intput_max_len
        dec cx

loc_131C7:              ; CODE XREF: lineinput+17Dj
        mov si, cx
        sub cx, ax
        inc cx
        add si, offset buff
        mov di, si
        inc di
        std
        rep movsb
        mov ax, input_key
        mov [di], al
        mov di, intput_max_len
        mov buff[di], 0
        cmp curs_end_pos, di
        jnb short loc_131EE
        inc curs_end_pos

loc_131EE:              ; CODE XREF: lineinput+1A5j
        inc curs_curr_pos
        jmp beg_loop
; ---------------------------------------------------------------------------

exit0:                  ; CODE XREF: lineinput:escj
                    ; lineinput+ADj
        cmp ax, 1Bh
        jz  short exit1
        mov si, offset buff
        mov di, input_text
        call    strcpy

exit1:                  ; CODE XREF: lineinput+1B5j
        mov ax, saved_curspos
        call    gotoxy
        mov al, saved_txtattr
        call    textattr
        mov ax, input_key
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        retn
lineinput   endp


; =============== S U B R O U T I N E =======================================


strlen      proc near       ; CODE XREF: start+33p sub_104C2+2p
                    ; sub_104E9+14p sub_1053D+5p
                    ; sub_10573+7p sub_10573+45p
                    ; sub_105CC+2Ep sub_105CC+58p
                    ; sub_105CC+70p sub_10688+1Bp
                    ; sub_108DD+Ep sub_108F6+Ep
                    ; sub_10973+11p sub_10973+19p
                    ; sub_10A7D+37p sub_10DA6+14p
                    ; message+5p sub_1102A+18p
                    ; sub_112A6+12p sub_112C3+Fp
                    ; seg000:12E8p sub_1205E+3Dp
                    ; sub_120E5+3Cp sub_12162+83p
                    ; sub_122C9+2Dp findtext+53p
                    ; sub_123A5+2Fp replacetext+59p
                    ; replacetext+9Ap replacetext+10Cp
                    ; sub_127F4+24p sub_128EB+7p
                    ; choosefile+1Ap choosefile+66p
                    ; choosefile+1C0p sub_12B12+A4p
                    ; lineinput+40p strcpy+8p strip+6p
                    ; strstr+7p strstr+19p sub_13526+46p
                    ; mkfullpath+9Ap mkfullpath+DDp
                    ; mkfullpath+126p removeslash+2p
                    ; addslash+2p
        push    cx
        push    di
        push    es
        mov cx, ds
        mov es, cx
        assume es:seg000
        mov di, dx
        xor al, al
        mov cx, 0FFFFh
        cld
        repne scasb
        mov ax, di
        dec ax
        sub ax, dx
        pop es
        assume es:nothing
        pop di
        pop cx
        retn
strlen      endp


; =============== S U B R O U T I N E =======================================


strcpy      proc near       ; CODE XREF: start+4Bp sub_104E9+Fp
                    ; sub_10573:loc_105B3p
                    ; sub_105CC:loc_10630p sub_105CC+6Bp
                    ; sub_105CC+92p sub_106C3+10p
                    ; sub_106C3+25p sub_106F8+41p
                    ; sub_10753+46p sub_1257A+1Ap
                    ; sub_12606+1Ap sub_126A9+45p
                    ; choosefile+15p choosefile+2Bp
                    ; choosefile+1D8p sub_12B12+21p
                    ; sub_12B12+48p sub_12B12+69p
                    ; sub_12B12+9Fp lineinput+29p
                    ; lineinput+1BEp mkfullpath+2Bp
                    ; mkfullpath+AFp mkfullpath+12Dp
        push    ax
        push    cx
        push    dx
        push    si
        push    di
        push    es
        mov dx, si
        call    strlen
        mov cx, ax
        inc cx
        cld
        repne movsb
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop ax
        retn
strcpy      endp


; =============== S U B R O U T I N E =======================================


strip       proc near       ; CODE XREF: start+30p sub_10973+14p
                    ; mkfullpath+2Fp
        push    ax
        push    cx
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        call    strlen
        mov cx, ax
        jcxz    short loc_1326A
        mov di, dx
        add di, cx
        dec di
        mov al, ' '
        std
        repe scasb
        jz  short loc_13266
        inc di

loc_13266:              ; CODE XREF: strip+17j
        inc di
        mov byte ptr [di], 0

loc_1326A:              ; CODE XREF: strip+Bj
        pop es
        assume es:nothing
        pop di
        pop cx
        pop ax
        retn
strip       endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


strupr      proc near       ; CODE XREF: start+4Ep sub_106F8+46p
                    ; sub_10753+4Bp sub_12279+18p
                    ; mkfullpath+32p
        push    ax
        push    si
        push    di
        push    es
        push    ds
        pop es
        assume es:seg000
        mov si, dx
        mov di, dx
        cld

loc_1327B:              ; CODE XREF: strupr+1Bj
        lodsb
        or  al, al
        jz  short loc_1328D
        cmp al, 'a'
        jb  short loc_1328A
        cmp al, 'z'
        ja  short loc_1328A
        sub al, ' '

loc_1328A:              ; CODE XREF: strupr+12j strupr+16j
        stosb
        jmp short loc_1327B
; ---------------------------------------------------------------------------

loc_1328D:              ; CODE XREF: strupr+Ej
        pop es
        assume es:nothing
        pop di
        pop si
        pop ax
        retn
strupr      endp


; =============== S U B R O U T I N E =======================================


strstr      proc near       ; CODE XREF: findtext+3Dp
                    ; replacetext+43p
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        mov dx, si
        call    strlen
        or  ax, ax
        jnz short loc_132A4
        mov ax, di
        jmp short loc_132CC
; ---------------------------------------------------------------------------

loc_132A4:              ; CODE XREF: strstr+Cj
        mov bx, ax
        push    ds
        push    es
        pop ds
        mov dx, di
        call    strlen
        mov cx, ax
        pop ds
        sub cx, bx
        jb  short loc_132CA
        inc cx
        mov ax, di
        mov dx, si
        cld

loc_132BB:              ; CODE XREF: strstr+36j
        push    cx
        mov cx, bx
        repe cmpsb
        pop cx
        jz  short loc_132CC
        mov si, dx
        inc ax
        mov di, ax
        loop    loc_132BB

loc_132CA:              ; CODE XREF: strstr+21j
        xor ax, ax

loc_132CC:              ; CODE XREF: strstr+10j strstr+2Fj
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        retn
strstr      endp


; =============== S U B R O U T I N E =======================================


atoui       proc near       ; CODE XREF: gotoline+1Bp
        push    bx
        push    dx
        push    si
        xor ax, ax
        mov si, dx

loc_132D9:              ; CODE XREF: atoui+24j
        mov bl, [si]
        xor bh, bh
        inc si
        cmp bl, '0'
        jb  short loc_132FB
        cmp bl, '9'
        ja  short loc_132FB
        sub bl, '0'
        mov dx, 0Ah
        mul dx
        jo  short loc_132F8
        add ax, bx
        jo  short loc_132F8
        jmp short loc_132D9
; ---------------------------------------------------------------------------

loc_132F8:              ; CODE XREF: atoui+1Ej atoui+22j
        mov ax, 0FFFFh

loc_132FB:              ; CODE XREF: atoui+Fj atoui+14j
        pop si
        pop dx
        pop bx
        retn
atoui       endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


strcat      proc near       ; CODE XREF: choosefile+5Bp
                    ; choosefile+61p choosefile+1BAp
                    ; sub_12B12+28p sub_12B12+72p
        push    ax
        push    cx
        push    di
        push    si
        xor al, al
        mov cx, 0FFFFh
        cld
        repne scasb
        dec di

loc_1330D:              ; CODE XREF: strcat+11j
        lodsb
        stosb
        or  al, al
        jnz short loc_1330D
        pop si
        pop di
        pop cx
        pop ax
        retn
strcat      endp


; =============== S U B R O U T I N E =======================================


initwindow  proc near       ; CODE XREF: start+Ep
        push    ax
        mov al, txtattr
        mov byte ptr unk_157FE, al
        mov byte ptr unk_157FF, al
        mov al, vx1
        mov ah, vy1
        mov word_15800, ax
        mov al, vx2
        mov ah, vy2
        mov word_15802, ax
        pop ax
        retn
initwindow  endp


; =============== S U B R O U T I N E =======================================


sub_13338   proc near       ; CODE XREF: start:loc_101ABp
                    ; sub_13338+Aj
        cmp word_144F3, 0
        jz  short locret_13344
        call    closewindow
        jmp short sub_13338
; ---------------------------------------------------------------------------

locret_13344:               ; CODE XREF: sub_13338+5j
        retn
sub_13338   endp


; =============== S U B R O U T I N E =======================================


drawborders proc near       ; CODE XREF: openwindow+B5p
                    ; drawborder+27p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        cmp bl, 1
        jnz short loc_13356
        mov bx, offset unk_144F5
        jmp short loc_13359
; ---------------------------------------------------------------------------

loc_13356:              ; CODE XREF: drawborders+Aj
        mov bx, offset unk_144FB

loc_13359:              ; CODE XREF: drawborders+Fj
        call    addr_of_pos
        push    ax
        push    dx
        xor ch, ch
        mov cl, dl
        sub cl, al
        mov si, cx
        shl si, 1
        dec cl
        push    cx
        cld
        mov ah, txtattr
        mov al, [bx]
        stosw
        jcxz    short loc_1337A
        mov al, [bx+1]
        rep stosw

loc_1337A:              ; CODE XREF: drawborders+2Ej
        mov al, [bx+2]
        stosw
        pop cx
        pop dx
        pop ax
        push    ax
        mov ah, dh
        call    addr_of_pos
        push    dx
        cld
        mov ah, txtattr
        mov al, [bx+5]
        stosw
        jcxz    short loc_13398
        mov al, [bx+1]
        rep stosw

loc_13398:              ; CODE XREF: drawborders+4Cj
        mov al, [bx+4]
        stosw
        pop dx
        pop ax
        call    addr_of_pos
        add di, antkol2
        xor ch, ch
        mov cl, dh
        sub cl, ah
        dec cl
        jcxz    short loc_133C7
        cld
        mov ah, txtattr
        mov al, [bx+3]

loc_133B7:              ; CODE XREF: drawborders+80j
        stosw
        add di, si
        dec di
        dec di
        stosw
        sub di, si
        dec di
        dec di
        add di, antkol2
        loop    loc_133B7

loc_133C7:              ; CODE XREF: drawborders+68j
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
drawborders endp


; =============== S U B R O U T I N E =======================================


openwindow  proc near       ; CODE XREF: sub_10D4C+1Ap
                    ; sub_10DA6+29p message+1Ap
                    ; seg000:1095p seg000:10EAp
                    ; userinput+1Cp replacetext+B9p
                    ; sub_127F4+53p choosefile+48p
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        mov border_type, bl
        mov byte ptr unk_157FE, cl
        mov byte ptr unk_157FF, ch
        mov word_15800, ax
        mov word_15802, dx
        sub dl, al
        inc dl
        sub dh, ah
        inc dh
        mov al, dh
        mul dl
        shl ax, 1
        add ax, 0Ch
        call    sub_13793
        or  ax, ax
        jnz short loc_13405
        mov ax, 1
        jmp loc_134AB
; ---------------------------------------------------------------------------

loc_13405:              ; CODE XREF: openwindow+2Ej
        mov bl, border_type
        mov es:0Ah, bl
        mov es:2, ax
        mov ax, word_144F3
        mov es:0, ax
        mov al, vx1
        mov es:4, al
        mov al, vy1
        mov es:5, al
        mov al, vx2
        mov es:6, al
        mov al, vy2
        mov es:7, al
        mov al, curx
        mov es:8, al
        mov al, cury
        mov es:9, al
        mov al, txtattr
        mov es:0Bh, al
        mov di, 0Ch
        mov ax, word_15800
        mov dx, word_15802
        call    sub_12ECE
        mov word_144F3, es
        mov bh, byte ptr unk_157FE
        mov cx, word_15800
        mov dx, word_15802
        mov ax, 600h
        int 10h     ; - VIDEO - SCROLL PAGE UP
                    ; AL = number of lines to scroll window (0 = blank whole window)
                    ; BH = attributes to be used on blanked lines
                    ; CH,CL = row,column of upper left corner of window to scroll
                    ; DH,DL = row,column of lower right corner of window
        cmp border_type, 0
        jz  short loc_13496
        mov al, byte ptr unk_157FF
        mov txtattr, al
        mov ax, word_15800
        mov dx, word_15802
        mov bl, border_type
        call    drawborders
        inc al
        inc ah
        mov word_15800, ax
        dec dl
        dec dh
        mov word_15802, dx

loc_13496:              ; CODE XREF: openwindow+A2j
        mov al, byte ptr unk_157FE
        mov txtattr, al
        mov ax, word_15800
        mov dx, word_15802
        call    window
        call    setcurs
        xor ax, ax

loc_134AB:              ; CODE XREF: openwindow+33j
        pop es
        pop di
        pop dx
        pop cx
        pop bx
        retn
openwindow  endp


; =============== S U B R O U T I N E =======================================


closewindow proc near       ; CODE XREF: sub_10214+11p
                    ; sub_102CD+16p sub_102EA+13p
                    ; sub_103B9+19p askoverwrite+16p
                    ; sub_10D28+Dp sub_10DA6+58p
                    ; seg000:10A1p sub_110A9+18p
                    ; sub_110A9:loc_110C9p
                    ; seg000:loc_1115Dp userinput+42p
                    ; userscr+1p replacetext+E6p
                    ; sub_127F4:loc_12897p
                    ; sub_127F4:loc_128D9p
                    ; choosefile:loc_129FCp
                    ; choosefile+1DBp sub_13338+7p
        push    ax
        push    dx
        push    di
        push    es
        mov ax, word_144F3
        or  ax, ax
        jz  short loc_13521
        mov es, ax
        mov al, vx1
        mov ah, vy1
        mov dl, vx2
        mov dh, vy2
        cmp byte ptr es:0Ah, 0
        jz  short loc_134DD
        dec al
        dec ah
        inc dl
        inc dh

loc_134DD:              ; CODE XREF: closewindow+22j
        mov di, 0Ch
        call    sub_12F1A
        mov al, es:4
        mov ah, es:5
        mov dl, es:6
        mov dh, es:7
        call    window
        mov al, es:8
        mov curx, al
        mov ah, es:9
        mov cury, ah
        call    setcurs
        mov al, es:0Bh
        mov txtattr, al
        mov ax, es:0
        mov word_144F3, ax
        mov ax, es:2
        call    sub_1381B

loc_13521:              ; CODE XREF: closewindow+9j
        pop es
        pop di
        pop dx
        pop ax
        retn
closewindow endp


; =============== S U B R O U T I N E =======================================


sub_13526   proc near       ; CODE XREF: sub_10DA6+31p
                    ; seg000:10F8p seg000:1119p
                    ; userinput+23p sub_127F4+5Bp
                    ; choosefile+81p choosefile+9Dp
        push    ax
        push    bx
        push    cx
        push    dx
        cmp border_type, 0
        jnz short loc_13534
        jmp loc_135B8
; ---------------------------------------------------------------------------

loc_13534:              ; CODE XREF: sub_13526+9j
        mov bx, ax
        call    wherex
        call    wherey
        push    ax
        mov ax, bx
        push    ax
        push    dx
        mov ax, word_15800
        dec al
        dec ah
        mov dx, word_15802
        inc dl
        inc dh
        call    window
        pop dx
        pop ax
        mov bl, txtattr
        push    bx
        mov txtattr, ch
        mov bl, al
        mov al, 1
        cmp bl, 1
        jz  short loc_13590
        cmp bl, 4
        jz  short loc_13590
        call    strlen
        mov bh, vx2
        sub bh, vx1
        or  bl, bl
        jz  short loc_13586
        cmp bl, 3
        jz  short loc_13586
        sub bh, al
        mov al, bh
        jmp short loc_13590
; ---------------------------------------------------------------------------

loc_13586:              ; CODE XREF: sub_13526+53j
                    ; sub_13526+58j
        inc bh
        shr bh, 1
        shr al, 1
        sub bh, al
        mov al, bh

loc_13590:              ; CODE XREF: sub_13526+3Fj
                    ; sub_13526+44j sub_13526+5Ej
        xor ah, ah
        cmp bl, 2
        jbe short loc_1359F
        mov ah, vy2
        sub ah, vy1

loc_1359F:              ; CODE XREF: sub_13526+6Fj
        call    gotoxy
        call    outtext
        pop bx
        mov txtattr, bl
        mov ax, word_15800
        mov dx, word_15802
        call    window
        pop ax
        call    gotoxy

loc_135B8:              ; CODE XREF: sub_13526+Bj
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_13526   endp


; =============== S U B R O U T I N E =======================================


drawborder  proc near       ; CODE XREF: seg000:10F0p
                    ; choosefile+4Dp
        push    ax
        push    bx
        push    dx
        cmp border_type, 0
        jz  short loc_135EB
        mov al, txtattr
        push    ax
        mov al, byte ptr unk_157FF
        mov txtattr, al
        mov bl, border_type
        mov ax, word_15800
        dec al
        dec ah
        mov dx, word_15802
        inc dl
        inc dh
        call    drawborders
        pop ax
        mov txtattr, al

loc_135EB:              ; CODE XREF: drawborder+8j
        pop dx
        pop bx
        pop ax
        retn
drawborder  endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

mkfullpath  proc near       ; CODE XREF: sub_10688+6p
                    ; choosefile+1D0p

var_A2      = word ptr -0A2h
var_A0      = byte ptr -0A0h
var_50      = byte ptr -50h
var_4E      = byte ptr -4Eh

        push    bp
        mov bp, sp
        sub sp, 0A2h
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        push    es
        push    ds
        pop es
        assume es:seg000
        mov [bp+var_A2], di
        cld

loc_13604:              ; CODE XREF: mkfullpath+21j
        lodsb
        or  al, al
        jnz short loc_1360F

loc_13609:              ; CODE XREF: mkfullpath+3Fj
        mov ax, 3
        jmp loc_13730
; ---------------------------------------------------------------------------

loc_1360F:              ; CODE XREF: mkfullpath+17j
        cmp al, 20h
        jz  short loc_13604
        dec si
        push    di
        lea di, [bp+var_A0]
        mov dx, di
        call    strcpy
        pop di
        call    strip
        call    strupr
        mov byte ptr [di], 0
        lea si, [bp+var_A0]
        cmp byte ptr [si], 0
        jz  short loc_13609
        cmp byte ptr [si+1], 3Ah
        jnz short loc_13643
        cld
        lodsb
        stosb
        mov dl, al
        sub dl, 41h
        lodsb
        stosb
        jmp short loc_13650
; ---------------------------------------------------------------------------

loc_13643:              ; CODE XREF: mkfullpath+45j
        mov ah, 19h
        int 21h     ; DOS - GET DEFAULT DISK NUMBER
        mov dl, al
        add al, 41h
        cld
        stosb
        mov al, 3Ah
        stosb

loc_13650:              ; CODE XREF: mkfullpath+51j
        push    si
        lea si, [bp+var_50]
        mov [si], dl
        add byte ptr [si], 41h
        inc si
        mov word ptr [si], 5C3Ah
        add si, 2
        mov ah, 47h
        inc dl
        int 21h     ; DOS - 2+ - GET CURRENT DIRECTORY
                    ; DL = drive (0=default, 1=A, etc.)
                    ; DS:SI points to 64-byte buffer area
        pop si
        jnb short loc_13670
        mov ax, 1
        jmp loc_13730
; ---------------------------------------------------------------------------

loc_13670:              ; CODE XREF: mkfullpath+78j
        cmp byte ptr [si], 5Ch
        jz  short loc_1368F
        push    si
        lea si, [bp+var_4E]
        cld

loc_1367A:              ; CODE XREF: mkfullpath+8Ej
        lodsb
        stosb
        or  al, al
        jnz short loc_1367A
        pop si
        mov dx, [bp+var_A2]
        call    addslash
        mov di, dx
        call    strlen
        add di, ax

loc_1368F:              ; CODE XREF: mkfullpath+83j
        cld

loc_13690:              ; CODE XREF: mkfullpath+A4j
        lodsb
        stosb
        or  al, al
        jnz short loc_13690
        push    di
        mov si, [bp+var_A2]
        lea di, [bp+var_A0]
        call    strcpy
        pop di
        mov dx, [bp+var_A2]
        call    removeslash
        mov ah, 3Bh
        int 21h     ; DOS - 2+ - CHANGE THE CURRENT DIRECTORY (CHDIR)
                    ; DS:DX -> ASCIZ directory name (may include drive)
        jb  short loc_136C9
        mov si, dx
        mov dl, [si]
        sub dl, 40h
        add si, 3
        mov ah, 47h
        int 21h     ; DOS - 2+ - GET CURRENT DIRECTORY
                    ; DL = drive (0=default, 1=A, etc.)
                    ; DS:SI points to 64-byte buffer area
        mov dx, [bp+var_A2]
        call    addslash
        xor ax, ax
        jmp short loc_13727
; ---------------------------------------------------------------------------

loc_136C9:              ; CODE XREF: mkfullpath+BEj
        lea dx, [bp+var_A0]
        call    strlen
        mov si, dx
        add si, ax
        std

loc_136D5:              ; CODE XREF: mkfullpath+E8j
        lodsb
        cmp al, '\'
        jnz short loc_136D5
        xor al, al
        cmp byte ptr [si], 3Ah
        jnz short loc_136E5
        inc si
        mov al, [si+1]

loc_136E5:              ; CODE XREF: mkfullpath+EFj
        inc si
        mov byte ptr [si], 0
        inc si
        push    ax
        mov ah, 3Bh
        lea dx, [bp+var_A0]
        int 21h     ; DOS - 2+ - CHANGE THE CURRENT DIRECTORY (CHDIR)
                    ; DS:DX -> ASCIZ directory name (may include drive)
        pop ax
        jb  short loc_13724
        or  al, al
        jz  short loc_136FD
        dec si
        mov [si], al

loc_136FD:              ; CODE XREF: mkfullpath+108j
        push    si
        mov si, [bp+var_A2]
        mov dl, [si]
        sub dl, 40h
        add si, 3
        mov ah, 47h
        int 21h     ; DOS - 2+ - GET CURRENT DIRECTORY
                    ; DL = drive (0=default, 1=A, etc.)
                    ; DS:SI points to 64-byte buffer area
        pop si
        mov dx, [bp+var_A2]
        call    addslash
        call    strlen
        mov di, dx
        add di, ax
        call    strcpy
        xor ax, ax
        jmp short loc_13727
; ---------------------------------------------------------------------------

loc_13724:              ; CODE XREF: mkfullpath+104j
        mov ax, 2

loc_13727:              ; CODE XREF: mkfullpath+D7j
                    ; mkfullpath+132j
        push    ax
        mov ah, 3Bh
        lea dx, [bp+var_50]
        int 21h     ; DOS - 2+ - CHANGE THE CURRENT DIRECTORY (CHDIR)
                    ; DS:DX -> ASCIZ directory name (may include drive)
        pop ax

loc_13730:              ; CODE XREF: mkfullpath+1Cj
                    ; mkfullpath+7Dj
        pop es
        assume es:nothing
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        add sp, 0A2h
        pop bp
        retn
mkfullpath  endp


; =============== S U B R O U T I N E =======================================


removeslash proc near       ; CODE XREF: mkfullpath+B7p
        push    ax
        push    di
        call    strlen
        cmp ax, 3
        jbe short loc_13753
        mov di, dx
        add di, ax
        dec di
        cmp byte ptr [di], '\'
        jnz short loc_13753
        mov byte ptr [di], 0

loc_13753:              ; CODE XREF: removeslash+8j
                    ; removeslash+12j
        pop di
        pop ax
        retn
removeslash endp


; =============== S U B R O U T I N E =======================================


addslash    proc near       ; CODE XREF: mkfullpath+95p
                    ; mkfullpath+D2p mkfullpath+123p
        push    ax
        push    di
        call    strlen
        mov di, dx
        add di, ax
        dec di
        cmp byte ptr [di], '\'
        jz  short loc_1376A
        inc di
        mov word ptr [di], '\'

loc_1376A:              ; CODE XREF: addslash+Dj
        pop di
        pop ax
        retn
addslash    endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


initmem     proc near       ; CODE XREF: start+8p
        push    ax
        push    bx
        push    es
        mov ax, es:2
        mov bx, es
        add bx, 1000h
        mov first_free_seg, bx
        mov es, bx
        assume es:nothing
        sub ax, bx
        mov es:0, ax
        mov word ptr es:2, 0
        pop es
        assume es:nothing
        pop bx
        pop ax
        retn
initmem     endp

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_6. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B R O U T I N E =======================================


sub_13793   proc near       ; CODE XREF: sub_101BA+8p sub_10834+7p
                    ; sub_1090F+19p sub_1090F+43p
                    ; sub_10C74+77p openwindow+29p
        push    bx
        push    dx
        or  ax, ax
        jz  short loc_13814
        mov bx, ax
        push    cx
        mov cl, 4
        shr ax, cl
        pop cx
        and bx, 0Fh
        jz  short loc_137A7
        inc ax

loc_137A7:              ; CODE XREF: sub_13793+11j
        mov es, first_free_seg
        xor dx, dx

loc_137AD:              ; CODE XREF: sub_13793+30j
        mov bx, es
        or  bx, bx
        jz  short loc_13814
        mov bx, es:0
        cmp ax, bx
        jbe short loc_137C5
        mov dx, es
        mov es, word ptr es:2
        jmp short loc_137AD
; ---------------------------------------------------------------------------

loc_137C5:              ; CODE XREF: sub_13793+27j
        mov bx, es:0
        sub bx, ax
        jz  short loc_137FA
        push    cx
        mov cx, es
        add cx, ax
        or  dx, dx
        jz  short loc_137E2
        push    es
        mov es, dx
        mov es:2, cx
        pop es
        jmp short loc_137E6
; ---------------------------------------------------------------------------

loc_137E2:              ; CODE XREF: sub_13793+42j
        mov first_free_seg, cx

loc_137E6:              ; CODE XREF: sub_13793+4Dj
        push    ds
        mov ds, cx
        mov ds:0, bx
        mov cx, es:2
        mov ds:2, cx
        pop ds
        pop cx
        jmp short loc_13818
; ---------------------------------------------------------------------------

loc_137FA:              ; CODE XREF: sub_13793+39j
        mov bx, es:2
        or  dx, dx
        jz  short loc_1380E
        push    es
        mov es, dx
        mov es:2, bx
        pop es
        jmp short loc_13818
; ---------------------------------------------------------------------------

loc_1380E:              ; CODE XREF: sub_13793+6Ej
        mov first_free_seg, bx
        jmp short loc_13818
; ---------------------------------------------------------------------------

loc_13814:              ; CODE XREF: sub_13793+4j
                    ; sub_13793+1Ej
        xor ax, ax
        mov es, ax
        assume es:nothing

loc_13818:              ; CODE XREF: sub_13793+65j
                    ; sub_13793+79j sub_13793+7Fj
        pop dx
        pop bx
        retn
sub_13793   endp


; =============== S U B R O U T I N E =======================================


sub_1381B   proc near       ; CODE XREF: sub_101F9+9p sub_10857+9p
                    ; sub_1087C+10p sub_10C3B+23p
                    ; sub_10D28+Ap closewindow+6Dp
        push    ax
        push    bx
        push    cx
        push    dx
        push    bp
        push    es
        or  ax, ax
        jnz short loc_13828

loc_13825:              ; CODE XREF: sub_1381B+11j
        jmp loc_138EC
; ---------------------------------------------------------------------------

loc_13828:              ; CODE XREF: sub_1381B+8j
        mov bx, es
        or  bx, bx
        jz  short loc_13825
        cmp first_free_seg, 0
        jnz short loc_13847
        mov es:0, ax
        mov word ptr es:2, 0
        mov first_free_seg, es
        jmp loc_138EC
; ---------------------------------------------------------------------------

loc_13847:              ; CODE XREF: sub_1381B+18j
        cmp bx, first_free_seg
        jnb short loc_13885
        add bx, ax
        cmp bx, first_free_seg
        jnz short loc_13874
        push    es
        mov es, first_free_seg
        assume es:nothing
        add ax, es:0
        mov bx, es:2
        pop es
        mov first_free_seg, es
        mov es:0, ax
        mov es:2, bx
        jmp short loc_138EC
; ---------------------------------------------------------------------------

loc_13874:              ; CODE XREF: sub_1381B+38j
        mov es:0, ax
        mov ax, first_free_seg
        mov es:2, ax
        mov first_free_seg, es
        jmp short loc_138EC
; ---------------------------------------------------------------------------

loc_13885:              ; CODE XREF: sub_1381B+30j
        mov bp, es
        mov es, first_free_seg
        xor dx, dx

loc_1388D:              ; CODE XREF: sub_1381B+83j
        mov bx, es
        or  bx, bx
        jz  short loc_138A0
        cmp bx, bp
        jnb short loc_138A0
        mov dx, es
        mov es, word ptr es:2
        jmp short loc_1388D
; ---------------------------------------------------------------------------

loc_138A0:              ; CODE XREF: sub_1381B+76j
                    ; sub_1381B+7Aj
        mov es, dx
        mov es:2, bp
        mov es, bp
        mov es:2, bx
        mov es:0, ax
        or  bx, bx
        jz  short loc_138D5
        mov cx, bp
        add cx, ax
        cmp cx, bx
        jnz short loc_138D5
        mov es, bx
        add ax, es:0
        mov bx, es:2
        mov es, bp
        mov es:0, ax
        mov es:2, bx

loc_138D5:              ; CODE XREF: sub_1381B+99j
                    ; sub_1381B+A1j
        mov es, dx
        mov cx, dx
        add cx, es:0
        cmp cx, bp
        jnz short loc_138EC
        add es:0, ax
        mov es:2, bx

loc_138EC:              ; CODE XREF: sub_1381B:loc_13825j
                    ; sub_1381B+29j sub_1381B+57j
                    ; sub_1381B+68j sub_1381B+C5j
        pop es
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_1381B   endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


memleft     proc near       ; CODE XREF: chkmem+1p
        push    bx
        push    es
        xor ax, ax
        mov es, first_free_seg

loc_138FC:              ; CODE XREF: memleft+18j
        mov bx, es
        or  bx, bx
        jz  short loc_1390E
        add ax, es:0
        mov es, word ptr es:2
        jmp short loc_138FC
; ---------------------------------------------------------------------------

loc_1390E:              ; CODE XREF: memleft+Cj
        pop es
        pop bx
        retn
memleft     endp

; ---------------------------------------------------------------------------
        align 2
        db 2Eh, 5 dup(0)
word_13918  dw 0            ; DATA XREF: sub_10456+2r
                    ; sub_1047B+1Dr sub_1047B+28r
                    ; sub_10895+6r sub_109C0+7r
                    ; sub_109C0:loc_109DAr sub_109C0+28r
                    ; sub_109C0+43w sub_10BDE+1r
                    ; sub_10BEC+7r sub_10BEC:loc_10C2Fw
                    ; sub_10C3B+4r sub_10C3B+2Bw
                    ; sub_10E9B:loc_10EB6r sub_112F2+64r
                    ; sub_112F2+6Ar sub_114C4+16r
                    ; sub_115E5+5r seg000:163Er
                    ; seg000:1644r seg000:1656r
                    ; seg000:165Cr sub_1166E+2r
                    ; sub_116CC+18r seg000:1779r
                    ; seg000:177Fw seg000:1855r
                    ; seg000:18D9r seg000:18DFr
                    ; seg000:18FBr gotoline+23r
                    ; findtext:loc_1233Cr
                    ; replacetext:loc_1242Dr sub_126A9+54r
byte_1391A  db 0            ; DATA XREF: sub_10973+4r
                    ; sub_11F94:loc_11FBFr sub_11F94+2Fw
                    ; sub_11F94+3Aw sub_12162+56r
                    ; sub_12162+5Aw sub_12162+6Cw
        align 2
aSetupbuf   db 'SETUPBUF',0
aV2_4       db 'v2.4',0
sattr       db 1Eh          ; DATA XREF: sub_10D4C+16r
                    ; sub_10D4C+48r showline:loc_10E69r
                    ; sub_10EF4:loc_10F16r
                    ; sub_10F21:loc_10F43r sub_10F4E+1Er
                    ; sub_10F78+1Er sub_10FA2+1Er
                    ; sub_10FCC+1Br sub_11008+17r
                    ; sub_1102A+48r
byte_1392B  db 7Eh          ; DATA XREF: showline+41r
byte_1392C  db 74h          ; DATA XREF: sub_10D4C:loc_10D70r
                    ; sub_10EF4+1r sub_10F21+1r
                    ; sub_10F4E+2r sub_10F78+2r
                    ; sub_10FA2+2r sub_10FCC+1r
                    ; sub_10FF2+1r sub_11008+1r
                    ; sub_1102A+5r
byte_1392D  db 0Fh          ; DATA XREF: userinput+30r
                    ; sub_127F4+7Cr choosefile+B3r
byte_1392E  db 4Fh          ; DATA XREF: sub_10DA6+21r
byte_1392F  db 4Eh          ; DATA XREF: sub_10DA6+25r
byte_13930  db 70h          ; DATA XREF: seg000:108Dr seg000:10E2r
byte_13931  db 70h          ; DATA XREF: seg000:1091r seg000:10E6r
byte_13932  db 70h          ; DATA XREF: message+12r userinput+14r
                    ; userinput+34r replacetext+B1r
                    ; sub_127F4+49r sub_127F4+5Er
                    ; sub_127F4+8Cr choosefile+40r
                    ; choosefile+C1r sub_12C49+8r
byte_13933  db 70h          ; DATA XREF: message+16r userinput+18r
                    ; replacetext+B5r sub_127F4+4Dr
                    ; choosefile+44r choosefile+7Dr
                    ; choosefile+99r
byte_13934  db 1            ; DATA XREF: sub_10F4E+11r
                    ; sub_11239:loc_11259r sub_112F2+A2r
                    ; sub_117CA+64r seg000:185Br
                    ; seg000:189Cw
byte_13935  db 1            ; DATA XREF: sub_10F78+11r
                    ; seg000:187Ar seg000:1C15w
byte_13936  db 1            ; DATA XREF: sub_10FA2+11r
                    ; sub_112F2+9Br seg000:1C23w
byte_13937  db 0            ; DATA XREF: seg000:1889r
byte_13938  db 0            ; DATA XREF: sub_11C32r sub_11C32+60r
        db 0Fh, 3 dup(70h), 4 dup(0Fh), 2 dup(7)
byte_13943  db 0            ; DATA XREF: seg000:10D5w seg000:10FBr
                    ; seg000:113Er seg000:1145w
                    ; seg000:1150r seg000:1157w
        db 76h, 3Dh, 0B7h, 3Eh, 0CBh, 3Fh, 2, 41h, 6Bh, 42h, 0D0h
        db 43h, 4Bh, 44h, 0D3h, 0FFh, 2 dup(0)
byte_13956  db 0            ; DATA XREF: sub_10DA6+4r sub_10DA6+Ew
        align 2
byte_13958  db 0            ; DATA XREF: sub_11239:loc_11274w
        align 2
        db 28h, 7Bh, 5Bh, 22h, 29h, 7Dh, 5Dh, 22h, 54h, 15h, 0D2h
        db 11h, 32h, 16h, 0B9h, 15h, 0CEh, 15h, 7Ah, 15h, 0CCh
        db 16h, 0Dh, 17h, 88h, 18h, 0D2h, 11h, 40h, 1Bh, 42h, 19h
        db 50h, 18h, 0B2h, 17h, 0Bh, 1Ch, 52h, 19h, 0B8h, 1Bh
        db 0FEh, 15h, 0A5h, 15h, 30h, 17h, 0D2h, 11h, 9Ch, 18h
        db 0A2h, 16h, 0E5h, 15h, 6Fh, 17h, 6Eh, 16h, 0D1h, 10h
        db 53h, 7, 0F8h, 6, 1Ah, 1Bh, 27h, 1Bh, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 81h, 10h, 0D2h, 11h, 0D2h
        db 11h, 0A5h, 18h, 0CEh, 15h, 0FEh, 15h, 0D2h, 11h, 0A5h
        db 15h, 0D2h, 11h, 0B9h, 15h, 0D2h, 11h, 0B3h, 18h, 0E5h
        db 15h, 32h, 16h, 9Ch, 18h, 0CCh, 16h, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h
        db 11h, 1Ah, 1Bh, 1Eh, 1Bh, 27h, 1Bh, 0D2h, 11h, 0D2h
        db 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 0D2h, 11h, 54h
        db 15h, 7Ah, 15h, 0D1h, 18h, 0FAh, 18h, 0C2h, 18h, 0EEh
        db 18h, 0, 9, 20h, 3Ch, 3Eh, 2Ch, 3Bh, 2Eh, 3Ah, 28h, 29h
        db 5Bh, 5Dh, 7Bh, 7Dh, 5Eh, 27h, 3Dh, 2Ah, 2Bh, 2Dh, 2Fh
        db 5Ch, 24h, 23h, 0
aShhEdV2_4C1289 db 9,' ',0Dh,0Ah
        db '    SHH ED v2.4',0Dh,0Ah
        db 0Ah
        db '    (C) 12/8/92',0Dh,0Ah
        db 0Ah
        db '    Sverre H. Huseby',0Dh,0Ah
        db '    Bjoelsengt. 17',0Dh,0Ah
        db '    N-0468 Oslo',0Dh,0Ah
        db '    Norway',0Dh,0Ah
        db '    ',0
aLin0Col0   db '    Lin 0     Col 0',0 ; DATA XREF: sub_10D4C+2Ao
aShhEdV2_4F1Hel db ' SHH ED v2.4 º   F1-help  F2-save  F3-load  F4-pick  Alt/X-exit',0
                    ; DATA XREF: sub_10D4C+3Fo
aPressEsc   db 'Press ESC',0
aInsert     db 'Insert ',0
aOverwrt    db 'Overwrt',0
aIndent     db 'Indent ',0
        db '       ',0
aPairing    db 'Pairing',0
        db '       ',0
aPgup       db 'PgUp',0
aPgupPgdn   db 'PgUp/PgDn',0
aPgdn       db 'PgDn',0
aReadingFile    db 'Reading file',0
aWritingFile    db 'Writing file',0
aFileIsChanged_ db 'File is changed. Save? (Y/N) ',0
aFileExists_Ove db 'File exists. Overwrite? (Y/N) ',0 ; DATA XREF: askoverwrite:loc_1067Ao
aReplace?YN db 'Replace? (Y/N) ',0  ; DATA XREF: replacetext+C1o
aError      db ' ERROR ',0
aGiveNameOfFile db ' Give name of file to read ',0
aNewFilename    db ' New filename ',0
aReadBlockFromF db ' Read block from file ',0
aWriteBlockToFi db ' Write block to file ',0
aPickFile   db ' Pick file ',0
aLine       db ' Line ',0           ; DATA XREF: gotoline+Ao
aSearchFor  db ' Search for ',0
aReplaceWith    db ' Replace with ',0
aOptions    db ' Options ',0
aScreenMustBeIn db 'Screen must be in textmode',0Dh,0Ah
        db '$Screen must have 80 columns',0Dh,0Ah
        db '$Out of memory',0
aReadError  db 'Read error',0
aWriteError db 'Write error',0
aCouldnTOpenFil db 'Couldn',27h,'t open file',0
aCouldnTCloseFi db 'Couldn',27h,'t close file',0
aUnknownPath    db 'Unknown path',0
aLineTooLongIns db 'Line too long - inserting newline',0
aLineTooLongTru db 'Line too long - truncating',0
aNotRoomForMore db 'Not room for more lines',0
aTooManyFiles   db 'Too many files',0
aUnknownOptionG db 'Unknown option given',0
aCriticalErrorC db 'Critical error! Check your disk',0
aHelp       db ' HELP ',0
        db 0Dh, 0Ah, 2 dup(20h), 42h, 61h, 73h, 69h, 63h, 20h
        db 43h, 75h, 72h, 73h, 6Fh, 72h, 20h, 4Dh, 6Fh, 76h, 65h
        db 6Dh, 65h, 6Eh, 74h, 0Dh, 0Ah, 2 dup(20h), 15h dup(2Dh)
        db 0Dh, 0Ah, 2 dup(20h), 43h, 68h, 61h, 72h, 20h, 4Ch
        db 65h, 66h, 74h, 3 dup(20h), 43h, 74h, 6Ch, 2Dh, 53h
        db 20h, 6Fh, 72h, 20h, 1Bh, 0Dh, 0Ah, 2 dup(20h), 43h
        db 68h, 61h, 72h, 20h, 52h, 69h, 67h, 68h, 74h, 2 dup(20h)
        db 43h, 74h, 6Ch, 2Dh, 44h, 20h, 6Fh, 72h, 20h, 1Ah, 0Dh
        db 0Ah, 2 dup(20h), 57h, 6Fh, 72h, 64h, 20h, 4Ch, 65h
        db 66h, 74h, 3 dup(20h), 43h, 74h, 6Ch, 2Dh, 41h, 20h
        db 6Fh, 72h, 20h, 43h, 74h, 6Ch, 2Dh, 20h, 1Bh, 0Dh, 0Ah
        db 2 dup(20h), 57h, 6Fh, 72h, 64h, 20h, 52h, 69h, 67h
        db 68h, 74h, 2 dup(20h), 43h, 74h, 6Ch, 2Dh, 46h, 20h
        db 6Fh, 72h, 20h, 43h, 74h, 6Ch, 2Dh, 20h, 1Ah, 0Dh, 0Ah
        db 2 dup(20h), 4Ch, 69h, 6Eh, 65h, 20h, 55h, 70h, 5 dup(20h)
        db 43h, 74h, 6Ch, 2Dh, 45h, 20h, 6Fh, 72h, 20h, 18h, 0Dh
        db 0Ah, 2 dup(20h), 4Ch, 69h, 6Eh, 65h, 20h, 44h, 6Fh
        db 77h, 6Eh, 3 dup(20h), 43h, 74h, 6Ch, 2Dh, 58h, 20h
        db 6Fh, 72h, 20h, 19h
aScrollUpCtlWSc db 0Dh,0Ah
        db '  Scroll Up   Ctl-W',0Dh,0Ah
        db '  Scroll Down Ctl-Z',0Dh,0Ah
        db '  Page Up     Ctl-R or PgUp',0Dh,0Ah
        db '  Page Down   Ctl-C or PgDn',0Dh,0Ah
        db '  ',0
aOtherCursorMov db 0Dh,0Ah
        db '  Other Cursor Movement',0Dh,0Ah
        db '  ---------------------',0Dh,0Ah
        db '  Beg of Line   Home',0Dh,0Ah
        db '  End of Line   End',0Dh,0Ah
        db '  Top of Screen Ctl-Home',0Dh,0Ah
        db '  Bot of Screen Ctl-End',0Dh,0Ah
        db '  Beg of File   Ctl-PgUp',0Dh,0Ah
        db '  End of File   Ctl-PgDn',0Dh,0Ah
        db '  Beg of Block  Ctl-Q B',0Dh,0Ah
        db '  End of Block  Ctl-Q K',0Dh,0Ah
        db '  Go to Line    Ctl-Q G',0Dh,0Ah
        db '  ',0
aInsertAndDelet db 0Dh,0Ah
        db '  Insert and Delete Commands',0Dh,0Ah
        db '  --------------------------',0Dh,0Ah
        db '  Insert Off/On         Ctl-V or Ins',0Dh,0Ah
        db '  Insert Line           Ctl-N',0Dh,0Ah
        db '  Delete Line           Ctl-Y',0Dh,0Ah
        db '  Delete to End of Line Ctl-Q Y',0Dh,0Ah
        db '  Delete Char Left      Ctl-H or BackSpace',0Dh,0Ah
        db '  Delete Char           Ctl-G or Del',0Dh,0Ah
        db '  Delete Word Right     Ctl-T',0Dh,0Ah
        db '  ',0
aBlockCommandsM db 0Dh,0Ah
        db '  Block Commands',0Dh,0Ah
        db '  --------------',0Dh,0Ah
        db '  Mark Blockstart      Ctl-K B',0Dh,0Ah
        db '  Mark Blockend        Ctl-K K',0Dh,0Ah
        db '  Copy Block           Ctl-K C',0Dh,0Ah
        db '  Move Block           Ctl-K V',0Dh,0Ah
        db '  Delete Block         Ctl-K Y',0Dh,0Ah
        db '  Read Block from File Ctl-K R',0Dh,0Ah
        db '  Write Block to File  Ctl-K W',0Dh,0Ah
        db '  Hide/Display Block   Ctl-K H',0Dh,0Ah
        db '  Indent Block         Ctl-K I',0Dh,0Ah
        db '  Unindent Block       Ctl-K U',0Dh,0Ah
        db '  ',0
aOtherEditingCo db 0Dh,0Ah
        db '  Other Editing Commands',0Dh,0Ah
        db '  ----------------------',0Dh,0Ah
        db '  Indent             Ctl-I or Tab',0Dh,0Ah
        db '  Auto Indent Off/On Ctl-O I',0Dh,0Ah
        db '  Pairmaking Off/On  Ctl-O P',0Dh,0Ah
        db '  Set Place Marker   Ctl-K 1,2',0Dh,0Ah
        db '  Find Place Marker  Ctl-Q 1,2',0Dh,0Ah
        db '  Contol Char Prefix Ctl-P',0Dh,0Ah
        db '  Search             Ctl-Q F',0Dh,0Ah
        db '  Search and replace Ctl-Q A',0Dh,0Ah
        db '  Repeat Last Search Ctl-L',0Dh,0Ah
        db '  Show User Screen   F5',0Dh,0Ah
        db '  ',0
aFileHandlingSa db 0Dh,0Ah
        db '  File Handling',0Dh,0Ah
        db '  -------------',0Dh,0Ah
        db '  Save File     F2',0Dh,0Ah
        db '  Load File     F3',0Dh,0Ah
        db '  Pick File     F4',0Dh,0Ah
        db '  Save Picklist Alt-F4',0Dh,0Ah
        db '  ',0
aOptionsToSearc db 0Dh,0Ah
        db '  Options to search/replace',0Dh,0Ah
        db '  -------------------------',0Dh,0Ah
        db '  G - Global; all occurences',0Dh,0Ah
        db '  N - No confirmation from user',0Dh,0Ah
        db '  ',0
        align 2
byte_144CA  db 0            ; DATA XREF: sub_11C32:loc_11C51w
                    ; sub_11CB9r sub_11CC6+4r sub_11CFFr
                    ; sub_11D0Er
word_144CB  dw 280h         ; DATA XREF: sub_11C32+47r
                    ; sub_11C32+75r
word_144CD  dw 0C8h         ; DATA XREF: sub_11C32+38w
                    ; sub_11C32:loc_11C6Dr sub_11C32+7Br
byte_144CF  db 8            ; DATA XREF: sub_11CC6+1Br
byte_144D0  db 8            ; DATA XREF: sub_11C32+2Fr
                    ; sub_11CC6+12r
        align 2
        db 53h, 2 dup(48h), 20h, 45h, 44h, 20h, 70h, 69h, 63h
        db 6Bh, 66h, 69h, 6Ch, 65h, 2Eh, 0Dh, 0Ah, 1Ah, 0, 45h
        db 44h, 2Eh, 50h, 43h, 4Bh, 2 dup(0), 2Ah, 2Eh, 2Ah, 0
border_type db 0            ; DATA XREF: openwindow+5w
                    ; openwindow:loc_13405r openwindow+9Dr
                    ; openwindow+B1r sub_13526+4r
                    ; drawborder+3r drawborder+14r
word_144F3  dw 0            ; DATA XREF: sub_13338r openwindow+43r
                    ; openwindow+88w closewindow+4r
                    ; closewindow+66w
unk_144F5   db 0DAh ; Ú       ; DATA XREF: drawborders+Co
        db 0C4h ; Ä
        db 0BFh ; ¿
        db 0B3h ; ³
        db 0D9h ; Ù
        db 0C0h ; À
unk_144FB   db 0C9h ; É       ; DATA XREF: drawborders:loc_13356o
        db 0CDh ; Í
        db 0BBh ; »
        db 0BAh ; º
        db 0BCh ; ¼
        db 0C8h ; È
        db    ? ;
unk_14502   db    ? ;
        db    ? ;
unk_14504   db    ? ;
        db    ? ;
unk_14506   db    ? ;
        db    ? ;
unk_14508   db    ? ;
        db    ? ;
unk_1450A   db    ? ;
        db    ? ;
unk_1450C   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_1455D   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_145AE   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_145FF   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14650   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_146A2   db    ? ;
        db    ? ;
unk_146A4   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_147A5   db    ? ;
unk_147A6   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_148A8   db    ? ;
        db    ? ;
cpl     db ?
        db    ? ;
unk_148AC   db    ? ;
        db    ? ;
unk_148AE   db    ? ;
        db    ? ;
unk_148B0   db    ? ;
        db    ? ;
unk_148B2   db    ? ;
        db    ? ;
unk_148B4   db    ? ;
        db    ? ;
byte_148B6  db ?            ; DATA XREF: seg000:1132w
                    ; userinput+4Aw sub_111C8w
                    ; sub_111D3+3w sub_112F2:loc_112FAr
                    ; userscr+Cw sub_127F4+9Ew
                    ; choosefile+D3w
unk_148B7   db    ? ;       ; DATA XREF: gotoline+Do gotoline+18o
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_149BD   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14ABF   db    ? ;
        db    ? ;
unk_14AC1   db    ? ;
        db    ? ;
unk_14AC3   db    ? ;
        db    ? ;
curlin      db    ? ;
        db    ? ;
unk_14AC7   db    ? ;
        db    ? ;
unk_14AC9   db    ? ;
unk_14ACA   db    ? ;
        db    ? ;
unk_14ACC   db    ? ;
        db    ? ;
unk_14ACE   db    ? ;
        db    ? ;
unk_14AD0   db    ? ;
unk_14AD1   db    ? ;
unk_14AD2   db    ? ;
        db    ? ;
unk_14AD4   db    ? ;
        db    ? ;
unk_14AD6   db    ? ;
        db    ? ;
unk_14AD8   db    ? ;
        db    ? ;
unk_14ADA   db    ? ;
        db    ? ;
unk_14ADC   db    ? ;
        db    ? ;
unk_14ADE   db    ? ;
        db    ? ;
unk_14AE0   db    ? ;
        db    ? ;
unk_14AE2   db    ? ;
        db    ? ;
unk_14AE4   db    ? ;
        db    ? ;
unk_14AE6   db    ? ;
        db    ? ;
unk_14AE8   db    ? ;
        db    ? ;
unk_14AEA   db    ? ;
        db    ? ;
unk_14AEC   db    ? ;
        db    ? ;
unk_14AEE   db    ? ;
        db    ? ;
unk_14AF0   db    ? ;
unk_14AF1   db    ? ;
unk_14AF2   db    ? ;
unk_14AF3   db    ? ;
unk_14AF4   db    ? ;
unk_14AF5   db    ? ;
unk_14AF6   db    ? ;
unk_14AF7   db    ? ;
        db    ? ;
unk_14AF9   db    ? ;
        db    ? ;
unk_14AFB   db    ? ;
        db    ? ;
unk_14AFD   db    ? ;
        db    ? ;
unk_14AFF   db    ? ;
        db    ? ;
curspos     dw ?
matches     db    ? ;
        db    ? ;
findtxt     db    ? ;       ; DATA XREF: sub_1226A+3w findtext+50o
                    ; replacetext+19o
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14B26   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14B47   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14B7A   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
unk_14BCD   db    ? ;
        db    ? ;
unk_14BCF   db    ? ;
        db    ? ;
unk_14BD1   db    ? ;
        db    ? ;
unk_14BD3   db    ? ;
        db    ? ;
unk_14BD5   db    ? ;
unk_14BD6   db    ? ;
        db    ? ;
unk_14BD8   db    ? ;
        db    ? ;
unk_14BDA   db    ? ;
        db    ? ;
unk_14BDC   db    ? ;
        db    ? ;
unk_14BDE   db    ? ;
        db    ? ;
unk_14BE0   db    ? ;
        db    ? ;
unk_14BE2   db    ? ;
        db    ? ;
unk_14BE4   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
byte_15148  db ?            ; DATA XREF: mkpickw sub_12570w
                    ; sub_1259D+2Fw sub_125D6+4r
        db    ? ;
unk_1514A   db    ? ;
        db    ? ;
unk_1514C   db    ? ;
unk_1514D   db    ? ;
        db    ? ;
unk_1514F   db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
vx1     db ?
vy1     db ?
vx2     db ?
vy2     db ?
antkol2     dw ?
curx        db ?
cury        db ?
sadr        dd ?
txtattr     db ?            ; DATA XREF: initscreen+41w
                    ; vistegn+18r vistegn+4Dr
                    ; sub_12E2C+7r textattrw sub_12EAE+3w
                    ; sub_12EAE+8w sub_12EBC+6w
                    ; sub_12EBC+Bw clreol+7r
                    ; lineinput+19r initwindow+1r
                    ; drawborders+27r drawborders+44r
                    ; drawborders+6Br openwindow+74r
                    ; openwindow+A7w openwindow+CAw
                    ; closewindow+5Fw sub_13526+2Fr
                    ; sub_13526+34w sub_13526+80w
                    ; drawborder+Ar drawborder+11w
                    ; drawborder+2Bw
stdattr     db    ? ;
buff        db 100h dup(?)      ; DATA XREF: outline+1Eo lineinput+24o
                    ; lineinput+30w lineinput+3Do
                    ; lineinput+BEw lineinput+14Bo
                    ; lineinput+189o lineinput+19Cw
                    ; lineinput+1B7o
input_text  dw ?
quit_keys   dw ?
curs_curr_pos   dw ?
string_offset   dw ?
curs_end_pos    dw ?
intput_max_len  dw ?
input_box_length dw ?
saved_curspos   dw ?
saved_curspos2  dw ?
input_key   dw ?
mtattr      db ?
saved_txtattr   db ?
flag        db ?
        db    ? ;
unk_157FE   db    ? ;
unk_157FF   db    ? ;
word_15800  dw ?
word_15802  dw ?
first_free_seg  dw ?
        db 28FAh dup(?)
seg000      ends


        end start
