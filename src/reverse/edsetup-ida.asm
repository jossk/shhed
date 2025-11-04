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

; Attributes: noreturn thunk

        public start
start       proc near
        jmp main
start       endp


; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

exit        proc near       ; CODE XREF: fatal+43p do_changes+2Ep
                    ; main+13p main+C1p
        call    endwindow
        call    endscreen
        call    endmem
        mov ax, 4C00h
        int 21h     ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
exit        endp            ; AL = exit code


; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

fatal       proc near       ; CODE XREF: find_area+21p
                    ; find_area+3Ap main+39p main+61p
                    ; main+7Fp main+96p main+B7p
        push    dx
        call    strlen
        mov dx, 0B12h
        add dl, al
        mov ax, 903h
        mov bl, 1
        mov cx, 7070h
        call    openwindow
        mov dx, 0DACh
        xor al, al
        call    bordertext
        mov al, ' '
        call    outchar
        pop dx
        call    outtext
        mov al, '.'
        call    outchar
        mov al, ' '
        call    outchar
        call    outchar
        mov dx, offset prsesc ; "Press ESC"
        call    outtext

loc_149:                ; CODE XREF: fatal+3Ej
        call    getkey
        cmp ax, 27
        jnz short loc_149
        call    closewindow
        call    exit
fatal       endp


; =============== S U B R O U T I N E =======================================


find_area   proc near       ; CODE XREF: main+67p
        mov cx, filelen
        mov dx, offset idstr ; "SETUPBUF"
        call    strlen
        sub cx, ax
        mov si, offset idstr ; "SETUPBUF"
        mov di, offset buffer
        push    ds
        pop es
        assume es:seg000

loc_16B:                ; CODE XREF: find_area+1Cj
        call    strcmp
        or  ax, ax
        jz  short loc_17B
        inc di
        loop    loc_16B
        mov dx, offset aUnknownEd_com ; "Unknown ED.COM"
        call    fatal
; ---------------------------------------------------------------------------

loc_17B:                ; CODE XREF: find_area+19j
        mov dx, offset idstr ; "SETUPBUF"
        call    strlen
        add si, ax
        add di, ax
        inc si
        inc di
        call    strcmp
        or  ax, ax
        jz  short loc_194
        mov dx, offset aDifferentVersi ; "Different versions of EDSETUP.COM and E"...
        call    fatal
; ---------------------------------------------------------------------------

loc_194:                ; CODE XREF: find_area+35j
        mov dx, si
        call    strlen
        add di, ax
        inc di
        mov area, di
        retn
find_area   endp


; =============== S U B R O U T I N E =======================================


show_status proc near       ; CODE XREF: do_changes+4Ap
        call    wherex
        call    wherey
        push    ax
        mov bx, area
        mov ax, 227h
        call    gotoxy
        mov dx, 0E48h
        cmp byte ptr [bx+0Eh], 0
        jz  short loc_1BE
        mov dx, offset aOn  ; "On "

loc_1BE:                ; CODE XREF: show_status+18j
        call    outtext
        mov ax, 327h
        call    gotoxy
        mov dx, offset aOff ; "Off"
        cmp byte ptr [bx+0Ah], 0
        jz  short loc_1D3
        mov dx, offset aOn  ; "On "

loc_1D3:                ; CODE XREF: show_status+2Dj
        call    outtext
        mov ax, 427h
        call    gotoxy
        mov dx, offset aOff ; "Off"
        cmp byte ptr [bx+0Bh], 0
        jz  short loc_1E8
        mov dx, offset aOn  ; "On "

loc_1E8:                ; CODE XREF: show_status+42j
        call    outtext
        mov ax, 527h
        call    gotoxy
        mov dx, offset aOff ; "Off"
        cmp byte ptr [bx+0Ch], 0
        jz  short loc_1FD
        mov dx, offset aOn  ; "On "

loc_1FD:                ; CODE XREF: show_status+57j
        call    outtext
        mov dx, offset aAbcd ; " Abcd "
        mov ax, 626h
        call    gotoxy
        mov al, [bx]
        call    textattr
        call    outtext
        mov ax, 726h
        call    gotoxy
        mov al, [bx+1]
        call    textattr
        call    outtext
        mov ax, 826h
        call    gotoxy
        mov al, [bx+2]
        call    textattr
        call    outtext
        mov ax, 926h
        call    gotoxy
        mov al, [bx+4]
        call    textattr
        call    outtext
        mov ax, 0A26h
        call    gotoxy
        mov al, [bx+5]
        call    textattr
        call    outtext
        mov ax, 0B26h
        call    gotoxy
        mov al, [bx+6]
        call    textattr
        call    outtext
        mov ax, 0C26h
        call    gotoxy
        mov al, [bx+7]
        call    textattr
        call    outtext
        mov ax, 0D26h
        call    gotoxy
        mov al, [bx+8]
        call    textattr
        call    outtext
        mov ax, 0E26h
        call    gotoxy
        mov al, [bx+9]
        call    textattr
        call    outtext
        pop ax
        call    gotoxy
        mov al, 0Fh
        call    textattr
        retn
show_status endp


; =============== S U B R O U T I N E =======================================


get_color   proc near       ; CODE XREF: do_changes+ADp
                    ; do_changes+BBp do_changes+CBp
                    ; do_changes+DBp do_changes+EBp
                    ; do_changes+FBp do_changes+10Bp
                    ; do_changes+11Bp do_changes+12Bp
        push    bx
        push    cx
        push    dx
        mov attr, al
        mov tmpattr, al
        xor ax, ax
        mov dx, 0D21h
        mov bl, 1
        mov cx, 0D0Fh
        call    openwindow
        mov dx, offset aForeground____ ; "\r\n         Foreground\r\n        "...
        call    outtext
        call    wherex
        call    wherey
        push    ax
        mov ax, 20Ah
        call    gotoxy
        mov cx, 10h

loc_2BF:                ; CODE XREF: get_color+38j
        mov al, 10h
        sub al, cl
        call    textattr
        mov al, 0DBh
        call    outchar
        loop    loc_2BF
        mov ax, 303h
        call    gotoxy
        mov cx, 8

loc_2D6:                ; CODE XREF: get_color+59j
        mov al, 8
        sub al, cl
        call    textattr
        mov al, 0DBh
        call    outchar
        call    wherey
        inc ah
        mov al, 3
        call    gotoxy
        loop    loc_2D6
        mov al, 0Fh
        call    textattr
        pop ax
        call    gotoxy

