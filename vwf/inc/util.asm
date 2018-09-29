; *** Turn screen on ***

ScreenOn:
        ld      hl,rLCDC
        set     7,[hl]
        ret


; *** Turn screen off ***

ScreenOff:
        ld      hl,rLCDC
        bit     7,[hl]          ; Is LCD already off?
        ret     z               ; yes, exit

        ld      a,[rIE]
        push    af
        res     0,a
        ld      [rIE],a         ; Disable vblank interrupt if enabled

.loop:  ld      a,[rLY]         ; Loop until in first part of vblank
        cp      145
        jr      nz,.loop

        res     7,[hl]          ; Turn the screen off

        pop     af
        ld      [rIE],a         ; Restore the state of vblank interrupt
        ret

waitforVRAM:
    ld      a,[rSTAT]
    and     STATF_BUSY
    jr      nz,@-4
    ret
