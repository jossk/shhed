.MODEl TINY

.CODE

EXTRN   strlen: PROC
EXTRN   getkey: PROC

PUBLIC atoui
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


PUBLIC strcpy
strcpy      proc near       ; CODE XREF: start+4Bp sub_104E9+Fp
                    ; sub_10573:loc_105B3p
                    ; sub_105CC:loc_10630p sub_105CC+6Bp
                    ; sub_105CC+92p sub_106C3+10p
                    ; sub_106C3+25p sub_106F8+41p
                    ; sub_10753+46p sub_1257A+1Ap
                    ; sub_12606+1Ap sub_126A9+45p
                    ; sub_12924+15p sub_12924+2Bp
                    ; sub_12924+1D8p sub_12B12+21p
                    ; sub_12B12+48p sub_12B12+69p
                    ; sub_12B12+9Fp sub_13043+29p
                    ; sub_13043+1BEp sub_135F0+2Bp
                    ; sub_135F0+AFp sub_135F0+12Dp
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


PUBLIC strip
strip       proc near       ; CODE XREF: start+30p sub_10973+14p
                    ; sub_135F0+2Fp
        push    ax
        push    cx
        push    di
        push    es
        push    ds
        pop es
        ;assume es:seg000
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
        ;assume es:nothing
        pop di
        pop cx
        pop ax
        retn
strip       endp


        align 2

PUBLIC strupr
strupr      proc near       ; CODE XREF: start+4Ep sub_106F8+46p
                    ; sub_10753+4Bp sub_12279+18p
                    ; sub_135F0+32p
        push    ax
        push    si
        push    di
        push    es
        push    ds
        pop es
        ;assume es:seg000
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
        ;assume es:nothing
        pop di
        pop si
        pop ax
        retn
strupr      endp


PUBLIC strstr
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


        align 2


PUBLIC strcat
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


PUBLIC CHOICE
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



        align 2

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

PUBLIC mkfullpath
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
        ;assume es:seg000
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
        ;assume es:nothing
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


END
