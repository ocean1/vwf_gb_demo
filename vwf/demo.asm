;////////////////////VWF demo by _ocean///////////////////////


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
	reti

	SECTION	"Org $48",HOME[$48]
	; $0048 - LCDC Status interrupt start address
	reti

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
	DB  "WRITTEN BY evo _ evobboy@yahoo.it",$00
    
    SECTION "Header",HOME[$100]
    incbin "Header.bin"

SECTION "LowRam :D", BSS
Bit_Pos DB
Tile_Pos DB
Ct_Line DB
Charx DB

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
ld hl,bordi
ld de,$8000
ld bc, $A0
call mem_Copy
ld hl,font
ld de,($8200)
ld bc, $2E0
call mem_Copy_mono
;---------------------------------------------------------------
;/////////////DIALOG WINDOW/////////////////

ld a,$00
ld hl,$9800+(SCRN_VY_B*1)
ld bc,$1
call mem_Set
ld a,$04
ld hl,$9800+(SCRN_VY_B*1)+1
ld bc,$12
call mem_Set
ld a,$01
ld hl,$9800+(SCRN_VY_B*1)+$13
ld bc,$1
call mem_Set
ld a, $07
ld hl,$9800+(SCRN_VY_B*2)
ld bc,$1
call mem_Set
ld a, $07
ld hl,$9800+(SCRN_VY_B*3)
ld bc,$1
call mem_Set
ld a, $07
ld hl,$9800+(SCRN_VY_B*4)
ld bc,$1
call mem_Set
ld a, $06
ld hl,$9800+(SCRN_VY_B*2)+$13
ld bc,$1
call mem_Set
ld a, $06
ld hl,$9800+(SCRN_VY_B*3)+$13
ld bc,$1
call mem_Set
ld a, $06
ld hl,$9800+(SCRN_VY_B*4)+$13
ld bc,$1
call mem_Set
ld a,$02
ld hl,$9800+(SCRN_VY_B*5)
ld bc,$1
call mem_Set
ld a,$05
ld hl,$9800+(SCRN_VY_B*5)+1
ld bc,$12
call mem_Set
ld a,$03
ld hl,$9800+(SCRN_VY_B*5)+$13
ld bc,$1
call mem_Set
;---------------------------------------------------------------
ld a,$00
ld hl,$C000
ld bc,$500
call mem_Set

ld hl, dialogo
ld bc, $9800+(SCRN_VY_B*2)+1
call froutine

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

;ORIGINAL FONT ROUTINE
froutine:
ld a, [hl+]
cp $FF
ret z
cp $F0
jr  nz, .nline

	ld a, c
	cp $60
	jr nc, .second
	ld bc, $9800+(SCRN_VY_B*3)+1
	jr .label

.second:
	ld bc, $9800+(SCRN_VY_B*4)+1

.label:

ld a, [hl+]
.nline:
ld [bc], a
inc bc
jp froutine

;////////////////////////////////////////////////

include "util.asm"
include "memory.asm"

SECTION "Data",DATA

font: incbin "font.bin"
bordi: incbin "brd.bin"
dialogo: incbin "testo.bin"

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