loc_2F7:                ; CODE XREF: get_color:loc_3A8j
                    ; get_color+131j get_color+14Dj
                    ; get_color+169j get_color:loc_3FFj
        call    wherex
        call    wherey
        push    ax
        mov al, attr
        and ax, 0Fh
        add ax, 30Ah
        call    gotoxy
        mov al, 18h
        call    outchar
        mov ah, attr
        shr ah, 1
        shr ah, 1
        shr ah, 1
        shr ah, 1
        and ax, 0F00h
        add ax, 304h
        call    gotoxy
        mov al, 1Bh

loc_326:
        call    outchar
        mov ax, 913h
        call    gotoxy
        mov al, attr
        call    textattr
        mov dx, offset aAbcd ; " Abcd "
        call    outtext
        mov al, 0Fh
        call    textattr
        pop ax
        call    gotoxy
        call    getkey
        push    ax
        call    wherex
        call    wherey
        push    ax
        mov al, attr
        and ax, 0Fh
        add ax, 30Ah
        call    gotoxy
        mov al, 20h
        call    outchar
        mov ah, attr
        shr ah, 1
        shr ah, 1
        shr ah, 1
        shr ah, 1
        and ax, 0F00h
        add ax, 304h
        call    gotoxy
        mov al, 20h
        call    outchar
        pop ax
        call    gotoxy
        pop ax
        cmp ax, 1Bh
        jnz short loc_38C
        mov al, tmpattr
        mov attr, al
        jmp short loc_402
; ---------------------------------------------------------------------------

loc_38C:                ; CODE XREF: get_color+EFj
        cmp ax, 0Dh
        jz  short loc_402
        cmp ax, -75
        jnz short loc_3AB
        mov al, attr
        and al, 0Fh
        dec al
        js  short loc_3A8
        and attr, 0F0h
        or  attr, al

loc_3A8:                ; CODE XREF: get_color+10Aj
                    ; get_color+126j get_color+142j
                    ; get_color+15Ej
        jmp loc_2F7
; ---------------------------------------------------------------------------

loc_3AB:                ; CODE XREF: get_color+101j
        cmp ax, -77
        jnz short loc_3C7
        mov al, attr
        and al, 0Fh
        inc al
        cmp al, 0Fh
        ja  short loc_3A8
        and attr, 0F0h
        or  attr, al
        jmp loc_2F7
; ---------------------------------------------------------------------------

loc_3C7:                ; CODE XREF: get_color+11Bj
        cmp ax, -72
        jnz short loc_3E3
        mov al, attr
        and al, 0F0h
        sub al, 10h
        cmp al, 70h
        ja  short loc_3A8
        and attr, 0Fh
        or  attr, al
        jmp loc_2F7
; ---------------------------------------------------------------------------

loc_3E3:                ; CODE XREF: get_color+137j
        cmp ax, -80
        jnz short loc_3FF
        mov al, attr
        and al, 0F0h
        add al, 10h
        cmp al, 70h
        ja  short loc_3A8
        and attr, 0Fh
        or  attr, al
        jmp loc_2F7
; ---------------------------------------------------------------------------

loc_3FF:                ; CODE XREF: get_color+153j
        jmp loc_2F7
; ---------------------------------------------------------------------------

loc_402:                ; CODE XREF: get_color+F7j
                    ; get_color+FCj
        call    closewindow
        mov al, attr
        pop dx
        pop cx
        pop bx
        retn
get_color   endp


; =============== S U B R O U T I N E =======================================


do_changes  proc near       ; CODE XREF: main+6Ap
        mov ax, 20Ch
        mov dx, 1743h
        mov bl, 2
        mov cx, 0E0Fh
        call    openwindow
        mov dx, offset aEdsetupV2_4C12 ; " EDSETUP v2.4  --  (C) 12/8/92 "
        xor al, al
        call    bordertext
        mov dx, offset aThisProgramMak ; "\r\n\n  This program makes it possible "...
        call    outtext
        call    getkey
        cmp ax, 1Bh
        jnz short loc_43D

loc_430:                ; CODE XREF: do_changes+53j
        call    closewindow
        mov dx, offset aAbortedByUser_ ; "Aborted by user. ED.COM is unchanged\r\"...
        mov ah, 9
        int 21h     ; DOS - PRINT STRING
                    ; DS:DX -> string terminated by "$"
        call    exit
; ---------------------------------------------------------------------------

loc_43D:                ; CODE XREF: do_changes+22j
        call    clrscr
        mov dx, offset menutxt ; "\r\n                   "...
        call    outtext

loc_446:                ; CODE XREF: do_changes+57j
                    ; do_changes+5Fj do_changes+65j
                    ; do_changes+69j do_changes+87j
                    ; do_changes+91j do_changes+9Bj
                    ; do_changes+A5j do_changes+B2j
                    ; do_changes+C1j do_changes+D1j
                    ; do_changes+E1j do_changes+F1j
                    ; do_changes+101j do_changes+111j
                    ; do_changes+121j do_changes+131j
                    ; do_changes+147j do_changes+14Ej
        call    wherex

loc_449:                ; DATA XREF: initscreen+Cr
                    ; screencols+5r
        call    wherey
        push    ax

loc_44D:                ; DATA XREF: initscreen+1Ar
        mov al, 20h
        call    outchar
        pop ax
        call    gotoxy
        call    show_status
        call    getkey
        cmp ax, 1Bh
        jz  short loc_430

loc_461:                ; DATA XREF: setcurs+10r getcurs+7r
                    ; initscreen+34r
        or  ah, ah
        jnz short loc_446
        cmp al, 61h
        jb  short loc_46F
        cmp al, 7Ah
        ja  short loc_446
        sub al, 20h

loc_46F:                ; CODE XREF: do_changes+5Bj
        cmp al, 41h
        jb  short loc_446
        cmp al, 5Ah
        ja  short loc_446
        push    ax
        call    outchar
        call    wherex
        dec al
        call    wherey

loc_483:                ; DATA XREF: screenrows+14r
        call    gotoxy
        pop ax
        mov bx, area
        cmp al, 41h
        jnz short loc_495
        xor byte ptr [bx+0Eh], 1
        jmp short loc_446
; ---------------------------------------------------------------------------

loc_495:                ; CODE XREF: do_changes+81j
        cmp al, 42h
        jnz short loc_49F
        xor byte ptr [bx+0Ah], 1
        jmp short loc_446
; ---------------------------------------------------------------------------

loc_49F:                ; CODE XREF: do_changes+8Bj
        cmp al, 43h
        jnz short loc_4A9
        xor byte ptr [bx+0Bh], 1
        jmp short loc_446
; ---------------------------------------------------------------------------

loc_4A9:                ; CODE XREF: do_changes+95j
        cmp al, 44h
        jnz short loc_4B3
        xor byte ptr [bx+0Ch], 1
        jmp short loc_446
; ---------------------------------------------------------------------------

