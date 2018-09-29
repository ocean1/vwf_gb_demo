;////////////////////HWF demo by _ocean///////////////////////

include "hardware.inc"

	SECTION	"Org $00",HOME[$00]
	; $0000 - Restart $00 address
RST_00:	jp	$100

	SECTION	"Org $08",HOME[$08]
	; $0008 - Restart $08 address
RST_08:	jp	$100

	SECTION	"Org $10",HOME[$10]
	; $0010 - Restart $10 address
RST_10:	jp	$100

	SECTION	"Org $18",HOME[$18]
	; $0018 - Restart $18 address
RST_18:	jp	$100

	SECTION	"Org $20",HOME[$20]
	; $0020 - Restart $20 address
RST_20:	jp	$100

	SECTION	"Org $28",HOME[$28]
	; $0028 - Restart $28 address
RST_28:	jp	$100

	SECTION	"Org $30",HOME[$30]
	; $0030 - Restart $30 address
RST_30:	jp	$100

	SECTION	"Org $38",HOME[$38]
	; $0038 - Restart $38 address
RST_38:	jp	$100

	SECTION	"Org $40",HOME[$40]
	; $0040 - V-Blank interrupt start address
	jp	IRQ_VBlank

	SECTION	"Org $48",HOME[$48]
	; $0048 - LCDC Status interrupt start address
	jp  IRQ_LCDC

	SECTION	"Org $50",HOME[$50]
	; $0050 - Timer Overflow interrupt start address
	reti

	SECTION	"Org $58",HOME[$58]
	; $0058 - Serial Transfer Completion interrupt start address
	reti

	SECTION	"Org $60",HOME[$60]
	; $0060 - Joypad interrupt start address
	reti

	SECTION	"Bwhabwhabwha",HOME[$61]
	DB  "HWF demo _ocean",$00
    
    SECTION "Header",HOME[$100]
    incbin "Header.bin"

SECTION "Main",HOME[$150]

Begin:
di
xor a
ldh [$FF],a
call    ScreenOff

;---------------------------------------------------------------

ld a,$FF
ld hl,$9800
ld bc,SCRN_VX_B*SCRN_VY_B
call mem_Set
ld a,$FF
ld hl,$9C00
ld bc,SCRN_VX_B*SCRN_VY_B
call mem_Set
ld hl,font
ld de,$8000
ld bc, $260
call mem_Copy
;---------------------------------------------------------------
;/////////////Window Dialog/////////////////

ld a,$1C
ld hl,$9800+(SCRN_VY_B*1)
ld bc,$1
call mem_Set
ld a,$20
ld hl,$9800+(SCRN_VY_B*1)+1
ld bc,$12
call mem_Set
ld a,$1D
ld hl,$9800+(SCRN_VY_B*1)+$13
ld bc,$1
call mem_Set
ld a, $23
ld hl,$9800+(SCRN_VY_B*2)
ld bc,$1
call mem_Set
ld a, $23
ld hl,$9800+(SCRN_VY_B*3)
ld bc,$1
call mem_Set
ld a, $23
ld hl,$9800+(SCRN_VY_B*4)
ld bc,$1
call mem_Set
ld a, $22
ld hl,$9800+(SCRN_VY_B*2)+$13
ld bc,$1
call mem_Set
ld a, $22
ld hl,$9800+(SCRN_VY_B*3)+$13
ld bc,$1
call mem_Set
ld a, $22
ld hl,$9800+(SCRN_VY_B*4)+$13
ld bc,$1
call mem_Set
ld a,$1E
ld hl,$9800+(SCRN_VY_B*5)
ld bc,$1
call mem_Set
ld a,$21
ld hl,$9800+(SCRN_VY_B*5)+1
ld bc,$12
call mem_Set
ld a,$1F
ld hl,$9800+(SCRN_VY_B*5)+$13
ld bc,$1
call mem_Set
;---------------------------------------------------------------

ld hl, dialogo
ld bc, $9800+(SCRN_VY_B*2)+1
call hwfroutine
;---------------------------------------------------------------

    ld  a,%00000000
    ldh [$41],a
    
    ld  a,%00000001
    ldh [$FF],a
    
    ld  a,%10010011
    ldh  [$40],a
