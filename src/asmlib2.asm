.MODEl TINY


.DATA?

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


.CODE

EXTRN   txtattr:BYTE

EXTRN   wherex: PROC
EXTRN   wherey: PROC
EXTRN   gotoxy: PROC
EXTRN   outchar: PROC
EXTRN   strcpy: PROC
EXTRN   strlen: PROC
EXTRN   textattr: PROC
EXTRN   getkey: PROC

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

PUBLIC lineinput
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
        ;assume es:seg000
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
        jz  short press_esc
        cmp ax, 0Dh
        jnz short check_quit_keys

press_esc:                    ; CODE XREF: lineinput+8Fj
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

END