loc_4B3:                ; CODE XREF: do_changes+9Fj
        cmp al, 45h
        jnz short loc_4C0
        mov al, [bx]
        call    get_color
        mov [bx], al
        jmp short loc_446
; ---------------------------------------------------------------------------

loc_4C0:                ; CODE XREF: do_changes+A9j
        cmp al, 46h
        jnz short loc_4D0
        mov al, [bx+1]
        call    get_color
        mov [bx+1], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_4D0:                ; CODE XREF: do_changes+B6j
        cmp al, 47h
        jnz short loc_4E0
        mov al, [bx+2]
        call    get_color
        mov [bx+2], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_4E0:                ; CODE XREF: do_changes+C6j
        cmp al, 48h
        jnz short loc_4F0
        mov al, [bx+4]
        call    get_color
        mov [bx+4], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_4F0:                ; CODE XREF: do_changes+D6j
        cmp al, 49h
        jnz short loc_500
        mov al, [bx+5]
        call    get_color
        mov [bx+5], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_500:                ; CODE XREF: do_changes+E6j
        cmp al, 4Ah
        jnz short loc_510
        mov al, [bx+6]
        call    get_color
        mov [bx+6], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_510:                ; CODE XREF: do_changes+F6j
        cmp al, 4Bh
        jnz short loc_520
        mov al, [bx+7]
        call    get_color
        mov [bx+7], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_520:                ; CODE XREF: do_changes+106j
        cmp al, 4Ch
        jnz short loc_530
        mov al, [bx+8]
        call    get_color
        mov [bx+8], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_530:                ; CODE XREF: do_changes+116j
        cmp al, 4Dh
        jnz short loc_540
        mov al, [bx+9]
        call    get_color
        mov [bx+9], al
        jmp loc_446
; ---------------------------------------------------------------------------

loc_540:                ; CODE XREF: do_changes+126j
        cmp al, 4Eh
        jnz short loc_556
        mov cx, 0Fh
        push    ds
        pop es
        mov si, offset sattr
        mov di, area
        cld
        rep movsb
        jmp loc_446
; ---------------------------------------------------------------------------

loc_556:                ; CODE XREF: do_changes+136j
        cmp al, 51h
        jz  short loc_55D
        jmp loc_446
; ---------------------------------------------------------------------------

loc_55D:                ; CODE XREF: do_changes+14Cj
        call    closewindow
        retn
do_changes  endp


; =============== S U B R O U T I N E =======================================

; Attributes: noreturn

main        proc near       ; CODE XREF: startj
        mov ah, 0Fh
        int 10h     ; - VIDEO - GET CURRENT VIDEO MODE
                    ; Return: AH = number of columns on screen
                    ; AL = current video mode
                    ; BH = current active display page
        cmp al, 3
        jbe short loc_577
        cmp al, 7
        jz  short loc_577
        mov dx, 4762

loc_570:                ; CODE XREF: main+21j
        mov ah, 9
        int 21h     ; DOS - PRINT STRING
                    ; DS:DX -> string terminated by "$"
        call    exit
; ---------------------------------------------------------------------------

loc_577:                ; CODE XREF: main+6j main+Aj
        call    screencols
        cmp ax, 80
        jnb short loc_584
        mov dx, offset aEdsetupScreenM ; "EDSETUP: Screen must have at least 80 c"...
        jmp short loc_570
; ---------------------------------------------------------------------------

loc_584:                ; CODE XREF: main+1Cj
        call    initmem
        call    initscreen
        call    initwindow
        mov ax, 3D02h
        mov dx, offset filenm ; "ED.COM"
        int 21h     ; DOS - 2+ - OPEN DISK FILE WITH HANDLE
                    ; DS:DX -> ASCIZ filename
                    ; AL = access mode
                    ; 2 - read & write
        jnb short loc_59D
        mov dx, offset aCouldnTOpenEd_ ; "Couldn't open ED.COM for reading/writin"...
        call    fatal
; ---------------------------------------------------------------------------

loc_59D:                ; CODE XREF: main+34j
        mov hdl, ax
        mov bx, ax
        mov ax, 5700h
        int 21h     ; DOS - 2+ - GET FILE'S DATE/TIME
                    ; BX = file handle
        mov ftime, cx
        mov fdate, dx
        mov ah, 3Fh
        mov bx, hdl
        mov cx, 7FFFh
        mov dx, 1322h
        int 21h     ; DOS - 2+ - READ FROM FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to read
                    ; DS:DX -> buffer
        jnb short loc_5C5
        mov dx, offset aReadError ; "Read error"
        call    fatal
; ---------------------------------------------------------------------------

loc_5C5:                ; CODE XREF: main+5Cj
        mov filelen, ax
        call    find_area
        call    do_changes
        mov ax, 4200h
        mov bx, hdl
        xor cx, cx
        xor dx, dx
        int 21h     ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                    ; AL = method: offset from beginning of file
        jnb short loc_5E3
        mov dx, offset aWriteError ; "Write error"
        call    fatal
; ---------------------------------------------------------------------------

loc_5E3:                ; CODE XREF: main+7Aj
        mov ah, 40h
        mov bx, hdl
        mov cx, filelen
        mov dx, 1322h
        int 21h     ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                    ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
        jnb short loc_5FA

loc_5F4:                ; CODE XREF: main+9Bj
        mov dx, offset aWriteError ; "Write error"
        call    fatal
; ---------------------------------------------------------------------------

loc_5FA:                ; CODE XREF: main+91j
        cmp ax, cx
        jnz short loc_5F4
        mov ax, 5701h
        mov bx, hdl
        mov cx, ftime
        mov dx, fdate
        int 21h     ; DOS - 2+ - SET FILE'S DATE/TIME
                    ; BX = file handle, CX = time to be set
                    ; DX = date to be set
        mov ah, 3Eh
        int 21h     ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                    ; BX = file handle
        jnb short loc_61B
        mov dx, offset aCouldnTCloseFi ; "Couldn't close file"
        call    fatal
; ---------------------------------------------------------------------------

loc_61B:                ; CODE XREF: main+B2j
        mov dx, offset aEd_comIsUpdate ; "ED.COM is updated\r\n$"
        mov ah, 9
        int 21h     ; DOS - PRINT STRING
                    ; DS:DX -> string terminated by "$"
        call    exit
main        endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


setcurs     proc near       ; CODE XREF: outchar+3p
                    ; outtext:loc_7A9p clrscr+29p
                    ; setwindow+16p gotoxy+1Cp
                    ; openwindow+D7p closewindow+58p
        push    ax
        push    bx
        push    dx
        push    es
        mov dl, curx
        mov dh, cury
        xor ax, ax
        mov es, ax
        mov bh, byte ptr es:loc_461+1
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