;---------------------------------------------------------------

    ei
.wait1:
    halt
jp .wait1

;---------------------------------------------------------------

;Font Routine
froutine:
ld a, [hl+]
cp $FF
ret z
cp $F1
jr  nz, .nline1
ld bc, $9800+(SCRN_VY_B*3)+1
ld a, [hl+]
.nline1:
cp $F2
jr  nz, .nline2
ld bc, $9800+(SCRN_VY_B*4)+1
ld a, [hl+]
.nline2:
ld [bc], a
inc bc
jp froutine

;INTERRUPT
IRQ_VBlank:
    reti

IRQ_LCDC:
    reti

;//////////////////////////ROUTINE HWF////////////////////////
hwfroutine:
push bc
push hl
ld a,$FF
ld hl,$8300
ld bc,$0036
call mem_Set
ld hl, $D000
ld a, $83
ld [hl+], a
xor a,a
ld [hl], a
pop hl

hwfloop:
ld a, [hl+]
push hl
ld e, a
cp $FF
jr nz, noexit1
jp exitloop
noexit1:
cp $F1
jr nz, .noline1
ld hl, $D000
ld a, $84
ld [hl+],a
ld a, $20
ld [hl],a
pop hl
ld a,[hl+]
ld e, a
push hl
.noline1
cp $F2
jr nz, .noline2
ld hl, $D000
ld a, $85
ld [hl+],a
ld a, $40
ld [hl],a
pop hl
ld a,[hl+]
ld e, a
push hl
.noline2
call calcolo_offset
ld de, $D002
ld a,h
ld [de], a
inc de
ld a, l
ld [de], a
;///////////////////////second char/////////////////
pop hl
ld a, [hl+]
push hl
ld e, a
cp $FF
jr nz, noexit2
call loopcopia
jp exitloop
noexit2:
cp $F1
jr nz, .noline1s
call loopcopia
ld hl, $D000
ld a, $84
ld [hl+],a
ld a, $20
ld [hl],a
jp fineloopz
.noline1s
cp $F2
jr nz, .noline2s
call loopcopia
ld hl, $D000
ld a, $85
ld [hl+],a
ld a, $40
ld [hl],a
jp fineloopz
.noline2s
call calcolo_offset
ld a,[$D002]
ld d,a
ld a,[$D003]
ld e,a      ;in $de, address pointing to 1st char tile
ld c,$10
.orloop:
ld a,[de]
ld b,[hl]
swap b
or b
ld b,a
push hl
push de
ld a, [$D000]
ld h, a
ld a, [$D001]
ld l, a
call waitforVRAM
ld a,b
ld [hl+], a
ld de, $D000
ld a,h
ld [de],a
inc de
ld a,l
ld [de],a

pop de
pop hl
inc de
inc hl
dec c
jr nz, .orloop
fineloopz:
pop hl
jp hwfloop

exitloop:
pop hl
pop bc
ld hl,ndialog
call froutine
ret

;////////////////////////OTHER ROUTINES//////////////////////

loopcopia:
ld a,[$D002]
ld d,a
ld a,[$D003]
ld e,a
ld c,$10
.loop1:
ld a,[de]
ld b,a
push hl
push de
ld a, [$D000]
ld h, a
ld a, [$D001]
ld l, a
call waitforVRAM
ld a,b
ld [hl+], a
ld de, $D000
ld a,h
ld [de],a
inc de
ld a,l
ld [de],a
pop de
pop hl
inc de
inc hl
dec c
jr nz, .loop1
ret

calcolo_offset:
ld d,0  ;$hl = $e*$10
ld h,d
ld l,e
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
add hl,de
ld de,font
add hl, de  ;$hl = font addr
ret

include "util.asm"
include "memory.asm"

SECTION "Data",DATA

font: incbin "font.bin"
dialogo: incbin "testo.bin"

ndialog: incbin "ndialog.bin"

;---------------------------------------------------------------
;///////////////////////////MACRO///////////////////////////////
PushAll:    MACRO
  push  af
  push  bc
  push  de
  push  hl
  ENDM

PopAll:     MACRO
  pop   hl
  pop   de
  pop   bc
  pop   af
  ENDM
;---------------------------------------------------------------
