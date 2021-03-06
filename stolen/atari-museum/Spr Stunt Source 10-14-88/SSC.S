;@A D	 *4>HR\+p
; z-1______ -0

	.LIST
	.6502
	.TITLE  "SUPER STUNT CYCLE   John Boeschen & Co."
    .subttl "SSC.S:  Include File, Main Loop"
; z-1______ -0

	.include "SSCEQU.S"	;Atari 7800 System Equates, global variables
	.include "SSCMAC.S"	;Special syntax ("put", "header", etc.)
; z-1______ -0

; ref. [SSCEQU] for def.:
* RAM reserved, to include data decompression buffers:
;RAM2	=   $1800	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
;R2SIZE 	=   $840	;$1800 to $203F, $840 or 2112 bytes (counts to 0).
* RAM variable block:
;RAM3	=   $2100	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
;R3SIZE 	=   $40	;$2100 to $213F, $40 or 64 bytes.
* RAM used for Display List Lists and Display List headers:
;RAM4	=   $2200	;FIRST SEGMENT OF MEMORY MINUS THE ZP,STACK, AND CHIPS
;R4SIZE	=   $400	;$2200 to $27FF, $400 or 1024 bytes.

;___________ MAIN LOOP ___________________

	.org	$4000	; ROM BANK

RUN:	  	; Cold Start
	cld
	cli		;sei in final
 	ldx	#$FF
	txs

   jsr WarmStart	;[INIT]

mainloop:

	lda SWCHB
	and #%00001000   ;detect pause switch
	beq .2

* Option for demo here:
	jsr waitvb	;sync to screen
*	jsr Zoom	;[SSCZOOM]

.2:	 jmp mainloop

;______  AUXILIARY CODE ____________________

; No alignment required:

	.include "SSCINI.S"	;
	.include "SSCSUB.S"	;
	.include "SSCDLI.S"	;
	.include "SSCZOOM.S"	;

;_______ NMI AND IRQ HANDLERS ______________

DummyRTI:  rti	; Temporarily unused

;_______  GRAPHIC CONTROL __________________

	ds.B RUN+$800-*	;align - disallow <0  (presently $4800)
DLL:	.include "SSCDLL.S"	;Display List Lists.  <= two pages.

	ds.B RUN+$1000-*	;align - disallow <0  (presently $5000)
DLS:	.include "SSCDLS.S"	;Display Lists	  <= two pages.

Zeros:
	ds.B RUN+$1200-*	;(presently $5200)

;_______  GRAPHIC DATA _____________________

	.org  $E000

GraphicData:
	.include  "SSCBIKE.S"	;Foreground bike and alphabets.

;_______  ENCRYPTION AND 6502 VECTORS ______________________________

	.org  $FF7A
	.include  "SSCENC.S"	;Encryption block of 128 bytes

;6502 Vectors at $FFFA-$FFFF
   dc.W  DLI,RUN,$FF80	;[*] Interrupt Vectors for the 6502:
;  interrupts in [SSCDLI]	$FFFA=NMI $FFFC=Reset $FFFE=IRQ ($ff80=dload)

; Z-1________ -0

        .end
; Z-1________ -0
                                                                                                                                                                                                    