getcurs     proc near       ; CODE XREF: initscreen+64p
        push    ax
        push    bx
        push    es
        xor ax, ax
        mov es, ax
        assume es:seg000
        mov bl, byte ptr es:loc_461+1
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
getcurs     endp


; =============== S U B R O U T I N E =======================================


screencols  proc near       ; CODE XREF: main:loc_577p
                    ; initscreen+4Dp
        push    es
        xor ax, ax
        mov es, ax
        assume es:seg000
        mov ax, word ptr es:loc_449+1
        pop es
        assume es:nothing
        retn
screencols  endp


; =============== S U B R O U T I N E =======================================


screenrows  proc near       ; CODE XREF: initscreen+5Cp
        push    bx
        push    cx
        mov ah, 12h
        mov bl, 10h
        int 10h     ; - VIDEO - ALTERNATE FUNCTION SELECT (PS, EGA, VGA, MCGA) - GET EGA INFO
                    ; Return: BH = 00h color mode in effect CH = feature bits, CL = switch settings
        cmp bl, 10h
        pop cx
        pop bx
        jz  short loc_68B
        xor ax, ax
        push    es
        mov es, ax
        assume es:seg000
        mov al, byte ptr es:loc_483+1
        pop es
        assume es:nothing
        inc al
        retn
; ---------------------------------------------------------------------------

loc_68B:                ; CODE XREF: screenrows+Dj
        mov ax, 25
        retn
screenrows  endp


; =============== S U B R O U T I N E =======================================


initscreen  proc near       ; CODE XREF: main+26p
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        xor ax, ax
        mov es, ax
        assume es:seg000
        mov ax, 0B000h
        cmp byte ptr es:loc_449, 7
        jz  short loc_6A6
        mov ax, 0B800h

loc_6A6:                ; CODE XREF: initscreen+12j
        mov word ptr sadr+2, ax
        mov ax, word ptr es:loc_44D+1
        mov bx, ax
        mov cl, 4
        shr ax, cl
        add word ptr sadr+2, ax
        shl ax, cl
        sub bx, ax
        mov word ptr sadr, bx
        xor ax, ax
        mov es, ax
        mov bh, byte ptr es:loc_461+1
        mov ah, 8
        int 10h     ; - VIDEO - READ ATTRIBUTES/CHARACTER AT CURSOR POSITION
                    ; BH = display page
                    ; Return: AL = character
                    ; AH = attribute of character (alpha modes)
        mov stdattr, ah
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
        call    getcurs
        pop es
        assume es:nothing
        pop dx
        pop cx
        pop bx
        pop ax
        retn
initscreen  endp


; =============== S U B R O U T I N E =======================================


endscreen   proc near       ; CODE XREF: exit+3p
        retn
endscreen   endp


; =============== S U B R O U T I N E =======================================


screenaddr  proc near       ; CODE XREF: vistegn+48p
                    ; drawborders:loc_985p drawborders+3Fp
                    ; drawborders+59p
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
screenaddr  endp


; =============== S U B R O U T I N E =======================================


vistegn     proc near       ; CODE XREF: outcharp outtext+Ap
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    di
        cmp al, 0Ah
        jnz short loc_756

loc_72A:                ; CODE XREF: vistegn+65j
        mov al, cury
        inc al
        cmp al, vy2
        jbe short loc_751
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

loc_751:                ; CODE XREF: vistegn+13j
        mov cury, al
        jmp short loc_78A
; ---------------------------------------------------------------------------

loc_756:                ; CODE XREF: vistegn+8j
        cmp al, 0Dh
        jnz short loc_75F
        mov al, vx1
        jmp short loc_787
; ---------------------------------------------------------------------------

loc_75F:                ; CODE XREF: vistegn+38j
        mov cx, ax
        mov al, curx
        mov ah, cury
        call    screenaddr
        mov ax, cx
        mov ah, txtattr
        mov es:[di], ax
        mov al, curx
        inc al
        cmp al, vx2
        jbe short loc_787
        mov al, vx1
        mov curx, al
        jmp short loc_72A
; ---------------------------------------------------------------------------

loc_787:                ; CODE XREF: vistegn+3Dj vistegn+5Dj
        mov curx, al

loc_78A:                ; CODE XREF: vistegn+34j
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


outchar     proc near       ; CODE XREF: fatal+1Ep fatal+27p
                    ; fatal+2Cp fatal+2Fp get_color+35p
                    ; get_color+4Cp get_color+79p
                    ; get_color:loc_326p get_color+CAp
                    ; get_color+E4p do_changes+43p
                    ; do_changes+6Cp
        call    vistegn
        call    setcurs
        retn
outchar     endp


; =============== S U B R O U T I N E =======================================


outtext     proc near       ; CODE XREF: fatal+22p fatal+35p
                    ; show_status:loc_1BEp
                    ; show_status:loc_1D3p
                    ; show_status:loc_1E8p
                    ; show_status:loc_1FDp show_status+6Dp
                    ; show_status+7Cp show_status+8Bp
                    ; show_status+9Ap show_status+A9p
                    ; show_status+B8p show_status+C7p
                    ; show_status+D6p show_status+E5p
                    ; get_color+19p get_color+A5p
                    ; do_changes+19p do_changes+37p
                    ; bordertext+7Cp
        push    ax
        push    bx
        mov bx, dx

loc_79D:                ; CODE XREF: outtext+Ej
        mov al, [bx]
        or  al, al
        jz  short loc_7A9
        call    vistegn
        inc bx
        jmp short loc_79D
; ---------------------------------------------------------------------------

loc_7A9:                ; CODE XREF: outtext+8j
        call    setcurs
        pop bx
        pop ax
        retn
outtext     endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


clrscr      proc near       ; CODE XREF: do_changes:loc_43Dp
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
clrscr      endp


; =============== S U B R O U T I N E =======================================


setwindow   proc near       ; CODE XREF: openwindow+D4p
                    ; closewindow+45p bordertext+2Ap
                    ; bordertext+8Bp
        mov vx1, al
        mov curx, al
        mov vy1, ah
        mov cury, ah
        mov vx2, dl
        mov vy2, dh
        call    setcurs
        retn
setwindow   endp


; =============== S U B R O U T I N E =======================================


gotoxy      proc near       ; CODE XREF: show_status+Ep
                    ; show_status+23p show_status+38p
                    ; show_status+4Dp show_status+65p
                    ; show_status+73p show_status+82p
                    ; show_status+91p show_status+A0p
                    ; show_status+AFp show_status+BEp
                    ; show_status+CDp show_status+DCp
                    ; show_status+E9p get_color+26p
                    ; get_color+3Dp get_color+56p
                    ; get_color+61p get_color+74p
                    ; get_color+8Ep get_color+99p
                    ; get_color+AEp get_color+C5p
                    ; get_color+DFp get_color+E8p
                    ; do_changes+47p do_changes:loc_483p
                    ; bordertext:loc_BCBp bordertext+8Fp
        push    ax
        add al, vx1
        cmp al, vx2
        ja  short loc_81A
        add ah, vy1
        cmp ah, vy2
        ja  short loc_81A
        mov curx, al
        mov cury, ah
        call    setcurs

