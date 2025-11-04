.MODEl TINY


.DATA

        PUBLIC  vx1, vy1, vx2, vy2
        PUBLIC  antkol2
        PUBLIC  curx, cury
        PUBLIC  sadr
        PUBLIC  txtattr
        PUBLIC  stdattr


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

.DATA?

;init    DB      ?   ; Er init utfâ€ºrt?
vx1     DB      ?   ; Å¥verste venstre X-koordinat
vy1     DB      ?   ; Å¥verste venstre Y-koordinat
vx2     DB      ?   ; Nederste hâ€ºyre X-koordinat
vy2     DB      ?   ; Nederste hâ€ºyre Y-koordinat
antkol2 DW      ?   ; Antall kolonner pâ€  skjermen * 2
curx    DB      ?   ; Cursor X
cury    DB      ?   ; Cursor Y
sadr    DD      ?   ; Startadresse for nâ€ vâ€˜rende skjermside
txtattr DB      ?   ; Nâ€ vâ€˜rende attributt
stdattr DB      ?   ; Tekstattributt fra init_scrlow ble kalt opp

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



.CODE

        align 2

PUBLIC setcurs
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
        mov bh, byte ptr es:[462h]
        mov ah, 2
        int 10h     ; - VIDEO - SET CURSOR POSITION
                    ; DH,DL = row, column (0,0 = upper left)
                    ; BH = page number
        pop es
        pop dx
        pop bx
        pop ax
        retn
setcurs     endp


PUBLIC getcurs
getcurs     proc near       ; CODE XREF: initscreen+64p
        push    ax
        push    bx
        push    es
        xor ax, ax
        mov es, ax
        ;assume es:seg000
        mov bl, byte ptr es:[462h]
        xor bh, bh
        shl bx, 1
        mov ax, es:[bx+450h]
        mov curx, al
        mov cury, ah
        pop es
        ;assume es:nothing
        pop bx
        pop ax
        retn
getcurs     endp


PUBLIC screencols
screencols  proc near       ; CODE XREF: main:loc_577p
                            ; initscreen+4Dp
        push    es
        xor ax, ax
        mov es, ax
        ;assume es:seg000
        mov ax, word ptr es:[44Ah]
        pop es
        ;assume es:nothing
        retn
screencols  endp


PUBLIC screenrows
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
        ;assume es:seg000
        mov al, byte ptr es:[484h]
        pop es
        ;assume es:nothing
        inc al
        retn
; ---------------------------------------------------------------------------

loc_68B:                ; CODE XREF: screenrows+Dj
        mov ax, 25
        retn
screenrows  endp


PUBLIC initscreen
initscreen  proc near       ; CODE XREF: main+26p
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        xor ax, ax
        mov es, ax
        ;assume es:seg000
        mov ax, 0B000h
        cmp byte ptr es:[449h], 7
        jz  short loc_6A6
        mov ax, 0B800h

loc_6A6:                ; CODE XREF: initscreen+12j
        mov word ptr sadr+2, ax
        mov ax, word ptr es:[44Eh]
        mov bx, ax
        mov cl, 4
        shr ax, cl
        add word ptr sadr+2, ax
        shl ax, cl
        sub bx, ax
        mov word ptr sadr, bx
        xor ax, ax
        mov es, ax
        mov bh, byte ptr es:[462h]
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
        ;assume es:nothing
        pop dx
        pop cx
        pop bx
        pop ax
        retn
initscreen  endp


PUBLIC endscreen
endscreen   proc near       ; CODE XREF: exit+3p
        retn
endscreen   endp


PUBLIC addr_of_pos
addr_of_pos  proc near       ; CODE XREF: vistegn+48p
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
addr_of_pos  endp


PUBLIC vistegn
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
        call    addr_of_pos
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

        
        align 2


PUBLIC outchar
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


PUBLIC outtext
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


PUBLIC outword
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

        align 2


PUBLIC clrscr
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


PUBLIC clreol
clreol PROC
        push    ax
        push    bx
        push    cx
        push    dx
        ;call    getcurs
        mov     ax, 0600h
        mov     bh, [txtattr]
        mov     cl, [curx]
        mov     ch, [cury]
        mov     dl, [vx2]
        mov     dh, [cury]
        int     10h
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
clreol endp


PUBLIC window
window   proc near       ; CODE XREF: openwindow+D4p
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
window   endp


PUBLIC gotoxy
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


PUBLIC wherex
wherex      proc near       ; CODE XREF: show_statusp
                    ; get_color+1Cp get_color:loc_2F7p
                    ; get_color+B5p do_changes:loc_446p
                    ; do_changes+6Fp bordertext+10p
        mov al, curx
        sub al, vx1
        retn
wherex      endp


PUBLIC wherey
wherey      proc near       ; CODE XREF: show_status+3p
                    ; get_color+1Fp get_color+4Fp
                    ; get_color+67p get_color+B8p
                    ; do_changes:loc_449p do_changes+74p
                    ; bordertext+13p
        mov ah, cury
        sub ah, vy1
        retn
wherey      endp

        align 2


PUBLIC textattr
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


PUBLIC textcolor
textcolor   proc near
        push    ax
        and al, 0Fh
        and txtattr, 0F0h
        or  txtattr, al
        pop ax
        retn
textcolor   endp


PUBLIC textbackground
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


PUBLIC getkey
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


PUBLIC strlen
strlen      proc near       ; CODE XREF: fatal+1p find_area+7p
                    ; find_area+27p find_area+3Fp
                    ; strcmp+6p bordertext+46p
        push    cx
        push    di
        push    es
        mov cx, ds
        mov es, cx
        ;assume es:seg000
        mov di, dx
        xor al, al
        mov cx, 0FFFFh
        cld
        repne scasb
        mov ax, di
        dec ax
        sub ax, dx
        pop es
        ;assume es:nothing
        pop di
        pop cx
        retn
strlen      endp


PUBLIC strcmp
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


PUBLIC initwindow
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


PUBLIC endwindow
endwindow   proc near       ; CODE XREF: exitp endwindow+Aj
        cmp window_seg, 0
        jz  short locret_970
        call    closewindow
        jmp short endwindow
; ---------------------------------------------------------------------------

locret_970:             ; CODE XREF: endwindow+5j
        retn
endwindow   endp


PUBLIC drawborders
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
        call    addr_of_pos
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
        call    addr_of_pos
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


PUBLIC openwindow
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
        call    window
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


PUBLIC closewindow
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
        call    window
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


PUBLIC bordertext
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
        call    window
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
        call    window
        pop ax
        call    gotoxy

loc_BE4:                ; CODE XREF: bordertext+Bj
        pop dx
        pop cx
        pop bx
        pop ax
        retn
bordertext  endp


; ???
PUBLIC drawborder
drawborder     proc near
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
drawborder     endp

        align 2

PUBLIC initmem
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


PUBLIC endmem
endmem      proc near       ; CODE XREF: exit+6p
        retn
endmem      endp


PUBLIC getmem
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
        ;assume es:seg000

loc_CC6:                ; CODE XREF: getmem+65j getmem+79j
                    ; getmem+7Fj
        pop dx
        pop bx
        retn
getmem      endp


PUBLIC freemem
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
        mov es:[0], ax
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


PUBLIC memleft
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


END
