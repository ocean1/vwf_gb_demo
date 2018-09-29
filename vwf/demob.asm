;////////////////////VWF demo by evo///////////////////////

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
call    ScreenOff           ;spegni schermo

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
ld de,($8000+$A0)
ld bc, $220
call mem_Copy_mono
;---------------------------------------------------------------
;/////////////SETTA LA FINESTRA PER IL DIALOGO/////////////////

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
call vwfroutine

;--------------------
push bc
ld hl,$C010
ld de,($8000+$A0)
ld bc, $1B0
call mem_Copy_mono
pop bc
ld hl,ndialog
call froutine
;--------------------

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

;//////////////////////////VWF ROUTINE////////////////////////
vwfroutine:
push bc
push hl
xor a
ld [Bit_Pos],a
ld [Tile_Pos],a
ld [Ct_Line],a
pop hl
vwfloop:
ld a,[hl+]
cp $F0 ;(a capo)
jr nz, noacapo
ld a,[Tile_Pos]
cp 18
jr c,label1
ld a,$24
jp label2
label1:
ld a,$12
label2:
ld [Tile_Pos],a
xor a
ld [Bit_Pos],a
ld a,[hl+]
noacapo:
cp $FF
jr nz, continua
jp finito
continua:
ld [Charx],a
push hl
ld h,0
ld l,a
ld bc, (font-$50)
call calcolo_offset ;in hl c'è il font read pointer
push hl
ld a,[Tile_Pos]
ld h,0
ld l,a
ld bc, $C010 ;(spazio vuoto in ram)
call calcolo_offset  ;in hl c'è il ram write pos. pointer
ld c,8
pop de ;in de c'è il font read pointer
push hl ;nello stack abbiamo il ram write pos. pointer
ld a,d
ld [$C004],a
ld a,e
ld [$C005],a
write_loop:
ld a,[$C004]
ld h,a
ld a,[$C005]
ld l,a
ld a,[Ct_Line]
ld d,0
ld e,a
add hl,de ;hl = hl + current_line
ld a,[hl]
ld b,a ;b = current character
ld d,a ;d = current character (serve per il secondo carattere)
ld a,[Bit_Pos] ;a = Bit_Pos
cp $00
jr z, .no_shift
.loop:
srl b
dec a
jr nz, .loop
.no_shift:
push hl ;nello stack abbiamo il font read pointer
ld hl,Bit_Pos
ld a,8
sub [hl]
cp $00
jr z, .noloop
.loop1:
sla d
dec a
jr nz, .loop1
.noloop:
ld a,d
pop de ;in de c'è il font read pointer
pop hl ;in hl c'è il ram write pos. pointer
push de
ld d,a
ld a,b
or [hl]
ld [hl+],a
ld a,d
pop de
push hl ;ram write pos. pointer
ld d,0
ld e,$07
add hl,de
ld [hl],a
ld hl, Ct_Line
inc [hl]
dec c
jp nz, write_loop
ld c,8
ld a,0
ld [Ct_Line],a
ld a, [Tile_Pos]
ld h,0
ld l,a
sla l
rl h
sla l
rl h
sla l
rl h ;tile_pos*8
ld a,[Bit_Pos]
ld d,0
ld e,a
add hl,de ;tile_pos*8+bit_pos
push hl
ld hl,(widthtbl-$0A)
ld a,[Charx]
ld d,0
ld e,a
add hl, de
ld l,[hl]
ld h,0
pop de
add hl, de  ;tile_pos*8+bit_pos+char_length
ld a,l
and $07
ld [Bit_Pos],a
srl h
rr l
srl h
rr l
srl h
rr l ;(tile_pos*8+bit_pos+char_length)/8
ld a,l
ld [Tile_Pos],a
pop hl
pop hl
jp vwfloop
finito:
pop bc
ret

calcolo_offset:
add hl,hl
add hl,hl
add hl,hl
add hl, bc  ;in hl c'è il puntatore
ret

;////////////////////////////////////////////////

include "util.asm"
include "memory.asm"

SECTION "Data",DATA

font: incbin "font.bin"
bordi: incbin "brd.bin"
dialogo: incbin "testo.bin"

ndialog: incbin "ndialog.bin" ;New dialog text (copy this to map :))
widthtbl : incbin "width.bin"

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