loc_81A:                ; CODE XREF: gotoxy+9j gotoxy+13j
        pop ax
        retn
gotoxy      endp


; =============== S U B R O U T I N E =======================================


wherex      proc near       ; CODE XREF: show_statusp
                    ; get_color+1Cp get_color:loc_2F7p
                    ; get_color+B5p do_changes:loc_446p
                    ; do_changes+6Fp bordertext+10p
        mov al, curx
        sub al, vx1
        retn
wherex      endp


; =============== S U B R O U T I N E =======================================


wherey      proc near       ; CODE XREF: show_status+3p
                    ; get_color+1Fp get_color+4Fp
                    ; get_color+67p get_color+B8p
                    ; do_changes:loc_449p do_changes+74p
                    ; bordertext+13p
        mov ah, cury
        sub ah, vy1
        retn
wherey      endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


textattr    proc near       ; CODE XREF: show_status+6Ap
                    ; show_status+79p show_status+88p
                    ; show_status+97p show_status+A6p
                    ; show_status+B5p show_status+C4p
                    ; show_status+D3p show_status+E2p
                    ; show_status+EEp get_color+30p
                    ; get_color+47p get_color+5Dp
                    ; get_color+9Fp get_color+AAp
        mov txtattr, al
        retn
textattr    endp


; =============== S U B R O U T I N E =======================================


textcolor   proc near
        push    ax
        and al, 0Fh
        and txtattr, 0F0h
        or  txtattr, al
        pop ax
        retn
textcolor   endp


; =============== S U B R O U T I N E =======================================


textbackground  proc near
        push    ax
        push    cx
        mov cl, 4
        shl al, cl
        and txtattr, 0Fh
        or  txtattr, al
        pop cx
        pop ax
        retn
textbackground  endp


; =============== S U B R O U T I N E =======================================


save_window_area proc near      ; CODE XREF: openwindow+85p
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

loc_888:                ; CODE XREF: save_window_area+41j
        push    cx
        mov cx, dx
        push    si
        cld
        rep movsw
        pop si
        add si, ax
        pop cx
        loop    loc_888
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        retn
save_window_area endp


; =============== S U B R O U T I N E =======================================


restore_window_area proc near       ; CODE XREF: closewindow+2Fp
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

loc_8D8:                ; CODE XREF: restore_window_area+45j
        push    cx
        mov cx, dx
        push    di
        cld
        rep movsw
        pop di
        add di, ax
        pop cx
        loop    loc_8D8
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        retn
restore_window_area endp


; =============== S U B R O U T I N E =======================================


getkey      proc near       ; CODE XREF: fatal:loc_149p
                    ; get_color+B1p do_changes+1Cp
                    ; do_changes+4Dp getkey+6j
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
        jnz short loc_905
        mov al, ah
        xor ah, ah
        neg ax
        retn
; ---------------------------------------------------------------------------

loc_905:                ; CODE XREF: getkey+Ej
        xor ah, ah
        retn
getkey      endp


; =============== S U B R O U T I N E =======================================


strlen      proc near       ; CODE XREF: fatal+1p find_area+7p
                    ; find_area+27p find_area+3Fp
                    ; strcmp+6p bordertext+46p
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


strcmp      proc near       ; CODE XREF: find_area:loc_16Bp
                    ; find_area+30p
        push    cx
        push    dx
        push    di
        push    si
        mov dx, si
        call    strlen
        inc ax
        mov cx, ax
        xor ax, ax
        cld
        repe cmpsb
        jz  short loc_93F
        jb  short loc_93C
        mov ax, 1
        jmp short loc_93F
; ---------------------------------------------------------------------------

loc_93C:                ; CODE XREF: strcmp+13j
        mov ax, 0FFFFh

loc_93F:                ; CODE XREF: strcmp+11j strcmp+18j
        pop si
        pop di
        pop dx
        pop cx
        retn
strcmp      endp


; =============== S U B R O U T I N E =======================================


initwindow  proc near       ; CODE XREF: main+29p
        push    ax
        mov al, txtattr
        mov win_attr1, al
        mov win_attr2, al
        mov al, vx1
        mov ah, vy1
        mov window_upper_left_pos, ax
        mov al, vx2
        mov ah, vy2
        mov window_down_right_pos, ax
        pop ax
        retn
initwindow  endp


; =============== S U B R O U T I N E =======================================


endwindow   proc near       ; CODE XREF: exitp endwindow+Aj
        cmp window_seg, 0
        jz  short locret_970
        call    closewindow
        jmp short endwindow
; ---------------------------------------------------------------------------

locret_970:             ; CODE XREF: endwindow+5j
        retn
endwindow   endp


; =============== S U B R O U T I N E =======================================


drawborders proc near       ; CODE XREF: openwindow+B5p
                    ; sub_BE9+27p
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        cmp bl, 1
        jnz short loc_982
        mov bx, offset border_chars0
        jmp short loc_985
; ---------------------------------------------------------------------------

loc_982:                ; CODE XREF: drawborders+Aj
        mov bx, offset border_chars1

loc_985:                ; CODE XREF: drawborders+Fj
        call    screenaddr
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
        jcxz    short loc_9A6
        mov al, [bx+1]
        rep stosw

loc_9A6:                ; CODE XREF: drawborders+2Ej
        mov al, [bx+2]
        stosw
        pop cx
        pop dx
        pop ax
        push    ax
        mov ah, dh
        call    screenaddr
        push    dx
        cld
        mov ah, txtattr
        mov al, [bx+5]
        stosw
        jcxz    short loc_9C4
        mov al, [bx+1]
        rep stosw

loc_9C4:                ; CODE XREF: drawborders+4Cj
        mov al, [bx+4]
        stosw
        pop dx
        pop ax
        call    screenaddr
        add di, antkol2
        xor ch, ch
        mov cl, dh
        sub cl, ah
        dec cl
        jcxz    short loc_9F3
        cld
        mov ah, txtattr
        mov al, [bx+3]

loc_9E3:                ; CODE XREF: drawborders+80j
        stosw
        add di, si
        dec di
        dec di
        stosw
        sub di, si
        dec di
        dec di
        add di, antkol2
        loop    loc_9E3

loc_9F3:                ; CODE XREF: drawborders+68j
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


openwindow  proc near       ; CODE XREF: fatal+11p get_color+13p
                    ; do_changes+Bp
        push    bx
        push    cx
        push    dx
        push    di
        push    es
        mov border_type, bl
        mov win_attr1, cl
        mov win_attr2, ch
        mov window_upper_left_pos, ax
        mov window_down_right_pos, dx
        sub dl, al
        inc dl
        sub dh, ah
        inc dh
        mov al, dh
        mul dl
        shl ax, 1
        add ax, 0Ch
        call    getmem
        or  ax, ax
        jnz short loc_A31
        mov ax, 1
        jmp loc_AD7
; ---------------------------------------------------------------------------

loc_A31:                ; CODE XREF: openwindow+2Ej
        mov bl, border_type
        mov es:0Ah, bl
        mov es:2, ax
        mov ax, window_seg
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
        mov ax, window_upper_left_pos
        mov dx, window_down_right_pos
        call    save_window_area
        mov window_seg, es
        mov bh, win_attr1
        mov cx, window_upper_left_pos
        mov dx, window_down_right_pos
        mov ax, 600h
        int 10h     ; - VIDEO - SCROLL PAGE UP
                    ; AL = number of lines to scroll window (0 = blank whole window)
                    ; BH = attributes to be used on blanked lines
                    ; CH,CL = row,column of upper left corner of window to scroll
                    ; DH,DL = row,column of lower right corner of window
        cmp border_type, 0
        jz  short loc_AC2
        mov al, win_attr2
        mov txtattr, al
        mov ax, window_upper_left_pos
        mov dx, window_down_right_pos
        mov bl, border_type
        call    drawborders
        inc al
        inc ah
        mov window_upper_left_pos, ax
        dec dl
        dec dh
        mov window_down_right_pos, dx

loc_AC2:                ; CODE XREF: openwindow+A2j
        mov al, win_attr1
        mov txtattr, al
        mov ax, window_upper_left_pos
        mov dx, window_down_right_pos
        call    setwindow
        call    setcurs
        xor ax, ax

loc_AD7:                ; CODE XREF: openwindow+33j
        pop es
        pop di
        pop dx
        pop cx
        pop bx
        retn
openwindow  endp


; =============== S U B R O U T I N E =======================================


closewindow proc near       ; CODE XREF: fatal+40p
                    ; get_color:loc_402p
                    ; do_changes:loc_430p
                    ; do_changes:loc_55Dp endwindow+7p
        push    ax
        push    dx
        push    di
        push    es
        mov ax, window_seg
        or  ax, ax
        jz  short loc_B4D
        mov es, ax
        mov al, vx1
        mov ah, vy1
        mov dl, vx2
        mov dh, vy2
        cmp byte ptr es:0Ah, 0
        jz  short loc_B09
        dec al
        dec ah
        inc dl
        inc dh

loc_B09:                ; CODE XREF: closewindow+22j
        mov di, 0Ch
        call    restore_window_area
        mov al, es:4
        mov ah, es:5
        mov dl, es:6
        mov dh, es:7
        call    setwindow
        mov al, es:8
        mov curx, al
        mov ah, es:9
        mov cury, ah
        call    setcurs
        mov al, es:0Bh
        mov txtattr, al
        mov ax, es:0
        mov window_seg, ax
        mov ax, es:2
        call    freemem

loc_B4D:                ; CODE XREF: closewindow+9j
        pop es
        pop di
        pop dx
        pop ax
        retn
closewindow endp


; =============== S U B R O U T I N E =======================================


bordertext  proc near       ; CODE XREF: fatal+19p do_changes+13p
        push    ax
        push    bx
        push    cx
        push    dx
        cmp border_type, 0
        jnz short loc_B60
        jmp loc_BE4
; ---------------------------------------------------------------------------

loc_B60:                ; CODE XREF: bordertext+9j
        mov bx, ax
        call    wherex
        call    wherey
        push    ax
        mov ax, bx
        push    ax
        push    dx
        mov ax, window_upper_left_pos
        dec al
        dec ah
        mov dx, window_down_right_pos
        inc dl
        inc dh
        call    setwindow
        pop dx
        pop ax
        mov bl, txtattr
        push    bx
        mov txtattr, ch
        mov bl, al
        mov al, 1
        cmp bl, 1
        jz  short loc_BBC
        cmp bl, 4
        jz  short loc_BBC
        call    strlen
        mov bh, vx2
        sub bh, vx1
        or  bl, bl
        jz  short loc_BB2
        cmp bl, 3
        jz  short loc_BB2
        sub bh, al
        mov al, bh
        jmp short loc_BBC
; ---------------------------------------------------------------------------

loc_BB2:                ; CODE XREF: bordertext+53j
                    ; bordertext+58j
        inc bh
        shr bh, 1
        shr al, 1
        sub bh, al
        mov al, bh

loc_BBC:                ; CODE XREF: bordertext+3Fj
                    ; bordertext+44j bordertext+5Ej
        xor ah, ah
        cmp bl, 2
        jbe short loc_BCB
        mov ah, vy2
        sub ah, vy1

loc_BCB:                ; CODE XREF: bordertext+6Fj
        call    gotoxy
        call    outtext
        pop bx
        mov txtattr, bl
        mov ax, window_upper_left_pos
        mov dx, window_down_right_pos
        call    setwindow
        pop ax
        call    gotoxy

loc_BE4:                ; CODE XREF: bordertext+Bj
        pop dx
        pop cx
        pop bx
        pop ax
        retn
bordertext  endp


; =============== S U B R O U T I N E =======================================


sub_BE9     proc near
        push    ax
        push    bx
        push    dx
        cmp border_type, 0
        jz  short loc_C17
        mov al, txtattr
        push    ax
        mov al, win_attr2
        mov txtattr, al
        mov bl, border_type
        mov ax, window_upper_left_pos
        dec al
        dec ah
        mov dx, window_down_right_pos
        inc dl
        inc dh
        call    drawborders
        pop ax
        mov txtattr, al

loc_C17:                ; CODE XREF: sub_BE9+8j
        pop dx
        pop bx
        pop ax
        retn
sub_BE9     endp

; ---------------------------------------------------------------------------
        align 2

; =============== S U B R O U T I N E =======================================


initmem     proc near       ; CODE XREF: main:loc_584p
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


; =============== S U B R O U T I N E =======================================


endmem      proc near       ; CODE XREF: exit+6p
        retn
endmem      endp


; =============== S U B R O U T I N E =======================================


getmem      proc near       ; CODE XREF: openwindow+29p
        push    bx
        push    dx
        or  ax, ax
        jz  short loc_CC2
        mov bx, ax
        push    cx
        mov cl, 4
        shr ax, cl
        pop cx
        and bx, 0Fh
        jz  short loc_C55
        inc ax

loc_C55:                ; CODE XREF: getmem+11j
        mov es, first_free_seg
        xor dx, dx

loc_C5B:                ; CODE XREF: getmem+30j
        mov bx, es
        or  bx, bx
        jz  short loc_CC2
        mov bx, es:0
        cmp ax, bx
        jbe short loc_C73
        mov dx, es
        mov es, word ptr es:2
        jmp short loc_C5B
; ---------------------------------------------------------------------------

loc_C73:                ; CODE XREF: getmem+27j
        mov bx, es:0
        sub bx, ax
        jz  short loc_CA8
        push    cx
        mov cx, es
        add cx, ax
        or  dx, dx
        jz  short loc_C90
        push    es
        mov es, dx
        mov es:2, cx
        pop es
        jmp short loc_C94
; ---------------------------------------------------------------------------

loc_C90:                ; CODE XREF: getmem+42j
        mov first_free_seg, cx

loc_C94:                ; CODE XREF: getmem+4Dj
        push    ds
        mov ds, cx
        mov ds:0, bx
        mov cx, es:2
        mov ds:2, cx
        pop ds
        pop cx
        jmp short loc_CC6
; ---------------------------------------------------------------------------

loc_CA8:                ; CODE XREF: getmem+39j
        mov bx, es:2
        or  dx, dx
        jz  short loc_CBC
        push    es
        mov es, dx
        mov es:2, bx
        pop es
        jmp short loc_CC6
; ---------------------------------------------------------------------------

loc_CBC:                ; CODE XREF: getmem+6Ej
        mov first_free_seg, bx
        jmp short loc_CC6
; ---------------------------------------------------------------------------

loc_CC2:                ; CODE XREF: getmem+4j getmem+1Ej
        xor ax, ax
        mov es, ax
        assume es:seg000

loc_CC6:                ; CODE XREF: getmem+65j getmem+79j
                    ; getmem+7Fj
        pop dx
        pop bx
        retn
getmem      endp


; =============== S U B R O U T I N E =======================================


freemem     proc near       ; CODE XREF: closewindow+6Dp
        push    ax
        push    bx
        push    cx
        push    dx
        push    bp
        push    es
        or  ax, ax
        jnz short loc_CD6

loc_CD3:                ; CODE XREF: freemem+11j
        jmp loc_D9A
; ---------------------------------------------------------------------------

loc_CD6:                ; CODE XREF: freemem+8j
        mov bx, es
        or  bx, bx
        jz  short loc_CD3
        cmp first_free_seg, 0
        jnz short loc_CF5
        mov es:0, ax
        mov word ptr es:2, 0
        mov first_free_seg, es
        jmp loc_D9A
; ---------------------------------------------------------------------------

loc_CF5:                ; CODE XREF: freemem+18j
        cmp bx, first_free_seg
        jnb short loc_D33
        add bx, ax
        cmp bx, first_free_seg
        jnz short loc_D22
        push    es
        mov es, first_free_seg
        assume es:nothing
        add ax, es:0
        mov bx, es:2
        pop es
        mov first_free_seg, es
        mov es:0, ax
        mov es:2, bx
        jmp short loc_D9A
; ---------------------------------------------------------------------------

loc_D22:                ; CODE XREF: freemem+38j
        mov es:0, ax
        mov ax, first_free_seg
        mov es:2, ax
        mov first_free_seg, es
        jmp short loc_D9A
; ---------------------------------------------------------------------------

loc_D33:                ; CODE XREF: freemem+30j
        mov bp, es
        mov es, first_free_seg
        xor dx, dx

loc_D3B:                ; CODE XREF: freemem+83j
        mov bx, es
        or  bx, bx
        jz  short loc_D4E
        cmp bx, bp
        jnb short loc_D4E
        mov dx, es
        mov es, word ptr es:2
        jmp short loc_D3B
; ---------------------------------------------------------------------------

loc_D4E:                ; CODE XREF: freemem+76j freemem+7Aj
        mov es, dx
        mov es:2, bp
        mov es, bp
        mov es:2, bx
        mov es:0, ax
        or  bx, bx
        jz  short loc_D83
        mov cx, bp
        add cx, ax
        cmp cx, bx
        jnz short loc_D83
        mov es, bx
        add ax, es:0
        mov bx, es:2
        mov es, bp
        mov es:0, ax
        mov es:2, bx

loc_D83:                ; CODE XREF: freemem+99j freemem+A1j
        mov es, dx
        mov cx, dx
        add cx, es:0
        cmp cx, bp
        jnz short loc_D9A
        add es:0, ax
        mov es:2, bx

loc_D9A:                ; CODE XREF: freemem:loc_CD3j
                    ; freemem+29j freemem+57j freemem+68j
                    ; freemem+C5j
        pop es
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
        retn
freemem     endp

; ---------------------------------------------------------------------------
        align 2
prsesc      db 'Press ESC',0        ; DATA XREF: fatal+32o
errorhd     db ' ERROR ',0
aReadError  db 'Read error',0       ; DATA XREF: main+5Eo
aWriteError db 'Write error',0      ; DATA XREF: main+7Co main:loc_5F4o
aCouldnTOpenEd_ db 'Couldn',27h,'t open ED.COM for reading/writing',0 ; DATA XREF: main+36o
aCouldnTCloseFi db 'Couldn',27h,'t close file',0 ; DATA XREF: main+B4o
aUnknownEd_com  db 'Unknown ED.COM',0   ; DATA XREF: find_area+1Eo
aDifferentVersi db 'Different versions of EDSETUP.COM and ED.COM',0
                    ; DATA XREF: find_area+37o
aOn     db 'On ',0              ; DATA XREF: show_status+1Ao
                    ; show_status+2Fo show_status+44o
                    ; show_status+59o
aOff        db 'Off',0              ; DATA XREF: show_status+26o
                    ; show_status+3Bo show_status+50o
aAbcd       db ' Abcd ',0           ; DATA XREF: show_status+5Fo
                    ; get_color+A2o
aEdsetupV2_4C12 db ' EDSETUP v2.4  --  (C) 12/8/92 ',0 ; DATA XREF: do_changes+Eo
aThisProgramMak db 0Dh,0Ah      ; DATA XREF: do_changes+16o
        db 0Ah
        db '  This program makes it possible to configure SHH ED',0Dh,0Ah
        db '  to start with your favourite settings.',0Dh,0Ah
        db 0Ah
        db '  Changing of colors is for colordisplay only.',0Dh,0Ah
        db 0Ah
        db '  Be aware that the changes are written directly to',0Dh,0Ah
        db '  ED.COM, so if you use any checksumprograms to test',0Dh,0Ah
        db '  for virus, these will probably complain about ED.',0Dh,0Ah
        db 0Ah
        db '             Press any key to continue,',0Dh,0Ah
        db '                  or Esc to quit: ',0
aForeground____ db 0Dh,0Ah      ; DATA XREF: get_color+16o
        db '             Foreground',0Dh,0Ah
        db '          ________________',0Dh,0Ah
        db ' B |',0Dh,0Ah
        db ' a |',0Dh,0Ah
        db ' c |      ',1Bh,'/'
        db  1Ah
aForegroundK    db ':      foreground',0Dh,0Ah
        db ' k |      '
        db  18h
        db  2Fh ; /
        db  19h
aBackgroundGRet db ':      background',0Dh,0Ah
        db ' g |      Return:   finished',0Dh,0Ah
        db ' r |',0Dh,0Ah
        db ' n |      Example:  Abcd ',0Dh,0Ah
        db ' d |',0Dh,0Ah
        db ' ',0
menutxt     db 0Dh,0Ah      ; DATA XREF: do_changes+34o
        db '                                    Current setting',0Dh,0Ah
        db '  A.  Reset mouse at start',0Dh,0Ah
        db '  B.  Insertmode',0Dh,0Ah
        db '  C.  Autoindent',0Dh,0Ah
        db '  D.  Parenthesis Pairing',0Dh,0Ah
        db '  E.  Textattribute',0Dh,0Ah
        db '  F.  Blockattribute',0Dh,0Ah
        db '  G.  Top/bottom',0Dh,0Ah
        db '  H.  Errorwindow, text',0Dh,0Ah
        db '  I.  Errorwindow, border',0Dh,0Ah
        db '  J.  Helpwindow, text',0Dh,0Ah
        db '  K.  Helpwindow, border',0Dh,0Ah
        db '  L.  Messagewindow, text',0Dh,0Ah
        db '  M.  Messagewindow, border',0Dh,0Ah
        db '  N.  Default setup',0Dh,0Ah
        db '  Q.  Save changes and quit',0Dh,0Ah
        db 0Ah
        db '  Choose: ',0
aEdsetupScreenM db 'EDSETUP: Screen must have at least 80 columns',0Dh,0Ah,'$'
                    ; DATA XREF: main+1Eo
aEdsetupNeedTex db 'EDSETUP: Need textmode',0Dh,0Ah,'$'
aEd_comIsUpdate db 'ED.COM is updated',0Dh,0Ah,'$' ; DATA XREF: main:loc_61Bo
aAbortedByUser_ db 'Aborted by user. ED.COM is unchanged',0Dh,0Ah,'$'
                    ; DATA XREF: do_changes+27o
filenm      db 'ED.COM',0           ; DATA XREF: main+2Fo
idstr       db 'SETUPBUF',0         ; DATA XREF: find_area+4o find_area+Co
                    ; find_area:loc_17Bo
aV2_4       db 'v2.4',0
sattr       db 1Eh          ; DATA XREF: do_changes+13Do
                    ; setupdata
battr       db 7Eh
hattr       db 74h
uattr       db 0Fh
ftattr      db 4Fh
frattr      db 4Eh
htattr      db 70h
hrattr      db 70h
mtattr      db 70h
mrattr      db 70h
insert      db 1
indent      db 1
pair        db 1
tabul       db 0
resmouse    db 0
border_type db 0            ; DATA XREF: openwindow+5w
                    ; openwindow:loc_A31r openwindow+9Dr
                    ; openwindow+B1r bordertext+4r
                    ; sub_BE9+3r sub_BE9+14r
window_seg  dw 0            ; DATA XREF: endwindowr openwindow+43r
                    ; openwindow+88w closewindow+4r
                    ; closewindow+66w
border_chars0   db 0DAh ; Ú       ; DATA XREF: drawborders+Co
        db 0C4h ; Ä
        db 0BFh ; ¿
        db 0B3h ; ³
        db 0D9h ; Ù
        db 0C0h ; À
border_chars1   db 0C9h ; É       ; DATA XREF: drawborders:loc_982o
        db 0CDh ; Í
        db 0BBh ; »
        db 0BAh ; º
        db 0BCh ; ¼
        db 0C8h ; È
        db    ? ;
buffer      db 7FFFh dup(?)     ; DATA XREF: find_area+Fo
filelen     dw ?
hdl     dw ?
ftime       dw ?
fdate       dw ?
area        dw ?
attr        db ?
tmpattr     db ?
        db    ? ;
vx1     db ?
vy1     db ?
vx2     db ?
vy2     db ?
antkol2     dw ?
curx        db ?            ; DATA XREF: setcurs+4r getcurs+15w
                    ; vistegn+41r vistegn+54r vistegn+62w
                    ; vistegn:loc_787w clrscr+20w
                    ; setwindow+3w gotoxy+15w wherexr
                    ; openwindow+66r closewindow+4Cw
cury        db ?            ; DATA XREF: setcurs+8r getcurs+18w
                    ; vistegn:loc_72Ar vistegn:loc_751w
                    ; vistegn+44r clrscr+26w setwindow+Aw
                    ; gotoxy+18w whereyr openwindow+6Dr
                    ; closewindow+54w
sadr        dd ?
txtattr     db ?            ; DATA XREF: initscreen+41w
                    ; vistegn+18r vistegn+4Dr clrscr+7r
                    ; textattrw textcolor+3w textcolor+8w
                    ; textbackground+6w textbackground+Bw
                    ; initwindow+1r drawborders+27r
                    ; drawborders+44r drawborders+6Br
                    ; openwindow+74r openwindow+A7w
                    ; openwindow+CAw closewindow+5Fw
                    ; bordertext+2Fr bordertext+34w
                    ; bordertext+80w sub_BE9+Ar
                    ; sub_BE9+11w sub_BE9+2Bw
stdattr     db ?
win_attr1   db ?
win_attr2   db ?            ; DATA XREF: initwindow+7w
                    ; openwindow+Dw openwindow+A4r
                    ; sub_BE9+Er
window_upper_left_pos dw ?      ; DATA XREF: initwindow+11w
                    ; openwindow+11w openwindow+7Er
                    ; openwindow+90r openwindow+AAr
                    ; openwindow+BCw openwindow+CDr
                    ; bordertext+1Br bordertext+84r
                    ; sub_BE9+18r
window_down_right_pos dw ?      ; DATA XREF: initwindow+1Bw
                    ; openwindow+14w openwindow+81r
                    ; openwindow+94r openwindow+ADr
                    ; openwindow+C3w openwindow+D0r
                    ; bordertext+22r bordertext+87r
                    ; sub_BE9+1Fr
first_free_seg  dw ?
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
        db    ? ;
seg000      ends


        end start
